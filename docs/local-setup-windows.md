# Run the labs on your own Windows PC 🪟

The seminar uses **GitHub Codespaces**, so you don't need any of this on the day. Use this guide to practise **on your own PC**, or if your lab PCs allow installing software.

You'll set up **WSL2 + Ubuntu + Docker Engine**: the lightest, free way to run Docker on Windows (the Windows equivalent of Colima on a Mac). All lab commands then work exactly as written.

---

## 0. Requirements (check first)

| Requirement | How to check |
|---|---|
| Windows 10 version 22H2 or Windows 11 | <kbd>Win</kbd>+<kbd>R</kbd> → type `winver` → Enter |
| **Administrator rights** | You can "Run as administrator" |
| **Virtualization enabled** | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Esc</kbd> → **Performance** → **CPU** → "Virtualization: **Enabled**". If Disabled, turn on *Intel VT-x* / *AMD-V (SVM)* in the BIOS/UEFI settings |
| 8 GB RAM (16 GB recommended for the monitoring lab) | Task Manager → Performance → Memory |
| 20 GB free disk space | File Explorer → This PC |
| Internet access | — |

### What you'll install

| # | Tool | Where | Why |
|---|---|---|---|
| 1 | WSL2 + Ubuntu | Windows | A real Linux system inside Windows |
| 2 | Docker Engine + Compose | Ubuntu | Containers (Labs 3, 4, 6) |
| 3 | Git, Python 3, pip, venv | Ubuntu | Labs 1, 2, 5 |
| 4 | Terraform | Ubuntu | Lab 6 |
| 5 | VS Code + WSL extension | Windows | Editor and terminal |
| 6 | GitHub CLI (`gh`) | Ubuntu | Sign in to GitHub, push, create repos and pull requests from the terminal |
| 7 | Zsh + Oh My Zsh *(optional)* | Ubuntu | A friendlier terminal: Git branch in the prompt, suggestions, highlighting |
| 8 | Instructor's VS Code extensions *(optional)* | Windows + Ubuntu | Same editor setup as the instructor, one script |

⏱️ About **30–45 minutes**, mostly downloads.

---

## 1. Install WSL2 and Ubuntu
1. Click **Start**, type `PowerShell`, right-click **Windows PowerShell** → **Run as administrator**.
2. Run:
   ```powershell
   wsl --install -d Ubuntu
   ```
   > **Red error about `Microsoft.PowerShell_profile.ps1 cannot be loaded because running scripts is disabled`?** It's harmless. You can still type commands. To stop it appearing, run this once, answer **Y**, then reopen PowerShell:
   > ```powershell
   > Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
   > ```
   > This lets your own local scripts run (downloaded scripts still need a signature) and only affects your user account.
3. **Restart** the PC when asked.
4. After restart an **Ubuntu** window opens (if not: **Start** → type `Ubuntu` → Enter). It says *Installing, this may take a few minutes…*. **Wait**, and don't close the window.

### 1b. Create your Linux user account 👤
When installing finishes, Ubuntu asks you to create **your own Linux account**. It's separate from your Windows login.
```
Enter new UNIX username: juan
New password:
Retype new password:
passwd: password updated successfully
Installation successful!
juan@LAPTOP-1234:~$
```

| Rule | Example |
|---|---|
| **Username:** lowercase letters, numbers, `-` or `_`; starts with a letter; **no spaces, no capitals** | ✅ `juan`, `juan_dc`, `jdelacruz` · ❌ `Juan`, `juan dela cruz`, `1juan` |
| **Password:** anything you'll remember | It's **invisible while you type** (no dots or stars). That's normal: just type it and press Enter |

> 🔑 **Remember this password.** `sudo` (run as administrator) asks for it all day. Write it down somewhere safe.

