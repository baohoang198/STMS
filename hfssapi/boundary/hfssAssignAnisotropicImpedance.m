function hfssAssignAnisotropicImpedance(fid, ImpedanceName, Object, xx_Resistance, xx_Reactance,xy_Resistance, xy_Reactance, ...
    yx_Resistance, yx_Reactance, yy_Resistance, yy_Reactance)
    
%     if (nargin < 5)
%         Reactance=0;
%         InfGroundPlane = 'false';
%     elseif (nargin == 5)
%         InfGroundPlane = 'false';
%     end
    
    % Preamble.
    fprintf(fid, '\n');
    fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup") \n');
    fprintf(fid, '\n');
    fprintf(fid, 'oModule.AssignAnisotropicImpedance _\n');
    fprintf(fid, 'Array( _\n');
    fprintf(fid, '"NAME:%s", _\n', ImpedanceName);
    fprintf(fid, '"Objects:=", Array("%s"), _\n', Object);
    fprintf(fid, '"UseInfiniteGroundPlane:=",false,_\n');
    fprintf(fid, '"CoordSystem:=","Global",_\n');
    fprintf(fid, '"HasExternalLink:=",false,_\n');
    fprintf(fid, '"ZxxResistance:=", "%f", _\n', xx_Resistance);
    fprintf(fid, '"ZxxReactance:=", "%f", _\n', xx_Reactance);
    fprintf(fid, '"ZxyResistance:=", "%f", _\n', xy_Resistance);
    fprintf(fid, '"ZxyReactance:=", "%f", _\n', xy_Reactance);
    fprintf(fid, '"ZyxResistance:=", "%f", _\n', yx_Resistance);
    fprintf(fid, '"ZyxReactance:=", "%f", _\n', yx_Reactance);
    fprintf(fid, '"ZyyResistance:=", "%f", _\n', yy_Resistance);
    fprintf(fid, '"ZyyReactance:=", "%f")', yy_Reactance);
end