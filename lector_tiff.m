DIRECTORIO=pwd;
cd(DIRECTORIO);
lista={'banda674.tiff'; 'banda702.tiff'; 'banda711.tiff'; 'banda749.tiff'}
[n m] = size(lista); %n indica posicion lista(n,1)
for i=1:n
[X, R] = geotiffread(strcat(DIRECTORIO,'/',lista(i,1)));
end