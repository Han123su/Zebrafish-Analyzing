% 2D平面軌跡繪製 
%------------------------------ 輸入檔案為YOLO的MOT.txt讀取格式。--------------------------------
% -----------------------------------Paper論文主要使用這個--------------------------------------
data = importdata('other_papers1.txt');
% data = importdata('IMG_2820_Sham_1.txt');

% % yolov5
% data(:,3) = data(:,3) + double(data(:,5)/2);
% data(:,4) = data(:,4) + double(data(:,6)/2);
% labels = data(:,2);

% yolov7 
data(:,4) = data(:,4) + double(data(:,6)/2);
data(:,5) = data(:,5) + double(data(:,7)/2);
labels = data(:,3);

idx =1;
for label=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    % 19573 19594 6243 8738 4536
    disp(label);
    %yolov5
    x = (labels==label).*data(:,3);
    y = (labels==label).*data(:,4);
    %yolov7
%     x = (labels==label).*data(:,4);
%     y = (labels==label).*data(:,5);

    x(find(x==0))=[];
    y(find(y==0))=[];
    % res_x = x;
    % res_y = y;
    % res_x = [res_x;x];
    % res_y = [res_y;y];
    xx(1:length(x),idx) = x;
    yy(1:length(y),idx) = y;
    idx=idx+1;
end
% 劃出多隻斑馬魚軌跡圖

% col = colormap(jet(2000 + 1));
%     c_set(:,:,i) = col(int16((i/5)*2000),:);      
%     col( int16(i/length(xx(1,:))*2000),:)
col = color_set();

figure,
ax = axes;
hold on;
for i=1:length(xx(1,:))
    disp(i)
    t = (1:length(find(xx(:,i)>0)))/30;
%     plot3(xx(1:length(t),i),yy(1:length(t),i),t,'-','LineWidth', 1.5,'Color',col(int16(i/length(xx(1,:))*2000),:));
    plot(xx(1:length(t),i),yy(1:length(t),i),'-','LineWidth', 1.5,'Color', col(i,:));
end
% grid on;
% set(gca, 'GridLineStyle', '--');
set(gca, 'FontSize', 16)

str = {'Last ID: 19'};
text(1100 ,1900,str,'FontSize',18)
xlabel("X","FontWeight","bold","FontName","Times New Roman")
ylabel("Y","FontWeight","bold","FontName","Times New Roman")
zlabel("Time(s)","FontWeight","bold","FontName","Times New Roman")

% view(-37.5,20);
% saveas(gcf,"yolov5-otherpaper軌跡.jpg")

%% 3D平面軌跡繪製
% 輸入檔案為YOLO的單隻魚的.txt讀取格式(頭部)。
% data = importdata('sham/IMG_1832-sham_n1_1.txt');
data = importdata('.\data\20240703_pomgnt1_heterogeneous\IMG_5388~video\labels\IMG_5388~video_1.txt');
% head_x = data(:,2);
% head_y = data(:,3);
% center_x1 = data(:,4);
% center_y1 = data(:,5);
% center_x2 = data(:,6);
% center_y2 = data(:,7);
% tail_x = data(:,8);
% tail_y = data(:,9);

coordi = {};
coordi{1} = data(:,2:3);
coordi{2} = data(:,4:5);
coordi{3} = data(:,6:7);
coordi{4} = data(:,8:9);

x = coordi{1,1}(:,1);
y = coordi{1,1}(:,2);
t = (1:length(x))/240;
figure,
ax = axes;
col = turbo(5);
plot3(x,y,t,'-','LineWidth', 1.5)
grid on;
set(gca, 'GridLineStyle', '--');
set(gca, 'FontSize', 16)
newcolors = {'#000','#F00','#F80','#FF0','#0B0','#00F','#50F','#A0F'};
colororder(newcolors)

xlabel("X","FontWeight","bold","FontName","Times New Roman")
ylabel("Y","FontWeight","bold","FontName","Times New Roman")
zlabel("Time(s)","FontWeight","bold","FontName","Times New Roman")
title('3D Trajectory');

view(-37.5,20);

%% 2D平面軌跡繪製(自行加的)
x = coordi{1,1}(:,1);
y = coordi{1,1}(:,2);

figure;
plot(x, y, '-', 'LineWidth', 1.5);
grid on;
set(gca, 'GridLineStyle', '--');
set(gca, 'FontSize', 16);

newcolors = {'#000','#F00','#F80','#FF0','#0B0','#00F','#50F','#A0F'};
colororder(newcolors);

xlabel('X', 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Y', 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('2D Trajectory');

view(0, 90); % 將視角設置為上方視圖


