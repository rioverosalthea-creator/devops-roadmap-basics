# Lab 4: Docker Compose (45 min)

## 🎯 Goals
- Run **several containers together** with one command
- See containers talk to each other by name
- Understand why data in a database survives an app restart

## 💡 The idea
Real apps are more than one container: a web app, a database, a cache… Typing long `docker run` commands for each is painful. **Docker Compose** describes them all in one file, `compose.yaml`, and starts them together.

```
           your browser
                │ :8000
        ┌───────▼───────┐        ┌──────────────┐
        │  web (Flask)  │──────► │ redis (data) │
        └───────────────┘ "redis"└──────────────┘
                 one compose.yaml, one command
```

## 🛠️ Steps

### 1. Read the file
```bash
cat compose.yaml
```
Look at the `web` and `redis` services (ignore `prometheus` and `grafana` for now; they're for Lab 6).
- `build: ./app` builds our Dockerfile
- `REDIS_HOST: redis`: the web app finds the database using its **service name**

### 2. Start everything
```bash
docker compose up -d --build
docker compose ps
```
✅ Both `web` and `redis` show as **running**, and `web` shows `0.0.0.0:8000->8000` under PORTS.

> 🔢 **Peek at the status code:** `curl -i localhost:8000/health` shows `HTTP/1.1 200 OK` on the first line. Try `curl -i localhost:8000/nope` → `404 NOT FOUND`. More in the [discussion: HTTP status codes](04b-discussion-containers-kubernetes-architecture.md#4-http-status-codes).

> 🔌 **Where do I open port 8000?** Codespaces: **PORTS** tab → 🌐 next to 8000 (`localhost` in your own browser won't work). Own PC: <http://localhost:8000>. More help: [Run the app and open the 3 ports](../docs/ports.md).

### 3. Use the app
```bash
curl localhost:8000
curl localhost:8000
curl localhost:8000
```
The visitor number goes up. The count is stored in **Redis**, not in the web app.

### 4. Prove it: restart the web app
```bash
docker compose restart web
sleep 2
curl localhost:8000
```
✅ The count **continues** (e.g. `#4`) instead of going back to 1, because the data lives in the Redis container.

### 5. Logs from everything
```bash
docker compose logs          # all services
docker compose logs -f web   # follow one service live (Ctrl+C to stop)
```

### 6. Change config, apply
Edit `compose.yaml` and change:
```yaml
      GREETING: "Hello from Docker Compose!"
```
to your own message, save, then:
```bash
docker compose up -d     # Compose only re-creates what changed
curl localhost:8000
```

### 7. Stop everything
```bash
docker compose down
```

## ✅ Checkpoint
- [ ] `docker compose up -d` starts two containers
- [ ] The visitor count survived a web restart
- [ ] You can explain how `web` finds `redis`

## 🏋️ Mini challenge
Run `docker compose down`, then `up -d` again. Is the count kept? (No! `down` deletes the containers, including Redis's data.) Real projects add a **volume** so data survives. Ask the instructor how.

## 🆘 Troubleshooting
| Problem | Fix |
|---|---|
| `port is already allocated` | A container from Lab 3 is still running: `docker rm -f my-app` |
| Visitor count always 1 | Make sure you started with `docker compose`, not `docker run` (only Compose sets `REDIS_HOST`) |
| Changes not showing | Use `docker compose up -d --build` after changing the app code |

➡️ Next: [💬 Discussion: Containers, Kubernetes & app architecture](04b-discussion-containers-kubernetes-architecture.md)
