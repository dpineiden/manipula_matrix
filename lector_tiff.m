DIRECTORIO=pwd;
cd(DIRECTORIO);
lista={'banda674.tif'; 'banda702.tif'; 'banda711.tif'; 'banda749.tif'};
[n m] = size(lista); %n indica posicion lista(n,1)
i=1;
file=char(strcat(DIRECTORIO,'/imagenes/',lista(i,1)));
[X,R] = geotiffread(file);
INFO = geotiffinfo(file);
UTM.geokey=INFO.GeoTIFFTags.GeoKeyDirectoryTag;
UTM.tipo=INFO.Projection;
factor=.2;
factor_intercambio=0.1;
p=25;
q=25;
b=1;
c=0;
x=[600,800];
y=[1 3];
V1=X(:,:,1);
V2=X(:,:,2);
V3=X(:,:,3);
color={'R';'G';'B'};
bits=INFO.BitDepth;
for i=1:n
    figure
    for j=1:3
M(:,:,j)=interpolacion_matrix(X(:,:,j),x,y, b,c,p,q,factor,factor_intercambio);
Im(:,:,j)=mat2gray(M(:,:,j));
[M_16b(:,:,j),Map_16b]=gray2ind(Im(:,:,j),2^bits-1);
subplot(1,5,j)
imshow(M(:,:,j))
titulo=strcat(lista(i,1),' en :',color{j});
title(titulo); 
    end
subplot(1,5,4)
imshow(M)
title([lista(i,1),',corregida.'])    
subplot(1,5,5)
imshow(X)
title(lista(i,1))    
size(M_16b)
%guardar imagenes corregidas:
  file_rev=char(strcat(DIRECTORIO,'/imagenes/rev_',lista(i,1)));
  geotiffwrite(file_rev,M_16b,R,'GeoKeyDirectoryTag',UTM.geokey);   
end