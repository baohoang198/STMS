clc,
clear all,
close all,


%% Coordinate initial
num_point = 361;
dtheta = pi/num_point;
dphi = pi/num_point;
phi = linspace(0,2*pi,num_point);
theta = linspace(-pi/2,pi/2,num_point);
[Theta, Phi] = meshgrid(theta,phi);

%% Basic properties
d = 8.2/25;
%% Fourier Coeficients
leng_time = 8;
num_elements_x = 20;
num_elements_y =20;
num_elements = num_elements_y.* num_elements_x;
% ST_matrix = [0	3	2	2	3	3	1	0	3	2	2  	0	3	2	2	2	3	2	1	3	0	1	3	3	1	1	0	3	3	0	3	1	2	1	3	2	1	0	2	3	0	1	0	0	3	3	0	0	3	3	3	3	0	0	0	3	2	0	0	1	2	3	1	3	3	0	3	2	0	1	0	2	2	0	3	3	3	3	1	3
% ];
ST_matrix = [2	1	1	1	2	3	3	2	3	0	2	0	0	2	1	2	0	1	3	1	2	3	0	0	0	3	3	0	1	2	1	2	1	2	2	0	0	1	3	0	0	1	3	0	1	0	3	3	3	2	3	0	0	3	3	3	2	3	0	0	3	3	2	0	1	1	0	0	0	2	3	1	0	2	3	3	0	3	3	0	3	2	3	3	0	1	1	2	0	3	3	0	1	3	2	3	1	3	0	1	0	1	1	2	3	0	3	0	3	0	2	2	1	1	2	3	0	2	3	3	3	0	3	3	3	3	2	2	2	2	3	2	0	2	2	3	0	0	2	3	1	0	0	0	3	0	0	0	1	3	1	1	0	1	3	2	0	2	2	0];
% ST_matrix = [2     3     1     2     2     0     0     1];
% ST_matrix = randi([0 1],8,1);
ST_matrix = reshape(ST_matrix,num_elements_y,leng_time);
full_ST_matrix = repmat(ST_matrix,1,1,num_elements_x);
% full_ST_matrix = repelem(full_ST_matrix,2,1,1);

x = 1:8;
y = 1:8;
z = 1:8;
[X, Y, Z] = meshgrid(x,y,z);

% figure(100)
% scatter3(X(:),Z(:),Y(:),40,full_ST_matrix(:), 'filled' )     % draw the scatter plot
% ax = gca;
% ax.XDir = 'reverse' ;

T0 = 1;
harmonic_level = -1:1;
E = ones(361,361,4);
% for n = 1:4
%     E(:,:,n) = abs(Efield_cal(['patch_cell2_',num2str(n-1),'.ffd']));
% end

theta_steer = 0;
u = sin(Theta).*cos(Phi)+sind(theta_steer);
v = sin(Theta).*sin(Phi);
%% Reflection Coefficient
Amp = [0.78,0.27,0.78,0.27];
Phase = deg2rad([-100 -45 83 144]);

%% Calculation Field
total_E_cal = zeros(361,361,length(harmonic_level));
total_E_sim = zeros(361,361,length(harmonic_level));
EField_cal = zeros(361,361,leng_time);
EField_sim = zeros(361,361,leng_time);
for n = 1:leng_time
%     EField_sim(:,:,n) = Efield_calculation([pwd,'/220901_wt03/220830_28GHz_TimeSlot',num2str(n),'_Model',num2str(4),'.ffd']);   %% Import simulated data file 
for p = 1:num_elements_y
    for q = 1:num_elements_x
        if full_ST_matrix(p,n,q) == 0
            EField_cal(:,:,n) = EField_cal(:,:,n)+ E(:,:,1).*Amp(1).*exp(1j*(Phase(1))).*cos(Theta).*exp(1j*2*pi*d*((p-1).*u+(q-1).*v));
        elseif full_ST_matrix(p,n,q) == 1
            EField_cal(:,:,n) = EField_cal(:,:,n)+ E(:,:,2).*Amp(2).*exp(1j*(Phase(2))).*cos(Theta).*exp(1j*2*pi*d*((p-1).*u+(q-1).*v));
        elseif full_ST_matrix(p,n,q) == 2
            EField_cal(:,:,n) = EField_cal(:,:,n)+ E(:,:,3).*Amp(3).*exp(1j*(Phase(3))).*cos(Theta).*exp(1j*2*pi*d*((p-1).*u+(q-1).*v));
        else
            EField_cal(:,:,n) = EField_cal(:,:,n)+ E(:,:,4).*Amp(4).*exp(1j*(Phase(4))).*cos(Theta).*exp(1j*2*pi*d*((p-1).*u+(q-1).*v));
        end
    end
end
end

for k = 1:length(harmonic_level) 
    E_cal = zeros(361,361,leng_time);
