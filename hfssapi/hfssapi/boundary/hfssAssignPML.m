% hfssAssignPML(fid, Name, ObjName,Thickness,PMLObj,BaseObj,MinFreq,MinBeta,RadDist,Units,FUnits)
function hfssAssignPML(fid, Name, ObjectList,Thickness,PMLObj,BaseObj,MinFreq,MinBeta,RadDist,Units,FUnits)
% Creates the necessary VB Script to assign a Floquet Port to a given Object.
%
% Parameters :
% fid:		file identifier of the HFSS script file.
% Name:		name of the floquet port (appears under 'Excitations' in HFSS).
% ObjName:	name of the (sheet-like) object to which the floquet port is to
%           be assigned.
% Deembed:	(scalar) distance for deembeding the port. It accepts 0.
% Phi:		(degrees) scan angle phi.
% Theta:	(degrees) scan angle theta.
% iAStart:	(vector) starting point of the Lattice A direction. Specify as
%           [x, y, z].
% iAEnd:	(vector) ending point of the Lattice A direction. Specify as
%           [x, y, z].
% iBStart:	(vector) starting point of the Lattice B direction. Specify as
%           [x, y, z].
% iBEnd:	(vector) ending point of the Lattice B direction. Specify as
%           [x, y, z].
% Units:	specify as 'meter', 'in', 'cm' (defined in HFSS).
% Ref:		(boolean, optional) enables 3D Refinement for Floquet modes.
%           Defaults to false.
%
% @note It sets up only the default specular pair of nodes.
%
% Example :
% @code
% fid = fopen('myantenna.vbs', 'wt');
% ...
% hfssAssignMaster(fid, 'FloquetPort', 'Sheet', 0, 0, [-width/2, 0, 0], ...
%	               [width/2, 0, 0], [0, -height/2, 0], [0, height/2, 0], ...
%                  'meter');
% @endcode
%
% @author Pablo Alcon Garcia, pabloalcongarcia@gmail.com / palcon@tsc.uniovi.es
% @date 21 May 2013

% arguments processor.
% 	if (nargin < 11)
% 		error('Insufficient # of arguments !');
% 	elseif (nargin < 12)
% 	    Ref = false;
% 	end

% 	if Ref
% 	    Ref = 'true';
% 	else
% 	    Ref = 'false';
% 	end
nObjects = length(ObjectList);

% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup")\n');

% Parameters
fprintf(fid, 'oModule.CreatePML');
fprintf(fid, ' Array("NAME:%s",', Name);
fprintf(fid, '\t"UserDrawnGroup:=", false,');
fprintf(fid, '\t"PMLFaces:=", Array(_\n');
for iObj = 1:nObjects
    fprintf(fid, '%s', ObjectList{iObj});
    if (iObj ~= nObjects)
        fprintf(fid, ',');
    end
end
fprintf(fid, '),');
fprintf(fid, ' "Thickness:=","%f%s",',Thickness,Units);
fprintf(fid, ' "CreateJoiningObjs:=",_\n');
fprintf(fid, ' true,');
fprintf(fid, ' "PMLObj:=", %d,',PMLObj);
fprintf(fid, ' "BaseObj:=", %d,',BaseObj);
fprintf(fid, ' "Orientation:=", "Undefined",');
fprintf(fid, ' "UseFreq:=",_\n');
fprintf(fid, ' true,');
fprintf(fid, ' "MinFreq:=","%f%s",',MinFreq,FUnits);
fprintf(fid, ' "MinBeta:=",%d,',MinBeta);
fprintf(fid, ' "RadDist:=","%f%s")',RadDist,Units);
% fprintf(fid,'\t)');
end



