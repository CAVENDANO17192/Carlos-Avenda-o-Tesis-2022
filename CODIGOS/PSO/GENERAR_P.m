function [Poblacion]=GENERAR_P(limposx,limposy,limposz,limnegx,limnegy,limnegz,Particulas)
Poblacion = [];
for n = 1:1:Particulas
    Poblacion = [Poblacion; randi([limnegx limposx]),randi([limnegy limposy]),randi([limnegz limposz])];
    %Poblacion = [8,9,1;9,6,1;3,5,10;10,2,10;10,5,8]
end 
end