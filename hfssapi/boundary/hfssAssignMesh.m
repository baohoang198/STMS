% hfssAssignMesh(fid, Name, ObjectList,NumMaxElem,MaxLength,Units)
function hfssAssignMesh(fid, Name, ObjectList,NumMaxElem,MaxLength,Units)

nObjects = length(ObjectList);
%Set up Default
% RefineInside=false;
% Enabled=true;
% RestrictElem=false;
% RestrictLength=true;
% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("MeshSetup")\n');

% Parameters
fprintf(fid, 'oModule.AssignLengthOp');
fprintf(fid, ' Array("NAME:%s",', Name);
fprintf(fid, ' "RefineInside:=",false,');
fprintf(fid, ' "Enabled:=", true,');
fprintf(fid, ' "Faces:=", Array(_\n');
for iObj = 1:nObjects
    fprintf(fid, '%s', ObjectList{iObj});
    if (iObj ~= nObjects)
        fprintf(fid, ',');
    end
end
fprintf(fid, '),');
fprintf(fid, ' "RestrictElem:=",false,');
fprintf(fid, ' "NumMaxElem:=","%d",',NumMaxElem);
fprintf(fid, ' "RestrictLength:=",true,');
fprintf(fid, ' "MaxLength:=","%f%s")',MaxLength,Units);
%fprintf(fid,'\t)');
end



