# 🌩️ Cloudflare Tunnel 完整教學（取代 ngrok）

> **Cloudflare Tunnel**（簡稱 `cloudflared`）是 Cloudflare 提供的**免費**反向代理服務。
> 在 LINE 官方原生方案、Bridge 方案、或任何需要「把本機 port 暴露到網際網路」的場景，都可以**取代 ngrok**。
> 比 ngrok 強的地方：**完全免費** + **URL 可固定**（綁自己網域）+ **沒每月流量限制**。

---

## Cloudflare Tunnel vs ngrok 完整對照

| 比較項目 | 🌩️ Cloudflare Tunnel | 🚇 ngrok |
|---------|---------------------|---------|
| **基本費用** | ✅ **完全免費** | 免費版有限制 |
| **URL 是否固定** | ✅ 綁網域後永久固定 | ❌ 免費版每次重啟變 URL |
| **流量限制** | ✅ 無限制 | 免費版每月 1GB |
| **同時連線數** | ✅ 無限制 | 免費版限 1 個 tunnel |
| **自己網域** | ✅ 一鍵綁 | ❌ 要付費版（$8/月） |
| **設定複雜度** | 簡單模式：⭐ 進階：⭐⭐⭐ | ⭐⭐ |
| **HTTPS 憑證** | ✅ 自動 | ✅ 自動 |
| **要不要註冊** | ✅ 進階模式要 Cloudflare 帳號 | 要 ngrok 帳號 |
| **跨地區速度** | ✅ Cloudflare 全球 CDN | 視 ngrok 區域 |

> [!TIP]
> 想快速試試水溫 → 用「快速模式」（cloudflared 一行指令，URL 隨機）
> 想長期穩定（接 LINE Bot 永遠不用更新 webhook URL） → 用「固定 URL 模式」（要綁自己網域）

---

## 安裝 cloudflared

### 🪟 Windows

PowerShell（建議先以系統管理員身分執行）：

```powershell
winget install --id Cloudflare.cloudflared
```

