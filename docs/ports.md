# Run the app and open the 3 ports 🔌

The lab stack has three things you open in a browser:

| Port | Service | What you see | Used in |
|---|---|---|---|
| **8000** | Web app (Flask) | `Hello from Docker Compose! You are visitor #1.` | Labs 3–6 |
| **3000** | Grafana | Dashboards → **Seminar → Web App** | Lab 6 |
| **9090** | Prometheus | Query box: try `app_requests_total` | Lab 6 |

Redis (port 6379) has no browser page. Only the web app talks to it.

---

## ⚡ The quick way: one command

From the project folder (`/workspaces/devops-roadmap-basics` in Codespaces, `~/devops-roadmap-basics` on your PC):

```bash
bash scripts/start.sh
```

It starts all four containers, waits until each port answers, and prints the right links for where you are:

```
  SERVICE     PORT   OPEN IN YOUR BROWSER                           STATUS
  Web app     8000   https://your-codespace-8000.app.github.dev     ✅ up
  Grafana     3000   https://your-codespace-3000.app.github.dev     ✅ up
  Prometheus  9090   https://your-codespace-9090.app.github.dev     ✅ up
```

On your own PC the links are `http://localhost:8000`, `:3000` and `:9090`.

| Command | What it does |
|---|---|
| `bash scripts/start.sh` | Start everything and show the links |
| `bash scripts/start.sh status` | What's running + links + ✅/❌ per port |
| `bash scripts/start.sh stop` | Stop and remove the lab containers |

---

## 🛠️ The manual way (what the script does)

```bash
docker compose --profile monitoring up -d --build
docker compose ps
```

> ⚠️ Plain `docker compose up -d` starts **only port 8000** (web app + Redis). Grafana and Prometheus are in the `monitoring` **profile**, so you need `--profile monitoring` to get ports 3000 and 9090.

✅ `docker compose ps` should show four services. The **PORTS** column should list `0.0.0.0:8000->8000`, `0.0.0.0:3000->3000` and `0.0.0.0:9090->9090`. If a PORTS cell is empty, that container has stopped. See [Troubleshooting](#-troubleshooting).

Test from the terminal (works everywhere, including Codespaces):
```bash
curl localhost:8000
curl localhost:8000/health        # {"status":"ok"}
curl -s localhost:3000/api/health # Grafana: "database": "ok"
curl -s localhost:9090/-/ready    # Prometheus Server is Ready.
```

---

## 🌐 Open them in your browser

### In GitHub Codespaces
The Codespace is a computer at GitHub, so **`localhost` in your own browser shows nothing**. Use one of these:

1. **PORTS tab:** next to **TERMINAL** at the bottom. Each port has a 🌐 globe icon. Hover over the address and click it (or right-click → **Open in Browser**).
2. **Pop-up:** when a port starts, VS Code shows *"Your application running on port 8000 is available"*. Click **Open in Browser**.
3. **The links printed by `bash scripts/start.sh`.**

The links look like `https://<codespace-name>-8000.app.github.dev`. They're **private**: only you can open them while signed in to GitHub. To show your app to a neighbour, right-click the port → **Port Visibility → Public**. Set it back to **Private** afterwards.

Port missing from the PORTS tab? Click **Forward a Port** (or the **+**) and type `8000`, `3000` or `9090`.

### On Windows (WSL2 + Ubuntu)
Run the commands in the **VS Code terminal** (bottom-left says **WSL: Ubuntu**), then open **http://localhost:8000**, **http://localhost:3000** and **http://localhost:9090** in your normal Windows browser (Edge or Chrome). WSL forwards `localhost` to Windows automatically.

### On a Mac or Linux PC
Open **http://localhost:8000**, **:3000** and **:9090** in your browser.

---

## 🆘 Troubleshooting

| Problem | Fix |
|---|---|
| Only port 8000 works, no 3000/9090 | You started without the profile. Run `docker compose --profile monitoring up -d`, or `bash scripts/start.sh` |
| `port is already allocated` / script says *port already used* | Another container has that port, usually `my-app` from Lab 3. Run `docker ps`, then `docker rm -f <name>` (the script prints the exact command) |
| PORTS column empty for a service | It crashed. `docker compose logs web` (or `grafana`, `prometheus`) shows why. Then `docker compose up -d` again |
| Codespaces: page says *"Oh no, it looks like you are offline"* or 502 | The service isn't ready yet. Wait 10 s and refresh, or check `bash scripts/start.sh status` |
| Codespaces: `localhost:8000` doesn't open in my browser | Expected. Use the PORTS tab links (see above) |
| Windows: `curl localhost:8000` works in Ubuntu, but not in the Windows browser | In **PowerShell**: `wsl --shutdown`, reopen Ubuntu, `bash scripts/start.sh` again. Still failing on Windows 11? Add `networkingMode=mirrored` under `[wsl2]` in `C:\Users\<you>\.wslconfig`, then `wsl --shutdown` |
| Windows: `Cannot connect to the Docker daemon` | `sudo service docker start` (see [Windows setup, step 3](local-setup-windows.md#3-install-docker-engine-no-docker-desktop-needed)) |
| Grafana shows **No data** | Make some traffic: `for i in $(seq 1 50); do curl -s localhost:8000 > /dev/null; done`, wait 10–20 s |
| Mac: port 5000 is busy | That's AirPlay. This project uses 8000 for that reason, so you shouldn't hit it |

When you're done: `bash scripts/start.sh stop` (or `docker compose --profile monitoring down`).
