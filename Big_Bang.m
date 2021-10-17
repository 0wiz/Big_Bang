% Big Bang - Matlabprojekt i kursen Ingenjorsvetenskap

n = 50; G = 5; % n=NumberOfParticles G=GravityConst p=Particles
% [ 1=Mass 2=X-Pos 3=Y-Pos 4=X-Vel 5=Y-Vel 6=Radius 7=Num ]
p = [randi(50,1,n)+150;ones(1,n)*250;ones(1,n)*200;zeros(3,n);1:n];

% Functional Declarations
circle = [cos(linspace(0,2*pi,50));sin(linspace(0,2*pi,50))];
frame = 0; p(6,:) = sqrt(p(1,:)/pi); Circle = @(r,c) r*circle+c;
A = [0 500 0 400]; F = struct('cdata',[],'colormap',[]);

% Calculate Acceleration from initial Force
ini = [randi(50,1,n)+20;pi*randi(200,1,n)/100];
acce = ini(1,:)./p(1,:).*[cos(ini(2,:));sin(ini(2,:))];

for s=1:25, frame = frame+1; hold on
    for i = 1:n
        % Velocitly += Acceleration Position += Velocity
        p(4:5,i) = p(4:5,i)+acce(:,i); p(2:3,i) = p(2:3,i)+p(4:5,i);
        c = Circle(p(6,i),p(2:3,i)); plot(c(1,:),c(2,:),'b'), axis(A)
    end, hold off, F(frame) = getframe(); clf % Capture frame & clear
end

F = Gravity(p,G,A,F,frame);
movie(F)