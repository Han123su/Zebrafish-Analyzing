
function [ori_data, seq_var] = extract_feature(coordi,point_Id,save_dir,fnum,fs, save_img)
    clear v_ind;
    prompt1 = ['請輸入模式【1:多個點隨時間變化的角度】【2:兩點前後Frame角度隨時間的變化】' ...
        '【3:每三個Frames計算單點角度隨時間的角度變化】''【4:與XY軸的夾角】' '【5:EXIT】:'];
    
    input_v1 = 0;
    seq_var = {};
    ori_data = {};
    c = 1; 
    
    while(input_v1~=5)
        input_v1= 0;
        v_ind = 0;
        while(input_v1 ~= 1 && input_v1 ~= 2 && input_v1 ~= 3  && ...
                input_v1 ~= 4 && input_v1 ~= 5)
            input_v1 = input(prompt1);
    
            if(input_v1 ~= 1 && input_v1 ~= 2 && input_v1 ~= 3  && ...
                    input_v1 ~= 4  && input_v1 ~= 5)
                disp('模式輸入只有【1】、【2】、【3】、【4】、【5】');
            end
        end
    
        if input_v1 ==1
            prompt2 = '請輸入欲查詢角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:12) : ';
            prompt3 = '請輸入欲查詢角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:34) : ';
            input_v2 = input(prompt2);
            input_v3 = input(prompt3);
    
        elseif input_v1 ==2
            prompt2 = '請輸入欲查詢角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:12) : ';
            input_v2 = input(prompt2);
    
        elseif input_v1 ==3
            prompt2 = '請輸入欲查詢角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:1) : ';
            input_v2 = input(prompt2);
    
        elseif input_v1 ==4
            prompt2 = '輸出XY軸所夾的角度';
            disp(prompt2)
        else
            break;
        end
    
        if input_v1 == 1 && floor(log10(input_v2))+1 == 2 && floor(log10(input_v3))+1 == 2 % 檢查位數是否為2 [12] [34] 之類的
            v_ind = read_number(input_v2,input_v3); 
        elseif input_v1 ==2 && floor(log10(input_v2))+1 == 2
            v_ind(1) = floor(input_v2/10);
            v_ind(2) = mod(input_v2,10);
        elseif input_v1 ==3 && floor(log10(input_v2))+1 == 1
            v_ind = input_v2;
        elseif (input_v1 ==1 && (floor(log10(input_v2))+1 ~= 2 || floor(log10(input_v3))+1 ~= 2)) ||(input_v1==2 && floor(log10(input_v2))+1~=2)
            error("輸入位數超出範圍，請檢查輸入值是否為兩位數，例如 : 【12】【34】");
        elseif (input_v1 ==3 && floor(log10(input_v2))+1 ~= 1)
            error("輸入位數超出範圍，請檢查輸入值是否一位數");
        end
    
        % Be carefully!! You have to check again this video's fs.
        t = (1:fnum)/fs;
    
        for i = 1:fnum
            arr_coor = [];
            arr_coor2 = [];
            arr_coor_next = [];
            arr_coor = [arr_coor;coordi{point_Id(1)}(i,2),coordi{point_Id(1)}(i,1)];
            arr_coor = [arr_coor;coordi{point_Id(2)}(i,2),coordi{point_Id(2)}(i,1)];
            arr_coor = [arr_coor;coordi{point_Id(3)}(i,2),coordi{point_Id(3)}(i,1)];
            arr_coor = [arr_coor;coordi{point_Id(4)}(i,2),coordi{point_Id(4)}(i,1)];
            if input_v1 == 4
                % --------------------------------x軸夾角--------------------------------2
                parallel_point2 = arr_coor(2,:)+[0,2];
    
                v2 = arr_coor(1,:)-arr_coor(2,:);
                v1 = parallel_point2-arr_coor(2,:);
                v1_dot_v2 = dot(v1,v2);
                v1_cross_v2 = v1(1)*v2(2) - v1(2)*v2(1);
    
                angle = atan2(v1_cross_v2, v1_dot_v2);
                x_axis_angle(i) = angle*180/pi;
    
                % --------------------------------Y軸夾角--------------------------------
                if i~=fnum; check_Space_y = i+1; else; check_Space_y = i; end
                arr_coor_next = [arr_coor_next;coordi{point_Id(1)}(check_Space_y,2),coordi{point_Id(1)}(check_Space_y,1)];
                vertical_point2 = arr_coor(1,:)+[2,0];
    
                v2 = arr_coor_next(1,:)-arr_coor(1,:);
                v1 = vertical_point2-arr_coor(1,:);
    
                v1_dot_v2 = dot(v1,v2);
                v1_cross_v2 = v1(1)*v2(2) - v1(2)*v2(1);
    
                angle_y = atan2(v1_cross_v2, v1_dot_v2);
                realangle_y = angle_y*180/pi;
                if sign(realangle_y)~=true;realangle_y=360+realangle_y;end
                y_axis_angle(i) = (realangle_y);
    
            else
    
                if input_v1 == 1
                    v1 = arr_coor(v_ind(1),:)-arr_coor(v_ind(2),:);
                    v2 = arr_coor(v_ind(4),:)-arr_coor(v_ind(3),:);
    
                elseif input_v1 ==2
                    if i~=fnum; nxt = i+1; else; nxt = i; end
                    arr_coor2 = [arr_coor2;coordi{point_Id(1)}(nxt,2),coordi{point_Id(1)}(nxt,1)];
                    arr_coor2 = [arr_coor2;coordi{point_Id(2)}(nxt,2),coordi{point_Id(2)}(nxt,1)];
                    arr_coor2 = [arr_coor2;coordi{point_Id(3)}(nxt,2),coordi{point_Id(3)}(nxt,1)];
                    arr_coor2 = [arr_coor2;coordi{point_Id(4)}(nxt,2),coordi{point_Id(4)}(nxt,1)];
                    v1 = arr_coor(v_ind(1),:) - arr_coor(v_ind(2),:);
                    v2 = arr_coor2(v_ind(1),:) - arr_coor2(v_ind(2),:);
    
                elseif input_v1 ==3
                    if i~=fnum; nxt = i+1; else; nxt = i; end
                    if i<=fnum-2; nxtt = i+2;end
                    arr_coor2 = [arr_coor2;coordi{point_Id(1)}(nxt,2),coordi{point_Id(1)}(nxt,1),coordi{point_Id(1)}(nxtt,2),coordi{point_Id(1)}(nxtt,1)];
                    arr_coor2 = [arr_coor2;coordi{point_Id(2)}(nxt,2),coordi{point_Id(2)}(nxt,1),coordi{point_Id(2)}(nxtt,2),coordi{point_Id(2)}(nxtt,1)];
                    arr_coor2 = [arr_coor2;coordi{point_Id(3)}(nxt,2),coordi{point_Id(3)}(nxt,1),coordi{point_Id(3)}(nxtt,2),coordi{point_Id(3)}(nxtt,1)];
                    arr_coor2 = [arr_coor2;coordi{point_Id(4)}(nxt,2),coordi{point_Id(4)}(nxt,1),coordi{point_Id(4)}(nxtt,2),coordi{point_Id(4)}(nxtt,1)];
               
                    v1 = arr_coor2(v_ind(1),1:2)-arr_coor(v_ind(1),:);
                    v2 = arr_coor2(v_ind(1),3:4)-arr_coor2(v_ind(1),1:2);
    
                end
        
                v1_dot_v2 = dot(v1,v2);
                v1_cross_v2 = v1(1)*v2(2) - v1(2)*v2(1);
        
                angle = atan2(v1_cross_v2, v1_dot_v2);
                realangle = angle*180/pi;
    
                if sign(realangle)~=true && input_v1~=3 && input_v1~=2;realangle=realangle+360;else;...
                        realangle = (realangle);end
        
                angle_Array(i) = realangle;
        
                % delete 多餘的空間
                if input_v1==2 && i==fnum
                    angle_Array = angle_Array(1:fnum-1);
                elseif input_v1==3 && i==fnum
                    angle_Array = angle_Array(1:fnum-2);
                end
            end
    
        end
        
    
        if input_v1~=4
            res_angle =angle_Array;
            angle_dif=diff(angle_Array);
        else
            y_axis_angle = y_axis_angle(1:end-1);
        end
    
        % --------------------------運動間隔時間--------------------------------
