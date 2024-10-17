clc;
close all;
clear;
addpath('C:\Users\lab508\Desktop\matlab_code\functions') 

%% 讀取.txt資料
data = importdata('.\IMG_5190_pomgnt1WT_1_15s.txt');

% 4 點
coordi = {};
coordi{1} = data(:,2:3);
coordi{2} = data(:,4:5);
coordi{3} = data(:,6:7);
coordi{4} = data(:,8:9);
contour_AUC = data(:,12);
curve_rate = data(:,13);
sum_AUC = data(:,14);

%% 提取運動特徵並儲存結果
point_Id = [1,2,3,4]; 
fnum = length(data);
fs = 240;
save_dir = 'angle_figure/';
if ~exist(save_dir,'dir')
    mkdir(save_dir)
end

[ori_data, seq_var] = extract_feature(coordi, point_Id,save_dir,fnum,fs,true);

disp('ori_data:');
disp(ori_data);

% 1 12 34 | 1 12 23 | 1 23 34 | 1 12 24 | 2 12 | 2 34 | 3 1 | 3 4 | 4

%% 夾角 Approximate entropy
clc;
m =4; tau=1;scales=20;

for i=1:length(ori_data)
    disp("標記點"+string(ori_data{i}(1)));
    kk = cell2mat(ori_data{i}(2));
    kk = (kk-min(kk))./(max(kk)-min(kk));
    [ap, ~] = ApEn(kk, m=m, tau=tau);
    disp("夾角ApEn: ")
    %disp([ap(3); ap(4);ap(5)]);
    for i = 2:m
        fprintf('m=%d   ->  %.4f\n', i, ap(i+1));
    end
    fprintf('\n');
end
