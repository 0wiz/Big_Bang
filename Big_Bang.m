% Big Bang - Matlabprojekt i kursen Ingenjorsvetenskap

function F = Big_Bang(n, count) % n=NrOfParticles
PosAndVel = zeros(4,1); begin = round(n^(1/3))*7;

% Camera Declarations
s = [rand(1,300)*4;rand(2,300)*3000-1500];
F = struct('cdata',[],'colormap',[]); frame = 0; mS = 'MarkerSize';
figure('Color','white'), set(figure(1),'Position', [300 0 800 800])

for bangCount = 1:count
    % Particle(p): 1=Mass 2:3=Pos 4:5=Vel 6=Radius
    p = [randi(50,1,n)+150;zeros(5,n)];
    p(2:5,:) = repelem(PosAndVel,1,n); p(6,:) = sqrt(p(1,:)/pi);
    
    % Calculate Acceleration from initial Force
    ini = [randi(50,1,n)+20;pi*randi(200,1,n)/100];
    acc = ini(1,:)./p(1,:).*[cos(ini(2,:));sin(ini(2,:))];
    
    for startIn = begin:(-1):0
        frame = frame+1; C = zeros(3,1); hold on
        
        % Draw background stars and adjust zoom
        for i = 1:size(s,2), plot(s(2,i),s(3,i),'*b',mS,2+s(1,i)); end
        
        % Update particles
        for i = 1:n
            p(2:3,i) = p(2:3,i)+p(4:5,i); % Pos += Vel
            p(4:5,i) = p(4:5,i)+acc(:,i); % Vel += Acc
            Circle(p(6,i),p(2:3,i),'k','k') % Draw particle
            C(1) = C(1)+p(1,i); % Calculate center of mass
            C(2:3) = (C(2:3)*C(1)+p(2:3,i)*p(1,i))/C(1);
        end
        
        % Center, zoom & finish up camera before image capture
        hold off, set(gca,'visible','off')
        A = [-1 1]*(max(max(abs(p(2:3,:)-C(2:3))))+max(p(6,:))*2);
        axis([A+C(2) A+C(3)]), F(frame) = getframe(); clf
    end
    
    % Collect particles again and catch changes
    [p,F] = Gravity(p,s,F); PosAndVel = p(2:5,1);
    frame = numel(cellfun('isempty',{F.cdata}));
end
