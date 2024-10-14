clc;
% cal ApEn & MSEn of the angle
% Mobj = MSobject('ApEn', 'm', m, 'tau', tau); 
% radius --> typicall 0.2*std(S);
% ------Config------
m =4; tau=1;scales=20;

%% 夾角 Approximate entropy
for i=1:length(ori_data)
    disp("標記點"+string(ori_data{i}(1)));
    kk = cell2mat(ori_data{i}(2));
    kk = (kk-min(kk))./(max(kk)-min(kk));
    [ap, ~] = ApEn(kk, m=m, tau=tau);
    disp("夾角ApEn: ")
    disp([ap(3); ap(4);ap(5)]);
    %   kk = (kk-min(kk(331:end-330)))./(max(kk(331:end-330))-min(kk(331:end-330)));
    %   [~, ~] = MSEn_(kk(331:end-330), Mobj, string(ori_data{i}(1)),Scales=scales,Plotx=true);
    % name = ['figure/1006/m' int2str(j) '/夾角/' int2str(i) '_MSEn.png'];
    % saveas(gcf,name)
end

%% 夾角差 Approximate entropy
for i=1:length(seq_var)
    disp("標記點"+string(seq_var{i}(1)));
    kk = cell2mat(seq_var{i}(2));
    kk = (kk-min(kk))./(max(kk)-min(kk));
    [ap, ~] = ApEn(kk, m=m, tau=tau);
    disp("夾角差ApEn: ");
    disp([ap(3); ap(4);ap(5)]);
    %   kk = (kk-min(kk(331:end-330)))./(max(kk(331:end-330))-min(kk(331:end-330)));
    %   [~, ~] = MSEn_(kk(331:end-330), Mobj, string(ori_data{i}(1)),Scales=scales,Plotx=true);
    % name = ['figure/1006/m' int2str(j) '/夾角/' int2str(i) '_MSEn.png'];
    % saveas(gcf,name)
end

%% 其他特徵 Approximate entropy
kk = curve_rate;
kk = (kk-min(kk))./(max(kk)-min(kk));
[ap, ~] = ApEn(kk, m=m, tau=tau);
disp("curve approximate entropy: ");
disp([ap(3); ap(4);ap(5)]);
kk = contour_AUC;
kk = (kk-min(kk))./(max(kk)-min(kk));
[ap, ~] = ApEn(kk, m=m, tau=tau);
disp("contour approximate entropy: ");

disp([ap(3); ap(4);ap(5)]);
kk = sum_AUC;
kk = (kk-min(kk))./(max(kk)-min(kk));
[ap, ~] = ApEn(kk, m=m, tau=tau);
disp("AUC approximate entropy: ");
disp([ap(3); ap(4);ap(5)]);

%%
% ------Config------
m =4; tau=1;scales=20;
Mobj = MSobject('ApEn', 'm', m, 'tau', tau); 
Feature= struct('f1', [], 'f2', [], 'f3', [], 'f4', [], 'f5', [], ...
    'f6', [], 'f7', [], 'f8', [], 'f9', []);

%%  MSEn 
list_h = ["0621","0622","9853","9854","9857"];
list_m = ["0767","0779","0787","0788","0838","0999","1006","1286","1287","1288","1290","1291"];
list_s = ["1269","1270","1271","1272","1275"];
for i=list_h
    full_name = strcat('D:\Jian\Zebrafish-tracking-analysis-behavior\datasets\healthy', '\data\var_', i,'.mat');
    load(full_name);
    for j=9
        kk = cell2mat(ori_data{j}(2));
        % kk = (kk-min(kk))./(max(kk)-min(kk));
        kk = (kk-min(kk(331:end-330)))./(max(kk(331:end-330))-min(kk(331:end-330)));  
        [value, ~] = MSEn_(kk(331:end-330), Mobj, string(ori_data{j}(1)),Scales=scales,Plotx=true);
        disp(value);
        if j==3
            Feature.f3 = [Feature.f3 ;value];
        elseif j ==4
            Feature.f4 = [Feature.f4 ;value];
        elseif j==6
            Feature.f6 = [Feature.f6 ;value];
        else
            Feature.f9 = [Feature.f9 ;value];
        end
            close all;
    end
end
%%
[f3, f4, f6, f9] = deal(zeros(1, 0));
f3= [f3;mean(Healthy_Feature.f3); mean(MPTP_Feature.f3); mean(Sham_Feature.f3)];
f4= [f4;mean(Healthy_Feature.f4); mean(MPTP_Feature.f4); mean(Sham_Feature.f4)];
f6= [f6;mean(Healthy_Feature.f6); mean(MPTP_Feature.f6); mean(Sham_Feature.f6)];
f9= [f9;mean(Healthy_Feature.f9); mean(MPTP_Feature.f9); mean(Sham_Feature.f9)];
colors = [
    0, 255, 0;     % 綠色
    255, 0, 0;     % 紅色
    0, 0, 255;     % 藍色
    ];
figure,
% for i=1:2
%     plot(1:20,f3(i,:),'LineWidth',1,'Color',colors(i,:)/255)   
%  
% end
errorbar(1:20,f3(1,:),std(Healthy_Feature.f3(1:3,:)),"-*",'MarkerSize',6,'Color','black','LineWidth',1.5);
hold on;
errorbar(1:20,f3(2,:),std(MPTP_Feature.f3),"-o",'MarkerSize',6,'Color','red','LineWidth',1.2);
errorbar(1:20,f3(3,:),std(Sham_Feature.f3),"-^",'MarkerSize',6,'Color','b','LineWidth',1.2);
ylim([0 0.7])
% yticks(0:0.15:0.7)
legend("Healthy","MPTP","Sham");
xlabel('Scale','FontSize',12,'FontWeight','bold','Color',[7 54 66]/255)
ylabel('ApEn','FontSize',12,'FontWeight','bold','Color',[7 54 66]/255)
str = ['Multiscale ApEn  $\theta$(\overrightarrow{b_' num2str(2) 'b_' num2str(3) '}',...
                ',\overrightarrow{b_' num2str(3) 'b_' num2str(4) '}' ')'];
title(str,'interpreter','latex')
saveas(gcf,'feature3.png')

%% 2 dimention Cross-approximate entropy
seq=[];
scales=20;
indd =2;
l1 = (cell2mat(seq_var{indd}(2)));
l2 = (cell2mat(seq_var{indd+1}(2)));
seq(1,:) = l1(330:end-330);
seq(2,:) = l2(330:end-330);
seq(1,:) = (seq(1,:)-min(seq(1,:)))./(max(seq(1,:))-min(seq(1,:)));
seq(2,:) = (seq(2,:)-min(seq(2,:)))./(max(seq(2,:))-min(seq(2,:)));

name = string(seq_var{indd}(1))+"與"+string(seq_var{indd+1}(1));
[cap, ~] = XApEn(seq,m=m,tau=tau);
disp("標記點 "+string(seq_var{indd}(1))+" 與 "+string(seq_var{indd+1}(1)));
disp("Cross approximate entropy:");
disp(cap);
% multiscale cross entropy
Mobj = MSobject('XApEn', 'm', m, 'tau', tau);
[~, ~] = XMSEn(seq, Mobj,name,Scales=scales,Plotx=true);
name = ['figure/' '1_XMSEn.png'];
saveas(gcf,name)
