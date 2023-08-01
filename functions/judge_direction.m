function [orientation] = judge_direction(realangle_x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
orientation = struct;
up_right = 0;
up_left = 0;
dn_right = 0;
dn_left = 0;
L = length(realangle_x);

for i=1:L
    if 0< realangle_x(i)&& realangle_x(i) <90
        up_right = up_right+1;
    elseif 90<realangle_x(i)&& realangle_x(i) <180
        up_left = up_left+1;
    elseif 0> realangle_x(i)&&realangle_x(i)>-90
        dn_right = dn_right+1;
    elseif -90> realangle_x(i)&&realangle_x(i) >-180
        dn_left = dn_left+1;
    end
end
orientation.a = up_right;
orientation.b = up_left;
orientation.c = dn_left;
orientation.d = dn_right;

end