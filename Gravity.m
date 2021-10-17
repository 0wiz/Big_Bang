% Gravitation - Matlabprojekt i kursen Ingenjorsvetenskap

function F = Gravity(p,G,A,F,frame)

% Functional Declarations
circle = [cos(linspace(0,2*pi,50));sin(linspace(0,2*pi,50))];
Circle = @(r,c) r*circle+c; endIn = 10; n = size(p,2);

while (endIn>0), frame = frame+1; i = 0; hold on
    if (n == 1), endIn = endIn-1; end % Adds 10 frames to end of movie
    
    while (i < n), i = i+1; % Check for collision between Particles
        for j = [1:i-1 i+1:n], if (i > n), break, end, ij = [i j];
            if (sqrt(sum((p(2:3,j)-p(2:3,i)).^2)) <= max(p(6,ij)))
                [~,big] = max(p(1,ij)); big = ij(big); % Heaviest
                Mass = sum(p(1,ij)); % New mass is sum of masses
                Pos = p(2:3,big); % Position is from heaviest
                Vel = sum(p(4:5,ij).*p(1,ij),2)/sum(p(1,ij));
                Rad = sqrt(sum(p(1,ij))/pi); % Radius from new mass
                p(:,min(ij)) = [Mass;Pos;Vel;Rad;p(7,big)];
                p = p(:,[1:max(ij)-1 max(ij)+1:n]); n = n-1; i = i-1;
                break
            end
        end
    end
    for i = 1:n, others = [1:i-1 i+1:n];
        % Expand screenspace if particle comes out of bounds
        if (p(2,i)<A(1) || p(2,i)>A(2) || p(3,i)<A(3) || p(3,i)>A(4))
            A = A + [-300 300 -200 200];
        end
        
        % Plot particle as circle
        c = Circle(p(6,i),p(2:3,i)); plot(c(1,:),c(2,:),'b')
        axis(A)%, text(p(2,i)-5,p(3,i),int2str(p(7,i)))
        
        % Distances = Positions - Position
        dist = p(2:3,others)-p(2:3,i);
        [mDist,mIdx] = min(sum(dist.^2));
        if (mDist > sum(p(6,[i others(mIdx)]))^2)
            dire = atan2(dist(2,:),dist(1,:));
            % Acceleration = G * Masses / Distances^2
            acce = G*p(1,others)./sum(dist.^2);
            % Velocitly += Acceleration
            p(4:5,i) = p(4:5,i)+sum(acce.*[cos(dire);sin(dire)],2);
        end
        % Position += Velocity
        p(2:3,i) = p(2:3,i)+p(4:5,i);
    end
    hold off, F(frame) = getframe(); clf % Capture frame & clear
end