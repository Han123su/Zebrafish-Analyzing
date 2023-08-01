folder = 'D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\correct\nowater\CROP_IMG-9853';

for k=5844:5844
%     k = arr(k);
    Images =[folder '/' int2str(k) '.png'];
    disp("frame"+k);

    I = imread(Images);
    HSV = rgb2hsv(I); h=HSV(:,:,1);v=HSV(:,:,3);s=HSV(:,:,2);
    HSV2 = HSV;

    v1 =v;
    v = imadjust(v);
    % 陰影區域
%     v(300:end,1:200) =v1(300:end,1:200);
%     v(1:300,1:end) =v1(1:300,1:end);

    HSV2(:,:,1)=h;HSV2(:,:,3)=v;HSV2(:,:,2)=s;

    logical_H = logical((h>0.3 &h<0.48)&s<mean2(s)-0.); 
    v = v.*logical_H;
    HSV(:,:,1)=h;HSV(:,:,3)=v;HSV(:,:,2)=s;

    % 轉為RGB影像
    img =  im2uint8(hsv2rgb(HSV));
    %
    %--------------- 做Canny 偵測----------------
    im = img;
    gray = rgb2gray(im);    
    gray = imgaussfilt(gray,4);
    f = ones(3,3) / 9;
    smooth = imfilter(gray,f);
    for j = 1:5
        smooth = imfilter(smooth,f);
    end

    se = strel('disk',2);
    [~, thres] = edge(smooth,'canny');  
    [canny, ~] = edge(smooth,'canny',thres+0.25);
    canny = imclearborder(canny);
    canny = imdilate(canny,se);
    fill_canny = imfill(canny,'holes');
    fill_canny = imerode(fill_canny,se);
    fill_canny2 = imfilter(fill_canny,f);
    fill_canny2 = imfilter(fill_canny2,f);   
    fill_canny2 = bwareaopen(fill_canny2,25);

    %------------------
    gray_img = rgb2gray(img);

    % new green channel 
    threshold_G = sum(img(:,:,2),'all')/sum(img(:,:,2)>0,'all'); % 自適應的thresholding 
    mask1 = img(:,:,2)>=threshold_G+55;

    T = graythresh(gray_img);
    mask2 = im2bw(gray_img,T);

    mask = mask1&mask2;
    mask = bwareaopen(mask,8);
    se = strel('disk',2);
    mask = imdilate(mask,se);

    mask = imfill(mask,'holes');
    se = strel('disk',1);
    mask = imerode(mask,se);
%     fill_canny2(1300:end,:) = 0;

    imwrite(fill_canny2 ,strcat('Binary_IMG/',num2str(k),'.png'));
%     imwrite(fill_canny2 ,strcat('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy\imgs\Binary_IMG-9853\',num2str(k),'.png'));

    subplot(241), imshow(I),title("原影像");
    subplot(242),imshow(hsv2rgb(HSV2)),title("HSV增強");
    subplot(243),imshow(im),title("HSV處理玩影像");
    subplot(244),imshow(smooth),title('模糊');
    subplot(245),imshow(canny),title("edge");
    subplot(246),imshow(fill_canny),title("filled img ");
    subplot(247),imshow(fill_canny2),title("filter filled img");
    subplot(248),imshow(mask),title("green filter filled img");
%     name = ['paper_figure/' int2str(k) '.png'];
%     saveas(gcf,name);
end
%% confirm all imgs has four ROI
arr = [];
for i=1:fnum
    I = imread(['Binary_IMG/' int2str(i) '.png']);
%     I = rgb2gray(I);
%     T = grayThres(I);
%     I = imbinarize(I,T);
    disp(i);
%     I = bwareaopen(I,20);
%     I(1000:end,:)=0;
    s = regionprops(bwlabel(I));
    cen = cat(1,s.Centroid);
    if length(cen)<4 || length(cen)>4
        arr = [arr i];
        disp("Problem");
        disp(arr);
    end
end

%%
