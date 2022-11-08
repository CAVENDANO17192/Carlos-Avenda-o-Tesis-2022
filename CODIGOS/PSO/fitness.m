function [costo]=fitness(x,XP,y,YP,z,ZP,Xobs,Yobs,Zobs,tol1,nobs,castigador1,tol2,castigador2)
u1 = 0;
u2 = 0;
u3 = 0;
dist1=0;
dist2=0;
dist3=0;
val=0.01;

switch nobs
    
    case 1
        dist1 = sqrt(((Xobs(1)-x)^2)+((Yobs(1)-y)^2)+((Zobs(1)-z)^2));

        if dist1 < tol1
            u1 =castigador1+u1;
        end
        
       if dist1 < tol2
            u1 =castigador2+u1;
        end

        if dist1 >= tol1-val
             u1 = 0;
        end
        
    case 2
        dist1 = sqrt(((Xobs(1)-x)^2)+((Yobs(1)-y)^2)+((Zobs(1)-z)^2));
        dist2 = sqrt(((Xobs(2)-x)^2)+((Yobs(2)-y)^2)+((Zobs(2)-z)^2));
        
        if (dist1 < tol1)
            u1 = castigador1+u1;
        end
        
        if (dist2 < tol1)
            u2 = castigador1+u2;
        end
        
        if (dist1 < tol2)
            u1 = castigador2+u1;
        end
        
        if (dist2 < tol2)
            u2 = castigador2++u2;
        end
        
        if dist1 > tol1-val
            u1 = 0;
        end
        
        if dist2 > tol1-val
            u2 = 0;
        end
        
    case 3
        dist1 = sqrt(((Xobs(1)-x)^2)+((Yobs(1)-y)^2)+((Zobs(1)-z)^2));
        dist2 = sqrt(((Xobs(2)-x)^2)+((Yobs(2)-y)^2)+((Zobs(2)-z)^2));
        dist3 = sqrt(((Xobs(3)-x)^2)+((Yobs(3)-y)^2)+((Zobs(3)-z)^2));
      
        if (dist1 < tol1)
            u1 = castigador1+u1;
        end
        
        if (dist2 < tol1)
            u2 = castigador1+u2;
        end
        
        if (dist3 < tol1)
            u3 = castigador1+u3;
        end
        
        if (dist1 < tol2)
            u1 = castigador2;
        end
        
        if (dist2 < tol2)
            u2 = castigador2;
        end
        
        if (dist3 < tol2)
            u3 = castigador2;
        end

        if dist1 > tol1-val
            u1 = 0;
        end
        
        if dist2 > tol1-val
            u2 = 0;
        end
        
        if dist3 > tol1-val
            u3 = 0;
        end
        
end
costo = (3*((x-XP)^2)+3*((y-YP)^2)+3*((z-ZP)^2))+u1+u2+u3;
end



