%[nietos_Path directorios]=listar_nietos_directorio(Directorio_Padre,Nivel)
%Directorio_Padre: entrada string que es el directorio a partir del cual se
%hace el analisis de archivos dnetro de este.
%Nivel es un índice para nombrar los archivos
function [nietos_Path directorios]=listar_nietos_directorio(Directorio_Padre,Nivel,BaseDir)
cd(Directorio_Padre);
cd('..')
Log='Logs';
%Hijo es el numero de Directorio Hijo 
cd(Directorio_Padre);
DirectorioInicial=Directorio_Padre;
Hijo=1;
%se analiza directorio padre, entregando las rutas de archivos de texto con
%lista completa y directoios, listado de directorios, numeros de filas en
%que se encuentra cada directorio en archivo de lista completa
[lista_archivos{Hijo,1} lista_directorios{Hijo,1} lin_dir n_linea_dir]=listar_directorio(Directorio_Padre,BaseDir,Hijo,Nivel,Log);
%lista_archivos es el txt que tiene la lista de todos los archivos en lista
%dentro del directorio actual
%lista_directorios es el txt que tiene la lista de todos los directorios
%hijos del actual
%poner un while (mientras) lar
%leemos lista_directorios
%lista_archivos entrega ruta de la lista de archivos obtenidas mediantes ls
%lista_directorios entrega la ruta de la lista d edirectorios
%lin_dir entrega una lista de pares de datos, nro file y fila
%n_linea_dir entrega los nros de fila en que se encuentra cada directorio
%en lista_archivos
Dir_char='/';
FID_D=fopen(lista_directorios{Hijo,1},'r');
%%guardar lista de archivos en directorio padre.    
txt_lista_NA=strcat(BaseDir,'/',Log,'/','archivos_total.txt');
D=1;        
W=0;
Q=1;
%mientras se lea línea a línea archivo Directorios 'D'
        %abre la lista de archivos que es un directorio a un archivo txt
        FID_A=fopen(lista_archivos{Hijo,1},'r');
        %mientras A
        %variable a, indice de linea en archivo A        
        %se inicializa contadore de lineas para ARchivo A
        nuevo_a=1;
        while ~feof(FID_A)
                    %obtiene linea de A
                    leer_linea_A=fgetl(FID_A);
                    %obtiene largo e liena A
                    N_A=length(leer_linea_A);
                    %copia la linea en patron para buscar los espacios
                    %caracter
                    patron=leer_linea_A;
                    str=' ';
                    k_str=strfind(patron,str);
                    if length(k_str)>=1
                    k_espacio=k_str(length(k_str));
                    else
                    k_espacio=0;
                    end
                    Archivo_Hijo=leer_linea_A(k_espacio+1:N_A);
                    %SI Existe una carpeta hija dentro del directorio,

        %se obtienen los valores de línea actual y siguiente directorio
        %siempre k es mayor que m ya que corresponde a una linea posterior
        %en lista_archivos
       length(n_linea_dir);
       n_linea_dir;
                    if Q<=length(n_linea_dir)
                    m=n_linea_dir(Q);%linea de primer directorio
                     %linea de siguiente directorio
                    if length(n_linea_dir)<=1;
                      k=3
                    else
                      k=n_linea_dir(Q+1);
                    end    
                    end
        %leer lista de archivos con ayuda de archivo de directorios,
        %entregando un analisis de los directorios hijos: lista de archivos
        %y directorios dentro de directorios hijo; en conjunto con una
        %lista de archivos hijos del directorio.
                    Directorio=lin_dir{Q}
                    %analizar:                    
                   if (m+4<=nuevo_a) &&(nuevo_a<=k-2) && W>=n_linea_dir(1)-2 && ~strcmp('fin de linea (+1)',Directorio)
                       %&linealeida=leer_linea_A(N_A)
%                        NUEVOA=nuevo_a
%                        M=m
%                        K=k
                        %sumamos 1 al indice de pares de directorio
%PARA DIRECTORIOS HIJOS NO OCULTOS
                        if strcmp(Dir_char,char(leer_linea_A(N_A))) && ~strcmp('./',char(leer_linea_A(N_A-1:N_A)))                     
                            %si existe un directorio al interior hay un nuevo
                        Directorio_Padre=Directorio;
                        Nuevo_Directorio=leer_linea_A(k_espacio+1:N_A-1);
                        Directorio_Hijo=[Directorio_Padre,Dir_char,Nuevo_Directorio];
                        Hijo=Hijo+1;
                        %ejecutar ls sobre nuevo directorio y listar
                        %archivos y carpetas
                        %entregando los strings
                        [lista_archivos{Hijo,1} lista_directorios{Hijo,1} lin_dir_nieto{Hijo,1} n_linea_dir_nieto{Hijo,1}]=listar_directorio(Directorio_Hijo,BaseDir,Hijo,Nivel,Log);
%PARA ARCHIVOS DENTRO DE DIRECTORIO HIJO NO OCULTOS
                        elseif ~strcmp(Dir_char,char(leer_linea_A(N_A-1:N_A))) && ~strcmp('.',char(leer_linea_A(k_espacio+1)))
                         %listar los archivos hijos del directorio hijo
                        Directorio_Padre=strcat(Directorio)    
                        %guardar archivos txt con nombre nuevo 
                        Nuevo_Archivo{nuevo_a,1}=[Directorio,Dir_char,leer_linea_A(k_espacio+1:N_A),'\n'];  
                        fid=fopen(txt_lista_NA,'a+');%crear o abrir archivo lista.txt agregando al final de lista
                        %actualizando lista de archivos en directorio
                        fprintf(fid,Nuevo_Archivo{nuevo_a,1});
                        fclose(fid);
                        %cerrar ListaArchivo
                        end
                    %Si existen archivos dentro el directorio, quedan
                    %listados desde la primera linea hasta la linea 'm' de
                    %lista_archivos, leer desde 1 a m-2.
%PARA ARCHIVOS DENTRO DE DIRECTORIO PADRE                    
                   elseif n_linea_dir(2)>1 && nuevo_a<n_linea_dir(2)-1  && W<n_linea_dir(2)-2
                       W=1+W;
                        %guardar archivos txt con nombre nuevo 
                        Blabla=Directorio;
                        Archivo=leer_linea_A(k_espacio+1:N_A);
                        Nuevo_Archivo{nuevo_a,1}=[Directorio,Dir_char,leer_linea_A(k_espacio+1:N_A),'\n'];
                        fid=fopen(txt_lista_NA,'a+');%crear o abrir archivo lista.txt agregando al final de lista
                        %actualizando lista de archivos en directorio
                        fprintf(fid,Nuevo_Archivo{nuevo_a,1});
                        fclose(fid);
                        %cerrar ListaArchivo
                    end
            nuevo_a=1+nuevo_a;
%cambiar Q
        if nuevo_a==k
            Q=Q+1;
        end

            %end mientras a
        end       
        fclose(FID_A);
        %pasa  anueva linea de archivo de directorios
%end mientras D


directorios=lista_directorios;
nietos_Path=lista_archivos;
end
