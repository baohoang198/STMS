%hfssCell1 (fid,Name,Axis,Start,No,p,r,w,Units)
function hfssCell1(fid,Name,Axis,Start,No,p,h,r,w,Units)
%A= round(rand(No));
A=[0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0];
for iX=0:No-1
    for iY=0:No-1
        if(A((iX+1),(iY+1))==0)
            hfssDrawRing(fid,[Name,num2str(iX),num2str(iY)],Axis,[Start(1)+(iX+1/2).*p,Start(2)+(iY+1/2).*p,Start(3)],r,r-w,Units);
        else
            continue;
        end
    end
end
hfssBox(fid,'Sub',[-2*p,-2*p,0],[4*p,4*p,h],'mm');
end
