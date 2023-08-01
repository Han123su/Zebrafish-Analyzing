% validate angle 

% I = imread(strcat(folder, strcat(int2str(i), '.png')));
I = mask;
i=1;
x1 = coordi{1}(i,2); y1 = coordi{1}(i,1); % 頭
x2 = coordi{1}(i+1,2); y2 = coordi{1}(i+1,1); % 身
x3 = coordi{1}(i,2); y3 = coordi{1}(i,1); 
x3 = x3+2; %y3=y2+2;
figure(1),
imshow(I);
hold on;
plot(x1,y1,'.r','LineWidth',0.1); % 123
plot(x2,y2,'.g','LineWidth',0.1); % 123
plot(x3,y3,'*b','LineWidth',0.1); % 123

arr_coor(1,:) = [x1,y1];
A = arr_coor(1,:);
arr_coor(2,:) = [x2,y2];
B = arr_coor(2,:);
% parallel_point2 = [x2, y2+2];
parallel_point2 = [x3, y3];

plot([B(2),A(2)],[B(1),A(1)],'r');
plot([parallel_point2(2),A(2)],[parallel_point2(1),A(1)],'r');


v2 = B-A;
v1 = parallel_point2-A;

v1_dot_v2 = dot(v1,v2);
v1_cross_v2 = v1(1)*v2(2) - v1(2)*v2(1);

angle = atan2(v1_cross_v2, v1_dot_v2);
realangle_x = angle*180/pi;
%     if sign(realangle_x)~=true;realangle_x=360+realangle_x;end
disp(realangle_x)
%% validate orientation
up_right = 0;
up_left = 0;
dn_right = 0;
dn_left = 0;

if 0< realangle_x <90 
    up_right = up_right+1;
elseif 90< realangle_x <180
    up_left = up_left+1;
elseif 0> realangle_x >-90
    dn_right = dn_right+1;
elseif -90> realangle_x >-180
    dn_left = dn_left+1;
end
%% validate lost Item 
lostInds = [0,0,1,0];

%new_track =tracks(1:3);% 1 2 11 12 ==> 1 2  12 11
arr = false(1,size(tracks,2));
idx = find(lostInds>0);
arr(idx) = true;

x = find(arr==1);
y = find(arr==0);
new_tracks(y) = tracks(1:3);

new_track(~arr) = tracks(1:3); %有問題 找出哪一點是新的點與將丟失的位置給替換成原來新的點為，把11原本的點(第四點)為給安排回去第三點
new_track(arr) = newdot;
tracks = new_track;
