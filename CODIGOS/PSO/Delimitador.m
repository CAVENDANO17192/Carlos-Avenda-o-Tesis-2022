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



end