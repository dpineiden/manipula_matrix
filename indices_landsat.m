%buscar cada cuadro en la lista de imagenes de proyecto
%entregar cuatro ´indices en los que encuentra cada punto.
%esto indica bajo que imagenes landsat se encuentra el recuadro
%Puntos_x es un par de valores que indican minimo y maximo horizontal
%Puntos_y un par de valores que indican minimo maximo vertical
%Arreglo_x es una lista de valores de dos columnas que contiene los valores
%minimo y maximo horizontal de las imagenes landsat en UTM 19N
%Arreglo_y es una lista de valores de dos columnas que contiene los valores
%minimo y maximo vertical de las imagenes landsat en UTM 19N
function [x1 x2 y1 y2]=indices_landsat(Puntos_x,Puntos_y,Arreglo_x,Arreglo_y)
[n m]=size(Arreglo_x);%el mismo que Arreglo_y n filas y m=2 columnas
%tamaño de Puntos_- es de 1 fila, 2 columnas
j=1;
l=1;
h=1;
k=1;
x1=0;
x2=0;
y1=0;
y2=0;
for i=1:n
   if and(Arreglo_y(i,1)<=Puntos_y(1),Puntos_y(1)<=Arreglo_y(i,2))
       y1(h)=i;
       h=h+1;
   end
   if and(Arreglo_y(i,1)<=Puntos_y(2),Puntos_y(2)<=Arreglo_y(i,2))
       y2(k)=i;
       k=1+k;
   end    
   if and(Arreglo_x(i,1)<=Puntos_x(1),Puntos_x(1)<=Arreglo_x(i,2))
       x1(j)=i;
       j=1+j;
   end
   if and(Arreglo_x(i,1)<=Puntos_x(2),Puntos_x(2)<=Arreglo_x(i,2))
       x2(l)=i;
       l=1+l;
   end

   
end
end