% Gravitation - Matlabprojekt i kursen Ingenjorsvetenskap

function [p,F] = Gravity(p,s,F,Circle)
% Define some variables and derive others from input data
n = size(p,2); frame = numel(cellfun('isempty',{F.cdata}));
mS = 'MarkerSize';

while (p(6,1)>6.9), frame = frame+1; C = zeros(3,1); hold on
    % Draw background stars and adjust zoom
    for i = 1:size(s,2), plot(s(2,i),s(3,i),'*b',mS,2+s(1,i)); end
    
    for i = 1:n, rest = [1:i-1 i+1:n];
        % Update particles
        dist = p(2:3,rest)-p(2:3,i); % Dists = Positions-Pos
        dir = atan2(dist(2,:),dist(1,:)); % Directions to p(rest)
        acc = sum(5*p(1,rest)./sum(dist.^2).*[cos(dir);sin(dir)],2);
        if (sum(acc.^2)<100), p(4:5,i) = p(4:5,i)+acc;
        else, p(4:5,i) = p(4:5,i)+.001*acc; end
        p(2:3,i) = p(2:3,i)+p(4:5,i);
        
        % Draw parcticle & Calculate center of mass
        Circle(p(6,i),p(2:3,i),'k','k')
        C = [C(1)+p(1,i);(C(2:3)*C(1)+p(2:3,i)*p(1,i))/(C(1)+p(1,i))];
    end, hold off
    A = [-1 1]*(max(max(abs(p(2:3,:)-C(2:3))))+max(p(6,:))*2);
    axis([A+C(2) A+C(3)]), set(gca,'visible','off')
    F(frame) = getframe(); clf, i = 0;
    if (n==1), p(6,1) = p(6,1)*.8; end
    
    % Check for collision between Particles
    while (i<n), i = i+1;
        for j = [1:i-1 i+1:n], if (i > n), break, end, ij = [i j];
            if (sum((p(2:3,j)-p(2:3,i)).^2) < max(p(6,ij))^2)
                [~,big] = max(p(1,ij)); big = ij(big); % Biggest
                Mass = sum(p(1,ij)); % New mass is sum of masses
                Vel = sum(p(4:5,ij).*p(1,ij),2)/Mass; % Momentum
                p(:,min(ij)) = [Mass;p(2:3,big);Vel;sqrt(Mass/pi)];
                p = p(:,[1:max(ij)-1 max(ij)+1:n]); n = n-1; i = i-1;
                break
            end
        end
    end
end