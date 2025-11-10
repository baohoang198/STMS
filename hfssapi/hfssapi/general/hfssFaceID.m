
function hfssFaceID(fid, BodyName, Position, Unit)
%hfssFaceID(fid, BodyName, Position, Unit)
%% Preamble.
fprintf(fid, '\n');
fprintf(fid,'Dim faceID\n');
fprintf(fid,'faceID=');
fprintf(fid, 'oEditor.GetFaceByPosition _\n');
%% Rectangle Parameters.
fprintf(fid, '(Array("NAME:FaceParameters", _\n');
fprintf(fid,'"BodyName:=", "%s",_\n',BodyName);
fprintf(fid, '"XPosition:=", "%f%s", _\n', Position(1), Unit);
fprintf(fid, '"YPosition:=", "%f%s", _\n', Position(2), Unit);
fprintf(fid, '"ZPosition:=", "%f%s"))\n', Position(3), Unit);
