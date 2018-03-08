%proiect REALIZAREA DE MOZAICURI
%

%%
%seteaza parametri pentru functie

%citeste imaginea care va fi transformata in mozaic
%puteti inlocui numele imaginii
params.imgReferinta = imread('../data/imaginiTest/obama.jpeg');
%seteaza directorul cu imaginile folosite la realizarea mozaicului
%puteti inlocui numele directorului
params.numeDirector = '../data/colectie';

params.tipImagine = 'png';

%seteaza numarul de piese ale mozaicului pe orizontala
%puteti inlocui aceasta valoare
params.numarPieseMozaicOrizontala = 100;
%numarul de piese ale mozaicului pe verticala va fi dedus automat

%seteaza optiunea de afisare a pieselor mozaicului dupa citirea lor din
%director
params.afiseazaPieseMozaic = 0;

%seteaza modul de aranjare a pieselor mozaicului
%optiuni: 'caroiaj','aleator','hexagon'
params.modAranjare = 'caroiaj';


%seteaza criteriul dupa care realizeze mozaicul
%optiuni: 'aleator','distantaCuloareMedie','distantaCuloareMedie2'

%'distantaCuloareMedie2' are in plus conditia ca o piesa sa nu se afle pe
%pozitii vecine
%'distantaCuloareMedie2' !!!! este doar pt modul de aranjare: caroiaj !!!
params.criteriu = 'distantaCuloareMedie2';

%%
%apeleaza functia principala
imgMozaic = construiesteMozaic(params);

imwrite(imgMozaic,'obama_100.jpeg');
figure, imshow(imgMozaic)
impixelinfo;
