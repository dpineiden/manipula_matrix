function [G_ndvi]=grilla_div_matrix(M, n, d)
 %M Matriz de Imágen de algún índice en especial
 %n cantidad de pixeles a considerar en cada analisis
 %d distancia por cada lado que representa un pixel.
  [filas, columnas] = size(M);
 REM_filas = rem(filas, n);
 REM_columnas = rem(columnas, n);
 ns = 0;
 eo = 0;
 total_A=0;
 filas_G=0;
 columnas_G=0;
 
 if REM_filas < filas && REM_columnas < columnas
     
 filas_G =[n:2*n:filas-REM_filas];
 columnas_G =[n:2*n:columnas-REM_columnas];
 
 gp = length(filas_G);
 gq = length(columnas_G);
 
 final_fila = filas - filas_G(gp);
 final_columna = columnas - columnas_G(gq);
 
 paso_grilla_fila = n;
 paso_grilla_columna = n;
 

 %en caso de tener un sobrante que no calce en la matriz original
 %se debe hacer un calculo que considera adicionalmente ese espacio
 %solo si valor en ese punto es mayor a cero.
 for i=filas_G(1):gp %for1
     for j=columnas_G(1):gq %for2 
       if M(filas_G(i),columnas_G(j))>0
         for cuadrante=1:4 %for3             
             %pasa a darle valores para extraer matriz  
             switch cuadrante
                 case 1 
                     caso=1
                    step=[-1 -1];
                    Np= i - (step(1) + paso_grilla_fila)
                    Mq= j - (step(2) + paso_grilla_columna)
                 case 2 
                                          caso=2
                    step=[-1 1];                 
                    Np= i - (step(1) + paso_grilla_fila)
                    %revisa cuando esté terminando la fila o la columna
                    if final_fila > 0 && i == filas_G(gp)
                    paso_grilla_fila = final_fila;
                    end 
                    if final_columna > 0 && j == columnas_G(gp)
                    paso_grilla_columna = final_columna;
                    end    
                    
                    Mq= j + (step(2) - paso_grilla_columna)
                 case 3 
                                          caso=3
                    step=[1 -1];                 
                    Np= i + (step(1) - paso_grilla_fila)

                    %revisa cuando esté terminando la fila o la columna
                    if final_fila > 0 && i == filas_G(gp)
                    paso_grilla_fila = final_fila;
                    end 
                    if final_columna > 0 && j == columnas_G(gp)
                    paso_grilla_columna = final_columna;
                    end    
                    Mq= j - (step(2) + paso_grilla_columna)

                 case 4 
                                          caso=4
                    step=[1 1];             
                    Np= i + (step(1) - paso_grilla_fila)

                    %revisa cuando esté terminando la fila o la columna
                    if final_fila > 0 && i == filas_G(gp)
                    paso_grilla_fila = final_fila;
                    end 
                    if final_columna > 0 && j == columnas_G(gp)
                    paso_grilla_columna = final_columna;
                    end    

                    Mq= j + (step(2) - paso_grilla_columna)
             end

             %se procede a recortar la matriz mayor
             i           
             j
             
             step
             
             lugar_fila=[i:step(1):Np]
             lugar_col=[j:step(2):Mq]
             A = M(lugar_fila,lugar_col)
             %se suman sus valores      
             Total_A = sum(A(:));
             %se obtiene el área que cubre la matriz.
              [na,nb]= size(A);
              ns=na*d;
              eo=nb*d;
             Area_A = ns*eo;
             %se obtiene la densidad del valor en cuadrante.
             G_ndvi(i+step(1),j+step(2))=Total_A/Area_A            
         end %for3 
         %se retoma el valor de n en paso
         paso_grilla_fila = n;
         paso_grilla_columna = n;
 
 else     
     msgbox('No se puede realizar la operación, revisa los valores de n, d o la matriz M')
 end
     end %for2 
 end%for1
end