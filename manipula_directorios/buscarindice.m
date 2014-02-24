function indice=buscarindice(nombre,lista)
L1=length(lista);

for i=1:L1
    Buscado=char(nombre);
    Obtenido=char(lista(i));
    L_b=length(Buscado);
    L_o=length(Obtenido);
    if L_b==L_o
    if eq(Buscado,Obtenido)        
       indice=i;
    else
       indice=[];
    end
    end
end

end