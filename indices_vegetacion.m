
%definir directorio de trabajo
%setear en este directorio
%Nombre del Proceso
%se desean guardar las variables en .mat?savemat 0:no, 1:si
%INDICES={"NDVI","SR","DVI","SAVI","TNDI","NDWI","EVI","TGDVI"}
function [IndiceVegetacion, INFO,UTM, R_l]=indices_vegetacion(BaseDir,MTLDIR,savemat,Nombre_Proceso,CorteX,CorteY,INDICES)
[n m]=size(INDICES);
cd(BaseDir);
var_mat=savemat;
Carpeta_output='Output';%salida, guardar resultados
i=1;
Landsat=5;
Carpeta_img=strcat(BaseDir,'/img_',Nombre_Proceso);
%Nombres bandas:[blue,green,red,NIR,SWIR,-]
hemisferio='S';
%reflactancia NIR:R 1
Banda=4;
[R_l(:,:,1),L_l(:,:,1),DN7(:,:,1),UTM,COD_SAT_IMG,INFO.nir]=reflactancia(Banda,Landsat,Carpeta_img,MTLDIR,hemisferio,Nombre_Proceso,CorteX,CorteY);
%reflactancia ROJA:R 2
Banda=3;
[R_l(:,:,2),L_l(:,:,2),DN7(:,:,2),UTM,COD_SAT_IMG,INFO.red]=reflactancia(Banda,Landsat,Carpeta_img,MTLDIR,hemisferio,Nombre_Proceso,CorteX,CorteY);
R_l(:,:,3)=zeros(size(R_l(:,:,1)));
R_l(:,:,4)=zeros(size(R_l(:,:,1)));

for i=1:m
    switch INDICES{1,i}
        case 'TGDVI'
        %reflactancia AZUL:R 3
        Banda=1;
        [R_l(:,:,3),L_l(:,:,3),DN7(:,:,3),UTM,COD_SAT_IMG,INFO.blue]=reflactancia(Banda,Landsat,Carpeta_img,MTLDIR,hemisferio,Nombre_Proceso,CorteX,CorteY);
        %reflactancia SWIR:R 4
        case 'NDWI'
        Banda=5;
        [R_l(:,:,4),L_l(:,:,4),DN7(:,:,4),UTM,COD_SAT_IMG,INFO.swir]=reflactancia(Banda,Landsat,Carpeta_img,MTLDIR,hemisferio,Nombre_Proceso,CorteX,CorteY);
    end
end

IndiceVegetacion.NDVI=0;
IndiceVegetacion.SR=0;
IndiceVegetacion.DVI=0;
IndiceVegetacion.SAVI=0;
IndiceVegetacion.TNDI=0;
IndiceVegetacion.NDWI=0;
IndiceVegetacion.EVI=0;
IndiceVegetacion.TGDVI=0;
for i=1:m
   switch  INDICES{1,i}
       case 'NDVI'
            Numerador=R_l(:,:,1)-R_l(:,:,2);
            Denominador=R_l(:,:,1)+R_l(:,:,2);
            IndiceVegetacion.NDVI=Numerador./Denominador;
            INFO_x=INFO.nir;
       case 'SR'
           IndiceVegetacion.SR=R_l(:,:,1)./R_l(:,:,2);
           INFO_x=INFO.nir;
       case 'DVI'
           IndiceVegetacion.DVI=R_l(:,:,1)-R_l(:,:,2);
           INFO_x=INFO.nir;
       case 'SAVI'
           L=0.5;
            Numerador=R_l(:,:,1)-R_l(:,:,2);
            Denominador=R_l(:,:,1)+R_l(:,:,2)+L;
           IndiceVegetacion.SAVI=(Numerador./Denominador)*(1+L); 
           INFO_x=INFO.nir;
       case 'TNDI'
            Numerador=R_l(:,:,1)-R_l(:,:,2);
            Denominador=R_l(:,:,1)+R_l(:,:,2);
            pre_TNDI=(Numerador./Denominador) +1;
            IndiceVegetacion.TNDI=sqrt(pre_TNDI);
            INFO_x=INFO.nir;
       case 'NDWI'
            Numerador=R_l(:,:,1)-R_l(:,:,4);
            Denominador=R_l(:,:,1)+R_l(:,:,4);
            IndiceVegetacion.NDWI=Numerador./Denominador;
            INFO_x=INFO.swir;
       case 'EVI'
           G=2.5;
           L=1;
           C_1=6;
           C_2=7.5;
           Numerador=R_l(:,:,1)-R_l(:,:,2);
           Denominador=R_l(:,:,1)+C_1*R_l(:,:,2)-C_2*R_l(:,:,3)+L;
           IndiceVegetacion.EVI=G*Numerador./Denominador;
           INFO_x=INFO.nir;
       case 'TGDVI'            
            La_1=0.56e-6;%en metros
            La_2=0.66e-6;
            La_3=0.83e-6;            
            Numerador_1=R_l(:,:,1)-R_l(:,:,2);
            Denominador_1=La_3-La_2;            
            Numerador_2=R_l(:,:,2)-R_l(:,:,3);
            Denominador_2=La_2-La_1;            
            pre_TGDVI=Numerador_1./Denominador_1-Numerador_2./Denominador_2;
            %pasar a 0 valores menores que 0
            pre_TGDVI(pre_TGDVI<0)=0;
            IndiceVegetacion.TGDVI=pre_TGDVI;
            INFO_x=INFO.blue;
   end



end

if var_mat==1
savefile=strcat(Carpeta_output,'/',Nombre_Proceso,'/',COD_SAT_IMG,'.mat');
save(savefile,'R_l','L_l','DN7','UTM');
end


end