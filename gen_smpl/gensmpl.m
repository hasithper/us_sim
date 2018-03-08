function [a,j] = gensmpl(r,d,dim,str,itr)
%GENSMPL Summary of this function goes here
%r = radius of the particles
%n = Number of the particles
%d = Spacing of the particle



if nargin < 5
    itr=1e6;
    warning('Number of iteration not specified(using default value 1e6)')
end

smpl_stat=1;
r_slct=sort(r,'descend');
n=length(r_slct);
%r_slct=r.*ones([1 n]);
while smpl_stat>0
x_pbc=[0];
y_pbc=[0];
z_pbc=[0];
r_pbc=[0];
j=1;
state=0;
[x1 y1 z1]=sphere;

while (j<n+1 & itr>0)
    itr=itr-1;
    x0=rand*dim;
    y0=rand*dim;
    z0=rand*dim;
    r0=r(j); 
    
    %debuging
    disp(j)
    %% check orignl point
    state=2;
    for q=1:length(x_pbc)
        tmp=[(x_pbc(q)-x0) (y_pbc(q)-y0) (z_pbc(q)-z0)];
        if (sum(tmp.^2))<((2*d)^2)
            state=-1;
            break;
        end
    end
    
    x_tmp=0;
    y_tmp=0;
    z_tmp=0;
    r_tmp=0;
    qq=1;
    if state>0
        x_tmp(qq)=x0;
        y_tmp(qq)=y0;
        z_tmp(qq)=z0;
        r_tmp(qq)=r(j);
       
        qq=qq+1;
        %check intersects
        wall_col=0;
        if(x0<r0)
            wall_col(1)=1;
        end
        if(x0>dim-r0)
            wall_col(2)=1;
        end
        if(y0<r0)
            wall_col(3)=1;
        end
        if(y0>dim-r0)
            wall_col(4)=1;
        end
        if(z0<r0)
            wall_col(5)=1;
        end
        if(z0>dim-r0)
            wall_col(6)=1;
        end
        
        org=[x0 y0 z0];
        
        dd=sum(wall_col);
        for i=1:dd
            pp=combnk(find(wall_col),i);
            for q=1:size(pp,1)
                pb=pp(q,:);
                loc=org;
                for pq=1:length(pb)
                    
                    if pb(pq)==1
                        loc(1)=org(1)+dim;
                    end
                    if pb(pq)==2
                        loc(1)=org(1)-dim;
                    end
                    if pb(pq)==3
                        loc(2)=org(2)+dim;
                    end
                    if pb(pq)==4
                        loc(2)=org(2)-dim;
                    end
                    if pb(pq)==5
                        loc(3)=org(3)+dim;
                    end
                    if pb(pq)==6
                        loc(3)=org(3)-dim;
                    end
                    
                end
                x_tmp(qq)=loc(1);
                y_tmp(qq)=loc(2);
                z_tmp(qq)=loc(3);
                r_tmp(qq)=r(j);
                %surf(r*x1+loc(1),r*y1+loc(2),r*z1+z_tmp(i));
                % hold on
                qq=qq+1; 
%                 fprintf('pbc\n');
            end
            
        end
        %% check pbc with old
        for q=1:length(x_pbc)
            for yy=1:length(x_tmp)
                tmp=[(x_tmp(yy)-x_pbc(q)) (y_tmp(yy)-y_pbc(q)) (z_tmp(yy)-z_pbc(q))];
                if (sum(tmp.^2))<((2*d)^2)
                    state=-1;
                    break;
                end
                
            end
        end
    end
    %% add set of partcls to final list
    if state>0
        x_pbc=[x_pbc x_tmp];
        y_pbc=[y_pbc y_tmp];
        z_pbc=[z_pbc z_tmp];
        r_pbc=[r_pbc r_tmp];
        j=j+1;

    end
end
%% end print and bound
if (itr<2)
    fprintf('%d-itr Not completed\n',j);
     smpl_stat=1;
else
    fprintf('%d-itr Completed\n',itr);
    smpl_stat=-1;
    a=[x_pbc',y_pbc',z_pbc',r_pbc'];
    a(1,:)=[];
    
    if nargin > 3
        dlmwrite(str,a, 'delimiter', ',', 'precision', 10); 
    end

    
end
end

end

