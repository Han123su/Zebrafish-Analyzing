%% Crop ROI
function crop_ROI(cal_Image_Size,coordi,point_Id,save_ROI_Folder,fnum)
    str_tmp = strcat(int2str(1), '.png');
    tempSize = size(imread(strcat('./' + string(cal_Image_Size) + '/', str_tmp)));
    windowSize = 200;
    rowSize = tempSize(1);
    colSize = tempSize(2);
    roi_array = [];

    if exist('ROI','dir')==0; mkdir('ROI'); end
    
    for i = 1:fnum
        disp(i);
        str_tmp = strcat(int2str(i), '.png');
        crop_img(:,:,:,1) = imread(strcat('./' + string(cal_Image_Size) + '/', str_tmp));
        save_file_name = strcat('./' + string(save_ROI_Folder) + '/', str_tmp);
    
        
        saveRow = int64(coordi{point_Id(2)}(i,1));
        saveCol = int64(coordi{point_Id(2)}(i,2)); 
    
        new_saveRow = 0;
        new_saveCol = 0;
    
        % image save -> (1920,1080)
        % 左
        if saveRow<=windowSize && saveCol>=windowSize
            disp("第一層");
            new_saveRow = windowSize-saveRow;
%             bright_img(:,:,:,i) = crop_img(saveCol-(windowSize-1):saveCol+windowSize, saveRow-(saveRow-1):saveRow+windowSize+new_saveRow, :, i);
            imwrite(crop_img(saveCol-(windowSize-1):saveCol+windowSize, saveRow-(saveRow-1):saveRow+windowSize+new_saveRow, :, 1), save_file_name);
    
        % 上
        elseif saveCol<=windowSize && saveRow>=windowSize
            disp("第二層");
            new_saveCol = windowSize-saveCol;
%             bright_img(:,:,:,i) = crop_img(saveCol-(saveCol-1):saveCol+windowSize+new_saveCol, saveRow-(windowSize-1):saveRow+windowSize,:,i);
            imwrite(crop_img(saveCol-(saveCol-1):saveCol+windowSize+new_saveCol, saveRow-(windowSize-1):saveRow+windowSize,:,1), save_file_name);
    
        % 左+上
        elseif saveRow<=windowSize && saveCol<=windowSize
            disp("第三層");
            new_saveRow = windowSize-saveRow;
            new_saveCol = windowSize-saveCol;
    
%             bright_img(:,:,:,i) = crop_img(saveCol-(saveCol-1):saveCol+windowSize+new_saveCol, saveRow-(saveRow-1):saveRow+windowSize+new_saveRow, :, i);
            imwrite(crop_img(saveCol-(saveCol-1):saveCol+windowSize+new_saveCol, saveRow-(saveRow-1):saveRow+windowSize+new_saveRow, :, 1), save_file_name);
    
        % 右上
        elseif saveRow>=colSize-windowSize && saveCol<=windowSize %
            disp("右上");
            new_saveRow = saveRow-windowSize;
            check_Right = colSize-saveRow;
            add_Re_Left = windowSize - check_Right;
    
            new_saveCol = windowSize-saveCol;
    
%             bright_img(:,:,:,i) = crop_img(saveCol-(saveCol-1):saveCol+windowSize+new_saveCol,saveRow-(windowSize-1)-add_Re_Left:colSize,:,i);
            imwrite(crop_img(saveCol-(saveCol-1):saveCol+windowSize+new_saveCol,saveRow-(windowSize-1)-add_Re_Left:colSize,:,1), save_file_name);
    
        % 右
        elseif saveRow>=colSize-windowSize && saveCol<=rowSize-windowSize
            disp("第四層");
            new_saveRow = saveRow-windowSize;
            check_Right = colSize-saveRow;
            add_Re_Left = windowSize - check_Right;
%             bright_img(:,:,:,i) = crop_img(saveCol-(windowSize-1):saveCol+windowSize,saveRow-(windowSize-1)-add_Re_Left:colSize,:,i);
            imwrite(crop_img(saveCol-(windowSize-1):saveCol+windowSize,saveRow-(windowSize-1)-add_Re_Left:colSize,:,1), save_file_name);
        % 下
        elseif saveCol>=rowSize-windowSize && saveRow<=colSize-windowSize
            disp("第五層");
            new_saveCol = saveCol-windowSize;
            check_Under = rowSize-saveCol;
            add_Re_Top = windowSize - check_Under;
%             bright_img(:,:,:,i) = crop_img(saveCol-(windowSize-1)-add_Re_Top:rowSize,saveRow-(windowSize-1):saveRow+windowSize,:,i);
            imwrite(crop_img(saveCol-(windowSize-1)-add_Re_Top:rowSize,saveRow-(windowSize-1):saveRow+windowSize,:,1), save_file_name);
        % 左+下
        elseif saveCol>=rowSize-windowSize && saveRow<=windowSize % 
            disp("左+下");
            new_saveRow = windowSize-saveRow;
    
            new_saveCol = saveCol-windowSize;
            check_Under = rowSize-saveCol;
            add_Re_Top = windowSize - check_Under;
%             bright_img(:,:,:,i) = crop_img(saveCol-(windowSize-1)-add_Re_Top:rowSize,saveRow-(saveRow-1):saveRow+windowSize+new_saveRow,:,i);
            imwrite(crop_img(saveCol-(windowSize-1)-add_Re_Top:rowSize,saveRow-(saveRow-1):saveRow+windowSize+new_saveRow,:,1), save_file_name);
    
        % 右+下
        elseif saveRow>=colSize-windowSize && saveCol>=rowSize-windowSize
            disp("第六層");
            new_saveRow = saveRow-windowSize;
            check_Right = colSize-saveRow;
            add_Re_Left = windowSize - check_Right;
    
            new_saveCol = saveCol-windowSize;
            check_Under = rowSize-saveCol;
            add_Re_Top = windowSize - check_Under;
    
%             bright_img(:,:,:,i) = crop_img(saveCol-(windowSize-1)-add_Re_Top:rowSize,saveRow-(windowSize-1)-add_Re_Left:colSize,:,i);
            imwrite(crop_img(saveCol-(windowSize-1)-add_Re_Top:rowSize,saveRow-(windowSize-1)-add_Re_Left:colSize,:,1), save_file_name);
        
        elseif (colSize-windowSize<=saveRow || saveRow>=windowSize) && (rowSize-windowSize<=saveCol || saveCol>=windowSize)
            disp("第七層");
%             bright_img(:,:,:,i) = crop_img(saveCol-(windowSize-1):saveCol+windowSize,saveRow-(windowSize-1):saveRow+windowSize,:,i);
            imwrite(crop_img(saveCol-(windowSize-1):saveCol+windowSize,saveRow-(windowSize-1):saveRow+windowSize,:,1), save_file_name);
        end
        clear crop_img;
    end
end
