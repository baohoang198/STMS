% -------------------------------------------------------------------------- %
% function hfssPolygon(fid, Name, Center,Start,numPoints,Axis, Units)
%
% Description:
% ------------
% Create a closed polygon object in HFSS. This function also provides 
% an option to punch a bunch of (circular) holes into the polygon object (so
% as to make way for cables, wires, etc.,).
%
% Parameters:
% -----------
% Name - Name Attribute for the PolyLine.
% Points - Points as 3-Tuples, ex: Points = [0, 0, 1; 0, 1, 0; 1, 0 1];
%          Note: size(Points) must give [nPoints, 3]
% Units - can be either:
%         'mm' - millimeter.
%         'in' - inches.
%         'mil' - mils.
%         'meter' - meter (note: don't use 'm').
%          or anything that Ansoft HFSS supports.
% [Circle], [Radius], [Axis] - optional holes to be punched into the polyline. 
%           Please specify as Center ([x, y, z]), Radius (scalar), Axis 
%           ('X', 'Y' or 'Z') , ... etc., The script will create circles
%           specified using the given parameters and subtract them from the 
%           polyline object. 
%
% Example:
% --------
% % sCube is a 1x3 vector, Radius, is a Scalar, cxCenter[A, B] is a 1x3 vector
% % and hBalun is a scalar.
% hfssPolyline(fid, 'Short', sCube, 'in', ...
%             [cxCenterA(1:2), -hBalun], Radius 'Z', ...
%             [cxCenterB(1:2), -hBalun], Radius, 'Z');
% 
% -------------------------------------------------------------------------- %

% ----------------------------------------------------------------------------
% This file is part of HFSS-MATLAB-API.
%
% HFSS-MATLAB-API is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the Free 
% Software Foundation; either version 2 of the License, or (at your option) 
% any later version.
%
% HFSS-MATLAB-API is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
% or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License 
% for more details.
%
% You should have received a copy of the GNU General Public License along with
% Foobar; if not, write to the Free Software Foundation, Inc., 59 Temple 
% Place, Suite 330, Boston, MA  02111-1307  USA
%
% Copyright 2004, Vijay Ramasami (rvc@ku.edu)
% ----------------------------------------------------------------------------
function hfssPolygon(fid, Name, Center,Start,numPoints,Axis, Units)


% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'oEditor.CreateRegularPolygon _\n');
fprintf(fid, 'Array("NAME:RegularPolygonParameters", ');
fprintf(fid, '"IsCovered:=", true,_\n ');


fprintf(fid, '"XCenter:=", "%.4f%s", ', Center(1), Units);
fprintf(fid, '"YCenter:=", "%.4f%s", ', Center(2), Units);
fprintf(fid, '"ZCenter:=", "%.4f%s",_\n',Center(3), Units);

fprintf(fid, '"XStart:=", "%.4f%s", _\n', Start(1), Units);
fprintf(fid, '"YStart:=", "%.4f%s",_\n ', Start(2), Units);
fprintf(fid, '"ZStart:=", "%.4f%s", _\n',Start(3), Units);
fprintf(fid, '"NumSides:=", "%d", _\n',numPoints);

fprintf(fid, '"WhichAxis:=", "%s"), _\n',Axis);

% Polyline Attributes.
fprintf(fid, 'Array("NAME:Attributes", _\n');
fprintf(fid, '"Name:=", "%s", _\n', Name);
fprintf(fid, '"Flags:=", "", _\n');
fprintf(fid, '"Color:=", "(255 0 0)", _\n');
fprintf(fid, '"Transparency:=", 0, _\n');
fprintf(fid, '"PartCoordinateSystem:=", "Global", _\n');
fprintf(fid, '"SolveInside:=", true)\n');

