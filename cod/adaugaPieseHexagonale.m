function imgMozaic = adaugaPieseHexagonale(params)

    [H,W,C,N] = size(params.pieseMozaic);
    [hImgRef,wImgRef,c] = size(params.imgReferintaRedimensionata);
    h = 28;
    w = 40;
    
    imgMozaicExtinsa = uint8(zeros((h+1)*round(params.numarPieseMozaicVerticala),(w+1)*round(params.numarPieseMozaicOrizontala),c));
    imgMozaic = uint8(zeros(h*round(params.numarPieseMozaicVerticala),w*round(params.numarPieseMozaicOrizontala),c));
    imgReferintaReRedim = imresize(params.imgReferintaRedimensionata,[(h+1)*round(params.numarPieseMozaicVerticala),(w+1)*round(params.numarPieseMozaicOrizontala)],'nearest');
    
    pieseMozaicRedim = uint8(zeros(h,w,C,N));
    pieseMozaicRedimAN = uint8(zeros(h,w,1,N));
    

    
    mediiPiese = zeros(c,N);
    mediiPieseAN = zeros(1,N);

    %creare forma de hexagon
    
    hexagon = uint8(ones(h,w,c));
    %sus
    for i = 1:round(h/2)-1
            %stanga
            for j = 1: round(w/3) - i+1
                hexagon(i,j,:) = 0;
            end
            %dreapta
            for j = round(2*w/3)  +i : w 
                hexagon(i,j,:) = 0;
            end
    end
    %jos
    for i = round(h/2)  :h     
         %stanga
         for j = 1: round(w/3)  -(h-i)
                hexagon(i,j,:) = 0;
         end
         %dreapta       
         for j =  w + round((w+1)/3) -i +2  : w 
                hexagon(i,j,:) = 0;
         end    
    end

        %daca piesele nu au dimensiunea h*w le redimensionam
       if not(H == h) || not(W==w)
            for i = 1:N
                pieseMozaicRedim(:,:,:,i) = imresize(params.pieseMozaic(:,:,:,i),[h,w]);    
            end
       else
            for i = 1:N
                pieseMozaicRedim(:,:,:,i) = params.pieseMozaic(:,:,:,i);
            end
       end
       
        %vector de piese alb negru
        for i =1:N
            pieseMozaicRedimAN(:,:,1,i) = rgb2gray(pieseMozaicRedim(:,:,:,i)); 
        end
        
        %medii piese
        for y = 1:N
            for x=1:c
                mediiPiese(x,y) = mean(mean(pieseMozaicRedim(:,:,x,y)));
            end
        end
      
        %medii piese alb negru
        for y = 1:N   
            mediiPieseAN(1,y) = mean(mean(pieseMozaicRedimAN(:,:,1,y)));    
        end
      

	switch (params.criteriu)
        case 'aleator'
            
            if c == 1
                for i = 1:params.numarPieseMozaicVerticala+2
                    for j = 1:3*params.numarPieseMozaicOrizontala/4 +1
 
                        index = randi(N);
     
                        imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +round((j+1)*w/3)+1:j*w+round((1+j)*w/3),1)=... 
                        imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +round((j+1)*w/3)+1:j*w+round((1+j)*w/3),1) + hexagon(:,:,1).*pieseMozaicRedimAN(:,:,1,index);
                    
                    end
                end
            
                for i = 1:params.numarPieseMozaicVerticala +2
                    for j = 0:3*params.numarPieseMozaicOrizontala/4 
                        
                        index = randi(N);
                       
                        imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +round(j*w/3) : (j+1)*w+round(j*w/3), 1) = ...
                        imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +round(j*w/3) : (j+1)*w+round(j*w/3), 1) + hexagon(:,:,1).*pieseMozaicRedimAN(:,:,1,index); 
                    end
                end
   
                 
            else
                
                %poza de referinta e color
                for i = 1:params.numarPieseMozaicVerticala+2
                    for j = 1:3*params.numarPieseMozaicOrizontala/4 +1

                        index = randi(N);
     
                        imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),:)=... 
                        imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),:) + hexagon(:,:,:).*pieseMozaicRedim(:,:,:,index);
                    
                    end
                end
            
                for i = 1:params.numarPieseMozaicVerticala +2
                    for j = 0:3*params.numarPieseMozaicOrizontala/4 
              
                        index = randi(N);
 
                        imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), :) = ...
                        imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), :) + hexagon(:,:,:).*pieseMozaicRedim(:,:,:,index);

                    end
                end
    
                
            end

        case 'distantaCuloareMedie'
            if c == 1
                for i = 1:params.numarPieseMozaicVerticala+2
                    for j = 1:3*params.numarPieseMozaicOrizontala/4 +1
         
                     
                        medieImgReferintaC1 = mean2( imgReferintaReRedim( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),1));

                        %diferenta minima o initializez cu suma diferentelor pe
                        %fiecare canal dintre poza de referinta si prima poza din
                        %colectie
                
                        index = 1;
                        diferentaMinima = abs(medieImgReferintaC1 - mediiPieseAN(1,1));
                    
                        for a = 2:N
                            %caut diferenta minima
                            difTemp = abs(medieImgReferintaC1 - mediiPieseAN(1,a));
               
                            if abs(difTemp) < abs(diferentaMinima)
                                diferentaMinima = difTemp;
                                index = a;
                            end
                        end 
     
                        imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),1)=... 
                        imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),1) + hexagon(:,:,1).*pieseMozaicRedimAN(:,:,1,index);
                    
                    end
                end
            
                for i = 1:params.numarPieseMozaicVerticala +2
                    for j = 0:3*params.numarPieseMozaicOrizontala/4 
              
                        medieImgReferintaC1 = mean(mean( imgReferintaReRedim( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), 1)));
                        index = 1;

                       diferentaMinima = abs(medieImgReferintaC1 - mediiPieseAN(1,1));
                
                        for a = 2:N
                            %caut diferenta minima
                            difTemp = abs(medieImgReferintaC1 - mediiPieseAN(1,a));
                            if abs(difTemp) < abs(diferentaMinima)
                                diferentaMinima = difTemp;
                                index = a;
                            end
                        end 
                    
                        imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), 1) = ...
                        imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), 1) + hexagon(:,:,1).*pieseMozaicRedimAN(:,:,1,index); 
                    end
                end
   
                 
            else
                
                %poza de referinta e color
                for i = 1:params.numarPieseMozaicVerticala+2
                    for j = 1:3*params.numarPieseMozaicOrizontala/4 +1

                        
                    medieImgReferintaC1 = mean2( imgReferintaReRedim( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),1));
                    medieImgReferintaC2 = mean2( imgReferintaReRedim( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),2));
                    medieImgReferintaC3 = mean2( imgReferintaReRedim( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),3));
 
                    %diferenta minima o initializez cu suma diferentelor pe
                    %fiecare canal dintre poza de referinta si prima poza din
                    %colectie
                
                    index = 1;
    
                    diferentaMinima = (medieImgReferintaC1 - mediiPiese(1,1))^2+...
                        (medieImgReferintaC2 - mediiPiese(2,1))^2 + (medieImgReferintaC3 - mediiPiese(3,1))^2;
                    diferentaMinima = sqrt(diferentaMinima);
                
                    for a = 2:N
                        %caut diferenta minima
                        difTemp = sqrt((medieImgReferintaC1 - mediiPiese(1,a))^2+...
                            (medieImgReferintaC2 - mediiPiese(2,a))^2 + (medieImgReferintaC3 - mediiPiese(3,a))^2);
               
                        if abs(difTemp) < abs(diferentaMinima)
                            diferentaMinima = difTemp;
                            index = a;
                        end
                    end 
     
                    imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),:)=... 
                    imgMozaicExtinsa( (i-1)*h+h/2+1:i*h+h/2, (j-1)*w +floor((j+1)*w/3)+1:j*w+floor((1+j)*w/3),:) + hexagon(:,:,:).*pieseMozaicRedim(:,:,:,index);
                    
                    end
                end
            
                for i = 1:params.numarPieseMozaicVerticala +2
                    for j = 0:3*params.numarPieseMozaicOrizontala/4 
              
                    medieImgReferintaC1 = mean(mean( imgReferintaReRedim( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), 1)));
                    medieImgReferintaC2 = mean(mean( imgReferintaReRedim( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), 2)));
                    medieImgReferintaC3 = mean(mean( imgReferintaReRedim( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), 3)));
                    index = 1;

                    diferentaMinima = (medieImgReferintaC1 - mediiPiese(1,1))^2+...
                        (medieImgReferintaC2 - mediiPiese(2,1))^2 + (medieImgReferintaC3 - mediiPiese(3,1))^2;
                    diferentaMinima = sqrt(diferentaMinima);
                
                    for a = 2:N
                        %caut diferenta minima
                        difTemp = sqrt((medieImgReferintaC1 - mediiPiese(1,a))^2+...
                            (medieImgReferintaC2 - mediiPiese(2,a))^2 + (medieImgReferintaC3 - mediiPiese(3,a))^2);
               
                        if abs(difTemp) < abs(diferentaMinima)
                            diferentaMinima = difTemp;
                            index = a;
                        end
                    end 

                    imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), :) = ...
                    imgMozaicExtinsa( (i-1)*h+1:i*h, j*w+1 +floor(j*w/3) : (j+1)*w+floor(j*w/3), :) + hexagon(:,:,:).*pieseMozaicRedim(:,:,:,index);

                    end
                end
    
                
            end
            
      otherwise
        printf('EROARE, optiune necunoscuta \n');              
    end
    
    imgMozaic = imgMozaicExtinsa(round(h/2)+1:h*params.numarPieseMozaicVerticala+round(h/2),round(w/3)+1:w*params.numarPieseMozaicOrizontala+round(w/3),:);
end

