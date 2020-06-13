# Notebook-SSR // By: E9965
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/e9965/notebook-ssr/master)


## 錯誤白嫖JuypterNoteBook的方法

- 通過白嫖的JuypterNoteBook&白嫖Ngork的服務器來作酸酸乳用途

- 能力不足, 無法實現BBR(Plus)加速

- 理論上無法支持KCPtun , 因為內網穿透服務難以支持SSR & 客戶端之間的UDP暴力轉發

- 可使用官方Ngork (JP) 的內網穿透服務

- 線上免費:JuypterNoteBook
  - Kaggle [ 9小時 | 無須扶墻重建SSR | 硬盤I/O限制250Mb/s]
  
  - GoogleColab [ 12小時 | 需要扶墻重建SSR | 硬盤I/O限制100Mb/s]
***
### 本搭建過程使用了 "秋水逸冰"大佬 的搭建腳本 && 感謝大佬

`https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh`

### 食用教程
- 將一下命令粘貼到Notebook & 運行就好了

  - 使用Ngork官方
  
    `!chmod +x NOTESSR.sh && ./NOTESSR.sh {Ngroktoken / info} {Your SSR Password}`
    
    - Ngroktoken : Ngrok賬戶的token
    
    - info : 查看目前SSR的鏈接信息
    
    - Your SSR Password : SSR鏈接密碼
  
- 如需修改鏈接端口/協議等 , 請自行修改`shadowsocks-all.sh`腳本
***
### 本源的腳本地址:

`https://raw.githubusercontent.com/e9965/notebook-ssr/master/NOTESSR.sh`

***


## 更新日誌:

- 2020/6/12:筆記本 beta 0.01 
- 2020/6/13:更新NOTESSR2.sh (使用非官方) | 更新NOTESSR.sh (使用Ngork官方) 
- 2020/6/13:刪除NOTESSR2.sh (無效) | 優化NOTESSR.sh邏輯 & ErrorHandling & 其他
- 2020/6/13:優化NOTESSR.sh (可自定義Passwd)
