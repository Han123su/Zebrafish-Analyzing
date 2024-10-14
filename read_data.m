clc;
close all;
clear;
% addpath('D:\Jian\Zebrafish-Analysis-behavior\Analysis-behavior-code\functions')
addpath('C:\Users\lab508\Desktop\Analysis_behavior\functions') 
%% 讀取.txt資料
data = importdata('IMG_5190_pomgnt1WT_1_15s.txt');
% data = importdata('.\data\20240703_pomgnt1_heterogeneous\IMG_5388~video\labels\IMG_5388~video_1.txt');
% head_x = data(:,2);
% head_y = data(:,3);
% center_x1 = data(:,4);
% center_y1 = data(:,5);
% center_x2 = data(:,6);
% center_y2 = data(:,7);
% tail_x = data(:,8);
% tail_y = data(:,9);

% 3 點
% coordi{1} = data(:,2:3);
% coordi{2} = data(:,10:11);
% coordi{3} = data(:,8:9);
% coordi{4} = data(:,8:9);
% contour_AUC =  data(:,12);
% curve_rate =  data(:,13);
% sum_AUC =  data(:,14);
% 4 點
coordi = {};
coordi{1} = data(:,2:3);
coordi{2} = data(:,4:5);
coordi{3} = data(:,6:7);
coordi{4} = data(:,8:9);
contour_AUC = data(:,12);
curve_rate = data(:,13);
sum_AUC = data(:,14);

%% csv讀取格式(屬於舊版格式)

DataFrame = readtable('record_all_values.csv','readvariablenames',true,'preservevariablename',true);
curve_rate = DataFrame.("curve rate");
contour_AUC = DataFrame.("contour-AUC");
sum_AUC = DataFrame.("sum-AUC");

coordi = {};
coordi{1} = [DataFrame.head_x, DataFrame.head_y];
coordi{2} = [DataFrame.center_x, DataFrame.center_x];
coordi{3} = [DataFrame.tail_x, DataFrame.tail_y];
point_Id = [1,2,3,3];
fnum = length(sum_AUC);
fs = 240;
%% 提取運動特徵
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


disp('seq_var:');
disp(seq_var);
% 1234 1223 2334 12 34 1 4 
% 1 12 34 | 1 12 23 | 1 23 34 | 2 12 | 2 34 | 3 1 | 3 4 | 1 12 24 | 4