%         if input_v1 ==1
%             y= lowpass(angle_dif,1,fs);
%             globe_threshold = mean(abs(y));
%         
%             [pks,locs] = findpeaks(y,'MinPeakHeight',globe_threshold,'MinPeakDistance',120); %每0.5秒間不得有第二個peak
%             locs2= find(y>-globe_threshold&y<globe_threshold);
%             low_threshold = mean(abs(y(locs2)));
%             locs3 = find(y<=low_threshold & y>=-low_threshold);
%     
%             [B,TF] = rmoutliers(diff(locs3));
%             TF(end+1) = 0;
%             kk = ~TF.*locs3;
%             indices = find(kk>0);
%             locs4 = kk(indices);
%         
%             EI = []; %exercise interval
%             for i =1:length(locs)+1
%                 if i==1
%                     tmp_ind = locs4<locs(i);
%                     tmp = tmp_ind.*locs4;
%                 elseif i==length(locs)+1
%                     tmp_ind = locs4>locs(i-1);
%                     tmp = tmp_ind.*locs4;
%                 else
%                     tmp_ind = locs(i-1)<locs4 & locs4<locs(i);
%                     tmp = tmp_ind.*locs4;
%                 end
%         
%                 s_time = min(nonzeros(tmp));
%                 e_time = max(nonzeros(tmp));
%         
%                 if e_time-s_time<240 % 1s
%                     if sum(tmp>0)< 60 % 休息間隔得超過0.25s
%                         s_time =[];
%                         e_time =[];
%                         locs4(tmp_ind)=[];
%                     end
%                 end
%                 EI = [EI, e_time-s_time];
%             end
%             EI = EI./240;
%     %         disp("運動間隔時間:");
%     %         disp(EI);
%         end
    
        % 計算Zebrafish 游動方向
        if input_v1==4
            move_direction = judge_direction(x_axis_angle);
            disp("a: 右上, b:左上, c: 左下, d:右下")
            disp(move_direction);
        end
    
        
        % Visualize
        if input_v1==1
            figure(1),
            subplot(311),plot(t,angle_Array);
            
            str = ['$\theta$(\overrightarrow{b_' num2str(v_ind(1)) 'b_' num2str(v_ind(2)) '}',...
                ',\overrightarrow{b_' num2str(v_ind(3)) 'b_' num2str(v_ind(4)) '}' ')'];
            title(str,'interpreter','latex')
            xlabel('Time (sec)');ylabel('Angle');

            subplot(312),plot(t,[0,angle_dif]);
            str = ['Difference in $\theta$(\overrightarrow{b_' num2str(v_ind(1)) 'b_' num2str(v_ind(2)) '}',...
                '\overrightarrow{b_' num2str(v_ind(3)) 'b_' num2str(v_ind(4)) '}' ')' 'between $f_i$ and $f_{i-1}$'];
            title(str,'interpreter','latex')
            xlabel('Time (sec)');ylabel('Angle');