%     E_sim = zeros(361,361,leng_time);
    for n = 1:leng_time
% % % %         for p = 1:num_elements_y
% % % %             for q = 1:num_elements_x
% % % %                 if full_ST_matrix(p,n,q) == 0
% % % %                     %                     A_npq(n) = Amp(1);
% % % %                     %                     phase_npq(n) = exp(1j*(Phase(1)));
% % % %                     AF_cal(:,:,n) = AF_cal(:,:,n)+ E(:,:,1).*cos(Theta).*Amp(1).*exp(1j*(Phase(1))).*exp(1j*2*pi*d*((p-1/2).*u+(q-1/2).*v));
% % % %                 elseif full_ST_matrix(p,n,q) == 1
% % % %                     AF_cal(:,:,n) = AF_cal(:,:,n)+ E(:,:,2).*cos(Theta).*Amp(2).*exp(1j*(Phase(2))).*exp(1j*2*pi*d*((p-1/2).*u+(q-1/2).*v));
% % % %                 elseif full_ST_matrix(p,n,q) == 2
% % % %                     AF_cal(:,:,n) = AF_cal(:,:,n)+ E(:,:,3).*cos(Theta).*Amp(3).*exp(1j*(Phase(3))).*exp(1j*2*pi*d*((p-1/2).*u+(q-1/2).*v));
% % % %                 else
% % % %                     AF_cal(:,:,n) = AF_cal(:,:,n)+ E(:,:,4).*cos(Theta).*Amp(4).*exp(1j*(Phase(4))).*exp(1j*2*pi*d*((p-1/2).*u+(q-1/2).*v));
% % % %                 end
% % % %             end
% % % %         end
        E_cal(:,:,n) = EField_cal(:,:,n).*(sinc(harmonic_level(k)/leng_time)/leng_time).*(exp(-1j*pi*harmonic_level(k)*(2*n-1)/leng_time));
%         E_sim(:,:,n) = EField_sim(:,:,n).*(sinc(harmonic_level(k)/leng_time)/leng_time).*(exp(-1j*pi*harmonic_level(k)*(2*n-1)/leng_time));
    end
    total_E_cal(:,:,k) = sum(E_cal,3);
%     total_E_sim(:,:,k) = sum(E_sim,3);
    %% Array factor Calculation
    %     AF1(:,:,k) = AF_cal(Theta,Phi,d,FC1,num_elements_x,num_elements_y);
    %     AF2(:,:,k) = AF_cal(Theta,Phi,d,FC2,num_elements_x,num_elements_y);
    %     Utheta = abs(AF(k,:)).^2;
    %     Prad = sum(sum(Utheta.*sin(Theta)*dtheta*dphi));
    %     D(k,:) = 4*pi*Utheta/Prad;
    %     Ddb(k,:)=10.*log10(D(k,:)/max(D(k,:)));
    %     Ddb(k,:)=Ddb(k,:)-max(Ddb(k,:));
    %     peak = findpeaks(AF(k,:));
    %     Ddb(k,:)=10.*log10(abs(D(k,:)));
    total_E_cal = abs(total_E_cal);
%     total_E_sim = abs(total_E_sim);
    

end

%% Calculated Radiation Pattern 
X_idx = find(Phi == 0,1,'first');  % Find Phi = 0
figure,
ax = polaraxes;
for i = 1:length(harmonic_level)

    polarplot(ax,(theta),(total_E_cal(X_idx,:,i)/max(max(total_E_cal(X_idx,:,i)))));
%     polarplot(ax,(theta),(total_E_cal(X_idx,:,i)));
    grid on;
    ax.ThetaZeroLocation = 'top';
    ax.ThetaDir = 'clockwise'; % 90 degrees at the right
    hold on;
    pattern1(:,i) = (total_E_cal(X_idx,:,i)/max(max(total_E_cal(X_idx,:,i))))';
end
% pattern1 = (total_E_cal(X_idx,:,i)/max(max(total_E_cal(X_idx,:,i))))';
theta = rad2deg(theta)';
%   figure(202),
% ax = polaraxes; 
% for i = 1:length(harmonic_level)
%     polarplot(ax,(theta),(total_E_sim(X_idx,:,i)/max(max(total_E_sim(X_idx,:,i)))));
%     polarplot(ax,(theta),(total_E_sim(X_idx,:,i)));
%     grid on;
%     ax.ThetaZeroLocation = 'top';
%     ax.ThetaDir = 'clockwise'; % 90 degrees at the right
%     hold on;
% end


% % % 3D
% % for i = 1:length(harmonic_level)
% %     figure;
% % [x,y,z] = sph2cart(Phi,pi/2-Theta,total_E_cal(:,:,i));
% % mesh(x,y,z);
% % colorbar;
% % colormap(jet)
% % axis([-inf inf -inf inf 0 inf])
% % xlabel('x')
% % ylabel('y')
% % zlabel('z')
% % end