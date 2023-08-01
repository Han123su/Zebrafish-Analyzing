clc;
close all;
clear;
addpath('D:\Jian\Zebrafish-tracking-analysis-behavior\Zebrafish-tracking-analysis-behavior\functions')
%%
if exist('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\imgs\CROP_IMG-1175-n1','dir')
    rmdir 'D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\imgs\CROP_IMG-1175-n1' s
end
if ~exist('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\imgs\CROP_IMG-1175-n1','dir')
    mkdir('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\imgs\CROP_IMG-1175-n1')
end
%% Load zebrafish video (基於SORT開發的舊版斑馬魚追蹤系統)
% Crop adaptive region
% Around of photographing zebrafish's environment contained a lot of noise.
% So we need to remove this noise by croping images.
if ~exist('../datasets/multi/CROP_IMG-1829','dir')
    mkdir('../datasets/multi/CROP_IMG-1829')
    mkdir('../datasets/multi/ORI_IMG-1829')
end

videofileName = 'D:\Jian\Zebrafish-tracking-analysis-behavior\runs2\yolov5\IMG_1831-sham_n3_2.mp4';
obj = VideoReader(videofileName);
ze_reader = vision.VideoFileReader(videofileName);
videoPlayer = vision.VideoPlayer('Position',[20,400,700,400]);
i =0;
while ~isDone(ze_reader)
    frame = step(ze_reader);
    if i==0
        imshow(frame);  
        [xv,yv] = ginput(2);
        y1_plus = xv(1); 
        y2_plus = xv(2); 
        x1_plus = yv(1);
        x2_plus = yv(2);  
    end
%     dif_x = randi([-43 40],1,1);
%     dif_y = randi([-124 300],1,1);
%     frame2 =  frame(yv(1)+dif_y:yv(2)+dif_y,xv(1)+dif_x:xv(2)+dif_x,:);
    step(videoPlayer,frame)
    
    i =i+1;

    name = sprintf('%05d', i);

    imwrite(frame,strcat('D:\Jian\Zebrafish-tracking-analysis-behavior\runs2\yolov5\tracking_images\', name,'.png'));
end
save crop_idx xv yv ;
%%  Pre-processing the Zebrafish images
% apply the environment of the zebrafish' living. 
% we apply the HSV color space to replace traditional RGB.
% Only leave off the flouresceion region to track this position further. 
% every video need to adjust the threshold to make the image clearer.
% the func created a Binary_IMG folder to save these processed images.
% threshold =110; % 9853 110 / 9854 80
% 新增bwlabel機制來檢查 標記點沒有4個
% folder = 'CROP_IMG_9854';

[arr, ~] = pre_processed('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\correct\nowater\CROP_IMG-9853',i,omega=0.1,thres_canny=0.2);

%%
% Repreprocessd Image which are less thanfour marks.
count =1;
arr_res =arr;
processed_img =arr;
switch_mode = input("{1: 個別處理, 2: 全部處理} : ");
disp("需處理個數: "+length(processed_img));

switch switch_mode
    case 1
        k=1;
        k2 = 0;
        b = false;
        res = [];
        while ~isempty(processed_img) 
            
            disp(k)
            figure(1),
            if strcmpi(get(gcf,'CurrentCharacter'),'q')
                break;
            else
                imshow(strcat('./Binary_IMG/',num2str(arr(k)),'.png'));
                title("Frame--"+int2str(arr(k)));
                omega = input("飽和度常數(0.00 ~ 2.00): ");
                thres_canny = input("Canny dection thres(0 ~ 3): ");
    
                [~, v] = pre_processed('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\correct\nowater\CROP_IMG-9853',arr(k), mode=2,omega=omega,thres_canny=thres_canny);
                if k2==k
                    count =count+1;
                    if count ==5
                        b =input("繼續(0) or 跳過(1)");
                        count =0;
                    end
                end
                k2= k;
                if v || b
                    if b
                        res = [res arr(k)];
                    end
                    k2= 0;
                    b =false;
                    k = k+1;
                    processed_img(1) = [];
                end
            end
            
        end
        arr = processed_img;
        arr = [res arr];
        arr = sort(arr);

    case 2
        arr = [];
        omega = input("飽和度常數{0.0 ~ 2.0}: ");
        thres_canny = input("Canny dection thres{0.0 ~ 0.4}: ");
        for k=1:length(processed_img)
            disp(k);
            [deal_img, ~] = pre_processed('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\correct\nowater\CROP_IMG-9853',processed_img(k), mode=2,omega=omega,thres_canny=thres_canny);
            arr =[arr deal_img];
        end
end

close all;


%% create video stream
% Use ffmpeg to generate the video.
% !Notation: Pay attention to FPS and image's folder of pre-processing.
% system('del zebrafish_res-sham_01.mkv') 
% cd D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\imgs\Binary_IMG-9469\
cd Binary_IMG\
mypath=pwd;
system(['set PATH=' mypath ])
system( 'ffmpeg -r 30 -i %d.png ../nwc-9853.avi')
cd ..
% save var_9854 fnum fs coordi xv yv '-v7.3'
%% Motion-Based Multiple Object Tracking
% MBMOT(使用者選取四個目標點圖的Folder, 上一步製成的影片Folder, 追蹤圖儲存的Folder)
[coordi,point_Id,fnum] = MBMOT('../datasets/healthy/correct/nowater/CROP_IMG-9853', ...
    'nwc-9853.avi','../run'); 
%% 框出ROI 目前沒有用到
% crop_ROI(計算影像邊界的Folder, 追蹤目標點紀錄, 四點對位, 總Frame張數)
crop_ROI('Zebrafish-無病/20220826_綠螢光閃/數據分析/CROP_IMG_9853',coordi,point_Id,'ROI',fnum);

