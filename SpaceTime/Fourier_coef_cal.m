function [Fourier_coef] = Fourier_coef_cal(A_npq,phase_npq,harmonic_level, leng_time)
Fourier_coef = 0;
for n = 1:leng_time
    Fourier_coef = Fourier_coef + (A_npq(:,n).*phase_npq(:,n)/leng_time).*...
        sinc(harmonic_level/leng_time).*exp(-1j*pi*harmonic_level*(2*n-1)/leng_time);
%     Far_field = Far_field + E(:,:,n).*(A_npq(:,n).*phase_npq(:,n)/leng_time).*...
%         sinc(harmonic_level/leng_time).*exp(-1j*pi*harmonic_level*(2*n-1)/leng_time);
end

% for n = 1:leng_time
%     if harmonic_level ~= 0
%     Fourier_coef = Fourier_coef + (A_npq(:,n).*phase_npq(:,n)).*...
%         sin(pi*harmonic_level/leng_time)./(pi*harmonic_level).*exp(-1j*pi*harmonic_level*(2*n-1)/leng_time);
%     else
%         Fourier_coef = Fourier_coef + (A_npq(:,n).*phase_npq(:,n)).*exp(-1j*pi*harmonic_level*(2*n-1)/leng_time);        
%     end
% end

% FF = sum(diag(exp(-1j*pi*harmonic_level*(1:2:leng_time*2)'/leng_time)*(A_npq.*phase_npq/leng_time).*sinc(pi*harmonic_level/leng_time)));

end