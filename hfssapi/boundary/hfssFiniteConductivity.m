function hfssFiniteConductivity(fid, Name, ObjectList,useMaterial,material,infGND,useThickness,istwosided,isinternal)
%function hfssFiniteConductivity(fid, Name, ObjectList,useMaterial,material,infGND,useThickness,istwosided,isinternal)
% default arguments.
    if (nargin < 5)
    	error('Insufficient # of arguments !');
    elseif (nargin < 6)
    	infGND = [];
        useThickness=[];
        istwosided=[];
        isinternal=[];
    end
if isempty(useThickness)
    useThickness = false;
end
if isempty(infGND)
    infGND = false;
end
if isempty(istwosided)
    istwosided = false;
end
if isempty(isinternal)
    isinternal = true;
end

% # of objects.
nObjects = length(ObjectList);

% create the necessary script.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup")\n');
fprintf(fid, 'oModule.AssignFiniteCond _\n');
fprintf(fid, 'Array("NAME:%s", _\n', Name);
fprintf(fid, '"Objects:=", _\n');
fprintf(fid, 'Array(');
for iObj = 1:nObjects
    fprintf(fid, '"%s"', ObjectList{iObj});
    if (iObj ~= nObjects)
        fprintf(fid, ',');
    end
end
fprintf(fid, '), _ \n');
fprintf(fid, '"UseMaterial:=", %s, _ \n',useMaterial);
if(useMaterial)
    fprintf(fid,'"Material:=","%s",_\n',material);
end
% is infinite GND ?

if (useThickness)
    fprintf(fid, '"UseThickness:=", true, _ \n');
else
    fprintf(fid, '"UseThickness:=", false, _ \n');
end

fprintf(fid, '"Roughness:=", "0um", _ \n');

if (infGND)
    fprintf(fid, '"InfGroundPlane:=", true, _ \n');
else
    fprintf(fid, '"InfGroundPlane:=", false, _ \n');
end

if (istwosided)
    fprintf(fid, '"IsTwoSided:=", true, _ \n');
else
    fprintf(fid, '"IsTwoSided:=", false, _ \n');
end


if (isinternal)
    fprintf(fid, '"IsInternal:=", true) _ \n');
else
    fprintf(fid, '"IsInternal:=", false) _ \n');
end

% fprintf(fid, ')\n');