✅ Check your account:
```bash
whoami          # your username (NOT root)
sudo -v         # asks for your password; no error = you're an admin in Ubuntu
```
Prompt shows `root@…` or `whoami` says `root`? You skipped the account step. See [WSL troubleshooting](#-wsl-troubleshooting) → *Ubuntu logs in as root*.

✅ Check WSL, in **PowerShell**:
```powershell
wsl -l -v
```
Ubuntu should show **VERSION 2** and is usually marked with `*` (the default). If it shows 1: `wsl --set-version Ubuntu 2`.

### 1c. Start, stop and manage WSL 🐧
| I want to… | Do this |
|---|---|
| **Open Ubuntu** | **Start** → `Ubuntu`, or in PowerShell / Windows Terminal: `wsl` |
| Open Ubuntu in your home folder | `wsl ~` |
| Open a specific distro | `wsl -d Ubuntu` |
| Open Ubuntu from VS Code | VS Code → <kbd>F1</kbd> → **WSL: Connect to WSL** (bottom-left shows **WSL: Ubuntu**) |
| See installed distros and if they're running | `wsl -l -v` |
| Check WSL's version and settings | `wsl --status` and `wsl --version` |
| **Stop everything** (frees RAM, fixes most glitches) | `wsl --shutdown` |
| Stop only Ubuntu | `wsl -t Ubuntu` |
| Make Ubuntu the default for `wsl` | `wsl --set-default Ubuntu` |
| Update WSL itself | `wsl --update` |
| Open your Linux folder in Windows Explorer | In Ubuntu: `explorer.exe .`, or in Explorer: `\\wsl.localhost\Ubuntu\home\YOUR-USERNAME` |
| See your Windows `C:` drive from Ubuntu | `cd /mnt/c/Users/` (slow for projects; keep projects in `~`) |

> WSL starts **automatically** when you open Ubuntu or run `wsl`, and stops itself a few seconds after you close the last Ubuntu window (unless VS Code or Docker keeps it busy). All commands in the table run in **PowerShell**, except the ones that say "in Ubuntu".

> From now on, every command goes in the **Ubuntu** terminal, unless it says PowerShell.

## 2. Update Ubuntu
```bash
sudo apt update && sudo apt upgrade -y
```

## 3. Install Docker Engine (no Docker Desktop needed)
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```
**Close the Ubuntu window and open it again** (so you can use `docker` without `sudo`). Then:
```bash
docker run hello-world
docker compose version
```
✅ You see "Hello from Docker!" and a Compose version.

> **`Cannot connect to the Docker daemon`?** Start it with `sudo service docker start`. To make it start automatically, check that systemd is on: `cat /etc/wsl.conf` should contain
> ```
> [boot]
> systemd=true
> ```
> If not, add those two lines (`sudo nano /etc/wsl.conf`), then in **PowerShell** run `wsl --shutdown` and reopen Ubuntu.

## 4. Install Git, Python 3 and pip
Ubuntu already includes Python 3. These packages add **pip** (Python's package installer), **venv** (private package folders per project) and make the `python` command point to Python 3:
```bash
sudo apt install -y git curl python3 python3-pip python3-venv python-is-python3
git config --global user.name "Your Name"
git config --global user.email "YOUR-ID+YOUR-USERNAME@users.noreply.github.com"   # GitHub → Settings → Emails
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input     # keep Linux line endings in WSL
```
✅ Check:
```bash
python --version      # Python 3.12.x
pip3 --version        # pip 24.x from /usr/lib/python3/...
```

> Git errors like *Please tell me who you are*, *dubious ownership* or *divergent branches*? See [Git config troubleshooting](../labs/02-git-basics.md#-git-config-troubleshooting).

> **Don't install Python from python.org or the Microsoft Store for these labs.** Everything runs inside Ubuntu, so use the Python in Ubuntu. A Windows Python is a separate install that the labs never use.

## 5. Install Terraform
```bash
sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
```

## 6. Install VS Code and open it in Ubuntu
1. Download and install VS Code on **Windows** from <https://code.visualstudio.com>.
2. Open VS Code → Extensions (<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>X</kbd>) → install **WSL** (by Microsoft).
3. In the **Ubuntu** window, run:
   ```bash
   cd ~
   code .
   ```
   The first time, VS Code installs a small server inside Ubuntu (about 1 minute).
4. Check the **bottom-left corner** of VS Code. It must say **WSL: Ubuntu**. If not: press <kbd>F1</kbd> → type `WSL: Connect to WSL` → Enter.
5. Open the built-in terminal: <kbd>Ctrl</kbd>+<kbd>`</kbd> (the key above Tab), or **Terminal → New Terminal**.

> From now on, type every command in the **VS Code terminal**. It's the same Ubuntu terminal, right next to your files.

## 7. Install GitHub CLI and sign in
The **GitHub CLI** (`gh`) lets you sign in to GitHub once and then push, create repos and open pull requests from the terminal. No passwords or tokens to copy.

In the VS Code terminal:
```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
gh --version
```

Sign in:
```bash
gh auth login
```
Answer the questions with the arrow keys and <kbd>Enter</kbd>:

| Question | Choose |
|---|---|
| Where do you use GitHub? | **GitHub.com** |
| Preferred protocol for Git operations? | **HTTPS** |
| Authenticate Git with your GitHub credentials? | **Yes** |
| How would you like to authenticate? | **Login with a web browser** |

`gh` shows a **one-time code** like `ABCD-1234`. Copy it, press <kbd>Enter</kbd>, and a browser page opens (if it doesn't, <kbd>Ctrl</kbd>+click the `https://github.com/login/device` link). Paste the code → **Continue** → **Authorize GitHub CLI**.

✅ Check:
```bash
gh auth status
```
It shows `✓ Logged in to github.com account YOUR-USERNAME`. Git now uses this login for `git push`, so you won't be asked for a password.

> Never paste a GitHub password or token into chat or a file. `gh auth login` stores the login safely for you. To sign out: `gh auth logout`.

## 8. Get the labs
Create **your own copy** of the labs from the template and download it, in one command (still in the VS Code terminal):
```bash
cd ~
gh repo create devops-roadmap-basics --template neo64347/devops-roadmap-basics --public --clone
cd devops-roadmap-basics
code -r .
```
`code -r .` reopens VS Code in the project folder. Open the terminal again with <kbd>Ctrl</kbd>+<kbd>`</kbd>.

> Prefer the website? On GitHub click **Use this template → Create a new repository**, then run `gh repo clone YOUR-USERNAME/devops-roadmap-basics`.

> Keep your projects **inside Ubuntu** (`~/...`), not under `/mnt/c/...`. It's much faster.

## 9. Install the lab's Python packages with pip (one time)
Ubuntu blocks `pip install` for the whole system (you'd get `error: externally-managed-environment`) so you can't break Ubuntu's own Python. Instead, give the project its own **virtual environment**: a `.venv` folder that holds this project's packages.

In the VS Code terminal:

**1. Create and turn on the virtual environment**
```bash
cd ~/devops-roadmap-basics
python -m venv .venv
source .venv/bin/activate
```
Your prompt now starts with `(.venv)`. Check that `python` and `pip` come from the project:
```bash
which python pip     # both end in /devops-roadmap-basics/.venv/bin/...
```

**2. Update pip, then install the packages**
```bash
python -m pip install --upgrade pip
python -m pip install -r app/requirements.txt -r app/requirements-dev.txt
```
`requirements.txt` lists the app's packages (Flask, Gunicorn, Prometheus client, Redis). `requirements-dev.txt` adds **pytest** for the tests. The versions are pinned, so you get the same versions as the pipeline in Lab 5.

> 💡 `python -m pip` means "the pip that belongs to this python", so you can never install into the wrong Python by mistake.

**3. Check it worked**
```bash
pip list                      # Flask, gunicorn, prometheus_client, pytest, redis…
cd app && python -m pytest -q && cd ..
```
✅ You see `3 passed`.

**4. Tell VS Code to use it**
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → **Python: Select Interpreter** → choose **`./.venv/bin/python`**. VS Code then uses the venv for running, testing and auto-complete, and turns it on in new terminals automatically.

**Every new terminal:** if the prompt doesn't start with `(.venv)`, run `source .venv/bin/activate` again (in bash and Zsh alike).

| pip command | What it does |
|---|---|
| `python -m pip install NAME` | Install a package into the active venv |
| `python -m pip install -r FILE` | Install everything listed in a requirements file |
| `pip list` | Show installed packages |
| `pip show flask` | Details of one package (version, location) |
| `pip freeze > requirements.txt` | Save the exact versions you have |
| `python -m pip uninstall NAME` | Remove a package |
| `deactivate` | Turn the venv off |

> Broke something? Delete the folder and start again: `deactivate; rm -rf .venv`, then repeat steps 1–2.

## 10. ✅ Final check
```bash
git --version && gh --version && docker --version && docker compose version && python3 --version && terraform --version
gh auth status
docker compose up -d --build && sleep 5 && curl localhost:8000 && docker compose down
```
✅ The last command prints `Hello from Docker Compose! You are visitor #1.`

Start all three ports and get the links:
```bash
bash scripts/start.sh
```
<http://localhost:8000> (web app), <http://localhost:3000> (Grafana) and <http://localhost:9090> (Prometheus) open in your normal **Windows** browser. Stop with `bash scripts/start.sh stop`. At the end of the day, `bash scripts/cleanup.sh` removes **all** lab containers (add `--all` to also free the disk space). Shutting down Windows or running `wsl --shutdown` stops them as well, and they won't restart by themselves. Problems? See [Run the app and open the 3 ports](ports.md).

You're ready. Start at [Lab 1](../labs/01-linux-basics.md) (skip the Codespaces part of Lab 0).

## 11. ⭐ Optional: a nicer terminal with Zsh in VS Code
**Zsh** is the shell most DevOps engineers use (it's the default on Mac). With **Oh My Zsh** you get a clean prompt that shows your Git branch, **grey suggestions** from your history (press <kbd>→</kbd> to accept), **green/red highlighting** for valid/invalid commands, and shortcuts for `git`, `gh`, `docker` and `terraform`. All lab commands work the same in Zsh.

Do everything in the **VS Code terminal** (bottom-left says **WSL: Ubuntu**).

> **Using Codespaces?** Zsh and Oh My Zsh are already installed there. In the terminal panel click the **˅** next to **+** → **zsh**.

**1. Install Zsh**
```bash
sudo apt install -y zsh
zsh --version
```

**2. Install Oh My Zsh**
```bash
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
When it asks **"Do you want to change your default shell to zsh?"**, type `Y` and enter your Ubuntu password.

**3. Add autosuggestions and syntax highlighting**
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
sed -i 's/^plugins=(git)$/plugins=(git gh docker terraform zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
grep '^plugins=' ~/.zshrc
```
✅ The last command prints `plugins=(git gh docker terraform zsh-autosuggestions zsh-syntax-highlighting)`.

**4. Make Zsh the default terminal in VS Code**
1. Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → type **Terminal: Select Default Profile** → choose **zsh**.
2. Close all terminals (🗑️ icon in the terminal panel), then open a new one with <kbd>Ctrl</kbd>+<kbd>`</kbd>.

✅ Your prompt now looks like `➜  devops-roadmap-basics git:(main)`. Check with:
```bash
echo $SHELL     # /usr/bin/zsh
```

**5. Try it**
- Type `doc` and press <kbd>Tab</kbd>: Zsh completes `docker`. Press <kbd>Tab</kbd> twice after `docker ` to see sub-commands.
- Start typing a command you used before: a grey suggestion appears. Press <kbd>→</kbd> to accept it.
- Type a wrong command like `dokcer`: it turns **red** before you even press <kbd>Enter</kbd>.
- Shortcuts from the plugins: `gst` = `git status`, `gco main` = `git checkout main`, `gp` = `git push`. Run `alias | grep git` to see them all.

**6. Clone and pull repos with GitHub CLI in Zsh**

Make sure `gh` is installed. If you did step 7 it already is (it works the same in Zsh and bash):
```bash
gh --version || echo "gh is not installed yet"
```
<details><summary>Not installed? Install GitHub CLI now (in your Zsh terminal)</summary>

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
gh --version
```
</details>

**Sign in first.** `gh` won't clone anything, not even a public repo, until you're logged in:
```bash
gh auth status || gh auth login     # GitHub.com → HTTPS → Yes → Login with a web browser
gh auth setup-git                   # let git pull/push use the same login
```
The login is saved in `~/.config/gh`, so it's shared by Zsh, bash and VS Code. You only do this once.

**Clone** (download) a repo:
```bash
cd ~
gh repo clone YOUR-USERNAME/devops-roadmap-basics     # your copy of the labs
cd devops-roadmap-basics
code -r .                                             # reopen VS Code in this folder
```
Tip: type `gh repo cl` and press <kbd>Tab</kbd>. The `gh` plugin completes the command for you.

**Pull** (get the latest changes) any time:
```bash
cd ~/devops-roadmap-basics
git pull          # or the Zsh shortcut: gl
gh repo view      # quick look at the repo's README in the terminal
```

> Your prompt shows the branch and a ✗ when you have uncommitted changes, e.g. `➜  devops-roadmap-basics git:(main) ✗`. Commit or `git stash` before you pull.

> **Your settings live in `~/.zshrc`**, not `~/.bashrc`. To change the theme, edit `ZSH_THEME="robbyrussell"` in `~/.zshrc` (try `"agnoster"` with a [Nerd Font](https://www.nerdfonts.com)), then run `source ~/.zshrc`.
>
> **Python venv:** `source .venv/bin/activate` works the same in Zsh.
>
> **Undo:** `chsh -s $(which bash)`, then in VS Code choose **bash** as the default profile again.


## 12. ⭐ Optional: install the instructor's VS Code extensions
Want the same VS Code setup as the instructor? [`scripts/vscode/extensions.txt`](../scripts/vscode/extensions.txt) lists the extensions I use daily that also work on Windows: Docker, Kubernetes, Terraform, Python, GitHub Actions, GitLens, YAML, AWS Toolkit, Grafana, Prometheus and a spell checker. AI assistants and account-based tools are not included.

In the **VS Code terminal** (bottom-left says **WSL: Ubuntu**), inside the labs folder:
```bash
cd ~/devops-roadmap-basics
bash scripts/vscode/install.sh
```
It shows the list and asks **Install them? [y/N]**. Type `y`. Each extension is installed on the Windows side and the Ubuntu side, so VS Code uses the right one. It takes about **3–5 minutes**. Then reload: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → **Developer: Reload Window**.

> Only want some? Open the Extensions panel (<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>X</kbd>) and install them one by one, or delete lines from `extensions.txt` before running the script.
>
> **Low on disk or RAM?** Skip this step. The labs only need the extensions VS Code suggests automatically.
>
> **C# Dev Kit** is free for students, individuals and open source; companies need a Visual Studio licence.

---

## 🐧 WSL troubleshooting
First try the universal fix: in **PowerShell** run `wsl --shutdown`, wait 10 seconds, open Ubuntu again. Still broken? Find your problem:

### Installing and starting
| Problem / error | Fix (in **PowerShell as administrator** unless it says otherwise) |
|---|---|
| `wsl` is not recognized / `wsl --install` shows only help text | Windows is too old. Update Windows (**Settings → Windows Update**) to Windows 10 22H2 or Windows 11, then try again |
| `0x80370102` *The virtual machine could not be started because a required feature is not installed* | Virtualization is off. Turn on **Intel VT-x / AMD-V (SVM)** in the BIOS/UEFI, and in **Turn Windows features on or off** tick ✅ *Virtual Machine Platform*. Restart |
| `0x8007019e` *The Windows Subsystem for Linux optional component is not enabled* | Tick ✅ *Windows Subsystem for Linux* and ✅ *Virtual Machine Platform* in **Turn Windows features on or off** (or run `wsl --install` again), then restart |
| `0x800701bc` *WSL 2 requires an update to its kernel component* | `wsl --update`, then `wsl --shutdown` and reopen Ubuntu |
| *The Windows Subsystem for Linux has no installed distributions* | `wsl --install -d Ubuntu` (see the list with `wsl -l --online`) |
| Stuck on *Installing, this may take a few minutes…* for 15+ min | Restart the PC and open Ubuntu again. Still stuck: `wsl --unregister Ubuntu` ⚠️ (**deletes Ubuntu and all files in it**; fine on a fresh install), then `wsl --install -d Ubuntu` |
| Ubuntu window opens and **closes immediately** | `wsl --shutdown`, then `wsl --update`. Check `wsl -l -v`: if Ubuntu shows VERSION 1, run `wsl --set-version Ubuntu 2` |
| *The Windows Subsystem for Linux instance has terminated* | `wsl --shutdown` and reopen. Often caused by the PC sleeping or low memory |
| `wsl` opens **docker-desktop** instead of Ubuntu | `wsl --set-default Ubuntu` |
| *This app has been blocked by your system administrator* / company laptop | WSL is disabled by your organisation's policy. Use **GitHub Codespaces** (what the seminar uses) instead |

### User account and password
| Problem | Fix |
|---|---|
| *Please enter a username matching the regular expression…* / username rejected | Use only **lowercase** letters, numbers, `-` or `_`, starting with a letter. No spaces or capitals (e.g. `juan_dc`) |
| Typed the password but **nothing appears** | Normal! Linux hides passwords completely. Type it and press Enter |
| *Sorry, try again* / `sudo` rejects your password | Caps Lock? Keyboard layout? If you really forgot it, see the next row |
| **Forgot your Linux password** | In PowerShell: `wsl -d Ubuntu -u root`, then (now in Ubuntu as root) `passwd YOUR-USERNAME`, set a new one, `exit` |
| **Ubuntu logs in as `root`** (prompt `root@…`, `whoami` says `root`) | The account step was skipped. Create it now (in Ubuntu, as root): `adduser YOUR-USERNAME`, then `usermod -aG sudo YOUR-USERNAME`. Make it the default: `printf '[user]\ndefault=YOUR-USERNAME\n' >> /etc/wsl.conf`. Then in PowerShell: `wsl --shutdown`, reopen Ubuntu, check `whoami` |
| Want a **different username** | Easiest: create the new one as in the previous row (`adduser` + `usermod -aG sudo` + `/etc/wsl.conf` default), then `wsl --shutdown`. Your old user's files stay in `/home/OLD-NAME` |
| `YOUR-USERNAME is not in the sudoers file` | In PowerShell: `wsl -d Ubuntu -u root`, then `usermod -aG sudo YOUR-USERNAME`, `exit`, `wsl --shutdown`, reopen |
| `whoami` is right but the **prompt still says root** after editing `/etc/wsl.conf` | WSL only reads it at start: `wsl --shutdown` in PowerShell, then reopen Ubuntu |

### Network, time and files
| Problem | Fix |
|---|---|
| `apt update` / `curl` / `git clone` fail: *Temporary failure in name resolution* (often on **VPN** or office Wi-Fi) | Windows 11: create `C:\Users\<you>\.wslconfig` with `[wsl2]` and `dnsTunneling=true` on the next line (or `networkingMode=mirrored`), then `wsl --shutdown`. Still failing: disconnect the VPN and try again |
| `apt update`: *Release file … is not valid yet* | Ubuntu's clock is wrong (after sleep). `wsl --shutdown` and reopen Ubuntu |
| Can't find my files from Windows | In Ubuntu: `explorer.exe .` opens the current folder in Explorer |
| Everything is **very slow** in the project | Your project is under `/mnt/c/…`. Move it into Ubuntu: `cd ~` and clone it there |
| Laptop runs out of memory | Limit WSL: `C:\Users\<you>\.wslconfig` with `[wsl2]` and `memory=4GB`, then `wsl --shutdown` |

## 🆘 Troubleshooting

| Problem | Fix |
|---|---|
| Any WSL install, start, user account or network problem | See [WSL troubleshooting](#-wsl-troubleshooting) above |
| PowerShell: `...profile.ps1 cannot be loaded because running scripts is disabled` | Harmless, keep going. To fix it: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, answer **Y**, reopen PowerShell |
| `permission denied ... docker.sock` | You skipped reopening Ubuntu after `usermod`. Close and reopen it (or run `newgrp docker`) |
| `error: externally-managed-environment` on pip | The venv isn't on. Run `source .venv/bin/activate` (step 9), then install again |
| `python: command not found` | Run `sudo apt install -y python-is-python3`, or type `python3` instead |
| `No module named venv` / `ensurepip is not available` | Run `sudo apt install -y python3-venv`, then `rm -rf .venv` and create it again |
| `No module named flask` / `pytest: command not found` | The venv isn't on in this terminal. Run `source .venv/bin/activate` |
| VS Code shows *Import "flask" could not be resolved* | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → **Python: Select Interpreter** → `./.venv/bin/python` |
| `python` opens the Microsoft Store (in PowerShell) | You're in Windows, not Ubuntu. Use the VS Code terminal that says **WSL: Ubuntu** |
| `code: command not found` in Ubuntu | Install the VS Code **WSL** extension, close and reopen Ubuntu, try `code .` again |
| VS Code bottom-left doesn't say **WSL: Ubuntu** | <kbd>F1</kbd> → `WSL: Connect to WSL`. Commands in a plain Windows terminal won't find `docker` or `gh` |
| `gh auth login` doesn't open a browser | <kbd>Ctrl</kbd>+click the `https://github.com/login/device` link, or open it in your browser and paste the code |
| `git push` asks for a username/password | Run `gh auth setup-git` (or `gh auth login` again and answer **Yes** to "Authenticate Git") |
| `gh: command not found` | Rerun step 7, or open a new terminal |
| VS Code terminal still opens **bash** after step 11 | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → **Terminal: Select Default Profile** → **zsh**, then trash all terminals and open a new one |
| Zsh shows `[oh-my-zsh] plugin 'zsh-autosuggestions' not found` | Step 11.3's `git clone` didn't finish. Run both `git clone` commands again |
| Prompt shows `?` boxes or broken arrows | You chose a theme that needs a Nerd Font. Set `ZSH_THEME="robbyrussell"` in `~/.zshrc` and run `source ~/.zshrc` |
| `gh repo clone` says *To get started with GitHub CLI, please run: gh auth login* | Sign in first: `gh auth login`, then clone again |
| `git pull` asks for a username/password in Zsh | Run `gh auth setup-git` |
| `install.sh` says `'code' not found` | Run it in the **VS Code terminal**, not a plain Ubuntu window. Open VS Code from Ubuntu with `code .` first |
| `install.sh`: some extensions ❌ | Run the script again (network hiccup), or install those from the Extensions panel |
| Command worked in bash but not in Zsh | Wrap URLs or arguments with `?`, `*` or `[ ]` in quotes, e.g. `curl "http://localhost:8000/?x=1"` |
| `localhost:8000` doesn't open in the Windows browser | Run `wsl --shutdown` in PowerShell, reopen Ubuntu, start the containers again |
| WSL uses too much memory | Create `C:\Users\<you>\.wslconfig` with `[wsl2]` and `memory=4GB` on the next line, then `wsl --shutdown` |
| Ports 8000/3000 "already in use" | Another program uses them. Stop it, or change the left-hand port in `compose.yaml` (e.g. `"8001:8000"`) |

---

## Alternatives

| Option | When to use it |
|---|---|
| **Rancher Desktop** (<https://rancherdesktop.io>, free) | You prefer a GUI app. On first start choose **dockerd (moby)** and turn **off** Kubernetes to save memory. It uses WSL2 too, so step 0 still applies |
| **Docker Desktop** | Most tutorials assume it. Free for personal/education/small business, heavier, needs admin |
| **No admin rights** | Use the browser: **GitHub Codespaces** (what the seminar uses), or a free **iximiuz Labs Docker playground** (<https://labs.iximiuz.com/playgrounds/docker>, Docker preinstalled, time-limited sessions). *Play with Docker was shut down in March 2026.* |

> **Why not Colima?** Colima only runs on **macOS and Linux**. WSL2 + Docker Engine is the Windows equivalent.
