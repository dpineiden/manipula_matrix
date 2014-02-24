
function [IMc, X ,R , INFO]=corte_imagen(BaseDir,File,UTM_x,UTM_y)
[X, R] = geotiffread(File);
%cortar seccion definida
cd(BaseDir);
mkdir('Cortes_Imagenes');
cd('Cortes_Imagenes')
ruta_actual=pwd;
INFO = geotiffinfo(File);
UTM.geokey=INFO.GeoTIFFTags.GeoKeyDirectoryTag;
UTM.tipo=INFO.Projection;
[n,m]=size(X)
%pasa coordenadas a deg utm 19 N a deg
[x,y] = R.intrinsicToWorld(R.XLimIntrinsic,R.YLimIntrinsic)
%lognitud pixel largo-ancho [m]
largo_pixel= INFO.GeoTIFFTags.ModelPixelScaleTag(1);
p=largo_pixel; %en metros
%entregar los dos puntos limite del corte
%X_a__dx_1___
%   dy_1
%     |     X_1.................
%            .                  .  
%            .                  .
%            .                  .
%            .                  .
%            .                  .
%            .                  .
%            .                  .
%            .                  .
%..............................X_2______________
%                                             dy_2  
%                                               |
%                                ____________dx_2______X_b

%valores en coordenads de imagen tiff
X_1=UTM_x;
X_2=UTM_y;

left=round(abs(x(1)-floor(X_1(1)/p)*p)/p)
right=round(abs(x(1)-ceil(X_1(2)/p)*p)/p)
upper=round(abs(y(1)-floor(X_2(1)/p)*p)/p)
lower=round(abs(y(1)-ceil(X_2(2)/p)*p)/p)
% 
% [left_long, upper_lat] = projfwd(INFO, X_1(2), X_1(1))
% [right_long, lower_lat] = projfwd(INFO, X_2(2), X_2(1))
% 
% [left_d, upper_d] = R.worldToIntrinsic(left_long, upper_lat);
% left = round(abs(int64(left_d))/30);
% upper = round(abs(int64(upper_d))/30);
% [right_d, lower_d] = R.worldToIntrinsic(right_long, lower_lat);
% right = round(abs(int64(right_d))/30);
% lower = round(abs(int64(lower_d))/30);
IMc = X(  min(upper,lower):max(upper,lower), min(left,right):max(left,right)  );


end