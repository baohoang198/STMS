% ============================================================
% ST-LWA (Eq. 11 scatter field) with ts from a *reference harmonic* m0
% ts(x) = [(xi_m0*sin(theta_r0) - xi_gw) / (2*pi*m0)] * x   (fixed for all m)
% k_m   = 2*pi*m*dt_s/dx = 2*pi*m*q
% x in [0,L] with 81 points; Δf = 50 MHz; uniform tau(x)=tau0
% Computes: (1) polar POWER (upper semicircle), (2) peak vs m (stem),
%           (3) ts(x) vs x, (4) binary state map.
% ============================================================

clear; clc; close all;

%% ---------------- User parameters ----------------
c      = 3e8;                 % speed of light (m/s)
f0     = 10e9;                % base RF frequency (Hz)
df     = 20e3;                % Δf = 50 MHz

m0     = 1;                  % *** reference harmonic for ts(x)
theta_r0_deg = 40;            % desired beam angle for m0 (deg)

m_list = -4:4;                % harmonics to evaluate (including m=0)
tau0   = 0.5;                 % uniform duty cycle 0..1
beta_gw_ratio = 1;          % ξ_gw / k0  (ξ_gw treated constant)

aperture_in_wavelengths_at_f0 = 10;  % L = this * λ0 (fixed physical length)
Nx     = 81;                 % *** spatial samples (meta-atoms)
Ntheta = 1001;               % angular samples
upper_half_span_deg = 90;    % show -90..+90 deg in polar
Ntime  = 100;                % rows in state map
show_ts_mod1 = true;         % also show ts mod 1
% --------------------------------------------------

%% ---------------- Grids and fixed quantities ----------------
k0      = 2*pi*f0/c;
lambda0 = 2*pi/k0;
L       = aperture_in_wavelengths_at_f0 * lambda0;      % fixed physical aperture
x       = linspace(0, L, Nx);                           % x ∈ [0, L]
thetas  = linspace(deg2rad(-upper_half_span_deg), ...
                   deg2rad(+upper_half_span_deg), Ntheta);

% Waveguide wavenumber: constant (paper note)
xi_gw   = beta_gw_ratio * k0;

% Reference harmonic spatial wavenumber (physical, for ts design)
fm0     = f0 + m0*df;
xi_m0   = 2*pi*fm0/c;

% ----- Fixed time-shift slope q from your formula -----
q       = (xi_m0*sin(deg2rad(theta_r0_deg)) - xi_gw) / (2*pi*m0);  % cycles/m
ts_x    = q * x;                             % cycles (unwrapped)
ts_x_mod1 = mod(ts_x, 1);

fprintf('ts from m0=%+d: q = %.6g cycles/m, L = %.3g m, ts range [%.3f, %.3f] cycles\n',...
        m0, q, L, min(ts_x), max(ts_x));

% --- build state map (does not affect far-field) ---
t_norm = (0:Ntime-1)/Ntime;  State = zeros(Ntime, Nx);
for it = 1:Ntime
    phase = mod(t_norm(it) + ts_x_mod1, 1);
    State(it, :) = phase < tau0;            % 1 if ON, else 0
end

%% ---------------- Far-field with Eq. (11) ----------------
% Eq. (11):
% m = 0 :  A(x) = tau(x) * exp(-j * xi_gw * x)
% m≠0   :  A(x) = tau(x)*sinc(pi m tau(x)) * exp(-j * (xi_gw + k_m) * x)
% with k_m = 2*pi*m*q and evaluation at kx = xi_m*sin(theta), xi_m = 2π(f0+mΔf)/c

tau_x   = tau0 * ones(1, Nx);  % uniform τ(x)

S = struct('theta', [], 'power', [], 'label', [], 'theta_pred', [], ...
           'is_radiating', [], 'P_peak', [], 'theta_peak', [], ...
           'fmGHz', [], 'm', []);
S_idx = 0; global_Pmax = 0;

for m = m_list
    fm   = f0 + m*df;
    xi_m = 2*pi*fm/c;                   % physical free-space wavenumber at ω0+mΔω
    k_m  = 2*pi*m*q;                    % spatial shift from ts slope (rad/m)
    % k_m = 2.*pi.*m.*(ts_x(2)./x(2));
