
sad
% 1470 var_9470
for  i = 4:300
    fi = ['run/' int2str(i) '.sdpng'];
    f2 = imread(fi);
    xxx =  f2(1:526,:,:);
    imwrite(xxx,strcat('./run/',num2str(i),'.png'));
end

%%
Start_frame=400;%開始幀數

End_frame=500;%結束幀數

for k=Start_frame:5:End_frame
    
    name = ['D:\Jian\Zebrafish-tracking-analysis-behavior\runs\1270\ori_img\' int2str(k) '.jpg'];
    frame = imread(name);
    frame1 = im2uint8(frame);
%     frame1(:,:,2) = frame1(:,:,1);
%     frame1(:,:,3) = frame1(:,:,2);
%     frame(:,:,2) = im2uint8(frame);
%     frame(:,:,3) = im2uint8(frame);

% im=frame2im(frame);%製作gif文件，圖像必須是index索引圖像

    [I,map]=rgb2ind(frame1,256);%轉成gif圖片,只能用256色

% I=rgb2gray(frame);

%     waitbar((k-Start_frame)/(End_frame-Start_frame),h,['轉換中',num2str(round((k-Start_frame)*100/(End_frame-Start_frame))),'%']);

    if k==Start_frame

% 第一張直接保存到視頻目錄下

        imwrite(I,map,strcat('zebrafish.gif'),'gif','Loopcount',inf,'DelayTime',0.001); % 0.067

    else

% 剩下的每張圖續接上一個圖，每張圖間隔為與視頻中的一致

        imwrite(I,map,strcat('zebrafish.gif'),'gif','WriteMode','Append','DelayTime',0.001);

    end

end

% waitbar(1,h,'finished');

% close(h);





