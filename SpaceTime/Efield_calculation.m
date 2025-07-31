function Eth=Efield_calculation(filename)
[Eth, Eph] = READ_FFD(filename);

Th = -90:0.5:90;
Ph = 0:1:360;

[TH, PH] = meshgrid(Th,Ph);

Eth = reshape(Eth, size(TH));
Eph = reshape(Eph, size(PH));

% Etotal = sqrt(abs(Eth).^2+abs(Eph).^2).*exp(-1j*atan(Eph./Eth));

Etotal = Eth;
% Etotal = angle(Etotal);