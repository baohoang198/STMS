clear all;
close all;
addpath('hfssapi\3dmodeler');
addpath('hfssapi\analysis');
addpath('hfssapi\boundary');
addpath('hfssapi\contrib');
addpath('hfssapi\general');
addpath('hfssapi\reporter');
addpath('hfssapi\3dmodeler');
%% constant
f=5.8e9;
c=3e8;
lamda=c*1000/f;

%% Parameters
Ny=8;           % S? c?t
Mx=8;          % S? hàng
length_time = 1;

w_diode = 0.5;
w0 = 1.9;
Py = 6;
hs=0;
Resistance = 0.3;
Inductance = 0.7; 
Capacitance = [0.56, 0.45, 0.39 0.16];

%% gen HFSS file
hfssExePath = 'C:\Program Files\AnsysEM\AnsysEM21.2\Win64\ansysedt.exe';
tmpDataFile = 'tmpData1.m';
antennaFile=[pwd,'/Parallel_FullModel.aedt']; %file HFSS

% open a temporary script file.
Time_Space_pattern=csvread('220518_spaceTimeSequence1.csv');
Time_Space_pattern = [2     3     1     2     2     0     0     1];
Time_Space_pattern = reshape(Time_Space_pattern,Mx,length_time);
% Phase = repmat(Time_Space_pattern(:,1),1,Ny);

tmpScriptFile = ['220519_Parallel_8x8.vbs'];
fid = fopen(tmpScriptFile, 'wt');
fprintf(fid, 'Dim oHfssApp\n');
fprintf(fid, 'Dim oDesktop\n');
fprintf(fid, 'Dim oProject\n');
fprintf(fid, 'Dim oDesign\n');
fprintf(fid, 'Dim oEditor\n');
fprintf(fid, 'Dim oModule\n');
for n = 1:length_time
hfssOpenProject(fid,antennaFile);
hfssSetActiveDesign(fid,'FullModel'); %Design name
saveFile = [pwd,'/220519_Sample_Parallel1_',num2str(4),'.aedt'];
Phase = repmat(Time_Space_pattern(:,n),1,Ny);
Phase = repelem(Phase,2,2);

for i=1:Mx*2
    for j = 1:Ny*2
    if Phase(i,j) == 0
        hfssRectangle(fid,['rect','row_',num2str(i),'_col',num2str(j)],'Z',[(-w0/2)+Py*(i-1),(-w_diode/2)+(j-1)*Py,hs],w0,w_diode,'mm');
%         hfssAssignRLC(fid,['RLC',num2str(i)],['rect',num2str(i)],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,(-w_diode/2)-(0.5*N)*Py+0.5*Py+w_diode/2,hs],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py+w0,((-w_diode/2)-(0.5*N)*Py+0.5*Py)/2,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(1),'pF','Serial');
    elseif Phase(i,j) == 1
        hfssRectangle(fid,['rect','row_',num2str(i),'_col',num2str(j)],'Z',[(-w0/2)+Py*(i-1),(-w_diode/2)+(j-1)*Py,hs],w0,w_diode,'mm');
%         hfssAssignRLC(fid,['RLC',num2str(i)],['rect',num2str(i)],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,((-w_diode/2)-(0.5*N)*Py+0.5*Py)+w_diode/2,hs],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py+w0,((-w_diode/2)-(0.5*N)*Py+0.5*Py)/2,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(2),'pF','Serial');
    elseif Phase(i,j) == 2
        hfssRectangle(fid,['rect','row_',num2str(i),'_col',num2str(j)],'Z',[(-w0/2)+Py*(i-1),(-w_diode/2)+(j-1)*Py,hs],w0,w_diode,'mm');
%         hfssAssignRLC(fid,['RLC',num2str(i)],['rect',num2str(i)],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,((-w_diode/2)-(0.5*N)*Py+0.5*Py)+w_diode/2,hs],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py+w0,((-w_diode/2)-(0.5*N)*Py+0.5*Py)/2,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(3),'pF','Serial');
    elseif Phase(i,j) == 3
        hfssRectangle(fid,['rect','row_',num2str(i),'_col',num2str(j)],'Z',[(-w0/2)+Py*(i-1),(-w_diode/2)+(j-1)*Py,hs],w0,w_diode,'mm');
%         hfssAssignRLC(fid,['RLC',num2str(i)],['rect',num2str(i)],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,((-w_diode/2)-(0.5*N)*Py+0.5*Py)+w_diode/2,hs],[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py+w0,((-w_diode/2)-(0.5*N)*Py+0.5*Py)/2,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(4),'pF','Serial');
    end
    end
end

for i=1:Mx*2
    for j =1:Ny*2
    if Phase(i,j) == 0
%         hfssRectangle(fid,['rect',num2str(i)],'Z',[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,(-w_diode/2)-(0.5*N)*Py+0.5*Py,hs],w0,w_diode,'mm');
        hfssAssignRLC(fid,['RLC','row_',num2str(i),'_col',num2str(j)],['rect','row_',num2str(i),'_col',num2str(j)],[(-w0/2)+Py*(i-1),(j-1)*Py,hs], ...
            [(-w0/2)+Py*(i-1)+w0,(j-1)*Py,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(1),'pF','Serial');
    elseif Phase(i,j) == 1
%         hfssRectangle(fid,['rect',num2str(i)],'Z',[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,(-w_diode/2)-(0.5*N)*Py+0.5*Py,hs],w0,w_diode,'mm');
        hfssAssignRLC(fid,['RLC','row_',num2str(i),'_col',num2str(j)],['rect','row_',num2str(i),'_col',num2str(j)],[(-w0/2)+Py*(i-1),(j-1)*Py,hs], ...
            [(-w0/2)+Py*(i-1)+w0,(j-1)*Py,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(2),'pF','Serial');
    elseif Phase(i,j) == 2
%         hfssRectangle(fid,['rect',num2str(i)],'Z',[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,(-w_diode/2)-(0.5*N)*Py+0.5*Py,hs],w0,w_diode,'mm');
        hfssAssignRLC(fid,['RLC','row_',num2str(i),'_col',num2str(j)],['rect','row_',num2str(i),'_col',num2str(j)],[(-w0/2)+Py*(i-1),(j-1)*Py,hs], ...
            [(-w0/2)+Py*(i-1)+w0,(j-1)*Py,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(3),'pF','Serial');
    elseif Phase(i,j) == 3
%         hfssRectangle(fid,['rect',num2str(i)],'Z',[(-w0/2)-(0.5*N-(i-1))*Py+0.5*Py,(-w_diode/2)-(0.5*N)*Py+0.5*Py,hs],w0,w_diode,'mm');
        hfssAssignRLC(fid,['RLC','row_',num2str(i),'_col',num2str(j)],['rect','row_',num2str(i),'_col',num2str(j)],[(-w0/2)+Py*(i-1),(j-1)*Py,hs], ...
            [(-w0/2)+Py*(i-1)+w0,(j-1)*Py,hs],'mm',Resistance,'ohm',Inductance,'nH',Capacitance(4),'pF','Serial');
    end
    end
end
hfssSaveProject(fid,saveFile,true);
end
fclose(fid);
