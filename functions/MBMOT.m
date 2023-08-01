%% Motion-Based Multiple Object Tracking
% This example shows how to perform automatic detection and motion-based
% tracking of moving objects in a video from a stationary camera.
%   origin: https://ww2.mathworks.cn/help/vision/ug/motion-based-multiple-object-tracking.html
%   Copyright 2014 The MathWorks, Inc.
function [coordi,point_Id,count] = MBMOT(select_Point_Img_Folder,select_Video_Folder,output_Img_Folder)
% select_Point_Img_Folder ='../datasets/injection-sham/imgs/CROP_IMG-sham3';
% select_Video_Folder = 'zebrafish_res-sham3.mkv';
% output_Img_Folder= 'run';
    disp("Compress any keyboard buttion. And mark the point.")
    if exist(output_Img_Folder,'dir')==0; mkdir(output_Img_Folder); end

    temp_Img = imread(strcat('./' + string(select_Point_Img_Folder) + '/', strcat(int2str(1), '.png')));
    n = 4;
    cout = 1;
    f = figure;
    imshow(temp_Img);
    hold on
    coor = [];
%     ori_coordi=[];
    i = 1;
    while(i<=n)
        keydown = waitforbuttonpress;
        if (keydown == 1) 
            [x,y] = ginput(1);
            coor = [coor;[x,y]];
            i = i+1;
            plot(x,y,'r*');
        end
    end
    hold off
    close(f);
    imcoor = coor;
    save imcoor imcoor;
    for k = 1:n; coordi{k}=[];end
%     for k = 1:n; ori_coordi{k}=[];end
    lostInds = false(1,4);
    
    reader = vision.VideoFileReader(string(select_Video_Folder));
  
    maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);
    videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
    
    % Create System objects for foreground detection and blob analysis
    
    % 使用Blob 來捕捉連通域藉此得到 boundary邊框、 centroid中心點
    blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', true, 'CentroidOutputPort', true, ...
        'MinimumBlobArea', 10);
    
    tracks = struct(...
                'id', {}, ...
                'bbox', {}, ...
                'kalmanFilter', {}, ...
                'age', {}, ...
                'totalVisibleCount', {}, ...
                'consecutiveInvisibleCount', {});
    nextId = 1; % ID of the next track
    
    % save centtroid index 
    count =0;
    while ~isDone(reader)
        frame = step(reader);

        count = count+1;
        % change sigle to logical
        gray_f = rgb2gray(frame);
        T = graythresh(gray_f);
        mask = im2bw(gray_f,T);

        [~, centroids, bboxes] = step(blobAnalyser,mask);  


%         for i =1:n
%             ori_coordi{i} = [ori_coordi{i};centroids(i,:)];
%         end
        
        % Predict New Locations of Existing Tracks
        for i = 1:length(tracks)
                bbox = tracks(i).bbox;
                % Predict the current location of the track.
                predictedCentroid = predict(tracks(i).kalmanFilter);
                % we can take the predicted location to array ------------------ 
                % 在這邊可以抓到kalmanfilter預測過後藉由predict func預測的trace 點
    
                % Shift the bounding box so that its center is at 
                % the predicted location. 轉為預測的邊框
    
                predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
                tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    
        % Assign Detections to Tracks
        nTracks = length(tracks);
        nDetections = size(centroids, 1);
        
        % Compute the cost of assigning each detection to each track.歐肌理得距離
        % 驗證預測的trace 點與 新檢測到的點 計算歐基里德距離
        cost = zeros(nTracks, nDetections);

            
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end

        % 配合assgnDetectiontoTracke 根據域值去計算
        % Solve the assignment problem.
        costOfNonAssignment = 20; %代價可以設大一點，免得有人沒做事
    
        % 代表col 對col的代價最小
        % unassignedTracks剩下的點(人)   unassignedDetections剩下的任務
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
        disp("沒做事:"+unassignedTracks);
        disp("剩下的任務:"+unassignedDetections);
    
        % Update Assigned Tracks
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);
            
            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;
            
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
    
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
        
        
        % Delete Lost Tracks-----------------------------------------
        if ~isempty(tracks)
            invisibleForTooLong = 30;
            ageThreshold = 18;
            
            % Compute the fraction of the track's age for which it was visible.
            ages = [tracks(:).age];
            totalVisibleCounts = [tracks(:).totalVisibleCount];
            visibility = totalVisibleCounts ./ ages;
            
            % Find the indices of 'lost' tracks.
            lostInds = (ages < ageThreshold & visibility < 0.6) | ...
                [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
            
            % Delete lost tracks.
            tracks = tracks(~lostInds);
        end
        
        
        % Create New Tracks----------------------------------------
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        
        if size(tracks,2)<n
            for i = 1:size(centroids, 1)
            
                centroid = centroids(i,:);
                bbox = bboxes(i, :);
                
                % Create a Kalman filter object.
                kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                    centroid, [50, 15], [25, 10], 25);
                
                % Create a new track.
                newTrack = struct(...
                    'id', nextId, ...
                    'bbox', bbox, ...
                    'kalmanFilter', kalmanFilter, ...
                    'age', 1, ...
                    'totalVisibleCount', 1, ...
                    'consecutiveInvisibleCount', 0);
    
        
                % Add it to the array of tracks.
                tracks(end + 1) = newTrack;
        
                % 加進來的新的追蹤點必須要按照先前的index排列
                if ~isempty(tracks) && sum(lostInds)>0 && length(tracks)<5
                    arr = false(1,size(tracks,2));
                    idx = find(lostInds>0);
                    arr(idx) = true;
                    total_lost = sum(arr);
                    tmp(~arr) = tracks(1:end-total_lost);
                    tmp(arr) = tracks(end-total_lost+1:end);
                    tracks = tmp;
                    disp("lost"+idx+"-->sort"+nextId);
                end
                    
                % Increment the next id.
                nextId = nextId + 1;
            end
        end
 
        % display tracing results
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
        minVisibleCount =6;
        % 這邊可以調低一些 主要就是過幾次才能算追蹤到
    
        if ~isempty(tracks)
              
            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than 
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                % Create labels for objects indicating the ones for 
                % which we display the predicted rather than the actual 
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);
                
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end
        % 保護機制防止未抓取到trace點
        % 應該要把for 迴圈拿到try外面做
        try
            for i =1:n
                coordi{i} = [coordi{i};[tracks(i).kalmanFilter.State(1), tracks(i).kalmanFilter.State(3)]];
            end
            if cout == 1
                point_Id = track_motion_direction(coor, coordi, n); % 1:頭 | 2:身體1 | 3:身體2 | 4:尾巴
            end
            cout = cout + 1;
        catch    
            for i=1:n-1
                if length(coordi{i})~= length(coordi{i+1})
                    if length(coordi{i})> length(coordi{i+1});coordi{i+1} = [coordi{i+1};[nan, nan]];fillmissing(coordi{i+1},'previous');...
                    else; coordi{i} = [coordi{i};[nan, nan]];fillmissing(coordi{i},'previous');end
    %                 coordi{i} = [coordi{i};[nan, nan]];
                    
                end
            end
        end
    
        % Display the mask and the frame.
        step(maskPlayer, mask);
        step(videoPlayer, frame);
        name = [output_Img_Folder '/' int2str(count) '.png'];
        imwrite(frame,name);
        
    end

end
