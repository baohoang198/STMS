% hfssDrawRing(fid,Name,Axis,Center,rad1,rad2,Units)
function hfssDrawRing(fid,Name,Axis,Center,rad1,rad2,Units)
hfssCircle(fid,Name,Axis,Center,rad1,Units);
hfssCircle(fid,[Name,'2'],Axis,Center,rad2,Units);
hfssSubtract(fid,Name,[Name,'2']);
hfssAssignPE(fid,Name,0,{Name});
end