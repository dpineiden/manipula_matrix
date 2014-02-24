%calcula la reflactancia R_l
%calcula la radianca L_l
%Calcula o entrega los datos en DN7
%Entrega projeccion utm utilizada
%Entregar numero de banda
%entregar id Landsat {1,2,3,4,5,7}
%entregar Path
%Entregar hemisferio

function [R_l,L_l,DN7,UTM,COD_SAT_IMG,R]=reflactancia(Banda,Landsat,Path,MTLDIR,Hemisferio,Nombre_Proceso,CorteX,CorteY)
cd(Path);
cd('..');
BaseDir=pwd;
MTLDIR;
%crear carpeta de proceso en Log
[status_1,message_1,messageid_1] = mkdir('Logs',Nombre_Proceso);
%crear carpeta de proceso en Output
[status_2,message_2,messageid_2] = mkdir('Output',Nombre_Proceso);
cd(Path);
%valores slope para conversion DN5 a NDN7
%Hemisferio Sur
%Bajo la formula DN7=(slope*DN5)+intercep
%Landsat=[1 a 7];
%datos de correccion landsat
%Nombres bandas:[blue,green,red,NIR,SWIR,-]
Slope=[0.943,1.776,1.538,1.427,0.984,0,1.304];
Intercep=[4.21,2.58,2.5,4.8,6.96,0,5.76];
%valores gain y bias para convertir a datos radiacion
%bajo formula L_l=(gain*DN7)+bias
Gain_radiance=[0.778740,0.798819,0.621654,0.639764,0.12622,0,0.043898];
Bias_radiance=[-6.98,-7.2,-5.62,-5.74,-1.13,0,-.39];
%conversión de datos radiacion a reflectancia.
%se cargan los datos de distancia tierra sol
%el nombre de la variables sera: d=Dist_tierra_sol
%R_l= (%pi L d^2) / (Esun sin(Omega_se))
d=load('Dist_tierra_sol.m'); %cada dia un valor, en astronomical units
%Densidad Energia solar Esun[Watt/(m^2 %um)]
Esun_l=[1997,1812,1533,1039,2260.8,0,84.9];
%cargar la elevación solar _MTL.txt
%buscar por angulo elevacion solar 'SUN_ELEVATION' entregar valor a la derecha de '='
%buscar dia y hora por 'DATE_HOUR_CONTACT_PERIOD'
Path;
cd(Path);
cd(MTLDIR);
%se entrega en degrees y fecha YY-DDD-HH DDD el dia del año
Carpeta_img=pwd;
%listar archivos txt
archivo_MTL=get_list_files(Carpeta_img,'*_MTL.txt');
archivoMTL=char(archivo_MTL);
N_MTL=length(archivoMTL);
COD_SAT_IMG=archivoMTL(1:N_MTL-8);
FilePath=char(strcat(Carpeta_img,'/',archivo_MTL));
%buscar 'SUN_ELEVATION'
%buscar 'DATE_HOUR_CONTACT_PERIOD'
if Landsat==7
%Para DN7
Nombres_Valores={'SUN_ELEVATION','DATE_HOUR_CONTACT_PERIOD'};
elseif Landsat==5
%Para DN5
Nombres_Valores={'SUN_ELEVATION','LANDSAT_SCENE_ID'};
end
[Valores,Nombres_Obtenidos,N_lin]=buscar_valor_archivo(Nombres_Valores, FilePath);
%N_lin es largo de cada linea extraida del archivo.
%fclose(FID);
%verificar que se encontraron todos los valores buscados
L1=length(Nombres_Valores);
L2=length(Nombres_Obtenidos);
min_l1l2=min([L1,L2]);
Log_MTL=['Logs/',Nombre_Proceso,'/log_mtl.txt'];
cd(BaseDir);
fid_mtl = fopen(Log_MTL,'a+');
Hora=fix(clock);
String_hora=[num2str(Hora(1)),'/',num2str(Hora(2)),'/',num2str(Hora(3)),' a las ',num2str(Hora(4)),':',num2str(Hora(5)),' hrs'];
if ~eq(L1,L2)
   fprintf (fid_mtl,strcat(String_hora,'. No se encuentra valor en @',char(FilePath),'\r\n'),'a+');
