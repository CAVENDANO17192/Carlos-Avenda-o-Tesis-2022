function [Poblacion]=GENERAR_P(limposx,limposy,limposz,limnegx,limnegy,limnegz,Particulas)
Poblacion = [];


    [X1, Y1, Z1] = meshgrid(limnegx:0.35:limposx, limnegy:0.35:limposy, limnegz:0.20:limposz);
%     0.60 0.80 1.00 1.20 1.40 1.60 1.80 2.00 
%     0.00 0.35 0.70 1.05 1.40 1.75 2.10 2.45 
%     0.00 0.35 0.70 1.05 1.40 1.75 2.10 2.45 
    ; % verificar que genere matrices de 4x4x4 
    n = size(X1,1)*size(Y1,1)*size(Z1,1);
    Poblacion = [reshape(X1, [n, 1]),reshape(Y1, [n, 1]),  reshape(Z1, [n, 1])];
    %Poblacion = [8,9,1;9,6,1;3,5,10;10,2,10;10,5,8]

end




