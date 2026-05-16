# 🦞 開啟／修復助手 V2.0 完整教學

> 阿亮老師為學員打造的**圖形化萬用工具**——雙擊就能啟動 Hermes、診斷環境、修復常見問題、啟動隧道，**全程不用打任何指令**。
> 卡關時把右側日誌截圖傳給阿亮老師，老師就能立刻看到你的環境狀態。

---

## 🎯 這個工具能幫你什麼？

| 你的情境 | 用助手怎麼做 |
|---------|------------|
| 第一次安裝完不知道下一步 | 偵測 9 項看哪些 ✅ 哪些 ❌ → 按提示處理 |
| 龍蝦突然不會回話 | 按「🩺 環境診斷」看哪邊壞了 |
| 想重啟 Gateway | 按「🔁 重啟 Gateway (restart 單步)」一鍵搞定 |
| 要接 LINE 想開隧道 | 按「🌩️ 啟動 Cloudflare Tunnel」省去查指令 |
| 想知道 webhook 通不通 | 按「🩺 Webhook 健康檢查」貼網址即可 |
| 開機後要快速啟動 Hermes Desktop GUI | 按「🖥️ 啟動 Hermes Desktop GUI」 |
| 截圖傳給老師求救 | 按「💾 儲存日誌」存 txt 給老師看 |

---

## 📥 下載與安裝

### Step 1：下載

從教學網站首頁右上角點 **「🦞 開啟/修復助手」** 按鈕，會下載 `HermesHelper-V2.0.zip`（約 10 MB）。

或直接連結：[HermesHelper-V2.0.zip](HermesHelper-V2.0.zip)

### Step 2：解壓縮

解壓縮到任何資料夾，**建議放桌面或 D:\\**，方便每天雙擊使用。

解開後會看到 3 個檔案：

| 檔案 | 大小 | 用途 |
|------|------|------|
| `愛馬仕龍蝦助手.exe` | ~10 MB | ⭐ 一般學員雙擊這個 |
| `hermes_helper.py` | 38 KB | 進階學員 / 防毒擋掉時備援 |
| `使用說明.txt` | 7 KB | 文字版說明（內容跟本頁一樣）|

### Step 3：雙擊執行

雙擊 **`愛馬仕龍蝦助手.exe`**。

#### ⚠ 如果 Windows Defender 跳警告

PyInstaller 打包的 exe 偶爾被誤判為「不常見的程式」。**解法**：

1. 點藍色警告文字「**其他資訊**」
2. 出現「**仍要執行**」按鈕 → 點下去

如果防毒**完全擋掉**（沒有「仍要執行」選項），改用 `hermes_helper.py`：

```powershell
# 先確認有裝 Python 3
python --version

# 開命令列跑 .py
python "你的路徑\hermes_helper.py"
```

---

## 🖥️ V2.0 介面導覽

打開後會看到一個**橘色標題**的視窗。主畫面分**左半邊（操作）**和**右半邊（執行日誌）**。

### 標題列確認版本

```
🦞 愛馬仕龍蝦 HermesAgent 開啟/修復助手 V2.0
```

右上角會顯示 **V2.0 ｜ 2026-05-16**——確認你是新版而不是 V1.0。

---

## 📊 環境狀態偵測（自動 9 項）

開啟後幾秒內，左上「📊 環境狀態」會跑完 9 項偵測：

