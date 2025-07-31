clc,
clear,
% close all
addpath('GA')
%% Coordinate initial
num_point = 361;
dtheta = pi/num_point;
dphi = pi/num_point;
phi = linspace(0,2*pi,num_point);
theta = linspace(-pi/2,pi/2,num_point);
[Theta, Phi] = meshgrid(theta,phi);

%% Basic properties
d = 0.36;
%% Fourier Coeficients
leng_time = 1;
num_elements_x = 10;
num_elements_y = 10;
num_elements = num_elements_y.* num_elements_x;
ST_matrix = [1	0	2	2	0	2	3	3	1	2	3	3	0	2	1	1	0	3	2	2	2	0	3	0	2	2	1	3	3	3	2	2	2	1	3	2	2	0	3	3	1	2	3	2	3	1	2	2	1	3	3	0	1	3	3	3	1	2	0	2	0	3	1	2	3	3	2	2	2	2	3	2	1	1	3	3	3	1	2	3
];
% ST_matrix = zeros(1,8*8);
% ST_matrix = diag(ones(1,leng_time));
ST_matrix = reshape(ST_matrix,num_elements_y,8);
ST_matrix = ST_matrix(:,1);
full_ST_matrix = (repmat(ST_matrix,1,1,num_elements_x));
% full_ST_matrix = repelem(full_ST_matrix,2,1,1);
x = 1:8;
y = 1:8;
z = 1:8;

[X, Y, Z] = meshgrid(x,y,z);

% figure(100)
% scatter3(X(:),Z(:),Y(:),40,full_ST_matrix(:), 'filled' )     % draw the scatter plot
% xlabel('Time Slot')
% zlabel('X-Axis Space Coding')
% ax = gca;
% ax.XDir = 'reverse' ;


% full_ST_matrix = repmat(ST_matrix,1,1,num_elements_x);
T0 = 1;
harmonic_level = -3:3;
Amp = [0.9, 0.7,0.7,0.98];
Phase = deg2rad([-115.98 -40.12 57.18 149.98]);
% Phase = deg2rad([133.67,  48.66, -43.52]);
for n = 1:4
    E(:,:,n) = Efield_cal(['220517_Unitcell',num2str(n),'.ffd']);
end
for k = 1:length(harmonic_level)
    for p = 1:num_elements_y
        for q = 1:num_elements_x
            %% Phase modulation
            for n = 1:leng_time
                if full_ST_matrix(p,n,q) == 0
                    A_npq1(n) = Amp(1);
                    phase_npq1(n) = exp(1j*(Phase(1)));
                elseif full_ST_matrix(p,n,q) == 1
                    A_npq1(n) = Amp(2);
                    phase_npq1(n) = exp(1j*(Phase(2)));
                elseif full_ST_matrix(p,n,q) == 2
                    A_npq1(n) = Amp(3);
                    phase_npq1(n) = exp(1j*(Phase(3)));
                else
                    A_npq1(n) = Amp(4);
                    phase_npq1(n) = exp(1j*(Phase(4)));
                end
            end
            %             A_npq1 = ones(1,leng_time);
