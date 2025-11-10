% hfssDuplicateAroundAxis2(fid, ObjectList, Axis, nClones, Angle,Units, dupAssignments)

function hfssDuplicateAroundAxis2(fid, ObjectList, Axis, nClones, Angle,Units, dupAssignments)

if (nargin < 6)
	error('Insufficient number of arguments !');
elseif (nargin < 7)
	dupAssignments = [];
end;

% default arguments.
if isempty(dupAssignments)
	dupAssignments = true;
end;

nObjects = length(ObjectList);

% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'oEditor.DuplicateAroundAxis _\n');
fprintf(fid, 'Array("NAME:Selections", _\n');

% Object Selections.
fprintf(fid, '"Selections:=", "');
for iObj = 1:nObjects,
	fprintf(fid, '%s', ObjectList{iObj});
	if (iObj ~= nObjects)
		fprintf(fid, ',');
	end;
end;
fprintf(fid, '", "NewPartsModelFlag:=", "Model"), _\n');

% Duplication Parameters

  fprintf(fid, 'Array("NAME:DuplicateAroundAxisParameters", _\n');
  fprintf(fid, '"CreateNewObjects:=", "true", _\n');
  fprintf(fid, '"WhichAxis:=", "%s", _\n', Axis);
  fprintf(fid, '"AngleStr:=", "%f%s", _\n', Angle, Units);
  fprintf(fid, '"NumClones:=", "%f"), _\n', nClones);
  
  % Duplicate Boundaries with Geometry or not.
fprintf(fid, 'Array("NAME:Options", _\n');
if (dupAssignments)
	fprintf(fid, '"DuplicateAssignments:=", true)\n');
else
	fprintf(fid, '"DuplicateAssignments:=", false)\n');
end;