function hfssCell (fid,Name1,Name2,Axis,Start,No,p,r,w,Units)
A= [0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0];
for nY=0:No-1
    for nX=0:No-1
        if(A((nX+1),(nY+1))==0) 
            hfssCircle(fid,['UCell_1',num2str(nX),num2str(nY),num2str(Name1),num2str(Name2)],Axis,[Start(1)+(nX+1/2)*p,Start(2)+(nY+1/2)*p,Start(3)],r,Units);
            hfssCircle(fid,['UCell_2',num2str(nX),num2str(nY),num2str(Name1),num2str(Name2)],Axis,[Start(1)+(nX+1/2)*p,Start(2)+(nY+1/2)*p,Start(3)],r-w,Units);
            hfssSubtract(fid,['UCell_1',num2str(nX),num2str(nY),num2str(Name1),num2str(Name2)],['UCell_2',num2str(nX),num2str(nY),num2str(Name1),num2str(Name2)]);
            
            if(nX==0)
                continue;
            else
                hfssUnite(fid, {['UCell_1',num2str(nX),num2str(nY),num2str(Name1),num2str(Name2)], ['UCell_1',num2str(nX-1),num2str(nY),num2str(Name1),num2str(Name2)]});
            end
        else
            continue;
        end
    end
    if(A((nX+1),(nY+1))==0)
        if(nY==0)
            continue;
        else
            hfssUnite(fid, {['UCell_1',num2str(No-1),num2str(nY),num2str(Name1),num2str(Name2)], ['UCell_1',num2str(No-1),num2str(nY-1),num2str(Name1),num2str(Name2)]});
        end
    else
        continue;
    end
end
if(A((nX+1),(nY+1))==0)
    hfssRename(fid,['UCell_1',num2str(No-1),num2str(nY),num2str(Name1),num2str(Name2)],['CELL',num2str(Name1),num2str(Name2)]);
    hfssAssignPE(fid, ['patch',num2str(Name1),num2str(Name2)],0,{['CELL',num2str(Name1),num2str(Name2)]});
end

end
