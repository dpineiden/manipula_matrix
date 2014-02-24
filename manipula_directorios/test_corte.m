clear
%cargar imagen
%definir ruta de imagen
BaseDir='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat/'
File='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat/DesAtacama/Imagenes/233_076/1984/12_diciembre/LM52330761984359AAA03_B1.TIF';
Ruta='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat/DesAtacama/Imagenes/233_076/1984/12_diciembre';
nombre_corte='Prueba';
UTM_x=[420000,500000];
UTM_y=[-2300000,-2400000];
largo_pixel=30;
[IMc, X, R, INFO]=corte_imagen(BaseDir,File,UTM_x,UTM_y);
 figure
 imshow(IMc)
 figure
 imshow(X)
save_geotif=guardar_img_tif(IMc,R,INFO,File,nombre_corte,UTM_x,UTM_y);