
function DeleteDesign(fid, ProjectName)

% create the necessary script.
fprintf(fid, '\n');
fprintf(fid, 'oProject.DeleteDesign "%s"',ProjectName);
