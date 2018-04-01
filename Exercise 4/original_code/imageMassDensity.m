function h = imageMassDensity(imgMatFile,options)
load(imgMatFile, 'densImgFullGrad');

imgDens = densImgFullGrad;
if ~exist('options', 'var'), options = 1; end
switch options
    case 2
        imgDens(imgDens>1e15) = 1e15;
    case 3
        imgDens(imgDens>1e15) = 1e15;
        imgDens(imgDens<1e10) = 0;
end
[ly,lx] = size(imgDens);

h = @(x,y) interp2(linspace(0,1,lx),linspace(0,1,ly),imgDens,x,1-y);