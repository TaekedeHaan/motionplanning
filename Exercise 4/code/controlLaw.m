function u = controlLaw(posRi, Mv, Lv)
k = 5;
% if Mv ~=0
%     Cv = Lv/Mv;
%     u = k*(Cv-posRi);
% 
% else 
%     u =0;
% end
u = k*(Lv-posRi);
check_nan = isnan(u);

if sum(check_nan) > 0 
    disp('Nan in controlLaw...')
end

