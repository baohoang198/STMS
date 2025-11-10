addpath('..\hfssapi\3dmodeler');
addpath('..\hfssapi\analysis');
addpath('..\hfssapi\boundary');
addpath('..\hfssapi\contrib');
addpath('..\hfssapi\general');
addpath('..\hfssapi\reporter');
addpath('..\hfssapi\3dmodeler');
hfssExePath = 'C:\Program Files\AnsysEM\AnsysEM21.2\Win64\ansysedt.exe';
tmpDataFile = 'tmpData1.m';
antennaFile=[pwd,'/FullModel1.aedt']; %file HFSS

tmpScriptFile = ['220530_InsertMetasurface2.vbs'];
fid = fopen(tmpScriptFile, 'wt');
hfssNewProject(fid);
% hfssSetActiveDesign(fid,'FullModel'); %Design name
hfssRectangle(fid,'rect','z',[0,0,0],5,5,'mm');
hfssAssignAnisotropicImpedance(fid,'imp1','rect',5,6,7,8,9,10,11,12);