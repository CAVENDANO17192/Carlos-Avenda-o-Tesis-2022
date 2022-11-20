function [u1x,u2x,u3x,u1y,u2y,u3y,u1z,u2z,u3z]=penal(nobs,x,y,z,Xobs,Yobs,Zobs,tol1,evadir)


dist1 = sqrt(((Xobs(1)-x)^2)+((Yobs(1)-y)^2)+((Zobs(1)-z)^2));
dist2 = sqrt(((Xobs(2)-x)^2)+((Yobs(2)-y)^2)+((Zobs(2)-z)^2));
dist3 = sqrt(((Xobs(3)-x)^2)+((Yobs(3)-y)^2)+((Zobs(3)-z)^2));

u1x=0;u2x=0;u3x=0;
u1y=0;u2y=0;u3y=0;
u1z=0;u2z=0;u3z=0;
%distancia entre particula-obstaculo.
if ((dist1 < tol1)||(dist2 < tol1)||(dist3 < tol1))
if nobs > 0
    dist1x = Xobs(1)-x;
    dist1y = Yobs(1)-y;
    dist1z = Zobs(1)-z;
    
    if (abs(dist1x) < tol1)
    
        if sign(dist1x) == -1 % derecha
            u1x = u1x+evadir;
        end

        if sign(dist1x) == 1 %izquierda
            u1x = u1x-evadir;
        end

        else 
            u1x = 0;
    
    end
    
    if (abs(dist1y) < tol1)
    
        if sign(dist1y) == -1 % derecha
            u1y = u1y+evadir;
        end

        if sign(dist1y) == 1 %izquierda
            u1y = u1y-evadir;
        end

        else 
            u1y = 0;
    end
    
    if (abs(dist1z) < tol1)
    
        if sign(dist1z) == -1 % derecha
            u1z = u1z+evadir;
        end

        if sign(dist1z) == 1 %izquierda
            u1z = u1z-evadir;
        end

        else 
            u1z = 0;
    
    end
    
        if nobs > 1
                dist2x = Xobs(2)-x;
                dist2y = Yobs(2)-y;
                dist2z = Zobs(2)-z;
                
                if(abs(dist2x) < tol1)
    
                    if sign(dist2x) == -1 % derecha
                        u2x = u2x+evadir;
                    end

                    if sign(dist2x) == 1 %izquierda
                        u2x = u2x-evadir;
                    end

                    else 
                        u2x = 0;
    
                end
                
                if(abs(dist2y) < tol1)
    
                    if sign(dist2y) == -1 % derecha
                        u2y = u2y+evadir;
                    end

                    if sign(dist2y) == 1 %izquierda
                        u2y = u2y-evadir;
                    end

                    else 
                        u2y = 0;

                end
                
                if(abs(dist2z) < tol1)
    
                    if sign(dist2z) == -1 % derecha
                        u2z = u2z+evadir;
                    end

                    if sign(dist2z) == 1 %izquierda
                        u2z = u2z-evadir;
                    end

                    else 
                        u2z = 0;

                end

                
                if nobs > 2

                    dist3x = Xobs(3)-x;
                    dist3y = Yobs(3)-y;
                    dist3z = Zobs(3)-z;

                     if(abs(dist3x) < tol1)

                        if sign(dist3x) == -1 % derecha
                            u3x = u3x+evadir;
                        end

                        if sign(dist3x) == 1 %izquierda
                            u3x = u3x-evadir;
                        end

                        else 
                            u3x = 0;

                    end



                    if(abs(dist3y) < tol1)

                        if sign(dist3y) == -1 % derecha
                            u3y = u3y+evadir;
                        end

                        if sign(dist3y) == 1 %izquierda
                            u3y = u3y-evadir;
                        end

                        else 
                            u3y = 0;

                    end


                    if(abs(dist3z) < tol1)

                        if sign(dist3z) == -1 % derecha
                            u3z = u3z+evadir;
                        end

                        if sign(dist3z) == 1 %izquierda
                            u3z = u3z-evadir;
                        end

                        else 
                            u3z = 0;

                    end
                        
                        
                end 
        end
end

end






end