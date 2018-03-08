function params = incarcaPieseMozaic(params)
%citeste toate cele N piese folosite la mozaic din directorul corespunzator
%toate cele N imagini au aceeasi dimensiune H x W x C, unde:
%H = inaltime, W = latime, C = nr canale (C=1  gri, C=3 color)
%functia intoarce pieseMozaic = matrice H x W x C x N in params
%pieseMoziac(:,:,:,i) reprezinta piese numarul i 

fprintf('Incarcam piesele pentru mozaic din director \n');
%completati codul Matlab

imaginiPiese=dir([params.numeDirector '/*.' params.tipImagine]);
primaPiesa = imread([params.numeDirector '/' imaginiPiese(1).name]);
N = length(imaginiPiese);
[H,W,C] = size(primaPiesa);

pieseMozaic = uint8(zeros(H,W,C,N));
for idx = 1:N
       piesaCurenta = imread([params.numeDirector '/' imaginiPiese(idx).name]);
       pieseMozaic(:,:,:,idx) = piesaCurenta;
end
if params.afiseazaPieseMozaic
    %afiseaza primele 100 de piese ale mozaicului
    figure,
    title('Primele 100 de piese ale mozaicului sunt:');
    idxImg = 0;
    for i = 1:10
        for j = 1:10
            idxImg = idxImg + 1;
            subplot(10,10,idxImg);
            imshow(pieseMozaic(:,:,:,idxImg));
        end
    end
    drawnow;
    pause(2);
end

params.pieseMozaic = pieseMozaic;