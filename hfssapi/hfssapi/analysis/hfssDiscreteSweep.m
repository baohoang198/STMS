% ----------------------------------------------------------------------------
% function hfssDisCreteSweep(fid, Name, SolutionName, fStartGHz, ...
%                                fStopGHz, [nPoints = 1000], [nMaxSols = 101], 
%                                [iTol = 0.5])
% 
% Description :
% -------------
% Create the VB Script necessary to add an interpolating sweep to an existing
% solution.
% 
% Parameters :
% ------------
% fid          - file identifier of the HFSS script file.
% Name         - name of the interpolating sweep. 
% SolutionName - name of the solution to which this interpolating sweep needs
%                to be added.
% fStartGHz    - starting frequency of sweep in GHz.
% fStopGHz     - stop frequency of sweep in GHz.
% nPoints      - # of output points (defaults to 1000).
% nMaxSols     - max # of interpolating points that need to be solved (more 
%                points will guarentee convergence) - defaults to 101.
% iTol         - interpolation tolerance (defaults to 0.5).
% 
% Note :
% ------
%
% Example :
% ---------
% fid = fopen('myantenna.vbs', 'wt');
% ... 
% hfssInterpolatingSweep(fid, 'Interp600to900MHz', 'Solve750MHz', 0.6, ...
%                        0.9, 1000, 101, 0.5);
%
% ----------------------------------------------------------------------------

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

function hfssDiscreteSweep(fid, Name, SolutionName, fStartGHz,fStopGHz,fStep,Unit)

% arguments processor.
if (nargin < 6)
	error('Insufficient # of arguments');
end


% create script.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("AnalysisSetup")\n');

fprintf(fid, 'oModule.InsertDrivenSweep _\n');
fprintf(fid, '"%s", _\n', SolutionName);
fprintf(fid, 'Array("NAME:%s", _\n', Name);
fprintf(fid, '"IsEnabled:=", true,_\n');
fprintf(fid, '"RangeType:=","LinearStep", _\n');
fprintf(fid,'"RangeStart:=","%f%s", _\n',fStartGHz,Unit);
fprintf(fid,'"RangeEnd:=","%f%s", _\n',fStopGHz,Unit);
fprintf(fid,'"RangeStep:=","%f%s", _\n',fStep,Unit);
fprintf(fid, '"Type:=", "Discrete", _\n');
fprintf(fid, '"SaveFields:=", true, _\n');
fprintf(fid, '"SaveRadFields:=", false, _\n');
fprintf(fid, '"ExtrapToDC:=", false)\n');