| 項目 | 看到 ✅ 代表 | 看到 ❌ 代表 | 怎麼處理 |
|------|------------|------------|---------|
| 📂 **安裝資料夾** | 找到 HermesAgent-Installer | 沒在 Downloads | 從教學網站重新下載安裝精靈 |
| 🖥️ **Hermes Desktop GUI** | 偵測到 v0.4.3+ 桌面版 | 未安裝（選裝） | 想用 GUI 就到 [Releases](https://github.com/fathah/hermes-desktop/releases) 下載 |
| 🐧 **WSL2** | Windows 子系統已裝 | 未安裝 | 按下方「⚙️ 跑 install-hermes.exe」 |
| 🐧 **Ubuntu 發行版** | WSL 內 Ubuntu OK | 未安裝 | 同上 |
| 🦞 **hermes (WSL)** | WSL 內 hermes 指令存在 | 未安裝 | 按「🔁 重裝 hermes (WSL 內)」 |
| 🪟 **hermes (Win)** | Windows 原生 hermes | 未安裝（常見） | 沒事，用 WSL 模式就好 |
| 🌩️ **cloudflared** | Cloudflare Tunnel 已裝 | 未安裝 | `winget install Cloudflare.cloudflared` |
| 💚 **config.yaml LINE** | LINE 官方原生已啟用 | 未啟用 / 沒 config.yaml | 跑 `hermes gateway setup` 設定 |
| ✈️ **config.yaml Telegram** | Telegram 已啟用 | 未啟用 / 沒 config.yaml | 跑 `hermes gateway setup` 設定 |

### 「🔄 重新偵測環境」按鈕

裝完任何東西後按這個重新跑一次，看狀態有沒有變綠。

> [!TIP]
> 學員回報問題時，**先按一次「重新偵測」再截圖**，這樣老師能看到最新狀態。

---

## 🚀 啟動 / 停止 / 診斷（6 個按鈕）

### 🟢 啟動 Hermes Gateway

跑 `hermes gateway start`（背景模式，視窗可關）。**最常用的按鈕**，每次開電腦先按這個。

### 🔴 停止 Hermes Gateway

跑 `hermes gateway stop`。要徹底關閉 Gateway 才用，**一般不要按**——要重啟改用下面的「重啟」。

### 🟠 查看 Gateway 狀態

跑 `hermes gateway status`，右側日誌顯示是否運行中、port 是哪個。

### 🟡 環境診斷 (hermes doctor)

跑 `hermes doctor`，會檢查：
- 依賴套件版本（Python、uv、Node.js）
- Bot Token 認證
- 各 platform 連線狀態
- 模型 API 連線

**任何「不知道為什麼壞了」**第一步就按這個。輸出傳給老師最有用。

### 🟣 🔁 重啟 Gateway (restart 單步)

**V2.0 修正點**：跑 `hermes gateway restart`（一個指令），**不是** V1.0 的 stop+start（會卡住）。

> [!WARNING]
> 想叫 AI 自己重啟也記得跟它說「**Restart**」，不要說「Stop 再 Start」——Hermes Gateway 一旦 stop 後可能不會自動 start 起來。

### 🩺 Webhook 健康檢查（V2.0 新功能）

按下去會跳出輸入框，貼上你的隧道 URL（不含後綴），例如：

```
https://hermes.example.com
https://random-abc.trycloudflare.com
```

工具自動加 `/line/webhook/health` 跑 curl 測試。

**結果判讀**：
| 回應 | 意思 |
|------|------|
| 200 + `{"status":"ok","platform":"line"}` | ✅ 通了 |
| 404 | 路徑不對或 Hermes 沒啟用 LINE platform |
| 522/523/524 | Cloudflare 後端連不到本機 — Gateway 沒跑 |
| 連不上 | cloudflared/ngrok 視窗關了？ |

---

## 🔧 修復 / 進階（8 個按鈕）

> 👇 這區在視窗下方，**用滑鼠滾輪往下捲**才能看到所有按鈕。

### 📂 開啟安裝資料夾

直接打開 `HermesAgent-Installer` 那個資料夾，方便你手動改 `.env` 或看 log。

### ⚙️ 跑 install-hermes.exe（管理員）

**V2.0 修正點**：V6.53 起改用 `install-hermes.exe`（取代舊版 `go.bat`）。
按下後會 UAC 彈窗請你按「是」，**然後安裝精靈就在新視窗開了**——可以選 [1] 全部安裝、[3A] 設 Telegram、[3B] 設 LINE 等等。

### 🖥️ 啟動 Hermes Desktop GUI（V2.0 新增）

如果偵測到桌面版 GUI，按下去就會啟動桌面 App。
**沒裝 Desktop GUI 時**會問你要不要去下載頁面。

### 🌩️ 啟動 Cloudflare Tunnel（V2.0 新增，推薦）

跳出小視窗問你要把哪個 port 暴露：

| 選項 | 預設值 | 用在 |
|------|--------|------|
| **8646** | ✅ 推薦 | LINE 官方原生方案 |
| **3000** | | LINE Bridge 方案 |
| 其他 | | 自己決定 |

按 OK 後在新 cmd 視窗跑 `cloudflared tunnel --url http://localhost:{port}`。

**幾秒後會看到 `https://*.trycloudflare.com` URL**，複製貼到 LINE Developers Console 的 Webhook URL。

> [!IMPORTANT]
> Webhook URL 後綴要對：
> - 官方原生 → `/line/webhook`（雙段）
> - Bridge → `/webhook`（單段）

### 🚇 啟動 ngrok 隧道（舊）

跟 Cloudflare Tunnel 類似，但走 ngrok。**V2.0 智能化**：依你的 `config.yaml` 自動推薦 port：
- 偵測到 LINE 官方原生啟用 → 預設 8646
- 否則 → 預設 3000

ngrok 免費版每次 URL 都會變，**長期用建議改 Cloudflare Tunnel**。

### 🌐 啟動 LINE Bridge（只在 Bridge 方案用）

**V2.0 智能化**：偵測到 `config.yaml` 已啟用 LINE 官方原生時，按下去會跳警告：

```
你已啟用 LINE 官方原生
不需要 Bridge（Hermes 內建處理）
你確定還是要啟動 Bridge 嗎？
```

按取消即可。**走官方原生路線的人這個按鈕用不到**。

### 🔁 重裝 hermes（WSL 內）

跑 NousResearch 官方安裝腳本，**大約 3-5 分鐘**。
**會問你 Y/N**——按 Y 才會真的跑。

什麼時候用？
- `hermes doctor` 報依賴壞了
- 升級到最新版
- 卡關卡到不行最後一招

### 🐧 開啟 WSL Ubuntu 終端

直接打開 WSL 命令列，方便你手動下指令。

---

## 📜 右側日誌（即時輸出）

每按一個按鈕，右側日誌就會顯示執行結果。文字顏色含意：

| 顏色 | 意思 |
|------|------|
| 🟢 綠 | 成功 |
| 🔴 紅 | 錯誤 |
| 🟠 橘 | 警告 |
| 🔵 藍 | 一般訊息 |
| 🟡 黃粗體 | 章節標題 |

### 兩個工具按鈕

**🧹 清空日誌**：把右側內容全清掉，方便下次測試。
**💾 儲存日誌**：把當前內容存成 `.txt`，**這個是你卡關時要傳給老師的檔案**。

---

## ❓ 常見問題

### Q1：雙擊 exe 後沒反應？

第一次啟動會慢 **3-5 秒**（PyInstaller 解壓 runtime）。如果超過 10 秒沒視窗：

1. 按 <kbd>Ctrl+Shift+Esc</kbd> 開工作管理員
2. 看「處理程序」分頁有沒有「愛馬仕龍蝦助手.exe」
3. **有但無視窗**：可能是視窗開在螢幕外 → 重啟電腦試試
4. **沒在跑**：可能被防毒擋掉

### Q2：偵測都是 ❌ 怎麼辦？

代表你還沒裝過 Hermes。

1. 按「⚙️ 跑 install-hermes.exe（管理員）」
2. UAC 彈窗按「是」
3. 跟著精靈做 [1] 全部安裝
4. 裝完後**回到本助手按「🔄 重新偵測環境」**

### Q3：偵測「config.yaml LINE/Telegram」顯示「沒 config.yaml」？

代表你**還沒設定過通訊平台**。

**最簡解法**：
1. 按「🐧 開啟 WSL Ubuntu 終端」
2. 在 WSL 內打：
   ```
   hermes gateway setup
   ```
3. 跟著精靈選 Telegram 或 LINE，貼 Token 即可

### Q4：「Webhook 健康檢查」回 522/523/524？

Cloudflare 連不到你電腦。檢查：

1. 按「📊 查看 Gateway 狀態」確認 Gateway 在跑
2. 看 Cloudflare Tunnel 視窗有沒有開著（關了就斷）
3. 防火牆有沒有擋

### Q5：「Webhook 健康檢查」回 404？

兩個可能：

1. **URL 路徑錯**：官方原生用 `/line/webhook`，Bridge 用 `/webhook`，**助手會自動加** `/line/webhook/health`，所以你輸入的 base URL 要對應**官方原生**才正確
2. **config.yaml 沒開 line.enabled**：偵測卡看「config.yaml LINE」是不是 ❌

### Q6：「啟動 LINE Bridge」跳出「你已啟用官方原生」？

**這是 V2.0 的智能提示**，**不是 bug**。

代表你已啟用 Hermes 官方原生 LINE，不需要 Bridge。**按「否」即可**，直接用「🚀 啟動 Gateway」就能用 LINE Bot。

### Q7：視窗下半部按鈕看不到？

**用滑鼠滾輪在左半邊往下捲**。所有按鈕都有，只是視窗高度有限放不下全部，要捲動瀏覽。

---

## 🔄 V2.0 vs V1.0 差異（升級重點）

| 維度 | V1.0 (2026-05-13) | V2.0 (2026-05-16) |
|------|-------------------|-------------------|
| 偵測項目 | 5 項 | **9 項** |
| 重啟 | stop+start（會卡）| **restart 單步** |
| 安裝按鈕 | go.bat | **install-hermes.exe**（V6.53+）|
| Webhook 健檢 | ❌ | ✅ |
| Cloudflare Tunnel | ❌ | ✅ 智能 port |
| Desktop GUI 啟動 | ❌ | ✅ 偵測到才出 |
| LINE Bridge 智能提示 | ❌ | ✅ 偵測官方原生會警告 |
| 左側可捲動 | ❌ | ✅ 滑鼠滾輪 |

**有 V1.0 的學員**：直接下載 V2.0.zip 覆蓋舊的就好，不影響任何資料。

---

## 🆘 卡關 SOS 流程

1. 按 **🩺 環境診斷** 跑一次
2. 按 **🔄 重新偵測環境**
3. **💾 儲存日誌** 存成 .txt
4. 在 FB 社團或 Email 傳給阿亮老師：
   - 截圖：偵測 9 項那塊
   - 附件：步驟 3 存的 .txt
   - 描述：你按了什麼按鈕、看到什麼錯誤訊息

老師看到日誌就能立刻判斷哪邊壞了，**比學員口述狀況效率高 10 倍**。

---

## 📞 聯絡資訊

| 管道 | 連結 |
|------|------|
| 📧 Email | iddmail@ycsh.tp.edu.tw |
| 📺 YouTube | [@Liang-yt02](https://www.youtube.com/@Liang-yt02) |
| 👥 FB 社團 | [愛馬仕龍蝦學員社團](https://www.facebook.com/groups/2754139931432955) |
| 🌐 教學網站 | [hermes-lobster.netlify.app](https://hermes-lobster.netlify.app) |

---

> [!TIP]
> 這個助手會持續更新，未來版本可能新增更多偵測項目和按鈕。
> 看標題列 **V2.0 ｜ 2026-05-16** 確認你是不是最新版，舊版下載重灌即可。
