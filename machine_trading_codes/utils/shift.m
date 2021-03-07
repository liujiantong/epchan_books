function y=shift(day,x)
% y=shift(day, x). If day > 0, will have NaN in 1:day. If day < 0, will
% have NaN in end-day:end.

if (day>0)
    y=[NaN*ones(day,size(x,2));x(1:end-day,:)];
elseif (day<0)
    day=-day;
    y=[x(day+1:end,:); NaN*ones(day,size(x,2))];
end