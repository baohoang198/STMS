function AF = AF_cal(Theta, Phi, d, Fourier_mpq,num_elements_x,num_elements_y)
AF  = 0;
theta_steer = 0;
u = sin(Theta).*cos(Phi)+sind(theta_steer);
v = sin(Theta).*sin(Phi);

for p = 1:num_elements_y
    for q = 1: num_elements_x
      
        AF = AF +Fourier_mpq(p,:,q).*cos(Theta).*exp(1j*2*pi*d*((p-1).*u+(q-1).*v));
    end
end
AF=abs(AF)/max(max(abs(AF)));
end
