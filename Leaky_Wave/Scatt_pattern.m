% ============================================================
% ST-LWA: All plots — polar POWER, peak-vs-m stem, t_s(x), state map
% km is from the figure: km = 2*pi*m*dt_s/dx = 2*pi*m*q
% t_s(x) = q*x is fixed from reference harmonic m0.
% x in [0, L] with 81 samples; Δf = 50 MHz.  Compute first, plot last.
% ============================================================

clear; clc; close all;

%% ---------------- User parameters ----------------
c      = 3e8;                 % speed of light (m/s)
f0     = 10e9;                % base RF frequency (Hz)
df     = 50e6;                % Δf = 50 MHz

m0     = 1;                   % reference harmonic to set t_s(x)
theta_r0_deg = 20;            % target angle for m0 (deg)

m_list = -4:4;                % harmonics to evaluate (includes m=0)
tau0   = 0.5;                 % uniform duty cycle τ in [0,1]
beta_gw_ratio = 1;            % ξ_gw / k0  (ξ_gw is treated constant)

aperture_in_wavelengths_at_m0 = 10;  % L = this * λ(m0), FIXED physical length
Nx     = 81;                 % spatial samples (meta-atoms)
Ntheta = 1001;               % angular samples for far-field
upper_half_span_deg = 90;    % visible sector for polar plot (−90..+90)
Ntime  = 100;                % time samples for state map (rows)
show_ts_mod1 = true;         % also show t_s(x) wrapped to [0,1]
% --------------------------------------------------

%% ---------------- Angle grid (upper semicircle) ----------------
thetas = linspace(deg2rad(-upper_half_span_deg), ...
                  deg2rad(+upper_half_span_deg), Ntheta);   % radians

%% ---------------- Reference harmonic → fixed q and fixed L ----------------
theta_r0 = deg2rad(theta_r0_deg);

% Free-space wavenumbers at f0 and fm0
k0      = 2*pi*f0/c;
fm0     = f0 + m0*df;
xi_m0   = 2*pi*fm0/c;                % = ξ_{m0} (free-space)

% Physical aperture length set by λ(m0)
lambda_m0 = 2*pi/xi_m0;
L         = aperture_in_wavelengths_at_m0 * lambda_m0;       % physical aperture (m)

% Waveguide wavenumber is *constant* (paper): ξ_gw = β_ratio * k0
xi_gw    = beta_gw_ratio * k0;

% ---- Fixed slope q from your formula (ts from reference m0) ----
% t_s(x) = [(ξ_{m0} sinθ_r0 − ξ_gw) / (2π m0)] * x
q        = (xi_m0*sin(theta_r0) - xi_gw) / (2*pi*m0);        % cycles/m

% Aperture x-grid and ts(x)
x        = linspace(0, L, Nx);
ts_x     = q * x;                     % t_s(x) in cycles (unwrapped)
ts_x_mod1 = mod(ts_x, 1);             % wrapped to [0,1]

fprintf('Design m0=%+d, θr0=%.2f° | q=%.6g cycles/m | L=%.4g m | t_s range=[%.3f, %.3f] cycles\n', ...
        m0, theta_r0_deg, q, L, min(ts_x), max(ts_x));

%% ---------------- Compute far-field for each harmonic ----------------
S = struct('theta', [], 'power', [], 'label', [], 'theta_pred', [], ...
           'is_radiating', [], 'P_peak', [], 'theta_peak', [], ...
           'fmGHz', [], 'm', []);
S_idx = 0;
global_Pmax = 0;

for m = m_list
    % Free-space wavenumber for evaluation (still ξ_m = 2π(f0+mΔf)/c)
    f_m  = f0 + m*df;
    xi_m = 2*pi*f_m/c;

    % ---------- km from the figure: km = 2π m q (rad/m) ----------
    km_phase = 2*pi*m*q;

    % Aperture field A(x) with fixed t_s(x)=q*x; uniform τ
    amp_const = tau0 * sinc(m * tau0);                 % MATLAB sinc = sin(pi x)/(pi x)
    if m == 0
        A = tau0 .* exp(-1j * (xi_gw * x));           % Eq.(11), m=0 branch
    else
        A = amp_const .* exp(-1j * ((xi_gw + km_phase) * x));  % Eq.(11), m≠0
    end

    % Spatial FT at kx = ξ_m sinθ; field then POWER (NO normalization)
    kx = xi_m * sin(thetas);
    integrand = exp(1j * (kx(:) .* x)) .* A;          % Nθ × Nx
    F = trapz(x, integrand, 2);
    P = abs(F).^2;

    global_Pmax = max(global_Pmax, max(P));

    % Predicted beam angle from phase match: kx ≈ ξ_gw + km_phase
    arg = (xi_gw + km_phase) / xi_m;
    if abs(arg) <= 1, theta_pred = asin(arg);  is_radiating = true;
    else,            theta_pred = NaN;         is_radiating = false;
    end

    [P_peak, idx_peak] = max(P);
    theta_peak = thetas(idx_peak);

    S_idx = S_idx + 1;
    S(S_idx).theta        = thetas;
    S(S_idx).power        = P;
    S(S_idx).label        = sprintf('m = %+d (f = %.3f GHz)', m, f_m/1e9);
    S(S_idx).theta_pred   = theta_pred;
    S(S_idx).is_radiating = is_radiating;
    S(S_idx).P_peak       = P_peak;
    S(S_idx).theta_peak   = theta_peak;
    S(S_idx).fmGHz        = f_m/1e9;
    S(S_idx).m            = m;