%             subplot(313)
%             plot(t,[0,y],locs4./240,y(locs4),'o',locs./240,pks,'*b'),title("運動間隔")
    
        elseif input_v1==2
            figure(2),
            subplot(211),plot((1:length(angle_Array))/fs, angle_Array);
            xlabel('Time (sec)');ylabel('Angle');
            str = ['$\theta$($f_1$(\overrightarrow{b_' num2str(v_ind(1)) 'b_' num2str(v_ind(2)) '})',... 
                ',$f_2$(\overrightarrow{b_' num2str(v_ind(1)) 'b_' num2str(v_ind(2)) '}))'];
            title(str,'interpreter','latex')

            subplot(212),plot((1:length(angle_dif))/fs, angle_dif);
            str = ['Diffrerence in angle($f_1$(\overrightarrow{b_' num2str(v_ind(1)) 'b_' num2str(v_ind(2)) '})',... 
                ',$f_2$(\overrightarrow{b_' num2str(v_ind(1)) 'b_' num2str(v_ind(2)) '}))' 'between $f_i$ and $f_{i-1}$'];
            title(str,'interpreter','latex')

            xlabel('Time (sec)');ylabel('Angle');
    
        elseif input_v1==3
            figure(3),
            subplot(211),plot((1:length(angle_Array))/fs,angle_Array);
            str = ['$\theta$(\overrightarrow{f_1(b_' num2str(v_ind(1)) ')f_2(b_' num2str(v_ind(1)) ')}',... 
                ',\overrightarrow{f_2(b_' num2str(v_ind(1)) ')f_3(b_' num2str(v_ind(1)) ')})'];
            title(str,'interpreter','latex')


            xlabel('Time (sec)');ylabel('Angle');
            subplot(212),plot((1:length(angle_dif))/fs, angle_dif);
            str = ['Difference in $\theta$(\overrightarrow{f_1(b_' num2str(v_ind(1)) ')f_2(b_' num2str(v_ind(1)) ')}',... 
                ',\overrightarrow{f_2(b_' num2str(v_ind(1)) ')f_3(b_' num2str(v_ind(1)) ')})' 'between $f_i$ and $f_{i-1}$'];
            title(str,'interpreter','latex')

            xlabel('Time (sec)');ylabel('Angle');
    
        elseif input_v1==4
            figure(4),
            subplot(211),plot(t,x_axis_angle),
            str = '$\theta$(\overrightarrow{b_1b_2}, X-axis)';
            title(str,'interpreter','latex')

            xlabel('Time (sec)');ylabel('Angle');
            subplot(212),plot((1:length(y_axis_angle))/fs, y_axis_angle),
            str = '$\theta$(\overrightarrow{f_1(b_1)f_2(b_2)}, Y-axis)';
            title(str,'interpreter','latex')

            xlabel('Time (sec)');ylabel('Angle');
        end
        name = [save_dir int2str(c) '-feature.png'];
        if save_img
            saveas(gcf,name)
        end
        if input_v1~=4
            ori_data{c} = { convertCharsToStrings(mat2str(v_ind)), angle_Array};
            seq_var{c} = { convertCharsToStrings(mat2str(v_ind)),angle_dif};
            c=c+1;
        else
            ori_data{c} = { "X",x_axis_angle};
            ori_data{c+1} = { "Y",y_axis_angle};
            seq_var{c} = { "X",diff(x_axis_angle)};
            c=c+2;
        end
        if c>10
            c =1;
            seq_var={};
            ori_data={};
            break;
        end
    
    end
    if input_v1 ==5
        disp("----------------EXIT!!--------------");
    end
end
