function [Mv, Lv, phiFcn] = centroidNumerical(V, massFcn, par)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Mac Schwager, MIT, 2006
% Andreas Breitenmoser, MIT, 2009
%
% Calculate the centroid of a region V parameterized by K'*a. Uses
% numerical descritization of region to evaluate the centroid integrals.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res = par.res;

% Make rectangular domain to contain region
xmax = max(V(:,1));
xmin = min(V(:,1));
ymax = max(V(:,2));
ymin = min(V(:,2));

% Integration step
xstep = (xmax-xmin)/res;
ystep = (ymax-ymin)/res;

% Integration loop to calc M, intxphi, intyphi
phiFcn = zeros(res^2,3);
Mv = 0;
Lv = [0 0]';
Lv2 = Lv;
i = 1;
for x = xmin+xstep/2:xstep:xmax-xstep/2
    for y = ymin+ystep/2:ystep:ymax-ystep/2
        q = [x; y];
        phiFcn(i, 1:2) = q';
        if inpolygon(q(1), q(2), V(:,1), V(:,2))
            phiq = massFcn(q(1),q(2));
            
            Mblock =xstep*ystep*phiq;
            
            Mv = Mv + Mblock;
            %prevents Nan values in the case of Mv = 0 (happends when phiq
            %,density, is equal to zero)
            if Mv ~= 0
                %Calculates CENTERS OF MASS of the concidered polygon
                %iteravily.. NOT the 'moments'......
                Lv = ((Mv-Mblock)*Lv + [q(1),q(2)]'*Mblock)/Mv;
                %Lv = Lv + phiq*q;
            end

           

            phiFcn(i, 3) = phiq;
        end
        i = i+1;
    end
      
            
end
check_nan = isnan(Lv);

if sum(check_nan) > 0
    disp('Nan in centroidNUmerical.m...')
elseif Lv == 0
    %disp('Lv is zero...')
end


%check centers
% close all
% figure(1);scatter(V(:,1),V(:,2));hold on; scatter(Lv(1),Lv(2));hold on;legend('V','Lv')
% grid on
% disp('jatog')
            
