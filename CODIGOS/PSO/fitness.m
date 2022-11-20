function [costo]=fitness(x,XP,y,YP,z,ZP)
costo = (3*((x-XP)^2)+3*((y-YP)^2)+3*((z-ZP)^2));
end



