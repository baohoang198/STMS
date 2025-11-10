function Cost = Cost_function(num_elements_x,num_elements_y,ST_matrix,theta_desired,leng_time,harmonic_level)
ST_matrix = reshape(ST_matrix,num_elements_y,leng_time);
full_ST_matrix = repmat(ST_matrix,1,1,num_elements_x);
d = 8.2/25;
full_ST_matrix = repelem(full_ST_matrix,2,1,1);
SLL_desired = 0.5;
%% Coordinate initial

num_point = 361;
dtheta = pi/num_point;
dphi = pi/num_point;
phi = 0;
theta = -pi/2:dtheta:pi/2;
[Theta, Phi] = meshgrid(theta,phi);

Cost = 0;
% Weight
weightTD_funda = 10;
weightTD_harmonic = 10;
weightSLL = 9;
Amp = [0.88 0.43 0.45 0.86];
Phase = deg2rad([-180 -90 0 90]);

for i = 1:length(harmonic_level)

    for p = 1:num_elements_y
        
        for q = 1:num_elements_x
            
            for n = 1:leng_time
                if full_ST_matrix(p,n,q) == 0
                    A_npq(n) = Amp(1);
                    phase_npq(n) = exp(1j*(Phase(1)));
                elseif full_ST_matrix(p,n,q) == 1
                    A_npq(n) = Amp(2);
                    phase_npq(n) = exp(1j*(Phase(2)));
                elseif full_ST_matrix(p,n,q) == 2
                    A_npq(n) = Amp(3);
                    phase_npq(n) = exp(1j*(Phase(3)));
                else
                    A_npq(n) = Amp(4);
                    phase_npq(n) = exp(1j*(Phase(4)));
                end
            end
            %             % Phase modulation
%             A_npq = ones(1,leng_time);
%             phase_npq = exp(1j*(pi/2.*full_ST_matrix(p,:,q)-Phasemax));
            %% Fourier coefficient
            FC(p,:,q) = Fourier_coef_cal(A_npq,phase_npq,harmonic_level(i),leng_time);
        end
    end
    %% Array factor Calculation
    AF = AF_cal(Theta,Phi,d,FC,num_elements_x,num_elements_y);
    AF = abs(AF);
    % %
    % %     theta_cal_idx = find(AF == 1);
    % %     theta0_idx = find(theta == 0);

    %% Cost value calculation

    theta_cal_idx = AF == max(max(AF));
    TD = abs(rad2deg(theta(theta_cal_idx))-theta_desired(i));
    %     Cost = Cost + weightTD*TD; %xac dinh peak cua truong tan x
    if harmonic_level(i) == 0
        Cost = Cost + weightTD_funda.*TD;
    else
        Cost = Cost + weightTD_harmonic.* TD;
    end
    Cost = max(Cost);

    AF_peak = findpeaks(AF);
    AF_SLL = setdiff(AF_peak,max(max(AF)));
    if (isempty(AF_SLL))
        SLL = 0;
    else
        SLL = max(AF_SLL);
    end
    Cost = Cost + weightSLL*SLL;
%     Cost = Cost - max(max(AF));
end
Cost = max(Cost);