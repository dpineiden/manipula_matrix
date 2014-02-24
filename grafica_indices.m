%pasar los índices de vegetacion a escala de grises, plotear cada uno en un
%subplot y guardar cada imagen
%Vamos a graficar 'IndiceVegetacion'
Nombre_Proceso='Prueba_Indices';
Carpeta_output='Output';
COD_SAT_IMG='LM52330761984359AAA03'
%obtengo los nombres de Indice de Vegetacion
lista=fieldnames(IndiceVegetacion);
[n m]=size(lista);
%n entrega la cantidad de elementos o nombres de lista
%revisar cuales son con valor '0' para omitir su gráfica.
IV=[];
Nombre_IV='';
j=1;
for i=1:n
    Indice=getfield(IndiceVegetacion,lista{i,1});
    [n_I m_I]=size(Indice);
    Uno=any(Indice(:));
%     if n_I<m_I
%         V=Indice*Indice';
%     else
%         V=Indice'*Indice;
%     end
%     [L,U]=lu(V);
%     Det_L(i)=det(L);
%     Det_U(i)=det(U);
%     if Det_L(i)!=0 || Det_L(i)!=0
    if Uno==1
        IV(:,:,j)=Indice;
        Nombre_IV{j,1}=lista{i};
        j=j+1;
    end
end
%con esto, tenemos el set de indices que realmente se calcularon y se
%obtienen sus nombres para poder graficarlos con un subplot
%recurrimos nuevamente a obtener la cantidad de los nombre de indices
%recuperados
IndiceVegetacion=[];
[n m]=size(Nombre_IV)
%definir tamaño de subplot
fa=factor(n);
N=length(fa);
n_a=ceil(N/2);
%multiplicar de a  a n_a
g1=prod(fa(1:n_a));
%multiplicar de n_a+1 a NN
g2=prod(fa(n_a+1:N));
%creamos figure
figure
scale=0.3;
for i=1:n
I(:,:,i)=mat2gray(IV(:,:,i),[min(min(IV(:,:,i))) max(max(IV(:,:,i)))]);    
B(:,:,i) = imresize(I(:,:,i), scale);
subplot(g1,g2,i);
imshow(B(:,:,i));
title(Nombre_IV{i,1});
end
%Guardar, se hace separado para asegurar que se grafiquen las imagenes en
%primer lugar
%hora se procede a guardar cada set de imagenes como geotiff
for i=1:n
 [I_16b,Map_16b]=gray2ind(I(:,:,i),65536);
  savefile_TIF=strcat(Carpeta_output,'/',Nombre_Proceso,'/',COD_SAT_IMG,'_',Nombre_IV{i});
  geotiffwrite(savefile_TIF,I_16b,INFO.nir,'GeoKeyDirectoryTag',UTM.geokey); 
end


% I=mat2gray(Indice,[min(min(Indice)) max(max(Indice))]);
% [I_16b,Map_16b]=gray2ind(I,65536);

% savefile_TIF=strcat(Carpeta_output,'/',Nombre_Proceso,'/',COD_SAT_IMG,'_',INDICES{i},'.TIF');
% geotiffwrite(savefile_TIF,I_16b,INFO_x,'GeoKeyDirectoryTag',UTM.geokey);
% imwrite(I_16b,savefile_TIF,'tif');
% Info_tif=imfinfo(savefile_TIF);
% savefile_PNG=strcat(Carpeta_output,'/',Nombre_Proceso,'/',COD_SAT_IMG,'_',INDICES{i},'.PNG');
% imwrite(I_16b,savefile_PNG,'png');
% Info_png=imfinfo(savefile_PNG);