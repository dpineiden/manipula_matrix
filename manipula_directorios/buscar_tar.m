BaseDir='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat';
Directorio='DesAtacama';
DirectorioFin='DesAtacama/Imagenes';
Dir_tar='Imagenes/Comp';
Directorio_Padre=[BaseDir,'/',Directorio,'/',Dir_tar];
cd(Directorio_Padre);
[A lista]=unix(['find -name *.tar.gz']);
%guardar lista en archivos
archivos_targz='archivos_targz.txt';
RutaLog=[BaseDir,'/Logs'];
FID=fopen([RutaLog,'/',archivos_targz],'w+');
fprintf(FID,lista);
fclose(FID);
%leer cada linea  descomprimir en img_Proyecto
%se abre archivo para leer
NewDir=DirectorioFin;
unix(['mkdir ',BaseDir,'/',NewDir]);
fid=fopen([RutaLog,'/',archivos_targz],'r');
while ~feof(fid)
    leer_linea=fgetl(FID); 
    indice=1;
    nombre=desmembrar(leer_linea,'/');
    [a b]=size(nombre);
    for j=1:a
        if strcmp(nombre{j,1},Directorio)
            indice=j;
        end
    end
    cd([BaseDir,'/',DirectorioFin]);
    for j=indice+1:a-1        
        unix(['mkdir ',nombre{j,1}]);
        cd(nombre{j,1});
    end
        nombre_toma=nombre{a,1};
        unix(['mkdir ',nombre_toma(1:length(nombre_toma)-7)]);
        cd(nombre_toma(1:length(nombre_toma)-7));
    %se han creado las carpetas
    line_tar=[BaseDir,'/',Directorio,'/',Dir_tar,leer_linea(2:length(leer_linea))];
    %se descomprime aqui el archivo (dentro de carpeta)
    unix(['tar -xf ',line_tar]); 
    unix(['rm ',line_tar]);
end
fclose(fid);