else
   fprintf (fid_mtl,strcat(String_hora,'. Todos los valores encontradoes en @',char(FilePath),'\r\n'),'a+');
end
fclose(fid_mtl);
%SUN ELEVATION
%Valores a numeros (deg --> rad)
%buscamos la posicion de Nombres_Valores que corresponde a SUN ELEVATION
Nombre_SE=Nombres_Valores(1);
indice=buscarindice(Nombre_SE,Nombres_Obtenidos);
SUN_elevation_deg=str2double(char(Valores(indice)));
SUN_elevation_rad=SUN_elevation_deg*pi/180;
%se consigue el día de la toma a partir del MTL 
%si es LT5
Nombre_Sc=Nombres_Valores(2);
indice=buscarindice(Nombre_Sc,Nombres_Obtenidos);
Scene=char(Valores(indice));
Ls=length(Scene);
dia=str2double(Scene(Ls-8:Ls-6)); 
distancia_ts=d(dia);% en unidadddes astronomicas
%se carga la imagen de banda4.
%buscar la que termina con _B4.txt
Busqueda=strcat('*_B',num2str(Banda),'.TIF');
archivo=get_list_files(Carpeta_img,Busqueda);
FilePath=char(strcat(Carpeta_img,'/',archivo));
INFO = geotiffinfo(FilePath);

if ~strcmp(CorteX,'') | ~strcmp(CorteY,'')
[IMc X R INFO]=corte_imagen(BaseDir,File,CorteX,CorteY);
else
[X, R] = geotiffread(FilePath);
end
%X es la matriz con valores 0 a 255 8bit, grayscale= 2 dim
%CMAP es el mapa de colores
%R es la referencia geoespacial
UTM.geokey=INFO.GeoTIFFTags.GeoKeyDirectoryTag;
UTM.tipo=INFO.Projection;
%pasa coordenadas a deg utm 19 N a deg
[x,y] = R.intrinsicToWorld(R.XLimIntrinsic,R.YLimIntrinsic);
i=1;
[lat(i,1),lon(i,1)] = projinv(INFO, x(i),y(i));
i=2;
[lat(i,1),lon(i,1)] = projinv(INFO, x(i),y(i));
 %las posiciones intrinsecas corresponden a X(1,1) y X(n,m)
UTM.lat_deg=lat;
UTM.lon_deg=lon;
%Chile zona norte UTM 19
Z_utm=19;
[UTM_X(1),UTM_Y(1)] = wgs2utm(lat(1),lon(1),Z_utm,Hemisferio);
[UTM_X(2),UTM_Y(2)] = wgs2utm(lat(2),lon(2),Z_utm,Hemisferio);
UTM.x=UTM_X;
UTM.y=UTM_Y;
%X es la matriz 0 255 DN5
[n,m]=size(X);
DN7=zeros(n,m);
L_l=zeros(n,m);
R_l=zeros(n,m);
for i=1:n
    for j=1:m
        if X(i,j)>0
            if Landsat==5
             %los valores de DN7
            DN7(i,j)=(Slope(Banda)*X(i,j))+Intercep(Banda);
            else
            DN7(i,j)=X(i,j);    
            end
            %la radianza es entonces
            L_l(i,j)=Gain_radiance(Banda)*DN7(i,j)+Bias_radiance(Banda);
            %la reflactancia es entonces:
            %R= (%pi L d^2) / (Esun sin(Omega_se))
            R_l(i,j)=(pi*L_l(i,j)*distancia_ts^2)/(Esun_l(Banda)*sin(SUN_elevation_rad));
            if R_l(i,j)<0
                R_l(i,j)=0;
            end

        end        
    end
end

%calculo indice de vegetacion NDVI: (B4-B3)/(B4+B3)

end