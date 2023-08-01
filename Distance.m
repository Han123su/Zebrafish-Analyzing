%% Distance measurement condition 43s 10320 frame
% stadard
point = cameraParams.ReprojectedPoints;
cal = imread('check_board1/1.png');     
figure, imshow(cal);
hold on;
num =1;
plot(point(1,1,num),point(1,2,num),'.r','MarkerSize',10);
% plot(point(144,1,num),point(144,2,num),'.r','MarkerSize',10);
r = [point(67,1,1)-point(77,1,1) point(67,2,1)-point(77,2,1)];
r2 = [point(1,1,1)-point(144,1,1) point(1,2,1)-point(144,2,1)];
len = sqrt(sum(r.^2,2)); %848.9442
len2 = sqrt(sum(r2.^2,2)); %848.9442
d = len/10;
d2 = len2/13;
all = len+d;
all2 = len2+d2*2;
scale_width = all / 10;
scale__heigh = all2 / 19;
%%  Distance measurement
% Initial value.
% 長x寬 : 19 x10 cm  高：深度 20 cm  拍攝時水位會控制在8cm
fs = 240;
s = 1/fs;
% t = (1:80*240)/fs;
fnum = 18895; %  80s
t = (1:fnum)/fs;

rescale_h= 1;
rescale_w = 1 ;
scale_heigh = 1920/19;
scale_width = 1080/10;

% head
r = [diff(coordi{point_Id(1)}(361:length(t)+360,1))*rescale_h/scale_heigh diff(coordi{point_Id(1)}(361:length(t)+360,2))*rescale_w/scale_width];
dt1 = sqrt(sum(r.^2,2));
dt1 = dt1*10;
spd1 = dt1./s;
%body
r = [diff(coordi{point_Id(2)}(361:length(t)+360,1))*rescale_h/scale_heigh diff(coordi{point_Id(2)}(361:length(t)+360,2))*rescale_w/scale_width];
dt2 = sqrt(sum(r.^2,2));
dt2 = dt2*10;
spd2 = dt2./s;

fprintf("Head\n");
fprintf("%.2f\n", sum(dt1));
fprintf("%.3f\n", sum(dt1)/ t(end));
fprintf("Body\n");
fprintf("%.2f\n", sum(dt2));
fprintf("%.3f\n", sum(dt2)/ t(end));
clear;
%%
t = (1:10320-99)/240;
spd0621= spd0621.*~(spd0621> 100);
% spd0788= spd0788.*~(spd0788> 80);
% spd1212= spd1212.*~(spd1212> 100);
figure(1),
subplot(311),
plot(t,[0;spd0621(100:end)],'g', 'LineWidth',1);
% legend(['Healthy (Average speed: ' num2str(round(average_velocity1,2)) ' kpx /s ) '],'Location','northwest');
legend('Healthy');
xlabel("Time (sec)");
% ylabel('Velocity (kilopixels / s)');
xlim([0 43])
subplot(312),
plot(t,[0;spd0788(100:end)],'r', 'LineWidth',1);
% legend(['MPTP   (Average speed: ' num2str(round(average_velocity2,2)) ' kpx /s ) '],'Location','northwest');
legend('MPTP');
xlabel("Time (sec)");
ylabel('Velocity (mm / s)');
xlim([0 43])
subplot(313),
plot(t,[0;spd1212(100:end)],'b', 'LineWidth',1);
% legend(['Sham   (Average speed: ' num2str(round(average_velocity3,2)) ' kpx /s ) '],'Location','northwest');
% plot(t,[0;spd9854(361:10800)],'g', 'LineWidth',2);
legend('Sham');
xlabel("Time (sec)");
% ylabel('Velocity (kilopixels / s)');
xlim([0 43])
% hold off;
% saveas(gcf,'velocity_long.png')

