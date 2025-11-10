% hfssDrawLineUseFunc(fid,Name,xFunc,yFunc,zFunc,start,stop,nPoint)
function hfssDrawLineUseFunc(fid,Name,xFunc,yFunc,zFunc,start,stop,nPoint,ver)

% arguments processor.
% if (nargin < 7)
% 	error('Insufficient # of arguments !');
% elseif (nargin < 8)
%     if iUEnd(2)~=iUStart(2)
%         ReverseV = true;
%     else
%         ReverseV = false;
%     end
% end
% 
% if ReverseV
%     ReverseV = 'true';
% else
%     ReverseV = 'false';
% end

% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'oEditor.CreateEquationCurve _\n');

% Parameters
fprintf(fid, 'Array("NAME:EquationBasedCurveParameters",_\n');
fprintf(fid, '\t"XtFunction:=", "%s", _\n', xFunc);
fprintf(fid, '\t"YtFunction:=", "%s", _\n', yFunc);
fprintf(fid, '\t"ZtFunction:=", "%s", _\n', zFunc);
fprintf(fid, '\t"tStart:=", "%f", _\n', start);
fprintf(fid, '\t"tEnd:=", "%f", _\n', stop);
fprintf(fid, '\t"NumOfPointsOnCurve:=", "%d", _\n', nPoint);
fprintf(fid, '\t"Version:=", %d, _\n', ver);

fprintf(fid,'Array("NAME:PolylineXSection",_\n');
fprintf(fid,'"XSectionType:=","None",_\n');
fprintf(fid,'"XSectionOrient:=","Auto",_\n');
fprintf(fid,'"XSectionWidth:=","0",_\n');
fprintf(fid,'"XSectionTopWidth:=","0",_\n');
fprintf(fid,'"XSectionHeight:=","0",_\n');
fprintf(fid,'"XSectionNumSegments:=","0",_\n');
fprintf(fid,'"XSectionBendType:=","Corner")),_\n');

fprintf(fid, 'Array("NAME:Attributes", _\n');
fprintf(fid, '"Name:=", "%s", _\n', Name);
fprintf(fid, '"Flags:=", "", _\n');
fprintf(fid, '"Color:=", "(143 175 143)", _\n');
fprintf(fid, '"Transparency:=", 0, _\n');
fprintf(fid, '"PartCoordinateSystem:=", "Global", _\n');
fprintf(fid, '"UDMId:=", "", _\n');
fprintf(fid, '"MaterialValue:=", "" & Chr(34) & "vacuum" & Chr(34) & "", _\n');
fprintf(fid, '"SurfaceMaterialValue:=", "" & Chr(34) & "" & Chr(34) & "", _\n');
fprintf(fid, '"SolveInside:=", true,_\n');
fprintf(fid, '"IsMaterialEditable:=", true,_\n');
fprintf(fid, '"UseMaterialAppearance:=", false)\n');



% fprintf(fid, '\tArray("NAME:CoordSysVector", "Origin:=", _\n');
% fprintf(fid, '\t\tArray("%f%s", "%f%s", "%f%s"), _\n', ...
%         iUStart(1), Units, iUStart(2), Units, iUStart(3), Units);
% fprintf(fid, '\t\t"UPos:=", Array("%f%s", "%f%s", "%f%s") _\n', ...
%         iUEnd(1), Units, iUEnd(2), Units, iUEnd(3), Units);
% fprintf(fid, '\t\t), _\n');
% fprintf(fid, '\t"ReverseV:=", %s, _\n', ReverseV);
% fprintf(fid, '\t"Master:=", "%s", _\n', Master);
% fprintf(fid, '\t"UseScanAngles:=", true, "Phi:=", "0deg", "Theta:=", "0deg" _\n');