end

% Prepare sorted indices for tables/plots
[~, ord] = sort([S.m]);

%% ---------------- Build space–time binary state map ----------------
t = (0:Ntime-1)/Ntime;          % normalized time in [0,1)
State = zeros(Ntime, Nx);       % 0/1 states
for it = 1:Ntime
    phase = mod(t(it) + ts_x_mod1, 1);   % per element
    State(it, :) = phase < tau0;         % '1' if ON, else '0'
end

%% ===================== PLOTS (now draw everything) =====================

% (1) Polar POWER (upper semicircle), all harmonics together
figure('Color','w');
pax = polaraxes; hold(pax,'on');
pax.ThetaZeroLocation = 'top';               % 0° at top (broadside)
pax.ThetaDir = 'clockwise';
pax.ThetaLim = [-upper_half_span_deg, +upper_half_span_deg];
pax.RLim = [0, global_Pmax];
title(sprintf(['ST-LWA Polar POWER (upper semicircle)\n' ...
               'ts from m0=%+d at %g^\\circ; km=2\\pi m q; L fixed; Nx=%d; Δf=%.0f MHz'], ...
      m0, theta_r0_deg, Nx, df/1e6));

legtxt = cell(1, numel(S));
for k = 1:numel(S)
    polarplot(pax, S(k).theta, S(k).power, 'LineWidth', 2);
    legtxt{k} = S(k).label;
end
% predicted beam lines
for k = 1:numel(S)
    th = S(k).theta_pred;
    if S(k).is_radiating && ~isnan(th)
        polarplot(pax, [th th], [0 global_Pmax], '--', 'Color', [0.4 0.4 0.4]);
    end
end
legend(legtxt, 'Location','southoutside');

% (2) Peak POWER vs harmonic index (like your reference figure)
figure('Color','w'); hold on; box on; grid on;
m_vals  = [S(ord).m];
P_peaks = [S(ord).P_peak];
stem(m_vals, P_peaks, 'LineWidth', 2, 'Marker', 'none');
xlabel('Harmonics, m'); ylabel('Peak Power (a.u.)');
title('Peak radiated power per harmonic (no normalization)');
xlim([min(m_vals)-0.5, max(m_vals)+0.5]);
ylim([0, max(P_peaks)*1.05]);

% (3) t_s(x) over the aperture
figure('Color','w'); hold on; grid on; box on;
plot(x, ts_x, 'LineWidth', 2);
if show_ts_mod1
    plot(x, ts_x_mod1, '--', 'LineWidth', 1.5);
    legend('t_s(x) (cycles)', 't_s(x) mod 1 (0..1)', 'Location', 'best');
else
    legend('t_s(x) (cycles)', 'Location', 'best');
end
xlabel('x (m)'); ylabel('t_s(x) (cycles)');
title(sprintf('Fixed time-shift profile t_s(x) from m0=%+d, \\theta_{r0}=%g^\\circ', m0, theta_r0_deg));

% (4) Space–time binary state map
figure('Color','w');
imagesc(1:Nx, 1:Ntime, State); set(gca,'YDir','reverse');
axis tight; box on;
xlabel('Meta-atom'); ylabel('Time sequence');
cmap = [0.90 0.90 0.90; 0.70 0.25 0.55];  % 0=light gray, 1=magenta
colormap(cmap); caxis([0 1]);
cb = colorbar('Ticks',[0.25 0.75], 'TickLabels', {'0','1'}); cb.Label.String = 'State';
set(gca,'XTick',[1, round(Nx/2), Nx], 'YTick',[1, round(Ntime/2), Ntime]);
title(sprintf('Space–time state map: N_x=%d, N_t=%d, \\tau=%.2f, m_0=%+d', Nx, Ntime, tau0, m0));

%% ---------------- Console summary ----------------
fprintf('\n=== Peak POWER per harmonic (no normalization) ===\n');
fprintf('   m     f (GHz)    theta_pred (deg)   theta_peak (deg)      P_peak (arb)\n');
for k = ord
    th_pred_deg = rad2deg(S(k).theta_pred);
    th_peak_deg = rad2deg(S(k).theta_peak);
    if ~S(k).is_radiating, th_pred_deg = NaN; end
    fprintf('%4+g   %8.3f      %10.2f         %10.2f        %12.5g\n', ...
        S(k).m, S(k).fmGHz, th_pred_deg, th_peak_deg, S(k).P_peak);
end