%             phase_npq1 = exp(1j*(pi/2).*(full_ST_matrix(p,:,q))-deg2rad(144.13));
            FC1(p,:,q) = Fourier_coef_cal(A_npq1,phase_npq1,harmonic_level(k),leng_time);
            equi_amp1(p,k,q) = abs(FC1(p,:,q));
            equi_phase1(p,k,q) = rad2deg(angle(FC1(p,:,q)));

            %             %% Amplitute modulation
            %             A_npq2 = full_ST_matrix(p,:,q);
            %             phase_npq2 = exp(1j.*ones(1,num_elements_y).*(0));
            %             FC2(p,:,q) = Fourier_coef_cal(A_npq2,phase_npq2,harmonic_level(k),leng_time);
            %             equi_amp2(p,k,q) = abs(FC2(p,:,q));
            %             equi_phase2(p,k,q) = rad2deg(angle(FC2(p,:,q)));
        end
    end
    %% Array factor Calculation
    AF1(:,:,k) = AF_cal(Theta,Phi,d,FC1,num_elements_x,num_elements_y,full_ST_matrix,E,leng_time);
    
    %     AF2(:,:,k) = AF_cal(Theta,Phi,d,FC2,num_elements_x,num_elements_y);
    %     Utheta = abs(AF(k,:)).^2;
    %     Prad = sum(sum(Utheta.*sin(Theta)*dtheta*dphi));
    %     D(k,:) = 4*pi*Utheta/Prad;
    %     Ddb(k,:)=10.*log10(D(k,:)/max(D(k,:)));
    %     Ddb(k,:)=Ddb(k,:)-max(Ddb(k,:));
    %     peak = findpeaks(AF(k,:));
    %     Ddb(k,:)=10.*log10(abs(D(k,:)));
    AF1 = abs(AF1);
    %     AF2 = abs(AF2);
    % AF = abs(AF)/abs(max(AF));
%     af1 = 10.*log10(AF1);
    %     af2 = 10.*log10(AF2);
    % Ddb=10.*log10(D);
    %     figure,

end
% figure,
% image(equi_phase1(:,:,1),'CDataMapping' , 'scaled')
% h = colorbar;
% colormap("turbo")
% set(h, 'ylim' , [-180 180])
% caxis([-180 180])
% % %
% figure,
% image(abs(equi_amp1(:,:,1)),'CDataMapping' , 'scaled')
% h = colorbar;
% colormap("turbo")
% set(h, 'ylim' , [0 0.8])
% %
% figure,
% image(equi_phase2(:,:,1),'CDataMapping' , 'scaled')
% h = colorbar;
% colormap("turbo")
% set(h, 'ylim' , [-180 180])
% % %
% figure,
% image(abs(equi_amp2(:,:,1)),'CDataMapping' , 'scaled')
% h = colorbar;
% colormap(jet)
% set(h, 'ylim' , [0 0.3])
%
% figure;
% ax = polaraxes;                    % Find Desired ‘X’ Value
% polarplot(ax,Theta, AF1(:,:,1) );                        % Plot At Desired )X1 Value
% grid on;
% ax.ThetaZeroLocation = 'top';
% ax.ThetaDir = 'clockwise'; % 90 degrees at the right
% hold on;

% for ii = 1:length(harmonic_level)
%     af1(ii,:) =af1(ii,:)-normalize_af;
% end

% 3D

% for i = 1:length(harmonic_level)
%     figure;
% [x,y,z] = sph2cart(Phi,pi/2-Theta,AF1(:,:,i));
% mesh(x,y,z);
% colorbar;
% colormap(jet)
% axis([-inf inf -inf inf 0 inf])
% xlabel('x')
% ylabel('y')
% zlabel('z')
% end

% %2D
X_idx = find(Phi == 0,1,'first');
% figure,
% for i = 1:length(harmonic_level)
%     plot(rad2deg(theta),AF1(X_idx,:,i));
%     xlabel('Theta (\theta)')
%     ylabel('Scattering pattern')
%     axis([-90 90 -40 20])
%     hold on;
%     grid on;
% end

figure,
ax = polaraxes;
for i = 1:length(harmonic_level)

    polarplot(ax,(theta),AF1(X_idx,:,i));                        % Plot At Desired )X1 Value
    grid on;
    ax.ThetaZeroLocation = 'top';
    ax.ThetaDir = 'clockwise'; % 90 degrees at the right
    hold on;
end


%
% normalize_af = max(af2(4,:));
% figure,
% for i = 1:length(harmonic_level)
% plot(rad2deg(theta),af2(X_idx,:,i)-normalize_af);
% xlabel('Theta (\theta)')
% ylabel('Scattering pattern')
% axis([-90 90 -50 10])
% hold on;
% grid on,
% end
