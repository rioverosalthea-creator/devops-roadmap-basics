# Instructor guide 👩‍🏫

Audience: total beginners on Windows lab PCs, possibly **without admin rights**. Everything runs in **GitHub Codespaces** in the browser.

## 📅 Before the day

### 1–2 weeks before
- [ ] Ask students to **create a GitHub account** and **verify their email** (unverified accounts can't create Codespaces). Send them the repo link.
- [ ] Ask the venue: Chrome/Edge available? Can lab PCs reach `github.com`, `*.github.dev`, `*.app.github.dev`, `ghcr.io`, `mcr.microsoft.com`, `registry-1.docker.io`, `registry.terraform.io`? Corporate/school firewalls sometimes block these.
- [ ] Confirm this repo is a **template repository** (Settings → General → ✅ Template repository).

### The day before
- [ ] Dry run every lab yourself in a **fresh** Codespace from the template, timing each one. Include creating the `Protect main` ruleset (Lab 2) and adding the required checks (Lab 5): GitHub's Settings screens change, so update the click-steps if needed.
- [ ] Pre-check Docker Hub pulls work from a Codespace (`docker pull nginx:alpine`).
- [ ] Test the [backup plan](#-backup-plan-iximiuz-labs-docker-playground) in an iximiuz Docker playground (sign-in, `docker --version`, `bash scripts/start.sh`, open port 8000) and put the steps on a slide.
- [ ] Print or share the [cheat sheet](../docs/cheatsheet.md).

### On the day
- [ ] Start Lab 0 **first thing**. Codespace creation takes 1–2 minutes and is the most common blocker.
- [ ] Put the agenda, repo link and Wi-Fi details on the screen.
- [ ] Pair students up: a "driver" and a "navigator" who swap each lab.
- [ ] **Before everyone leaves:** on the projector, run `bash scripts/cleanup.sh`, then stop the Codespace (Lab 7, *Before you leave*). Walk the room and check that no one leaves a Codespace running.

### After the day
- [ ] Stop your own demo stack: `bash scripts/cleanup.sh` (add `--all` to free disk space).
- [ ] Check <https://github.com/codespaces> for running or leftover Codespaces of yours and delete the ones you don't need.

## ⏱️ Timing & teaching notes

| Time | Lab | Teach (≤10 min) | Watch out for |
|---|---|---|---|
| 09:00 | 0 Setup | The DevOps loop; "automate the boring stuff" | Unverified GitHub emails; slow Codespace start |
| 09:45 | 1 Linux | Command anatomy, Tab completion, Ctrl+C | Paste shortcut (<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd>); case-sensitive names |
| 10:45 | 2 Git | Draw *working → staging → commit → push*. Teach the short-lived branch strategy: one small change per branch, PR to protected `main`, checks before merge, delete after merge. Then students protect `main` and watch a direct push get rejected (`GH013`) | `git commit` without `-m` opens an editor (`:wq`). Ruleset must have an **empty bypass list**, or the owner can still push to `main` |
| 11:45 | 3 Docker | Image = recipe, container = the cake 🎂 | Port pop-ups; leftover containers holding ports |
| 13:30 | 4 Compose | Services talk by name; data lives in Redis | Lab 3 container still on port 8000 → `docker rm -f my-app` |
| 14:15 | 💬 Discussion (30 min, no hands-on) | Show the 5 diagrams. VM = house, container = apartment; Kubernetes = robot keeping "3 copies" alive; monolith vs microservices = kitchen vs food court; API = the kitchen's order window. Status codes: "4xx = you asked wrong, 5xx = we broke" (restaurant analogy). Optional 1-min demo: `curl -i` on `/`, `/health`, `/nope` (404) | Don't let it turn into a Kubernetes tutorial. Park deep questions for the [roadmap](../docs/roadmap.md). Stress "start simple" |
| 14:45 | 5 CI/CD | Students add **Run tests** + **Build…** as required checks, then show the red ❌ PR with **Merging is blocked** on the projector, and fix it together | First run may need "enable workflows" in the Actions tab |
| 16:00 | 6 Cloud/IaC/Monitoring | Pizza-as-a-service; plan/apply/destroy; "monitoring = smoke alarm" | Grafana "No data" until traffic is generated |
| 17:00 | 7 Wrap-up | Quiz, roadmap, **stop Codespaces** | |

**Branch protection isn't copied from the template.** Each student protects their own copy in Lab 2, step 6. If someone skipped it, their direct pushes still work: help them add the ruleset before Lab 5.

**If you're running late**, shorten the discussion to Part 1 only (15 min; give Part 2 as reading). Also safe to skip: Lab 3 mini challenge, Lab 6 Part A (talk through it instead), the Terraform Docker stretch.

**Early finishers:** mini challenges at the end of each lab; [roadmap](../docs/roadmap.md) project ideas.

## 💰 Codespaces cost
Personal GitHub accounts include a **free monthly Codespaces allowance** (GitHub currently lists it in core-hours. Check <https://docs.github.com/billing/managing-billing-for-github-codespaces/about-billing-for-github-codespaces> for current numbers). This repo requests a 2-core machine, so one seminar day uses only a small part of the allowance. Remind students to **stop** their Codespace at the end.

## 🛟 Backup plan: iximiuz Labs Docker playground
If Codespaces is blocked or unavailable for some students, use a free Linux server with Docker in the browser. ✅ Tested and working (Nov 2026).

> ⚠️ **Play with Docker (labs.play-with-docker.com) is shut down.** Its site says it is *"unavailable starting March 1, 2026"*. Don't put it on your slides.

1. Go to <https://labs.iximiuz.com/playgrounds/docker> and sign in (free account; GitHub login works). Click **Start**.
2. A terminal opens on a Linux server with **Docker preinstalled**. Check it:
   ```bash
   docker --version
   docker compose version
   ```
   If `docker compose` is missing: `curl -fsSL https://get.docker.com | sh`.
3. Get the labs (public repo, so no login needed to clone):
   ```bash
   git clone https://github.com/YOUR-USERNAME/devops-roadmap-basics.git
   cd devops-roadmap-basics
   bash scripts/start.sh
   ```
4. Open the ports from the playground's **port / expose** menu: enter `8000`, `3000` or `9090` to get a browser link. `curl localhost:8000` works in the terminal.

**What works there:** Labs 1, 3, 4 and 6 (monitoring) fully. Lab 2 works for local commits; to push, students need `gh auth login` (install `gh` as in the [Windows guide, step 7](../docs/local-setup-windows.md#7-install-github-cli-and-sign-in)), or they skip the push steps. Lab 5 can be done on github.com only (edit files in the browser with the ✏️ button; Actions still runs). Terraform isn't preinstalled, so demo Lab 6 Part A from your screen.

**Limits:** free playground time is limited and the server is wiped when the session ends. Check the current limit on the site the day before. Students should **push their work before the timer ends**, then start a new playground and `git clone` again.

**Second option:** [Killercoda Ubuntu playground](https://killercoda.com/playgrounds/scenario/ubuntu): free, time-limited. Check Docker first with `docker --version || curl -fsSL https://get.docker.com | sh`.

**Last resort:** pair students without a working environment with a neighbour who has one, and swap the driver role each lab.

## 🖥️ Your own demo machine
- **Mac:** Colima works well (`colima start --cpu 2 --memory 4`). Note macOS uses port 5000 for AirPlay, which is why the app uses **8000**.
- **Windows:** see [local setup](../docs/local-setup-windows.md) (WSL2 + Docker Engine).
- **Sharing your VS Code extensions:** on your Mac run `scripts/vscode/export-from-mac.sh`. It reads your installed extensions, keeps only the ones with a Windows build on the Marketplace, skips AI assistants and account-based tools (Claude, Cursor, OpenAI, Copilot, Codacy), and rewrites `scripts/vscode/extensions.txt`. Review the diff, commit and push. Students install them with step 12 of the Windows guide.

## ✅ Answer key: common questions
- **"Is Docker a virtual machine?"** No. Containers share the host's kernel, so they're much lighter and faster to start.
- **"Why not just use Docker Desktop?"** It's fine and free for education, but needs admin rights and more RAM. Codespaces needs neither.
- **"Do companies really use GitHub Actions?"** Yes, alongside GitLab CI, Jenkins, Azure DevOps and others. The concepts transfer.
- **"Terraform vs Ansible?"** Terraform *creates* infrastructure. Ansible mostly *configures* what's already there.
