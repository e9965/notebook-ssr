# Notebook-SSR // By: E9965
  * [錯誤白嫖JuypterNoteBook的方法 & 簡介](#錯誤白嫖JuypterNoteBook的方法-&-簡介)
    + [食用教程](#食用教程)
      - [食用栗子](#食用栗子)
    + [其他](#其他)
  * [更新日誌](#更新日誌)
***
## 錯誤白嫖JuypterNoteBook的方法 & 簡介
```
- 通過白嫖的JuypterNoteBook&白嫖Ngork的服務器來作酸酸乳用途
- 使用Ngork官方JP服務器
- 能力不足, 無法實現BBR(Plus)加速
- 理論上無法支持KCPtun , 因為內網穿透服務難以支持SSR & 客戶端之間的UDP暴力轉發
- 可使用官方Ngork (JP) 的內網穿透服務
- 線上免費:JuypterNoteBook
  - Kaggle [ 9小時 | 無須扶墻重建SSR | 硬盤I/O限制250Mb/s]
  - GoogleColab [ 12小時 | 需要扶墻重建SSR | 硬盤I/O限制100Mb/s]
  - DEEPNOTE [ 理論無限 | 無須扶墻重建SSR | 硬盤I/O限制為160Mb/s | 10GBps高速網絡 ]
```  
***
### 食用教程
- 將一下命令粘貼到Notebook & 運行就好了

```
{Ngroktoken}        : Ngrok賬戶的token
{Your SSR Password} : SSR鏈接密碼
{info}              : 查看目前SSR的鏈接信息
```

*如需修改鏈接端口/協議等 , 請自行修改`NOTESSR.sh`腳本*
#### 食用栗子
![alt text](https://github.com/e9965/notebook-ssr/raw/master/EXAMPLE.png)

1. 打開ColabNoteBook/Kaggle，輸入以下命令

```
!wget -q -O NOTESSR.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/NOTESSR.sh && chmod +x NOTESSR.sh
!./NOTESSR.sh ${NgrokToken} ${Your SSR Passwd}
```
***

【DEEPNOTE】特別版
1. 打開DEEPNOTE並新建Project&Terminal，分別輸入以下兩條命令

```
sudo su
wget -q -O NOTESSR.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/DEEPNOTE.sh && chmod +x NOTESSR.sh && ./NOTESSR.sh ${Your SSR Passwd}
```

2.返回DEEPNOTE的Jupyter NoteBook，輸入以下命令
```
!sudo apt update -y && sudo apt-get install stress-ng -y > /dev/null 2>&1 && stress-ng -c 0 -l 10 > /dev/null 2>&1
```

***

本源的腳本地址:

`https://raw.githubusercontent.com/e9965/notebook-ssr/master/NOTESSR.sh`
***
## 更新日誌

- 2020/6/12:筆記本 beta 0.01 
- 2020/6/13:更新NOTESSR2.sh (使用非官方) | 更新NOTESSR.sh (使用Ngork官方) 
- 2020/6/13:刪除NOTESSR2.sh (無效) | 優化NOTESSR.sh邏輯 & ErrorHandling & 其他
- 2020/6/13:優化NOTESSR.sh (可自定義Passwd)
- 2020/10/18:推出正式版（整合ver&运行速度Up）
- 2020/10/21:針對DEEPNOTE平台推出特別版
