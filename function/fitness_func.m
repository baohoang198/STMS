function AF = fitness_func(N0,H,c,f,AB_phase)
%function AF = fitness_func(N0,H,c,f,AB_phase)
%dx, dy, dz must less than lamda/2
%constants
N=17;
M=17;
f0=12e9;
lambda=c/f;
lambda0=c/f0;
dx=lambda0/5; %distance between elements (X)
dy=lambda0/5;%distance between elements (Y)
dz=lambda0/5;
phiS=0;
thetaS=0;
AB=[0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;
    0 0 0 0 sqrt(3)/2 0 0 0 0 0 0 0 sqrt(3)/2 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Array amplitudes
AB=AB';
[ row col ]=find(AB);
AB=repmat(AB,1,1,H);
total_power= (sum(sum(sum(AB.^2))));
%AB_phase=randi([0 1],H,N0); %Array phases
%AB_phase=ones([0 1 ],H,N0);
for j=1:H
    for i=1:N0
        AB(row(i),col(i),j)=AB(row(i),col(i),j)*exp(AB_phase(j,i).*180j);
    end
end

%AF calculation
theta0=[1:1:180];
phi0=[1:1:360];
[phi,theta]=meshgrid(phi0,theta0);
sinU=sind(theta).*cosd(phi)-sind(thetaS)*cosd(phiS);
sinV=sind(theta).*sind(phi)-sind(thetaS)*sind(phiS);
sinW=cosd(theta)-cos(thetaS);
AF_Field=0;

for h=1:H
    for n=1:N
        for m=1:M
            AF_Field = AB(m,n,h)*exp(1j*2*pi*(m)/lambda*dx*(sinU)).*exp(1j*2*pi*(n)/lambda*dy*(sinV)).*exp(1j*2*pi*(h)/lambda*dz*sinW)+ AF_Field;
        end
    end
end
AF_power=AF_Field.^2;
AF_power_normalized=AF_power/total_power;
AF=max(max(abs(AF_power_normalized)));
%Plotting
%mesh(phi0*180/pi,theta0*180/pi,20*log10(abs(AF)))
%axis([0 360 0 180 -10 6])
% surf(phi0,theta0,(abs(AF_power_normalized))), colorbar
% xlabel('\phi')
% ylabel('\theta')
% shading interp


% disp(max(max(abs(AF_power_normalized))))

% %% Dir(theta, phi)
% f=abs(AF_power);
% tmp=0;
% for phi=1:1:360
%     for theta=1:1:179
%         tmp=tmp+(f(theta,phi).*sind(theta)+f(theta+1,phi).*sind(theta+1));
%     end
% end
% Dir=(4*pi.*f)/tmp;
% Max_Dir=max(max(Dir));
% RCS=Max_Dir*lambda.^2/(4*pi*(N0^2)*(dx^2));
% toc