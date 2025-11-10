% ----------------------------------------------------------------------------
% function hfssInterpolatingSweep(fid, Name, SolutionName, fStartGHz, ...
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
% hfssFastSweep(fid, 'Interp600to900MHz', 'Solve750MHz', 0.6, ...
%                        0.9, 1000, 101, 0.5);
%
% linh.ho@polimi.it [20/07/2015]
% ----------------------------------------------------------------------------

function hfssFastSweep(fid, Name, SolutionName, fStartGHz, ...
                                fStopGHz, nPoints, nMaxSols, iTol)

% arguments processor.
if (nargin < 5)
	error('Insufficient # of arguments');
elseif (nargin < 6)
	nPoints = [];
	nMaxSols = [];
	iTol = [];
elseif (nargin < 7)
	nMaxSols = [];
	iTol = [];
elseif (nargin < 8)
	iTol = [];
end;

% process default arguments.
if isempty(nPoints)
	nPoints = 1000;
end;
if isempty(nMaxSols)
	nMaxSols = 101;
end;
if isempty(iTol)
	iTol = 0.5;
end;

% create script.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("AnalysisSetup")\n');

fprintf(fid, 'oModule.InsertDrivenSweep _\n');
fprintf(fid, '"%s", _\n', SolutionName);
fprintf(fid, 'Array("NAME:%s", _\n', Name);
fprintf(fid, '"Type:=", "Fast", _\n');
fprintf(fid, '"InterpTolerance:=", %f, _\n', iTol);
fprintf(fid, '"InterpMaxSolns:=", %d, _\n', nMaxSols);
fprintf(fid, '"SetupType:=", "LinearCount", _\n');
fprintf(fid, '"StartFreq:=", "%fGHz", _\n', fStartGHz);
fprintf(fid, '"StopFreq:=", "%fGHz", _\n', fStopGHz);
fprintf(fid, '"Count:=", %d, _\n', nPoints);
fprintf(fid, '"SaveFields:=", false, _\n');
fprintf(fid, '"ExtrapToDC:=", false)\n');
