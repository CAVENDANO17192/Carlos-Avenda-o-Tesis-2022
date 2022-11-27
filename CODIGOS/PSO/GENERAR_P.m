function [Poblacion]=GENERAR_P(limposx,limposy,limposz,limnegx,limnegy,limnegz,Particulas)
Poblacion = [];

par = (Particulas)^(1/3);
    [X1, Y1, Z1] = meshgrid(limnegx:((limposx-limnegx)/(par-1)):limposx, limnegy:((limposy-limnegy)/(par-1)):limposy, limnegz:((limposz-limnegz)/(par-1)):limposz);
 %x = 4
 %y = 3
 %z = 1.65


    n = size(X1,1)*size(Y1,1)*size(Z1,1);
    Poblacion = [reshape(X1, [n, 1]),reshape(Y1, [n, 1]),  reshape(Z1, [n, 1])];
    %Poblacion = [8,9,1;9,6,1;3,5,10;10,2,10;10,5,8]

end