function [Pob]=Delimitador(P,Particulas)
Pob = [];
conteo = 0;


for n = 1:(Particulas*8):size(P,1)
conteo = conteo + 1;
if conteo~= 30
    Pob = [Pob;P(n:n+Particulas-1,:) ];
end

if conteo == 30
    Pob = [Pob;P((size(P,1)-Particulas+1):end,:) ];
    break;
end 


end 
% 
% [xi,yi]= meshgrid(0:0.1:4,0:0.1:4);
% 
% zi = interp2(P(:,1),P(:,2),P(:,3),xi,yi,'linear');


end