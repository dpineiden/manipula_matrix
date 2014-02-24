%M=interpolacion_matrix([x_0 x_1],[y_0 y_1], b)
%interpola una zona de la matriz
%V: matriz de valores
%[x_0 x_1]: valores de posición horizontal
%[y_0 y_1]: valores de posición vertical
%b: orientación 1: horizontal, 0: vertical
%tener cuidado en definir bordes horizontales y verticales c=0 todo el
%registro vertical, c=1 todo registro horizontal, c=2 parcial, se toman
%ambos vectores
function M=interpolacion_matrix(V,x,y, b,c)
%verificar que sean mayores que 0 y dentro de V
[n m] = size(V);
M=V;
if length(x) <=2 || length(y) <=2 
x_0=x(1);
x_1=x(2);
y_0=y(1);
y_1=y(2);    
if c==0
    y_0=1;
    y_1=n;
elseif c==1
    x_0=1;
    x_1=m;
elseif c==2            

else
          msgbox('Error al ingresar zona de registro')
end
T=[]
if x_0>=0 && x_1>x_0  && x_1<=n && y_0>=0 && y_1>y_0 && y_1<=m 
    if b==1
        X=[x_0:x_1];
        Y=[y_0:y_1];
        for j=y_0:y_1
        m(j,1)=(V(x_1,j)-V(x_0,j))/(x_1-x_0);
        c(j,1)=(V(x_0,j)*x_1-V(x_1,j)*x_0)/(x_1-x_0);
        T(j,:)=m(j,1)*X+c(j,1);
        end
        M(Y,X)=T;    
    elseif b==0
        X=[x_0:x_1];
        Y=[y_0:y_1];
        for i=x_0:x_1
        m(1,i)=(V(i,y_1)-V(i,y_0))/(y_1-y_0);
        c(1,i)=(V(i,y_0)*y_1-V(i,y_1)*y_0)/(y_1-y_0);
        T(:,i)=m(1,j)*Y+c(1,j)
        end
        M(Y,X)=T;
    else
      msgbox('Error al ingresar orientación 0 para vertical o bien 1 para horizontal')
    end
else
    msgbox('Error al ingresar tus datos de interpolación')
end
else
    msgbox('Error en largo de vetores x o y')  
end

end