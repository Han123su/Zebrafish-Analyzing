# Zebrafish-Analyzing


## 資料讀取格式
1. `read_data.m` 檔要確認讀取的 `.txt` 檔裡面的資料格式，並確認是放置幾個關節點。
2. coordi 變數存取的資料格式為 <頭部, 身體1, 身體2, 尾部>, 其他為 <中心點, Contour, curve_rate, 尾部AUC面積>。(此為4點的資料格式)
3. coordi 變數存取的資料格式為 <頭部, 身體中心點, 尾部, Contour, curve_rate, 尾部AUC面積>。(此為3點的資料格式)
4. 舊版的讀取格式為 `.csv`

## 提取運動特徵
1. 將 `coordi` 變數輸入至 `extract_feature` 函數，並設置好參數，其中 boolean 值為是否要存下 time series 圖片。
2. 共有4種模式如下:
```bash
【1:多個點隨時間變化的角度】【2:兩點前後Frame角度隨時間的變化】【3:每三個Frames計算單點角度隨時間的角度變化】【4:與XY軸的夾角】【5:EXIT】

1範例: 角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:12),角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:34)
2範例: 角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:12) 輸入兩次
3範例: 角度範圍組【1:頭】【2:身體】【3:身體2】【4:尾部】(範例:1)
```
3. 輸出為 ori_data 為夾角，seq_var 夾角差。
4. 軌跡由 `trajectory.m` 繪製。
5. 距離、速度由 `Distance.m` 計算。(注意: 影片的幀數、解析度大小)
6. `evaluate.m` 包含了 Approximate entropy、Multiscale entropy計算，輸入為先前所得到的 ori_data、seq_var。
