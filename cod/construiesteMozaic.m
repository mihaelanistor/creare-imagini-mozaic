function imgMozaic = construiesteMozaic(params)
%functia principala a proiectului
%primeste toate datele necesare in structura params


%incarca toate imaginile mici = piese folosite pentru mozaic
params = incarcaPieseMozaic(params);

%calculeaza noile dimensiuni ale mozaicului
params = calculeazaDimensiuniMozaic(params);

%adauga piese mozaic
switch params.modAranjare
    case 'caroiaj'
        imgMozaic = adaugaPieseMozaicPeCaroiaj(params);
    case 'aleator'
        imgMozaic = adaugaPieseMozaicModAleator(params);
    case 'hexagon'
        imgMozaic = adaugaPieseHexagonale(params);
end