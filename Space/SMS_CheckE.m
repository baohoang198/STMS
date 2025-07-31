clc
clear
j = sqrt(-1);
M = 361;
k=2*pi;
theta = linspace(-pi/2,pi/2,M);
phi = linspace (0,2*pi,M);
[Theta,Phi] = meshgrid(theta,phi);
dtheta = pi/M;
dphi = pi/M;
% AF_pattern = AF_pattern(30,0);

Nbit = 2;
%Planar array variables
Mx=4; Ny=20;
dx=0.63/2;
dy=dx;
Theta_steering = 0;
Phi_steering = 0;
deltax=k*dx*sind(Theta_steering)*cosd(Phi_steering); deltay=k*dy*sind(Theta_steering)*sind(Phi_steering);
% Phase=randi([0 1],Mx,Ny);
% Phase=zeros(Mx,Ny);
amp=ones(Mx,Ny);
%  Phase= randi([0 3],Mx,Ny);
Phase=zeros(1,Ny);
% Phase = randi([0 1],5,5)
msize0 = 4;
msize1 = Mx-msize0;
% % % Phase00 = zeros(msize0,Ny);
% % % Phase01 = ones(msize1,Ny);
% % % Phase10 = ones(msize1,Ny);
% % % Phase11 = ones(msize1,Ny);
% Phase = ones(Mx,Ny);
Phase=[ 1     0     0     3     3     2     1     1     0     3     3     2     1     1     0     3     3     2     2     1
];
% Phase = randi([0 1],Mx,1);
Phase = repmat(Phase,Mx,1);
%Phase = repelem(Phase,1,2);
%Phase=Phase';
%Array factor calculation
psix=(k*dx*sin(Theta).*cos(Phi))+deltax;
psiy=(k*dy*sin(Theta).*sin(Phi))+deltay;
psix_00=(k*dx*sin(0).*cos(0))+deltax;
psiy_00=(k*dy*sin(0).*sin(0))+deltay;
AF=0;
AFy=0;
AF_00=0;
for m=1:Mx
    for n= 1:Ny
        AF = AF + amp(m,n).*exp(j*Phase(m,n)*pi/Nbit).*exp(j*(m-1/2)*psix).*exp(j*(n-1/2)*psiy);
    end
end

% AFmag = abs(AF);
AF_00mag=abs(AF_00);
%% Directivity Calculation
% % % Utheta = AFmag.^2;
% % % Prad = sum(sum(Utheta.*sin(Theta)*dtheta*dphi));
% % % D = 4*pi*Utheta/Prad;
% % % Ddb=10.*log10(D);
AFmag = abs(AF)/max(max(abs(AF)));
%%3D Directivity plot
% figure;
% surf(Phi,Theta,D);shading interp; colormap('default');
% xlabel('\phi [deg]','FontSize',15); set(gca,'XTick',-pi/2:pi/6:pi/2);
% set(gca,'XTicklabel',{'-90','-60','-30','0','30','60','90'},'fontsize',15,'fontweight','bold','box','on');
% ylabel('\theta [deg]','FontSize',15); set(gca,'YTick',0:pi/6:pi);
% set(gca,'YTicklabel',{'180','150','120','90','60','30','0'},'fontsize',15,'fontweight','bold','box','on');
% axis([-pi/2,pi/2,0,pi,-Inf,Inf]);
% zlabel('Directivity','FontSize',15);
% title('3D Dir as func of \theta and \phi','FontSize',20);

figure;
% AF=abs(AF_Field);
% disp(max(max(AF)))
[x,y,z] = sph2cart(Phi,pi/2-Theta,AFmag);
mesh(x,y,z);
%axis([-20 20 -20 20 -Inf Inf])
colorbar;
%caxis([-20 20]);
xlabel('x')
ylabel('y')
zlabel('z')
rad2deg = 180/pi;

X_idx = find(Phi == pi/2,1,'first');
AFmag=AFmag(X_idx,:);

% % % Cost=sqrt(sum(sum((AFmag-AF_pattern).^2)));
% % % [row1 col1] = find(AFmag(X_idx,:) == max(max(AFmag(X_idx,:))));
% % % [row2 col2] = find(AF_pattern == max(max(AF_pattern)));
% % % TD = abs(theta(row1,col1)*rad2deg-theta(row2,col2)*rad2deg)
% % % a=theta(row1, col1)*rad2deg
% % % b=theta(row2, col2)*rad2deg
% % % TD = min(min(TD));
% % % if TD <= 3
% % %     Cost = Cost-100;
% % % elseif 3 < TD && TD <= 10
% % %         Cost = Cost-50;
% % % else
% % %     Cost = Cost;
% % % end



figure;
ax = polaraxes;
X_idx = find(Phi == pi/2,1,'first');                     % Find Desired ‘X’ Value
polarplot(ax,(Theta(X_idx,:)), AFmag)                            % Plot At Desired ‘X’ Value
grid on;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise'; % 90 degrees at the right
grid on;
hold on;
% X_idx = find(Phi ==(pi-0), 1, 'first');                     % Find Desired ‘X’ Value
% polarplot((pi/2+Theta(X_idx,:)), AFmag(X_idx,:)) 
hold off



