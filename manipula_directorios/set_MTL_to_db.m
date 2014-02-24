
cd('/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat/DesAtacama/Imagenes/233_076');
BaseProject=pwd;
%buscar UL y LR en cada MTL de las imagenes de la zona
MTL_name='LANDSAT_SCENE_ID';
%se declaran los string a buscar
UL_x='CORNER_UL_PROJECTION_X_PRODUCT';
UL_y='CORNER_UL_PROJECTION_Y_PRODUCT';
LR_x='CORNER_LR_PROJECTION_X_PRODUCT';
LR_y='CORNER_LR_PROJECTION_Y_PRODUCT';
%tomar archivo MTL de proyecto
Directorio='DesAtacama';
archivos_MTL=['archivos_MTL_' Directorio '.txt'];
%pasar a basedatos NOMBRE imagen, buscar los UL LR y guardarlos en db
BaseLog='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat/Logs';
FID_MTL=fopen([BaseLog,'/',archivos_MTL],'r');
str='=';
i=0;
UTM_MTL_x=[];
UTM_MTL_y=[];
FILE_name={};
while ~feof(FID_MTL)
i=1+i;
MTL_lin=fgetl(FID_MTL);
FILE_name{i}=[BaseProject MTL_lin(2:length(MTL_lin))];
fid=fopen(MTL_lin,'r');
while ~feof(fid)
lin=fgetl(fid);
%leer archivo de cada línea MTL
%buscar '='
patron=lin;
k_str=strfind(patron,str);
n= length(k_str);
if n>=1
%nombre y valor:
UTM_name=lin(5:k_str(n)-2);
UTM_val=lin(k_str(length(k_str))+2:length(lin));
%comparar por caso
switch UTM_name
    case UL_x
        UTM_MTL_x(i,1)=str2double(UTM_val);
    case UL_y
        UTM_MTL_y(i,1)=str2double(UTM_val);
    case LR_x
        UTM_MTL_x(i,2)=str2double(UTM_val);        
    case LR_y
        UTM_MTL_y(i,2)=str2double(UTM_val);      
end%switch
end
end%while
fclose(fid);
end
fclose(FID_MTL);