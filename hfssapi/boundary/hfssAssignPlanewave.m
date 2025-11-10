    % hfssAssignPlanewave(fid, Name, ObjName,Eo,k,OriginX,Units)
    function hfssAssignPlanewave(fid, Name, ObjName,Eo,k,OriginX,Units,Type)
        % Creates the necessary VB Script to assign a Floquet Port to a given Object.
        %
        % Parameters :
        % fid:		file identifier of the HFSS script file.
        % Name:		name of the floquet port (appears under 'Excitations' in HFSS).
        % ObjName:	name of the (sheet-like) object to which the floquet port is to 
        %           be assigned.
        % Deembed:	(scalar) distance for deembeding the port. It accepts 0.
        % Phi:		(degrees) scan angle phi.
        % Theta:	(degrees) scan angle theta.
        % iAStart:	(vector) starting point of the Lattice A direction. Specify as
        %           [x, y, z].
        % iAEnd:	(vector) ending point of the Lattice A direction. Specify as
        %           [x, y, z].
        % iBStart:	(vector) starting point of the Lattice B direction. Specify as
        %           [x, y, z].
        % iBEnd:	(vector) ending point of the Lattice B direction. Specify as
        %           [x, y, z].
        % Units:	specify as 'meter', 'in', 'cm' (defined in HFSS).
        % Ref:		(boolean, optional) enables 3D Refinement for Floquet modes.
        %           Defaults to false.
        %
        % @note It sets up only the default specular pair of nodes.
        %
        % Example :
        % @code
        % fid = fopen('myantenna.vbs', 'wt');
        % ... 
        % hfssAssignMaster(fid, 'FloquetPort', 'Sheet', 0, 0, [-width/2, 0, 0], ...
        %	               [width/2, 0, 0], [0, -height/2, 0], [0, height/2, 0], ...
        %                  'meter');
        % @endcode
        %
        % @author Pablo Alcon Garcia, pabloalcongarcia@gmail.com / palcon@tsc.uniovi.es
        % @date 21 May 2013

        % arguments processor.
    % 	if (nargin < 11)
    % 		error('Insufficient # of arguments !');
    % 	elseif (nargin < 12)
    % 	    Ref = false;
    % 	end

    % 	if Ref
    % 	    Ref = 'true';
    % 	else
    % 	    Ref = 'false';
    % 	end

        % Preamble.
        fprintf(fid, '\n');
        fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup")\n');

        % Parameters
        fprintf(fid, 'oModule.AssignPlaneWave _\n');
        fprintf(fid, 'Array("NAME:%s", _\n', Name);
        
    if (Type==0)
            fprintf(fid, '\t"Objects:=", Array("%s"), _\n', ObjName);
        fprintf(fid, '\t"IsCartesian:=", true, _\n');
        fprintf(fid, '\t"EoX:=","%d",_\n',Eo(1));
        fprintf(fid, '\t"EoY:=", "%d",_\n',Eo(2));
        fprintf(fid, '\t"EoZ:=", "%d",_\n',Eo(3));
        fprintf(fid, '\t"kX:=", "%d",_\n',k(1));
        fprintf(fid, '\t"kY:=", "%d",_\n',k(2));
        fprintf(fid, '\t"kZ:=", "%d",_\n',k(3));
        fprintf(fid, '\t"OriginX:=",  "%f%s",_\n',OriginX(1), Units);
        fprintf(fid, '\t"OriginY:=", "%f%s",_\n',OriginX(2), Units);
        fprintf(fid, '\t"OriginZ:=", "%f%s",_\n',OriginX(3), Units);
        fprintf(fid, '\t"IsPropagating:=", true,_\n');
        fprintf(fid, '\t"IsEvanescent:=", false,_\n');
        fprintf(fid, '\t"IsEllipticallyPolarized:=", false)');
        elseif (Type==1)
        fprintf(fid, '\t"Faces:=", Array(%s), _\n', ObjName);
        fprintf(fid, '\t"IsCartesian:=", true, _\n');
        fprintf(fid, '\t"EoX:=","%d",_\n',Eo(1));
        fprintf(fid, '\t"EoY:=", "%d",_\n',Eo(2));
        fprintf(fid, '\t"EoZ:=", "%d",_\n',Eo(3));
        fprintf(fid, '\t"kX:=", "%d",_\n',k(1));
        fprintf(fid, '\t"kY:=", "%d",_\n',k(2));
        fprintf(fid, '\t"kZ:=", "%d",_\n',k(3));
        fprintf(fid, '\t"OriginX:=",  "%f%s",_\n',OriginX(1), Units);
        fprintf(fid, '\t"OriginY:=", "%f%s",_\n',OriginX(2), Units);
        fprintf(fid, '\t"OriginZ:=", "%f%s",_\n',OriginX(3), Units);
        fprintf(fid, '\t"IsPropagating:=", true,_\n');
        fprintf(fid, '\t"IsEvanescent:=", false,_\n');
        fprintf(fid, '\t"IsEllipticallyPolarized:=", false)');
    end
    end