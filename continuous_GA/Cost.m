function Cost=Cost(Phase,Incident,peakTarget,beamwidth,Nbit,numberCol,dx,dy,Phasemax,amp)
peakTarget = deg2rad(peakTarget);
beamwidth = deg2rad(beamwidth);

%do not use target
M = 361;
k=2*pi;

Mx  = length(Phase); Ny = numberCol;
theta = linspace(-pi/2,pi/2,M);
phi = linspace (0,2*pi,M);
dtheta = pi/M;
beamStep = fix(beamwidth/dtheta);
Theta_steering = Incident;
Phi_steering = 0 ;
[Theta,Phi] = meshgrid(theta,phi);
Phase = Phase';
Phase = repmat(Phase,1,Ny);
%Planar array variables



deltax=k*dx*sind(Theta_steering)*cosd(Phi_steering);
deltay=k*dy*sind(Theta_steering)*sind(Phi_steering);
%Array factor calculation
psix=(k*dx*sin(Theta).*cos(Phi))+deltax;
psiy=(k*dy*sin(Theta).*sin(Phi))+deltay;
AF=0;

for m=1:Mx
    for n= 1:Ny
        if Phase(m,n) ==0
        AF = AF + amp(1).*exp(1j*(Phase(m,n)*pi/Nbit-(Phasemax*pi/180))).*exp(1j*(m-1/2)*psix).*exp(1j*(n-1/2)*psiy);
        elseif Phase(m,n) ==1
            AF = AF + amp(2).*exp(1j*(Phase(m,n)*pi/Nbit-(Phasemax*pi/180))).*exp(1j*(m-1/2)*psix).*exp(1j*(n-1/2)*psiy);
        elseif Phase(m,n) ==2
            AF = AF + amp(3).*exp(1j*(Phase(m,n)*pi/Nbit-(Phasemax*pi/180))).*exp(1j*(m-1/2)*psix).*exp(1j*(n-1/2)*psiy);
        elseif Phase(m,n) ==3
            AF = AF + amp(4).*exp(1j*(Phase(m,n)*pi/Nbit-(Phasemax*pi/180))).*exp(1j*(m-1/2)*psix).*exp(1j*(n-1/2)*psiy);
        end
    end
end

%% Cost value calculation
X_idx = find(Phi == 0,1,'first');
AF = abs(AF(X_idx,:))./(max(max(abs(AF(X_idx,:)))));
peak = find(AF == 1);
Cost = 0;
theta0_idx = find(theta == 0);
% main side
if peakTarget > 0
    for i = 1 : theta0_idx
        if (AF(i)>0.7)
            Cost = Cost + 1e10;
        else
            continue,
        end
    end
elseif peakTarget < 0
    for i = theta0_idx : M
        if (AF(i)>0.7)
            Cost = Cost + 1e10;
        else
            continue,
        end
    end
end


if length(peak) == 1
    TD = abs(theta(peak)-peakTarget);
    
    % Weight
    weightTD = 1000;
    weightBW = 7;
    weightSL = 5;
  
    Cost = Cost + weightTD*TD; %xac dinh peak cua truong tan xa
    if peak+beamStep > 361 || peak-beamStep < 1
        Cost = 1e10;
    else
        for i = (peak-beamStep):(peak+beamStep)

            Cost = Cost - weightBW*AF(i);
        end
        
        for i = 1:(peak-beamStep-1)
            Cost = Cost + weightSL*AF(i);
        end
        
        for i = (peak+beamStep+1):361
            Cost = Cost + weightSL*AF(i);
        end
    end
end

% disp(CostFunc)