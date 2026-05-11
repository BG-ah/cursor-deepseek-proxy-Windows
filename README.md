首先，我是参考了另一个同学的地址在这：https://github.com/wustghj/cursor-deepseek-v4-proxy?tab=readme-ov-file

我为什么重新提交呢？
因为我试了他的方法，没有完全解决我的问题，但是我是在他基础上进行了修改而成功的，大家看他的就行，我这个主要是针对Windows电脑的。


#  Cursor DeepSeek V4 Proxy

> **一键修复 Cursor 使用 DeepSeek V4 时的 `reasoning_content` 错误，告别 `Rate limit exceeded`，让 AI Agent 模式稳定运行。**

---

## 📌 你能用这个项目解决什么问题？

如果你在 Cursor 中调用 DeepSeek V4（Pro / Flash）时，频繁遇到下面任意一种错误：

* `Provider returned error: The reasoning_content in the thinking mode must be passed back to the API.`
* `User API Key Rate limit exceeded`（明明配额还剩很多却报错）
* `AI Model Not Found: deepseek-v4-pro`（后台任务报模型名无效）
* 聊天第一轮正常，第二轮就开始报错、中断

**不用再折腾了，跟着本指南走 5 分钟就能彻底解决。**

---

## ✨ 核心功能

* ✅ **自动缓存 & 回传思维链**：再也不会因为 `reasoning_content` 缺失而报错。
* ✅ **智能限流**：内置令牌桶，防止突发的并发请求打满免费额度。
* ✅ **支持流式输出**：不影响 Cursor 的打字机渲染效果。
* ✅ **一键启动脚本**：Windows / macOS / Linux 通用，双击即可运行。
* ✅ **透明日志**：终端会实时显示请求状态，方便排错。
* ✅ **零侵入**：不需要修改 Cursor 程序文件，只改一个 Base URL。

---

## 🖥️ 适用环境

| 操作系统 | 支持情况 |
| :--- | :--- |
| **Windows 10 / 11** | ✅ 支持 |

> **唯一要求**：安装 **Python 3.8** 或更高版本（安装时请务必勾选 `Add Python to PATH`）。

---
<img width="451" height="392" alt="image" src="https://github.com/user-attachments/assets/08e3beaa-3d54-40ff-87a8-b170193702bd" />

## 🚀 超详细三步上手（小白专用）

### 第一步：下载项目并安装依赖

1.  下载本项目仓库的 ZIP 包，解压到本地（**路径请勿包含中文**）。
2.  进入解压后的文件夹，在文件夹地址栏输入 `cmd` 并回车，打开命令行窗口。
3.  执行以下命令安装依赖：
    ```bash
    pip install -r requirements.txt
    ```
    *若提示 `pip不是内部命令`，请重新安装 Python 并勾选 `Add to PATH`。*

### 第二步：启动本地代理 + 隧道

你需要一个隧道来生成公网地址（Cursor 限制访问 localhost）。

#### 🪟 Windows 用户
1.  确保文件夹内有 `cloudflared-windows-amd64.exe`（若无，请前往 [Cloudflare 官网](https://github.com/cloudflare/cloudflared/releases) 下载）。
2.  运行之前修改一下start_proxy.bat里面的路径："E:\Cminiconda\python.exe" proxy.py ；也就是你python安装的位置，因为我自己安装了好几个；
3.  双击运行 **`start_proxy.bat`**。
4.  会弹出窗口。在**隧道窗口**中，找到一串 `https://xxx.trycloudflare.com` 的地址并**复制**。


> ⚠️ **注意**：窗口不能关闭。隧道地址每次重启会变化，只要不关窗口就一直有效。
>
> 然后双击运行**start_tunnel.bat**
> .\cloudflared-windows-amd64.exe tunnel --url http://127.0.0.1:9000
> 这里面的名字要和你下载的程序名字一样，不懂的直接复制给豆包就行了。让豆包给你讲解。
> 也是会弹出窗口，不要关闭就行了。
> 

### 第三步：配置 Cursor

1.  打开 Cursor 设置：按 `Ctrl+Shift+P` → 输入 `Cursor Settings`。
2.  进入 **Models** 选项卡。
3.  在 **"Override OpenAI Base URL"** 中，粘贴刚才复制的地址，并**在末尾加上 `/v1`**：
    * 例如：`https://xxxxxx.trycloudflare.com/v1`
4.  在 API Key 处填入你的 **DeepSeek API Key**。
5.  **彻底退出并重启 Cursor**。

---


<img width="1608" height="413" alt="image" src="https://github.com/user-attachments/assets/a000f95c-39ce-4ba2-857d-18d3c7dbc053" />

## ❓ 常见问题 (FAQ)

<details>
<summary>🔁 隧道地址变了怎么办？</summary>
每次重启脚本都会生成新地址。你只需重新获取并更新到 Cursor 的 Base URL 即可。
</details>

<details>
<summary>💸 还是提示 Rate limit exceeded？</summary>    这一步我没有降低
DeepSeek 免费层级频率极低。你可以编辑 `proxy.py`，将 `TokenBucket(rate=5/60.0, capacity=5)` 中的 `5` 调小（如 `3`），强制降低请求频率。
</details>

<details>
<summary>🚫 必须用隧道吗？能不能连 localhost？</summary>
Cursor 出于安全原因禁止直接连接 `localhost`。Cloudflare Tunnel 是目前最简单、免费且无需注册的穿透方案。
</details>

<details>
<summary>🧪 代理会影响模型智商吗？</summary>
在 99% 的场景下无感知。代理仅是在模型“忘记”回传思维链时进行自动补全，确保对话不中断。
</details>

<details>
<summary>🧪 为什么只有 200k context，不是 1M？</summary>
这是 Cursor 的默认限制，不是代理问题。
    
Cursor 默认使用 200k context window。
如需启用模型支持的 1M context，需要在 Cursor Chat 中开启 `Max Mode`。
路径：
Chat -> Model Selector -> Max Mode
</details>

---


