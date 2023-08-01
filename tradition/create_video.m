enhance_obj = VideoWriter('./other_papers1.mp4');
enhance_obj.FrameRate = 30;
open(enhance_obj);
for i = 1:300
    frame_str_tmp = sprintf('%05d', i);
    disp(frame_str_tmp);
    frame = imread(strcat('D:\Jian\Zebrafish-tracking-analysis-behavior\實驗報告\pone.0154714.s002\code_final\images\CoreView_275_Master_Camera_', frame_str_tmp,'.jpg'));
    frames = im2uint8(frame);
    writeVideo(enhance_obj,frames);
end
close(enhance_obj);