或直接下載 exe：
- 到 [Cloudflare cloudflared GitHub Releases](https://github.com/cloudflare/cloudflared/releases)
- 抓 `cloudflared-windows-amd64.exe` → 改名為 `cloudflared.exe` → 放進 `PATH` 內任一資料夾

驗證：

```powershell
cloudflared --version
```

成功應顯示版本號（如 `cloudflared version 2026.4.1`）。

### 🍎 macOS

```bash
brew install cloudflared
```

### 🐧 Linux（Debian/Ubuntu）

```bash
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
```

### 🐧 Linux（Fedora/RHEL）

```bash
sudo dnf install https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
```

---

## 🚀 路線 A：快速模式（5 分鐘上手）

**特色**：
- ✅ 一行指令搞定
- ✅ 不用 Cloudflare 帳號
- ✅ 不用自己網域
- ❌ URL 隨機（每次重啟都變）
- ❌ 適合**測試 / 偶爾用**，不適合長期 production

### 用法

開一個 PowerShell（或終端機）視窗，跑：

```powershell
# LINE 官方原生方案（內建 8646）
cloudflared tunnel --url http://localhost:8646

# LINE Bridge 方案（Bridge 是 3000）
cloudflared tunnel --url http://localhost:3000

# 其他 port 自行換
cloudflared tunnel --url http://localhost:你的port
```

成功會看到：

```text
+--------------------------------------------------------------------------------+
|  Your quick Tunnel has been created! Visit it at (it may take a few minutes    |
|  to be reachable):                                                             |
|  https://random-words-something-funny.trycloudflare.com                        |
+--------------------------------------------------------------------------------+
```

複製那條 `https://*.trycloudflare.com` URL，去 LINE Developers Console 貼上：

| 方案 | Webhook URL |
|------|-------------|
| LINE 官方原生 | `https://*.trycloudflare.com/line/webhook` |
| LINE Bridge | `https://*.trycloudflare.com/webhook` |

### 缺點

- **這個視窗不能關**，關了 tunnel 就斷
- **每次 cloudflared 重啟 URL 都會變**，要重新貼到 LINE Console
- 不適合長期穩定用 → 看下面「路線 B：固定 URL 模式」

---

## 🏆 路線 B：固定 URL 模式（推薦長期用）

**特色**：
- ✅ URL **永久固定**（綁自己網域）
- ✅ 接 LINE Bot 後**永遠不用再更新 webhook URL**
- ✅ 完全免費（包含 Cloudflare 帳號 + 一年期 .pp.ua 免費網域選項）
- ⚠️ 設定步驟較多，第一次約 30 分鐘
- ⚠️ 需要有一個自己的網域名稱（可以買便宜的）

### 前置條件

1. **Cloudflare 帳號**（免費註冊）：[dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)
2. **一個網域名稱**，三條路：
   - 🆓 **完全免費**：[freenom.com](https://www.freenom.com)（.tk/.ml/.ga 但常被封）
   - 🆓 **學生方案**：GitHub Student Pack 給 1 年免費 .me 或 Namecheap 優惠
   - 💰 **付費**：Cloudflare Registrar **本價**（不抽成）約 $9/年買 `.com`

### Step 1：把網域加進 Cloudflare

1. Cloudflare Dashboard → **Add a Site**
2. 輸入你的網域（例：`example.com`）→ 選 **Free Plan**
3. Cloudflare 給你兩組 **Nameservers**（例：`amy.ns.cloudflare.com`, `barry.ns.cloudflare.com`）
4. 去網域註冊商（GoDaddy / Namecheap / 中華電信）**改 Nameservers** 成 Cloudflare 給的兩組
5. 等 DNS 生效（通常 1 小時，最久 24 小時）

> [!TIP]
> 不想動 Nameservers？也可以把整個網域**直接轉入 Cloudflare Registrar**，過程 5-10 分鐘自動完成，本價續約。

### Step 2：登入 cloudflared

```powershell
cloudflared tunnel login
```

會自動開瀏覽器，登入 Cloudflare 帳號 → 授權 → 完成。

### Step 3：建立永久 Tunnel

```powershell
cloudflared tunnel create hermes-lobster
```

成功會看到：

```text
Tunnel credentials written to C:\Users\你\.cloudflared\<UUID>.json
Created tunnel hermes-lobster with id <UUID>
```

**記下 `<UUID>`**，下一步要用。

### Step 4：設定 DNS 路由

```powershell
# 把 hermes.example.com 指向這個 tunnel
cloudflared tunnel route dns hermes-lobster hermes.example.com
```

把 `example.com` 換成你自己的網域，`hermes` 是子網域（可自訂）。

### Step 5：寫設定檔 `config.yml`

新建 `C:\Users\你\.cloudflared\config.yml`（Mac/Linux：`~/.cloudflared/config.yml`）：

```yaml
tunnel: <你的 UUID>
credentials-file: C:\Users\你\.cloudflared\<UUID>.json

ingress:
  # 路徑 1：LINE 官方原生
  - hostname: hermes.example.com
    service: http://localhost:8646

  # 路徑 2（如果你還跑 Bridge）：
  # - hostname: bridge.example.com
  #   service: http://localhost:3000

  # 必填：所有其他流量返回 404
  - service: http_status:404
```

> [!NOTE]
> 一個 tunnel 可以同時對應**多個 hostname**，分別接不同 port。LINE 官方原生 + LINE Bridge + 自架網站全部一個 tunnel 搞定。

### Step 6：啟動 Tunnel

```powershell
cloudflared tunnel run hermes-lobster
```

成功會看到：

```text
INF Starting tunnel tunnelID=...
INF Connection registered ...
```

去瀏覽器測：`https://hermes.example.com/line/webhook/health` → 應回 `{"status":"ok","platform":"line"}`。

### Step 7：設成 Windows 服務（開機自啟）

不想每次開機都手動跑 `cloudflared tunnel run`？

```powershell
# 以系統管理員身分執行 PowerShell
cloudflared service install
```

完成。下次開機自動啟動，背景跑、不佔視窗。

### Mac / Linux 開機自啟

**macOS**：

```bash
sudo cloudflared service install
```

會建立 `~/Library/LaunchDaemons/com.cloudflare.cloudflared.plist`。

**Linux（systemd）**：

```bash
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

### Step 8：去 LINE Console 貼**永久 URL**

| 方案 | Webhook URL（這次填了就不用再改）|
|------|-------------------------------|
| LINE 官方原生 | `https://hermes.example.com/line/webhook` |
| LINE Bridge | `https://hermes.example.com/webhook` |

**從此**：開機自啟 → URL 永遠不變 → LINE 永遠連得到。

---

## 在 Hermes `.env` 也要更新

LINE 官方原生方案會用 `LINE_PUBLIC_URL` 提供媒體檔，要同步：

```env
LINE_PUBLIC_URL=https://hermes.example.com
```

`hermes gateway restart` 套用。

---

## Troubleshooting

### Q1：`cloudflared tunnel run` 顯示「ERR Connection terminated」

通常是 `config.yml` 寫錯了：
- `tunnel: <UUID>` 那行 UUID 沒填對
- `credentials-file` 路徑錯（記得 Windows 用 `\` 或 `/` 都行但要對到實際檔案位置）
- `ingress` 縮排沒對齊（YAML 對縮排很嚴）

### Q2：Tunnel 跑起來了但連 `https://hermes.example.com` 顯示 522

- 本機 service 沒跑（`hermes gateway` 沒啟動）
- port 不對（你跑 8646 但 config.yml 寫 3000，或反之）
- 防火牆擋掉了 cloudflared 的 outbound 連線

### Q3：DNS 設好了但測試 URL 是「Not Found」

- DNS 還在傳播（等 30 分鐘）
- `cloudflared tunnel route dns` 的 hostname 拼錯
- `ingress` 段落的 `hostname` 跟 DNS 的 hostname 不一致

### Q4：Windows 服務裝完開機沒自動跑

```powershell
# 以系統管理員執行
Get-Service cloudflared
# 應該看到 Status: Running

# 沒在跑的話手動啟動
Start-Service cloudflared

# 看詳細 log
cloudflared --loglevel debug tunnel run hermes-lobster
```

### Q5：免費網域 freenom 申請被擋

很多 ISP 跟 Cloudflare 都把 `.tk` `.ml` 列入黑名單。**改買 Cloudflare Registrar 的 `.com`**（本價 $9.15/年），最划算且最穩。

### Q6：可以同時跑「快速模式」和「固定 URL 模式」嗎？

**可以**，但要分**兩個 PowerShell 視窗**。建議只用一種——固定 URL 模式設好了，快速模式就用不到了。

---

## 跟 ngrok 比較：什麼時候該換？

| 你的情況 | 推薦工具 |
|---------|---------|
| **第一次嘗試、純測試 5 分鐘** | ngrok 也行（指令最短） |
| **持續一週以上**、要綁 LINE Bot | **Cloudflare Tunnel 快速模式** |
| **超過一個月**，每天用 | **Cloudflare Tunnel 固定 URL 模式** |
| **生產級服務**、賺錢用 | **Cloudflare Tunnel 固定 URL 模式 + 開機自啟** |
| 公司網路限制 outbound 443 | 兩者都不行（要請 IT 開放）|

> [!TIP]
> 阿亮老師個人推薦：**新學員第一次用 ngrok 走通流程，第二次起改用 Cloudflare Tunnel 快速模式，第三次起改固定 URL 模式**。漸進升級，不會一次學太多。

---

## 接下來看哪一頁？

| 我的需求 | 看這一頁 |
|---------|---------|
| 設定 LINE 官方原生方案 | 「💚 LINE 官方原生方案」|
| 設定 LINE Bridge 方案 | 「💚 LINE Bridge 進階方案」|
| 每天怎麼啟動所有服務 | 「▶️ 每次啟動愛馬仕龍蝦」|
| 接 Telegram | 「✈️ Telegram 機器人設定」（不用 tunnel）|
