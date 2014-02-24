function save_geotif=guardar_img_tif(IMc,R,INFO,File,nombre_corte,UTM_x,UTM_y)

subR=R;
subR.RasterSize=size(IMc);
subR.XLimWorld=sort(UTM_x);
subR.YLimWorld=sort(UTM_y);
nombre=desmembrar(File, '/');
[n m]=size(nombre);
Archivo=char(nombre(n));
%guardar imagen en TIFF con geodatos
filename = [Archivo(1:length(Archivo)-4),'_',nombre_corte];
imwrite(IMc,filename,'tif')
%K = mat2gray(IMc);
%geotiffwrite(filename, K, subR,'GeoKeyDirectoryTag', INFO.GeoTIFFTags.GeoKeyDirectoryTag);
save_geotif='';
end