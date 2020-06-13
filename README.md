# notebook-ssr
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/e9965/notebook-ssr/master)


## 錯誤白嫖JuypterNoteBook的方法

- 通過白嫖的JuypterNoteBook&白嫖Ngork的服務器來作酸酸乳用途

- 能力不足, 無法實現BBRPlus加速

- 理論上無法支持KCPtun , 因為內網穿透服務難以支持SSR & 客戶端之間的UDP暴力轉發

- 可使用官方Ngork or Servo 的內網穿透服務
***
### 本搭建過程使用了 "秋水逸冰"大佬 的搭建腳本 && 感謝大佬

`wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh`

### 食用教程
- 將一下命令粘貼到Notebook & 運行就好了
`!wget -O NOTESSR.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/NOTESSR.sh > /dev/null 2>&1 && chmod +x NOTESSR.sh && ./NOTESSR.sh`


- 如需修改鏈接密碼/協議等 , 請自行修改sh腳本
***


## 更新日誌:

- 2020/6/12:筆記本 ver0.01 
- 2020/6/13:更新NOTESSR2.sh (使用Servo) | 更新NOTESSR.sh (使用Ngork官方) 
