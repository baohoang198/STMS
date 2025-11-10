% hfssAssignRLC(fid, Name, ObjectName, iLStart, iLEnd, Units, ...
%                               useRes,useInd,useCap,Resistance,Resis_Unit, Inductance,Induct_Unit,Capacitance,Capa_Unit,RLC_Type

function hfssAssignRLC(fid, Name, ObjectName, iLStart, iLEnd, Units, ...
                              useRes,useInd,useCap,Resistance,Resis_Unit, Inductance,Induct_Unit,Capacitance,Capa_Unit,RLC_Type)

% % % % arguments processor.
% % % if (nargin < 6)
% % % 	error('Not Enough Arguments !');
% % % elseif (nargin < 7)
% % % 	Resistance = [];
% % % 	Reactance = [];
% % % elseif (nargin < 8)
% % % 	Reactance = [];
% % % end;
% % % 
% % % % Setup default arguments.
% % % if isempty(Resistance)
% % % 	Resistance = 50.0;
% % % end;
% % % 
% % % if isempty(Reactance)
% % % 	Reactance = 0.0;
% % % end;

% The usual fprintf stuff.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup")\n');

fprintf(fid, 'oModule.AssignLumpedRLC _\n');
fprintf(fid, 'Array("NAME:%s", _\n', Name);
fprintf(fid, '"Objects:=",');
fprintf(fid, 'Array("%s"), _\n', ObjectName);
fprintf(fid, 'Array("NAME:CurrentLine", _\n');
fprintf(fid, '"Coordinate System:=", _\n');
fprintf(fid, '"Global","Start:=", Array("%f%s", "%f%s", "%f%s"), _\n',iLStart(1), Units, iLStart(2), Units, iLStart(3), Units);
fprintf(fid, '                          "End:=",   Array("%f%s", "%f%s", "%f%s")),_\n', ...
        iLEnd(1), Units, iLEnd(2), Units, iLEnd(3), Units);
fprintf(fid,'"RLC Type:=","%s",_\n',RLC_Type);
fprintf(fid,'"UseResist:=",%s, "Resistance:=","%f%s",_\n',useRes,Resistance,Resis_Unit);
fprintf(fid,'"UseInduct:=",%s, "Inductance:=","%f%s",_\n',useInd,Inductance,Induct_Unit);
fprintf(fid,'"UseCap:=",%s, "Capacitance:=","%f%s")',useCap,Capacitance,Capa_Unit);
fprintf(fid, '\n');