% k_m = 0
    if m == 0
        A = tau_x .* exp(-1j * (xi_gw * x));
    else
        % MATLAB sinc: sin(pi*z)/(pi*z) -> use sinc(m*tau) to get sinc(pi*m*tau)
        A = tau_x .* sinc(m*tau_x) .* exp(-1j * ((xi_gw + k_m) * x));
    end

    % Spatial FT evaluated at kx = xi_m sin θ
    kx = xi_m * sin(thetas);
    integrand = exp(1j * (kx(:) .* x)) .* A;     % Nθ × Nx
    F = trapz(x, integrand, 2);                  % field
    P = abs(F).^2;                               % POWER (no normalization)

    global_Pmax = max(global_Pmax, max(P));

    % Predicted main-lobe from phase match: kx ≈ (xi_gw + k_m)
    arg = (xi_gw + k_m) / xi_m;
    if abs(arg) <= 1, theta_pred = asin(arg); is_radiating = true;
    else,            theta_pred = NaN;        is_radiating = false;
    end

    [P_peak, idx_peak] = max(P);
    theta_peak = thetas(idx_peak);

    S_idx = S_idx + 1;
    S(S_idx).theta        = thetas;
    S(S_idx).power        = P;
    S(S_idx).label        = sprintf('m = %+d (f = %.3f GHz)', m, fm/1e9);
    S(S_idx).theta_pred   = theta_pred;
    S(S_idx).is_radiating = is_radiating;
    S(S_idx).P_peak       = P_peak;
    S(S_idx).theta_peak   = theta_peak;
    S(S_idx).fmGHz        = fm/1e9;
    S(S_idx).m            = m;
end
[~, ord] = sort([S.m]);

%% ===================== PLOTS (compute-first, plot-last) =====================

% (1) Polar POWER (upper semicircle)
figure('Color','w');
pax = polaraxes; hold(pax,'on');
pax.ThetaZeroLocation = 'top'; pax.ThetaDir = 'clockwise';
pax.ThetaLim = [-upper_half_span_deg, +upper_half_span_deg];
pax.RLim = [0, global_Pmax];
title(sprintf('Polar POWER (Eq. 11) — ts from m0=%+d, \\theta_{r0}=%g^\\circ', m0, theta_r0_deg));
legtxt = cell(1, numel(S));
for k = 1:numel(S)
    polarplot(pax, S(k).theta, S(k).power, 'LineWidth', 2);
    legtxt{k} = S(k).label;
end
for k = 1:numel(S)
    th = S(k).theta_pred;
    if S(k).is_radiating && ~isnan(th)
        polarplot(pax, [th th], [0 global_Pmax], '--', 'Color', [0.5 0.5 0.5]);
    end
end
legend(legtxt, 'Location','southoutside');

% (2) Peak POWER vs harmonic index
figure('Color','w'); hold on; box on; grid on;
m_vals  = [S(ord).m];
P_peaks = [S(ord).P_peak];
stem(m_vals, P_peaks, 'LineWidth', 2, 'Marker', 'none');
xlabel('Harmonics, m'); ylabel('Peak Power (a.u.)');
title('Peak radiated power per harmonic (no normalization)');
xlim([min(m_vals)-0.5, max(m_vals)+0.5]);
ylim([0, max(P_peaks)*1.05]);

% (3) t_s(x) vs x (unwrapped and mod 1)
figure('Color','w'); hold on; grid on; box on;
plot(x, ts_x, 'LineWidth', 2);
if show_ts_mod1
    plot(x, ts_x_mod1, '--', 'LineWidth', 1.5);
    legend('t_s(x) (cycles)', 't_s(x) mod 1 (0..1)', 'Location','best');
else
    legend('t_s(x) (cycles)', 'Location','best');
end
xlabel('x (m)'); ylabel('t_s(x) (cycles)');
title(sprintf('Fixed t_s(x) from m0=%+d, \\theta_{r0}=%g^\\circ', m0, theta_r0_deg));

% (4) Binary state map
figure('Color','w');
imagesc(1:Nx, 1:Ntime, State); set(gca,'YDir','reverse'); axis tight; box on;
xlabel('Meta-atom'); ylabel('Time sequence');
colormap([0.90 0.90 0.90; 0.70 0.25 0.55]); caxis([0 1]);
colorbar('Ticks',[0.25 0.75], 'TickLabels', {'0','1'});
set(gca, 'XTick', [1, round(Nx/2), Nx], 'YTick', [1, round(Ntime/2), Ntime]);
title(sprintf('Space–time state map: N_x=%d, N_t=%d, \\tau=%.2f', Nx, Ntime, tau0));
