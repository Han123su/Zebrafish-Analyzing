function [to_deal_with, v] = pre_processed(folder,num, varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if ~exist('./Binary_IMG','dir')
    mkdir('./Binary_IMG')
end
to_deal_with = [];

% 陰影區域面積圈選
p = inputParser;
Chk = @(x) isnumeric(x);
addParameter(p,'mode',1,Chk);
addParameter(p,'omega',0.05,Chk);
addParameter(p,'thres_canny',0.2,Chk);
parse(p,varargin{:})
omega = p.Results.omega; thres_canny = p.Results.thres_canny; 
mode = p.Results.mode;

if mode
    switch mode
        case 1
            to_deal_with = [];
            for k=1:num
                Images =[folder '/' int2str(k) '.png'];
                disp("frame"+k);
                I = imread(Images);
                HSV = rgb2hsv(I); h=HSV(:,:,1);v=HSV(:,:,3);s=HSV(:,:,2);
                % 對v channel 做影像增強
                v1 =v;
                v = imadjust(v);

                % 陰影區域
%                 v(800:end,500:end)=v1(800:end,500:end);
                logical_H = logical((h>0.3 &h<0.48)&s<mean2(s)-omega); 
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
                [canny, ~] = edge(smooth,'canny',thres+ thres_canny);
                canny = imclearborder(canny);
                canny = imdilate(canny,se);
                canny = imfill(canny,'holes');
                canny = imerode(canny,se);
                canny = imfilter(canny,f);
                canny = imfilter(canny,f);
                canny = bwareaopen(canny,25);
                
                % Check if there are more than 4 markers 
                % and sign the not satisfy's makers.
                s = regionprops(bwlabel(canny),'centroid');
                centroids = cat(1, s.Centroid);
                if length(centroids)<4 || length(centroids)>4
                    to_deal_with = [to_deal_with,k];
                    disp("需進一步處理影像:");
                    disp(to_deal_with);
                end
            
                %------------------
                imwrite(canny ,strcat('./Binary_IMG/',num2str(k),'.png'));
            end

        case 2
            
            Images =[folder '/' int2str(num) '.png'];
            disp("frame"+num);
            I = imread(Images);
            HSV = rgb2hsv(I); h=HSV(:,:,1);v=HSV(:,:,3);s=HSV(:,:,2);
       
            v1 =v;
            v = imadjust(v);
%             v(300:end,1:200) =v1(300:end,1:200);
%             v(1:300,1:end) =v1(1:300,1:end);
            % 陰影區域
%            v(800:end,500:end)=v1(800:end,500:end);

            logical_H = logical((h>0.28 &h<0.48)&s<mean2(s)-omega); 
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
            [canny, ~] = edge(smooth,'canny',thres+ thres_canny);
            canny = imclearborder(canny);
            canny = imdilate(canny,se);
            fill_canny = imfill(canny,'holes');
            fill_canny = imerode(fill_canny,se);
            canny2 = imfilter(fill_canny,f);
            canny2 = imfilter(canny2,f);
            canny2 = bwareaopen(canny2,25);
%             canny(1274:end,:) = 0;
            % Check if there are more than 4 markers 
            % and sign the not satisfy's makers.

            s = regionprops(bwlabel(canny2),'centroid');
            centroids = cat(1, s.Centroid);
            if length(centroids)<4 || length(centroids) >4
                v = 0;
                to_deal_with = num;
%             end
            else
                v =1;
                imwrite(canny2 ,strcat('./Binary_IMG/',num2str(num),'.png'));
            end
            imwrite(canny2 ,strcat('./Binary_IMG/',num2str(num),'.png'));
            figure(2),
            imshow(canny2),title("重新處理--Frame--"+int2str(num));
    end


        % mask1 new green channel
%     gray_img = rgb2gray(img);
% %     gray_img = imadjust(gra)
%     threshold_G = sum(img(:,:,2),'all')/sum(img(:,:,2)>0,'all'); % 自適應的thresholding 
%     mask1 = img(:,:,2)>=threshold_G;
% 
%     % mask 2
%     T = graythresh(gray_img);
%     mask2 = imbinarize(gray_img,T);
% 
% 
%     mask = mask1&mask2;
%     mask = bwareaopen(mask,8);
%     mask = imdilate(mask,se);
%     mask = imfill(mask,'holes');

%     subplot(151), imshow(img);
%     subplot(152),imshow(mask1)
%     subplot(153),imshow(mask2)
%     subplot(154),imshow(mask),title('去除陰影');
%     subplot(155),imshow(canny),title('去除陰影');
%     subplot(151), imshow(img);
%     subplot(152),imshow(gray)
%     subplot(153),imshow(smooth)
%     subplot(154),imshow(canny),title('去除陰影');
%     subplot(155),imshow(canny),title('去除陰影');


end