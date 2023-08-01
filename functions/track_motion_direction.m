function index_Array = track_motion_direction(coor,coordi,point_Num) % coor = 初始使用者自定的目標點  ||  coordi = 系統預測點

    for c = 1:point_Num
        head_p = coor(1,:); % 頭
        body_p1 = coor(2,:);
        body_p2 = coor(3,:);
        tail_p = coor(4,:);

        temp_p = coordi{c}; 
        temp_Distance1(c,:) = norm(temp_p-head_p);
        temp_Distance2(c,:) = norm(temp_p-body_p1);
        temp_Distance3(c,:) = norm(temp_p-body_p2);
        temp_Distance4(c,:) = norm(temp_p-tail_p);

        [M1,A1] = min(temp_Distance1);
        [M2,A2] = min(temp_Distance2);
        [M3,A3] = min(temp_Distance3);
        [M4,A4] = min(temp_Distance4);

        head_ID = A1;
        body1_ID = A2;
        body2_ID = A3;
        tail_ID = A4;
    end
    index_Array = [head_ID, body1_ID, body2_ID, tail_ID];
end