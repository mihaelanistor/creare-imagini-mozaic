function imgMozaic = adaugaPieseMozaicModAleator(params)

%imgMozaicVerificare este o matrice d dimensiunea pozei de referina
%redimensionata in care tin minte ce pixeli au fost acoperiti in imgMozaic 

[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);
imgMozaic = uint8(zeros(h,w,c));
imgMozaicExtinsa = uint8(zeros(h+H, w+W, c));
imgMozaicVerificare = uint8(zeros(h+H,w+W));

switch(params.criteriu)
    case 'aleator'
        if c == 1
            %aleator-aleator-AN
            %caz poza de referinta e alb negru
            
            pieseMozaicAlbNegru = uint8(zeros(H,W,1,N));
            
            for index = 1:N
                pieseMozaicAlbNegru(:,:,1,index) = rgb2gray(params.pieseMozaic(:,:,:,index));
            end
            
            %la fiecare 1000 de iteratii prin while recalculam numarul de
            %pixeli care au fost ocupati
            nrPixeliOcupati = 0;
            ok = 0;
            while(100*nrPixeliOcupati/(h*w) < 100)
                if ok == 0
                	[x,y] = find(imgMozaicVerificare(1:h,1:w) == 0);
                end
                ok = ok+1;
                    if(size(x,1) > 0)
                        pozitie = randi(size(x,1));
                        
                        i = x(pozitie);
                        j = y(pozitie);
                    end
                        
       
                if(imgMozaicVerificare(i,j) == 0)
                    
                    index = randi(N);
                
                    imgMozaicExtinsa( i:i+H-1, j:j+W-1,:) = pieseMozaicAlbNegru(:,:,1,index);
                    imgMozaicVerificare( i:i+H-1, j:j+W-1) = 1;
                end
                
                ok = ok +1;
                       %calculez cati pixeli au mai ramas o data la 1000 de iteratii
       %setez ok = 0 ca la urmatoarea iteratie sa se mai genereze o data
       %matricea de zerouri
                if ok > 999
                    ok = 0;
                    nrPixeliOcupati = 0;
                    for a=1:h
                        for b =1:w
                            if not(imgMozaicVerificare(a,b) == 0)
                                nrPixeliOcupati = nrPixeliOcupati +1;
                            end
                        end
                    end
                    fprintf("Mozaic ... %2.2f %%\n",100*nrPixeliOcupati/(h*w));
                end
            end
          %  end
            
        else
            %aleator-aleator-color
            %caz poza de referinta e color
            nrPixeliOcupati = 0;
            ok = 0;
            
            while(100*nrPixeliOcupati/(h*w) < 100)
                
                if ok == 0
                	[x,y] = find(imgMozaicVerificare(1:h,1:w) == 0);
                end
                ok = ok+1;
                    if(size(x,1) > 0)
                        pozitie = randi(size(x,1));
                        
                        i = x(pozitie);
                        j = y(pozitie);
                    end
                        
                
                if(imgMozaicVerificare(i,j) == 0)
                    %nicio piesa nu acopera pixelul(i,j) => punem piesa
               
                    index = randi(N); 
                
                    imgMozaicExtinsa( i:i+H-1, j:j+W-1,:) = params.pieseMozaic(:,:,:,index);
                    imgMozaicVerificare( i:i+H-1, j:j+W-1) = 1;
 
                end
                
                ok = ok +1;
                       %calculez cati pixeli au mai ramas o data la 1000 de iteratii
       %setez ok = 0 ca la urmatoarea iteratie sa se mai genereze o data
       %matricea de zerouri
                if ok > 999
                    ok = 0;
                    nrPixeliOcupati = 0;
                    for a=1:h
                        for b =1:w
                            if not(imgMozaicVerificare(a,b) == 0)
                                nrPixeliOcupati = nrPixeliOcupati +1;
                            end
                        end
                    end
                    fprintf("Mozaic ... %2.2f %%\n",100*nrPixeliOcupati/(h*w));

                 end
            end
            
        end
        
    case 'distantaCuloareMedie'
        if c == 1
            %aleator-medie-AN
            %caz poza de referinta e alb negru 
            pieseMozaicAlbNegru = uint8(zeros(H,W,1,N));
            
            for in = 1:N
                pieseMozaicAlbNegru(:,:,1,in) = rgb2gray(params.pieseMozaic(:,:,:,in));
            end
            
            mediiPieseAlbNegru = zeros(N);
            
            for idx = 1:N
                mediiPieseAlbNegru(idx) = mean2(pieseMozaicAlbNegru(:,:,1,idx));
            end
            
            ok = 0;
            nrPixeliOcupati = 0;
           
            while(100*nrPixeliOcupati/(h*w) < 100)
                if ok == 0
                	[x,y] = find(imgMozaicVerificare(1:h,1:w) == 0);
                end
                ok = ok+1;
                    if(size(x,1) > 0)
                        pozitie = randi(size(x,1));    
                        
                        i = x(pozitie);
                        j = y(pozitie);
                    end
                        
                        
                if(imgMozaicVerificare(i,j) == 0)
                    
                    %nicio piesa nu acopera pixelul(i,j) => punem piesa
                    
                    %calculam distanta minima pentru prima piesa si pixelul
                    %ales, apoi comparam cu urmatoarele distante si alegem
                    %minimul
                    
                    valPixelC1 = mean(params.imgReferintaRedimensionata(i,j,1));
                    diferentaMinima = abs(valPixelC1 - mediiPieseAlbNegru(1));
                    index = 1;
      
                    for iTemp = 2:N  
                        diferentaTemp = abs(valPixelC1 - mediiPieseAlbNegru(iTemp));
                        if abs(diferentaTemp) < abs(diferentaMinima)
                            diferentaMinima = diferentaTemp;
                            index = iTemp;
                        end
                    end
                    
                    imgMozaicExtinsa( i:i+H-1, j:j+W-1,1) = pieseMozaicAlbNegru(:,:,1,index);
                    imgMozaicVerificare( i:i+H-1, j:j+W-1) = 1;
                   
                end
                                        
                
                  %calculez cati pixeli au mai ramas o data la 1000 de iteratii
       %setez ok = 0 ca la urmatoarea iteratie sa se mai genereze o data
       %matricea de zerouri
                
                if ok > 999
                    ok = 0;
                    nrPixeliOcupati = 0;
                    for a=1:h
                        for b =1:w
                            if not(imgMozaicVerificare(a,b) == 0)
                                nrPixeliOcupati = nrPixeliOcupati +1;
                            end
                        end
                    end
                    fprintf("Mozaic ... %2.2f %%\n",100*nrPixeliOcupati/(h*w));
                 end
            end
        else
            %caz poza de referinta e color
            %aleator-medie-color
         
            mediiPiese = zeros(3,N);
            for j = 1:N
                for i = 1:c
                    mediiPiese(i,j) = mean2(params.pieseMozaic(:,:,i,j));       
                end
            end
            
            nrPixeliOcupati = 0;
            %calculam cat la suta din mozaic e complet dupa fiecare 100 de
            %pixeli colorati, pe care ii tinem minte in ok
            ok = 0;
            while(100*nrPixeliOcupati/(h*w) < 100)
                
                if ok == 0
                	[x,y] = find(imgMozaicVerificare(1:h,1:w) == 0);
                end
                ok = ok+1;
                    if(size(x,1) > 0)
                        pozitie = randi(size(x,1));

                        i = x(pozitie);
                        j = y(pozitie);
                    end
                        
                
                if(imgMozaicVerificare(i,j) == 0)
                    %nicio piesa nu acopera pixelul(i,j) => punem piesa
                    valPixelC1 = mean(params.imgReferintaRedimensionata(i,j,1));
                    valPixelC2 = mean(params.imgReferintaRedimensionata(i,j,2));
                    valPixelC3 = mean(params.imgReferintaRedimensionata(i,j,3));
    
                    diferentaMinima = (valPixelC1 - mediiPiese(1,1))^2+...
                    (valPixelC2 - mediiPiese(2,1))^2 +(valPixelC3 - mediiPiese(3,1))^2;
                    diferentaMinima = sqrt(double(diferentaMinima));
                    index = 1;
      
                    for iTemp = 2:N
                    
                        diferentaTemp = sqrt(double((valPixelC1 - mediiPiese(1,iTemp))^2+...
                            (valPixelC2 - mediiPiese(2,iTemp))^2+(valPixelC3 - mediiPiese(3,iTemp))^2));
             
                        if diferentaTemp < diferentaMinima
                            diferentaMinima = diferentaTemp;
                            index = iTemp;
                        end
                    end
                    
                    imgMozaicExtinsa( i:i+H-1, j:j+W-1,:) = params.pieseMozaic(:,:,:,index);
                    imgMozaicVerificare( i:i+H-1, j:j+W-1) = 1;
                end
                ok = ok +1;
       %calculez cati pixeli au mai ramas o data la 1000 de iteratii
       %setez ok = 0 ca la urmatoarea iteratie sa se mai genereze o data
       %matricea de zerouri
                if ok > 999
                    ok = 0;
                    nrPixeliOcupati = 0;
                    for a=1:h
                        for b =1:w
                            if not(imgMozaicVerificare(a,b,1) == 0)
                                nrPixeliOcupati = nrPixeliOcupati +1;
                            end
                        end
                    end
                    fprintf('Mozaic ... %2.2f%% \n',100*nrPixeliOcupati/(h*w));
                end
                   
            end

        end
    otherwise
        printf('EROARE, optiune necunoscuta \n');         
end
        
 imgMozaic = imgMozaicExtinsa(1:h,1:w,:);
