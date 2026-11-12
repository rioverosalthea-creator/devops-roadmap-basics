# Lab 3: Docker basics (60 min)

## 🎯 Goals
- Understand **images** and **containers**
- Run someone else's container
- Package our web app into your **own image** and run it

## 💡 The idea
"It works on my machine!" 😩 Docker fixes this by packaging an app **together with everything it needs** (language, libraries, settings), so it runs the same everywhere.

| Word | Think of it as… |
|---|---|
| **Image** | A recipe or template, read-only (e.g. `python:3.12-slim`) |
| **Container** | A running copy made from an image. You can start many from one image |
| **Dockerfile** | The instructions for building your own image |
| **Registry** | An app store for images (Docker Hub, GitHub Container Registry) |

```
 Dockerfile ──docker build──► Image ──docker run──► Container(s)
```

## 🛠️ Steps

### 1. Hello, container
```bash
docker run hello-world
```
Docker downloads (**pulls**) the image and runs it. Read the message it prints. It explains exactly what just happened.

### 2. Run a real web server
```bash
docker run -d --name web1 -p 8080:80 nginx:alpine
```
- `-d` runs it in the background ("detached")
- `--name web1` gives it a friendly name
- `-p 8080:80` connects port **8080** on your Codespace to port **80** inside the container

Open it: a pop-up says *"Your application running on port 8080 is available"* → click **Open in Browser**. (Or go to the **PORTS** tab next to the terminal and click the 🌐 icon for port 8080.) You'll see "Welcome to nginx!".

```bash
curl localhost:8080      # same page, in the terminal
```

### 3. Look at and manage containers
```bash
docker ps               # running containers
docker logs web1        # what the container printed
docker exec -it web1 sh # go INSIDE the container (type `ls`, then `exit` to leave)
docker stop web1        # stop it
docker ps -a            # -a shows stopped containers too
docker rm web1          # remove it
docker images           # images downloaded on this machine
```

### 4. Build your own image
Look at the recipe:
```bash
cat app/Dockerfile
```
Each line is one step: start from Python → copy requirements → install them → copy the code → start the app.

Build it and give it a name (a **tag**):
```bash
docker build -t my-app:v1 app
```
Run it:
```bash
docker run -d --name my-app -p 8000:8000 my-app:v1
curl localhost:8000
curl localhost:8000/health
```
✅ You should see `Hello, DevOps! You are visitor #1.` and `{"status":"ok"}`. Open port **8000** in the browser too.

### 5. Configure without rebuilding (environment variables)
```bash
docker rm -f my-app       # -f stops and removes in one go
docker run -d --name my-app -p 8000:8000 -e GREETING="Hi from $(whoami)!" my-app:v1
curl localhost:8000
```
Same image, different behaviour. That's how one image runs in **dev, test and production**.

### 6. Clean up
```bash
docker rm -f my-app
```

## ✅ Checkpoint
- [ ] You can explain *image vs container* in one sentence
- [ ] `docker build` and `docker run` worked for **your own** image
- [ ] You changed the greeting with `-e` without changing any code

## 🏋️ Mini challenge
Change `Hello, DevOps!` in `app/app.py` to your own message, rebuild as `my-app:v2`, and run it. Notice how fast the rebuild is: Docker **caches** the steps that didn't change.

## 🆘 Troubleshooting
| Problem | Fix |
|---|---|
| `port is already allocated` | Something already uses that port. `docker ps`, then `docker rm -f <name>` |
| `Conflict. The container name "/my-app" is already in use` | `docker rm -f my-app` |
| `curl: (7) Failed to connect` | The app may still be starting. Wait 2 seconds and retry. Check `docker logs my-app` |
| `Cannot connect to the Docker daemon` | Wait a minute after the Codespace starts, then open a new terminal |

➡️ Next: [Lab 4: Docker Compose](04-docker-compose.md)
