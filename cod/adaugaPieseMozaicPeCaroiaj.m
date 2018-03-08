function imgMozaic = adaugaPieseMozaicPeCaroiaj(params)
%
%tratati si cazul in care imaginea de referinta este gri (are numai un canal)


imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);

switch(params.criteriu)
    case 'aleator'
        %caz poza de referinta alb negru
        if c == 1
            pieseMozaicAlbNegru = uint8(zeros(H,W,1,N));
            for index = 1:N
                pieseMozaicAlbNegru(:,:,:,index) = rgb2gray(params.pieseMozaic(:,:,:,index));
            end
        %pune o piese aleatoare in mozaic, nu tine cont de nimic
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %alege un indice aleator din cele N
                indice = randi(N);    
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indice);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
        %caaz poza de referinta color
        else
            
        %pune o piese aleatoare in mozaic, nu tine cont de nimic
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %alege un indice aleator din cele N
                indice = randi(N);    
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indice);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        end
        
    case 'distantaCuloareMedie'
      
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        
        if c == 1
            pieseMozaicAlbNegru = uint8(zeros(H,W,1,N));
            for index = 1:N
                pieseMozaicAlbNegru(:,:,:,index) = rgb2gray(params.pieseMozaic(:,:,:,index));
            end
            
            mediiPieseAlbNegru = zeros(N);
           
            for a=1:N
                mediiPieseAlbNegru(a) = mean2(pieseMozaicAlbNegru(:,:,1,a));
            end
            
            for i = 1:params.numarPieseMozaicVerticala
                for j=1:params.numarPieseMozaicOrizontala
                    %calculez media pt fiecare portiune de poza egala cu
                    %dimensiunea unei poze din colectie
                
                    medieImgReferinta = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,1));
                
                    diferentaMinima = abs(medieImgReferinta - mediiPieseAlbNegru(1));
                    indicePozaPotrivita = 1;

                    for a = 2:N
                        difTemp = abs(medieImgReferinta - mediiPieseAlbNegru(a));
                    
                        if difTemp < diferentaMinima
                            diferentaMinima = difTemp;
                            indicePozaPotrivita = a;
                        end

                    end
                    
                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita);
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                end
            end 
                
        else
        %caz caroiaj-medie-color
        %retin intr-un vector mediile pieselor
        

        
        mediiPiese = zeros(c,N);
     
        for y = 1:N
            for x = 1:c
                mediiPiese(x,y) = mean2(params.pieseMozaic(:,:,x,y));
            end
        end
        
        for i = 1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %calculez media pt fiecare portiune de poza egala cu
                %dimensiunea unei poze din colectie
              
                medieImgReferintaC1 = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,1));
                medieImgReferintaC2 = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,2));
                medieImgReferintaC3 = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,3));
                %diferenta minima o initializez cu suma diferentelor pe
                %fiecare canal dintre poza de referinta si prima poza din
                %colectie
                
                indicePozaPotrivita = 1;
                diferentaMinima = (medieImgReferintaC1 - mediiPiese(1,1))^2+...
                (medieImgReferintaC2 - mediiPiese(2,1))^2 + (medieImgReferintaC3 - mediiPiese(3,1))^2;
                diferentaMinima = sqrt(diferentaMinima);
                
                for a = 2:N
                    %caut diferenta minima
                    difTemp = sqrt((medieImgReferintaC1 - mediiPiese(1,a))^2+...
                    (medieImgReferintaC2 - mediiPiese(2,a))^2 + (medieImgReferintaC3 - mediiPiese(3,a))^2);
               
                    if abs(difTemp) < abs(diferentaMinima)
                        diferentaMinima = difTemp;
                        indicePozaPotrivita = a;
                    end
                end 
                
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                    
                
            end
        end

        end
        
        %distantaCuloareMedie2 in plus fata de distantaCuloareMedie
        %verifica sa nu fie aceeasi piesa de doua ori una langa alta
    case 'distantaCuloareMedie2'
        
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        %in ordinePoze ti(i,j)n minte pozitia piesei pusa in pozitia
        %((i-1)*H+1,(j-1)*W+1)
        ordinePoze = zeros(uint8(params.numarPieseMozaicVerticala), uint8(params.numarPieseMozaicOrizontala));
        
        if c == 1
            pieseMozaicAlbNegru = uint8(zeros(H,W,1,N));
            for index = 1:N
                pieseMozaicAlbNegru(:,:,:,index) = rgb2gray(params.pieseMozaic(:,:,:,index));
            end
            
            mediiPieseAlbNegru = zeros(N);
           
            for a=1:N
                mediiPieseAlbNegru(a) = mean2(pieseMozaicAlbNegru(:,:,1,a));
            end
       
            for i = 1:params.numarPieseMozaicVerticala
                for j=1:params.numarPieseMozaicOrizontala
                    %calculez media pt fiecare portiune de poza egala cu
                    %dimensiunea unei poze din colectie
                
                    indicePozaPotrivita = 1;
                    indicePozaPotrivita2 = 2;
                    indicePozaPotrivita3 = 3;
                
                    medieImgReferinta = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,1));
                    diferentaMinima = abs(medieImgReferinta - mediiPieseAlbNegru(1));
                    diferentaMinima2 = abs(medieImgReferinta - mediiPieseAlbNegru(2));
                    diferentaMinima3 = abs(medieImgReferinta - mediiPieseAlbNegru(3));
                
                    for a = 4:N
                        difTemp = abs(medieImgReferinta - mediiPieseAlbNegru(a));
            
                        if difTemp< diferentaMinima
                            diferentaMinima3 = diferentaMinima2;
                            indicePozaPotrivita3 = indicePozaPotrivita2;
                        
                            diferentaMinima2 = diferentaMinima;
                            indicePozaPotrivita2 = indicePozaPotrivita;
                        
                            diferentaMinima = difTemp;
                            indicePozaPotrivita = a;
                        else
                            if difTemp< diferentaMinima2
                                diferentaMinima3 = diferentaMinima2;
                                indicePozaPotrivita3 = indicePozaPotrivita2;
                            
                                diferentaMinima2 = difTemp;
                                indicePozaPotrivita2 = a;
                            else
                                if difTemp < diferentaMinima3
                                    diferentaMinima3 = difTemp;
                                    indicePozaPotrivita3 = a;
                   
                                end
                            end
                        end
                    end

                    %verific pt fiecare piesa ce nu e pe prima linie sau
                    %coloana doi vecini: cel de sus si cel din stanga pt ca
                    %ceilalti nu sunt inca pusi in mozaic
                    
                    %daca poza cea mai potrivita se afla printre vecini, o
                    %verific pe a2a cea mai buna, iar daca se afla si ea
                    %printre vecini o pun pe a3a
                  
                    %caut piesa cea mai potrivita la stanga si sus
                    if not(i == 1)&& not(ordinePoze(i-1,j) == indicePozaPotrivita) && not(j == 1) && not(ordinePoze(i,j-1) == indicePozaPotrivita)
                        imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita);
                        nrPieseAdaugate = nrPieseAdaugate+1;
                        fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                        ordinePoze(i,j) = indicePozaPotrivita;   
                    else
                        %caut a2a piesa dupa cea mai potrivita la stanga si
                        %sus
                        if not(i == 1)&& not(ordinePoze(i-1,j) == indicePozaPotrivita2) && not(j == 1) && not(ordinePoze(i,j-1) == indicePozaPotrivita2)
                            imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita2);
                            nrPieseAdaugate = nrPieseAdaugate+1;
                            fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                            ordinePoze(i,j) = indicePozaPotrivita2; 
                         %piesa a3a
                        else
                            if not(i == 1)&& not(ordinePoze(i-1,j) == indicePozaPotrivita3) && not(j == 1) && not(ordinePoze(i,j-1) == indicePozaPotrivita3)
                                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita3);
                                nrPieseAdaugate = nrPieseAdaugate+1;
                                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                ordinePoze(i,j) = indicePozaPotrivita3;
                            else
                                %prima linie => caut doar la stanga
                                if i == 1 && not(j==1) && not(ordinePoze(i, j-1) == indicePozaPotrivita)
                                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita);
                                    nrPieseAdaugate = nrPieseAdaugate+1;
                                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                    ordinePoze(i,j) = indicePozaPotrivita;
                                else
                                    if i == 1 && not(j==1) && not(ordinePoze(i, j-1) == indicePozaPotrivita2)
                                        imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita2);
                                        nrPieseAdaugate = nrPieseAdaugate+1;
                                        fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                        ordinePoze(i,j) = indicePozaPotrivita2;
                                    else
                                        if j == 1 && not(i==1) && not(ordinePoze(i-1, j) == indicePozaPotrivita)
                                            imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita);
                                            nrPieseAdaugate = nrPieseAdaugate+1;
                                            fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                            ordinePoze(i,j) = indicePozaPotrivita;
                                        else
                                            %prima coloana=> caut doar sus
                                            if j == 1 && not(i==1) && not(ordinePoze(i-1, j) == indicePozaPotrivita2)
                                                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita2);
                                                nrPieseAdaugate = nrPieseAdaugate+1;
                                                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                                ordinePoze(i,j) = indicePozaPotrivita2;
                                            else
                                                %prima linie, prima
                                                %coloana => nu verific
                                                %vecinii
                                                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = pieseMozaicAlbNegru(:,:,:,indicePozaPotrivita);
                                                nrPieseAdaugate = nrPieseAdaugate+1;
                                                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                                ordinePoze(i,j) = indicePozaPotrivita;
                                            end
                                        end
                                    end
                                end                  
                            end
                        end
                    end
                end
            end 
                
        else
            %caz caroiaj medie2 color
            mediiPiese = zeros(C,N);
            for x = 1:C
                for y = 1:N
                    mediiPiese(x,y) = mean2(params.pieseMozaic(:,:,x,y));
                end
            end
        
            for i = 1:params.numarPieseMozaicVerticala
                for j=1:params.numarPieseMozaicOrizontala
                    %calculez media pt fiecare portiune de poza egala cu
                    %dimensiunea unei poze din colectie
                
                    indicePozaPotrivita = 1;
                    indicePozaPotrivita2 = 2;
                    indicePozaPotrivita3 = 3;
                
                    medieImgReferintaC1 = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,1));
                    medieImgReferintaC2 = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,2));
                    medieImgReferintaC3 = mean2( params.imgReferintaRedimensionata( (i-1)*H+1:i*H,(j-1)*W+1:j*W ,3));
                    %diferenta minima o initializez cu distanta euclidiana dintre
                    %poza de referinta si prima poza din colectie
                    diferentaMinima = (medieImgReferintaC1 - mediiPiese(1,1))^2+...
                    (medieImgReferintaC2 - mediiPiese(2,1))^2 + ...
                    (medieImgReferintaC3 - mediiPiese(3,1))^2;
                    diferentaMinima = sqrt(diferentaMinima);

                    diferentaMinima2 = (medieImgReferintaC1 - mediiPiese(1,2))^2 + ...
                    (medieImgReferintaC2 - mediiPiese(2,2))^2 +...
                    (medieImgReferintaC3 - mediiPiese(3,2))^2;
                    diferentaMinima2 = sqrt(diferentaMinima2);

                    diferentaMinima3 = (medieImgReferintaC1 - mediiPiese(1,3))^2 + ...
                    (medieImgReferintaC2 - mediiPiese(2,3))^2+...
                    (medieImgReferintaC3 - mediiPiese(3,3))^2;
                    diferentaMinima3 = sqrt(diferentaMinima3);
                
                    for a = 4:N
                        %caut diferenta minima
                    
                        difTemp = (medieImgReferintaC1 - mediiPiese(1,a))^2 + ...
                        (medieImgReferintaC2 - mediiPiese(2,a))^2+ ...
                        (medieImgReferintaC3 - mediiPiese(3,a))^2;
                        difTemp = sqrt(difTemp);
                    
                        if abs(difTemp) < abs(diferentaMinima)
                            diferentaMinima3 = diferentaMinima2;
                            indicePozaPotrivita3 = indicePozaPotrivita2;
                        
                            diferentaMinima2 = diferentaMinima;
                            indicePozaPotrivita2 = indicePozaPotrivita;
                        
                            diferentaMinima = difTemp;
                            indicePozaPotrivita = a;
                        else
                            if abs(difTemp) < abs(diferentaMinima2)
                                diferentaMinima3 = diferentaMinima2;
                                indicePozaPotrivita3 = indicePozaPotrivita2;
                            
                                diferentaMinima2 = difTemp;
                                indicePozaPotrivita2 = a;
                            else
                                if abs(difTemp) < abs(diferentaMinima3)
                                    diferentaMinima3 = difTemp;
                                    indicePozaPotrivita3 = a;
                   
                                end
                            end
                        end
                    end
                    
                    if not(i == 1)&& not(ordinePoze(i-1,j) == indicePozaPotrivita) && not(j == 1) && not(ordinePoze(i,j-1) == indicePozaPotrivita)
                        imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita);
                        nrPieseAdaugate = nrPieseAdaugate+1;
                        fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                        ordinePoze(i,j) = indicePozaPotrivita;   
                    else
                        if not(i == 1)&& not(ordinePoze(i-1,j) == indicePozaPotrivita2) && not(j == 1) && not(ordinePoze(i,j-1) == indicePozaPotrivita2)
                        imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita2);
                        nrPieseAdaugate = nrPieseAdaugate+1;
                        fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                        ordinePoze(i,j) = indicePozaPotrivita2; 
                        else
                            if not(i == 1)&& not(ordinePoze(i-1,j) == indicePozaPotrivita3) && not(j == 1) && not(ordinePoze(i,j-1) == indicePozaPotrivita3)
                                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita3);
                                nrPieseAdaugate = nrPieseAdaugate+1;
                                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                ordinePoze(i,j) = indicePozaPotrivita3;
                            else
                                if i == 1 && not(j==1) && not(ordinePoze(i, j-1) == indicePozaPotrivita)
                                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita);
                                    nrPieseAdaugate = nrPieseAdaugate+1;
                                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                    ordinePoze(i,j) = indicePozaPotrivita;
                
                                else
                                    if i == 1 && not(j==1) && not(ordinePoze(i, j-1) == indicePozaPotrivita2)
                                        imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita2);
                                        nrPieseAdaugate = nrPieseAdaugate+1;
                                        fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                        ordinePoze(i,j) = indicePozaPotrivita2;
                                    else
                                        if j == 1 && not(i==1) && not(ordinePoze(i-1, j) == indicePozaPotrivita)
                                        imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita);
                                        nrPieseAdaugate = nrPieseAdaugate+1;
                                        fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                        ordinePoze(i,j) = indicePozaPotrivita;
                                        else
                                            if j == 1 && not(i==1) && not(ordinePoze(i-1, j) == indicePozaPotrivita2)
                                                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita2);
                                                nrPieseAdaugate = nrPieseAdaugate+1;
                                                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                                ordinePoze(i,j) = indicePozaPotrivita2;
                                            else
                                                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indicePozaPotrivita);
                                                nrPieseAdaugate = nrPieseAdaugate+1;
                                                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                                                ordinePoze(i,j) = indicePozaPotrivita;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
    otherwise
        fprintf('EROARE, optiune necunoscuta \n');
    
end
    
    
    
    
    
