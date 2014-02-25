%M=interpolacion_matrix(V,x,y, b,c,p,q,factor)
%interpola una zona de la matriz
%V: matriz de valores
%[x_0 x_1]: valores de posición horizontal
%[y_0 y_1]: valores de posición vertical
%b: orientación 1: horizontal, 0: vertical
%tener cuidado en definir bordes horizontales y verticales c=0 todo el
%registro vertical, c=1 todo registro horizontal, c=2 parcial, se toman
%ambos vectores es una interpolación difusa, basada en la asgincación de un valor obtenido a partir
% de las zonas contiguas de cada pixel frontera, seleccionado al azar
%la zona contigua es criterio del usuario, basada un un valor p: cantidad
%de pixeles en torno a la vertical, y q cantidad de pixeles en torno a la
%horizontal
%p= es el ratio horizontal que recoge a la izq y derecha del punto elegido
%q= es el ratio vertical que recoge hacia arriba y abajo del punto elegido
%ambos determinan una matriz de dimensión 2p+1 x 2q+1 con centro el punto
%escogido
%factor: es un par de valores que le asigna un peso la interpolación lineal
%difusa, tiene valor de 0 a 1.
%$factor_intercambio: es el factor que se aplica al intercambio de la zona, primero a 
%la misma zona y luego a la matriz de reemplazo
function M=interpolacion_matrix(V,x,y, b,c,p,q,factor, factor_intercambio)
%verificar que sean mayores que 0 y dentro de V
[n_v, m_v] = size(V);
M=double(V);
%%se evalua si corresponde operar la función
if length(x) <=2 || length(y) <=2  || factor <=1 && factor >=0 || factor_intercambio <=1 && factor_intercambio >=0
%%se construyen los vectores de factor y factor_intercambio
factor=[factor,1-factor];  
factor_intercambio=[factor_intercambio,1-factor_intercambio];  
x_0=x(1);
x_1=x(2);
y_0=y(1);
y_1=y(2);

if c==0
    y_0=1;
    y_1=n_v;
elseif c==1
    x_0=1;
    x_1=m_v;
elseif c==2            

else
          msgbox('Error al ingresar zona de registro')
end

if x_0>=1 && x_1>x_0  && x_1<=m_v && y_0>=1 && y_1>y_0 && y_1<=n_v 
    if b==1
        X=[x_0:x_1];
        Y=[y_0:y_1];
        lx=length(X);
        ly=length(Y);
        for j=y_0:y_1
        m(j,1)=(V(j,x_1)-V(j,x_0))/(x_1-x_0);
        c(j,1)=(V(j,x_0)*x_1-V(j,x_1)*x_0)/(x_1-x_0);
        %%matriz grupo A-varian las columnas        
        I_0(1,:)=[max(j-q,1), max(x_0-p,1)];
        I_1(1,:)=[min(j+q,n_v),min(x_0+p,m_v)];
        %%matriz grupo B
        I_0(2,:)=[max(j-q,1), max(x_1-p,1)];
        I_1(2,:)=[min(j+q,n_v),min(x_1+p,m_v)];
        %%Grupos de matrices de adyacencia en torno a pixel frontera
        G_a=V(I_0(1,1):I_1(1,1),I_0(1,2):I_1(1,2));
        G_b=V(I_0(2,1):I_1(2,1),I_0(2,2):I_1(2,2));
        %%tamaño de matrices de adyacencia
        [n_a, m_a]=size(G_a);
        [n_b, m_b]=size(G_b);
        %%se determina aletoriamente que valor de matrices de adyacencia
        %%obtener
        for k=1:lx
        r_a_n=randi(n_a);
        r_a_m=randi(m_a);
        r_b_n=randi(n_b);
        r_b_m=randi(m_b);
        ga(k)=G_a(r_a_n,r_a_m);
        gb(k)=G_b(r_b_n,r_b_m);
        end
        %vector factor de posición del cada pixel
        beta=[1:lx]/lx;        
        alpha=1-beta;
        %%Se obtienen los vectores de interpolacion lineal y difusa pura.
        vectorlineal=round(double(m(j,1)))*X+c(j,1);
        vectordifuso=alpha.*round(double(ga))+beta.*round(double(gb));
        %#se suman linealmente
        vector=round((factor(1)*vectorlineal+factor(2)*vectordifuso));
        %%se asocia la lína correspondiente de T con el vector.
        T(j,:)=vector;
        end
        %%se rescata la matriz a corregir original
        M_o=double(M(Y,X));
        %%se determina la nueva matriz
        M(Y,X)=factor_intercambio(1)*M_o+factor_intercambio(2)*T;    
    elseif b==0
        X=[x_0:x_1];
        Y=[y_0:y_1];
        lx=length(X);
        ly=length(Y);        
        for i=x_0:x_1
        m(1,i)=(V(y_1,i)-V(y_0,i))/(y_1-y_0);
        c(1,i)=(V(y_0,i)*y_1-V(y_1,i)*y_0)/(y_1-y_0);
        %matriz grupo A-varian las filas
        I_0(1,:)=[max(y_0-q,1), max(i-p,1)];
        I_1(1,:)=[min(y_0+q,n_v),min(i+p,m_v)];
        %matriz grupo B
        I_0(2,:)=[max(y_1-q,1), max(i-p,1)];
        I_1(2,:)=[min(y_1+q,n_v),min(i+p,m_v)];
        %
        G_a=V(I_0(1,1):I_1(1,1),I_0(1,2):I_1(1,2));
        G_b=V(I_0(2,1):I_1(2,1),I_0(2,2):I_1(2,2));
        %
        [n_a, m_a]=size(G_a);
        [n_b, m_b]=size(G_b);
        %
        for k=1:ly
        r_a_n=randi(n_a);
        r_a_m=randi(m_a);
        r_b_n=randi(n_b);
        r_b_m=randi(m_b);
        ga(k)=G_a(r_a_n,r_a_m);
        gb(k)=G_b(r_b_n,r_b_m);
        end
        %
        beta=[1:ly]/ly;
        alpha=1-beta;
        %
        vectorlineal=m(j,1)*X+c(j,1);
        vectordifuso=alpha.*round(double(ga))+beta.*round(double(gb));
        %
        vector=round((vectorlineal*factor(1)+vectordifuso*factor(2)));
        %

        T(:,i)=vector;
        end
        M_o=double(M(Y,X));
        M(Y,X)=factor_intercambio(1)*M_o+factor_intercambio(2)*T;    
    else
      msgbox('Error al ingresar orientación 0 para vertical o bien 1 para horizontal')
    end
else
    msgbox('Error al ingresar tus datos de interpolación')
end
else
    msgbox('Error en largo de vetores x o y o factor')  
end

end