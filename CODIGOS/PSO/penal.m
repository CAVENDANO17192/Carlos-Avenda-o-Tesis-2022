function [u1x,u2x,u3x,u1y,u2y,u3y,u1z,u2z,u3z]=penal(nobs,x,y,z,Xobs,Yobs,Zobs,tol1,evadir)


dist1 = sqrt(((Xobs(1)-x)^2)+((Yobs(1)-y)^2)+((Zobs(1)-z)^2));
dist2 = sqrt(((Xobs(2)-x)^2)+((Yobs(2)-y)^2)+((Zobs(2)-z)^2));
dist3 = sqrt(((Xobs(3)-x)^2)+((Yobs(3)-y)^2)+((Zobs(3)-z)^2));

u1x=0;u2x=0;u3x=0;
u1y=0;u2y=0;u3y=0;
u1z=0;u2z=0;u3z=0;



if nobs > 0
if dist1 < tol1
    
    x1 = Xobs(1)-x;
    if (abs(x1) < tol1)
        
        if sign(x1) ==  1
            u1x=-evadir;
        end 
        
        if sign(x1) == -1
            u1x=evadir;
        end
        
    end
    
    y1 = Yobs(1)-y;
    if (abs(y1) < tol1)
        
        if sign(y1) ==  1
            u1y=-evadir;
        end 
        
        if sign(y1) == -1
            u1y=evadir;
        end
        
    end
    
    z1 = Zobs(1)-z;
    if (abs(z1) < tol1)
        
        if sign(z1) ==  1
            u1z=-evadir;
        end 
        
        if sign(z1) == -1
            u1z=evadir;
        end
        
    end
    
end 
end

if nobs > 1
if dist2 < tol1
    
    
    x2 = Xobs(2)-x;
    if (abs(x2) < tol1)
        
        if sign(x2) ==  1
            u2x=-evadir;
        end 
        
        if sign(x2) == -1
            u2x=evadir;
        end
        
    end
    
    y2 = Yobs(2)-y;
    if (abs(y2) < tol1)
        
        if sign(y2) ==  1
            u2y=-evadir;
        end 
        
        if sign(y2) == -1
            u2y=evadir;
        end
        
    end
    
    z2 = Zobs(2)-z;
    if (abs(z2) < tol1)
        
        if sign(z2) ==  1
            u2z=-evadir;
        end 
        
        if sign(z2) == -1
            u2z=evadir;
        end
        
    end
    
    
    
end 
end

if nobs > 2
if dist3 < tol1
    
    
    x3 = Xobs(3)-x;
    if (abs(x3) < tol1)
        
        if sign(x3) ==  1
            u3x=-evadir;
        end 
        
        if sign(x3) == -1
            u3x=evadir;
        end
        
    end
    
    y3 = Yobs(3)-y;
    if (abs(y3) < tol1)
        
        if sign(y3) ==  1
            u3y=-evadir;
        end 
        
        if sign(y3) == -1
            u3y=evadir;
        end
        
    end
    
    z3 = Zobs(3)-z;
    if (abs(z3) < tol1)
        
        if sign(z3) ==  1
            u3z=-evadir;
        end 
        
        if sign(z3) == -1
            u3z=evadir;
        end
        
    end
    
end 
end

end