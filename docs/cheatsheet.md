# Cheat sheet 📋

## Linux terminal
| Command | What it does |
|---|---|
| `pwd` | Where am I? |
| `ls -la` | List all files with details |
| `cd folder` / `cd ..` / `cd ~` | Go into a folder / up one / home |
| `cat file` | Show a file |
| `mkdir name` | Create a folder |
| `echo "text" > file` | Write text to a file (`>>` appends) |
| `cp a b` / `mv a b` / `rm a` | Copy / move or rename / delete |
| `rm -r folder` | Delete a folder and its contents |
| `grep "word" file` | Find lines containing a word |
| `code file` | Open a file in the editor |
| <kbd>Tab</kbd> / <kbd>Ctrl</kbd>+<kbd>C</kbd> / <kbd>Ctrl</kbd>+<kbd>L</kbd> | Autocomplete / stop / clear screen |
| `echo $SHELL` | Which shell am I using? (`bash` or `zsh`) |
| `source ~/.zshrc` | Reload Zsh settings after editing ([Zsh setup](local-setup-windows.md#11--optional-a-nicer-terminal-with-zsh-in-vs-code)) |
| <kbd>→</kbd> (Zsh) | Accept the grey suggestion |
| `gst` / `gco` / `gp` / `gl` (Zsh) | Shortcuts for `git status` / `git checkout` / `git push` / `git pull` |

## Git
| Command | What it does |
|---|---|
| `git status` | What changed? |
| `git add file` / `git add -A` | Stage one file / everything |
| `git commit -m "message"` | Save a snapshot |
| `git commit -am "message"` | Stage changed files and commit |
| `git push` / `git pull` | Send to / get from GitHub |
| `git log --oneline` | History |
| `git diff` | Show unstaged changes |
| `git switch -c name` | Create and switch to a branch |
| `git switch main` | Go back to main |
| `git push -u origin name` | Push a new branch and set its upstream |
| `git restore file` | Throw away uncommitted changes to a file |
| `git config --global user.name "Name"` / `user.email "…"` | Who you are (stamped on every commit) |
| `git config --list --show-origin` | All settings + which file they come from |
| `git config user.email` | The email this repo uses |
| `git commit --amend --reset-author --no-edit` | Re-stamp the last commit with your current name/email |
| `git config --global --add safe.directory PATH` | Fix "dubious ownership" |
| `git config --global pull.rebase false` | Fix the "divergent branches" question on `git pull` |

**Branch strategy:** keep `main` stable; create a small, short-lived branch per change (for example `feature/add-search`, `fix/login-error`, `docs/update-readme`); open a PR to `main`; merge when review and CI checks are complete; then delete the branch. No long-lived `develop` branch needed for this tutorial.

## GitHub CLI (`gh`)
| Command | What it does |
|---|---|
| `gh auth login` / `gh auth status` | Sign in (browser) / check who you are |
| `gh auth setup-git` | Let `git push` use your gh login |
| `gh repo create NAME --template OWNER/REPO --public --clone` | New repo from a template, downloaded |
| `gh repo clone OWNER/REPO` | Download a repo |
| `gh repo view --web` | Open the repo in the browser |
| `gh pr create --fill` | Open a pull request from your branch |
| `gh pr list` / `gh pr view --web` | List PRs / open one in the browser |
| `gh pr merge --merge --delete-branch` | Merge the PR and clean up the branch |
| `gh run list` / `gh run watch` | See GitHub Actions runs / follow one live |

## Python & pip (own PC)
| Command | What it does |
|---|---|
| `python -m venv .venv` | Create a virtual environment (once per project) |
| `source .venv/bin/activate` / `deactivate` | Turn it on / off (prompt shows `(.venv)`) |
| `python -m pip install -r app/requirements.txt` | Install the packages listed in a file |
| `python -m pip install --upgrade pip` | Update pip itself |
| `pip list` / `pip show flask` | Installed packages / details of one |
| `python -m pytest -q` | Run the tests |

## HTTP status codes
| Code | Meaning | Code | Meaning |
|---|---|---|---|
| `200` | OK ✅ | `404` | Not found |
| `201` | Created | `405` | Method not allowed |
| `301` / `302` | Redirect | `429` | Too many requests |
| `400` | Bad request | `500` | Server error 🔥 |
| `401` | Unauthorized (log in) | `502` / `504` | Bad gateway / timeout (app behind the load balancer is down or slow) |
| `403` | Forbidden | `503` | Service unavailable |

`curl -i URL` shows the status line · `curl -s -o /dev/null -w '%{http_code}\n' URL` prints only the code · **4xx** = the request is wrong · **5xx** = the server is broken

## Docker
| Command | What it does |
|---|---|
| `docker run -d --name x -p 8080:80 image` | Run a container in the background |
| `docker ps` / `docker ps -a` | Running / all containers |
| `docker logs x` | Container output |
| `docker exec -it x sh` | Open a shell inside a container |
| `docker stop x` / `docker rm -f x` | Stop / force-remove |
| `docker build -t name:tag folder` | Build an image |
| `docker images` | List images |
| `docker system prune` | Clean up unused stuff |

## Docker Compose
| Command | What it does |
|---|---|
| `docker compose up -d --build` | Build and start everything |
| `docker compose ps` | Status |
| `docker compose logs -f web` | Follow logs for one service |
| `docker compose restart web` | Restart one service |
| `docker compose down` | Stop and remove everything |
| `docker compose --profile monitoring up -d` | Also start Prometheus + Grafana |

## Terraform
| Command | What it does |
|---|---|
| `terraform init` | Download providers (once per folder) |
| `terraform plan` | Preview changes |
| `terraform apply` | Make the changes |
| `terraform destroy` | Remove everything it created |

## Ports used today
Start all three with `bash scripts/start.sh` ([how to open them](ports.md)).

| Port | What | Start with |
|---|---|---|
| 8000 | Our web app | `docker compose up -d` |
| 3000 | Grafana | `docker compose --profile monitoring up -d` |
| 9090 | Prometheus | `docker compose --profile monitoring up -d` |
| 8080 | nginx (Lab 3, Terraform stretch) | `docker run -p 8080:80 nginx:alpine` |

| Script | What it does |
|---|---|
| `bash scripts/start.sh` | Start everything, print links for 8000/3000/9090 |
| `bash scripts/start.sh status` | ✅/❌ per port + links |
| `bash scripts/start.sh stop` | Stop the lab containers |
| `bash scripts/cleanup.sh` | **End of session:** stop and remove *all* lab containers (Labs 3, 4, 6) |
| `bash scripts/cleanup.sh --all` | Also delete the lab images (frees about 1 GB) |
| `gh codespace stop` | Stop your Codespace (saves free hours) |
