# Lab 2: Git & GitHub (60 min)

## 🎯 Goals
- Understand what Git and GitHub are
- Make a change, **commit** it and **push** it to GitHub
- Work on a **branch** and open a **pull request**

## 💡 The idea
- **Git** is a "save game" system for code. Every **commit** is a snapshot you can go back to.
- **GitHub** is a website that stores your Git repositories online so teams can share and review code.

## 🌿 Our simple branching strategy

We'll use a beginner-friendly **short-lived branch** workflow:

- Keep `main` stable: it should contain work that's been checked and is safe to share.
- Start each small change from the latest `main` on its own branch.
- Use a clear name with a type and a few words, such as `feature/add-search`, `fix/login-error`, or `docs/update-readme`.
- Push the branch and open a pull request (PR) back to `main`. Review the change and wait for CI checks to pass before merging.
- Delete the branch after merging; start a fresh branch for the next change.

For this tutorial, you work on your own, so you can review your own PR. On a team, ask a teammate to review it. We are **not** using a separate long-lived `develop` branch or the full Git Flow model: one protected `main` and small PRs are enough to learn the core habit.

```
 working folder ──git add──► staging area ──git commit──► local history ──git push──► GitHub
   (your edits)              (what goes in the           (snapshots on              (shared copy)
                              next snapshot)              your machine)
```

## 🛠️ Steps

### 1. Introduce yourself to Git (one time)
Every commit is stamped with a **name** and an **email**. GitHub uses the email to link the commit to your account (your avatar appears next to it).

First check what's already set (Codespaces fills this in from your GitHub account):
```bash
git config --global user.name
git config --global user.email
```
If either is empty or wrong, set it:
```bash
git config --global user.name "Your Name"
git config --global user.email "YOUR-ID+YOUR-USERNAME@users.noreply.github.com"
```

> 🔒 **Which email?** Use your GitHub **no-reply** address so your real email isn't published in public commits. Find it at GitHub → **Settings → Emails** ("Keep my email addresses private"). It looks like `12345678+yourname@users.noreply.github.com`.

Recommended one-time settings (save typing and avoid common errors later):
```bash
git config --global init.defaultBranch main   # new repos start on "main", like GitHub
git config --global pull.rebase false          # "git pull" merges, no confusing question
git config --global core.editor "code --wait"  # open VS Code (not vim) when Git needs a message
```

✅ Check everything in one go:
```bash
git config --list --show-origin | grep -E 'user|init|pull|editor'
```
Problems? See [Git config troubleshooting](#-git-config-troubleshooting) below.

### 1b. Check you're signed in with GitHub CLI
**GitHub CLI** (`gh`) is GitHub in your terminal. In the VS Code terminal (<kbd>Ctrl</kbd>+<kbd>`</kbd>):
```bash
gh auth status
```
- **In Codespaces** you're already signed in. You'll see `✓ Logged in to github.com`.
- **On your own PC** (Windows setup guide, step 7): if it says *not logged in*, run `gh auth login` and choose **GitHub.com → HTTPS → Yes → Login with a web browser**.

Try it:
```bash
gh repo view --web     # opens your repo on GitHub in the browser
```

### 2. Look at the history
```bash
git status        # what has changed?
git log --oneline # list of snapshots (commits)
```

### 3. Make a change
Create a new notes file:
```bash
echo "# My DevOps notes" > NOTES.md
echo "- Today I learned Git!" >> NOTES.md
git status        # NOTES.md shows as "untracked" (red)
```

### 4. Stage → commit → push
```bash
git add NOTES.md                     # put it in the staging area
git status                           # now green: ready to commit
git commit -m "Add my DevOps notes"  # take the snapshot with a message
git push                             # send it to GitHub
```
Refresh your repo page on GitHub. 🎉 `NOTES.md` is there.

> 💡 **Good commit messages** say *what* and *why*, for example: `Fix typo in greeting`, `Add health check endpoint`.

### 5. See what changed (diff)
```bash
echo "- Commits are snapshots" >> NOTES.md
git diff          # shows exactly what changed (+ added, - removed)
git commit -am "Add a note about commits"   # -a stages changed files, -m adds the message
git push
```

### 6. Protect `main` (how real teams work) 🔒
So far you pushed straight to `main`. In real teams **nobody does that**: `main` is what users get, so every change goes through a **branch** and a **pull request (PR)** where the robots (CI) and teammates check it first. Let's make GitHub enforce that on your repo.

On GitHub, in **your** repo:
1. **Settings** → **Rules** → **Rulesets** → **New ruleset** → **New branch ruleset**.
2. **Ruleset name:** `Protect main` · **Enforcement status:** **Active**.
3. **Bypass list:** leave it **empty** (so the rule applies to you too).
4. **Target branches** → **Add target** → **Include default branch**.
5. Under **Rules**, tick:
   - ✅ **Restrict deletions** (usually ticked already)
   - ✅ **Require a pull request before merging** → *Required approvals*: **0** (you're working alone today)
   - ✅ **Block force pushes** (usually ticked already)
6. Click **Create**.

<details><summary>On your own PC with GitHub CLI? One command instead</summary>

(Codespaces' built-in login isn't allowed to change repo settings, so use the website there.)
```bash
gh api -X POST repos/{owner}/{repo}/rulesets --input - <<'EOF'
{"name":"Protect main","target":"branch","enforcement":"active",
 "conditions":{"ref_name":{"include":["~DEFAULT_BRANCH"],"exclude":[]}},
 "rules":[{"type":"deletion"},{"type":"non_fast_forward"},
  {"type":"pull_request","parameters":{"required_approving_review_count":0,"dismiss_stale_reviews_on_push":false,
   "require_code_owner_review":false,"require_last_push_approval":false,"required_review_thread_resolution":false}}]}
EOF
```
</details>

**Prove it works:** try to push straight to `main`:
```bash
echo "- Direct pushes to main are blocked" >> NOTES.md
git commit -am "Try a direct push"
git push
```
❌ GitHub refuses:
```
remote: error: GH013: Repository rule violations found for refs/heads/main.
remote: - Changes must be made through a pull request.
 ! [remote rejected] main -> main (push declined due to repository rule violations)
```
That's exactly what we want. Your commit is still safe on your computer. Next you'll send it the right way.

### 7. Branch → push → pull request → merge
A **branch** is a parallel copy where you can work safely without breaking `main`. Move the commit you just made onto a new branch:
```bash
git switch -c docs/first-notes      # short-lived branch (it includes your new commit)
echo "- Branches keep main safe" >> NOTES.md
git commit -am "Add a note about branches"
git push -u origin docs/first-notes # ✅ pushing a branch is allowed
```
Now open a **pull request (PR)**: a request to merge your branch into `main`. Do it from the VS Code terminal with GitHub CLI:
```bash
gh pr create --fill            # creates the PR (title and description from your commit)
gh pr view --web               # look at it on GitHub
gh pr merge --merge --delete-branch   # merge it, delete the branch, switch back to main
```
`gh pr merge` also switches you back to `main` and pulls the merged change. Check:
```bash
git branch        # * main
git status        # "Your branch is up to date with 'origin/main'"
cat NOTES.md      # both new lines are now in main
```

> 🔁 **From now on, every change follows the same 4 steps:**
> ```bash
> git switch main && git pull                   # start from the latest main
> git switch -c TYPE/SHORT-DESCRIPTION          # 1. short-lived branch
> git commit -am "What and why"                 # 2. commit (repeat as needed)
> git push -u origin TYPE/SHORT-DESCRIPTION     # 3. push the branch
> gh pr create --fill && gh pr merge --merge --delete-branch   # 4. PR + merge
> ```
> In a team, get a teammate to review the PR and confirm the required checks pass before merging.

<details><summary>Prefer clicking? Do it on the website instead</summary>

On GitHub you'll see a yellow banner: **Compare & pull request**. Click it → **Create pull request** → **Merge pull request** → **Confirm**. Then in the terminal:
```bash
git switch main
git pull
```
You can also use the **GitHub Pull Requests** panel in the VS Code sidebar.
</details>

## ✅ Checkpoint
- [ ] `NOTES.md` is visible on GitHub with 4 notes
- [ ] A direct `git push` to `main` was **rejected** by your `Protect main` ruleset
- [ ] You merged one pull request (`gh pr list --state merged` shows it)
- [ ] You can explain *add → commit → push* to your neighbour

## 🏋️ Mini challenge
Undo a mistake: add a silly line to `NOTES.md`, then throw the change away **before** committing:
```bash
git restore NOTES.md
```

## 🆘 Troubleshooting
| Problem | Fix |
|---|---|
| `Please tell me who you are` | Do step 1. More Git settings problems: [Git config troubleshooting](#-git-config-troubleshooting) |
| `nothing to commit` | You haven't changed anything, or forgot to save the file (<kbd>Ctrl</kbd>+<kbd>S</kbd>) |
| `GH013: Repository rule violations` / `Changes must be made through a pull request` | Your `main` is protected (step 6). Good! Move your work to a branch: `git switch -c fix/my-fix`, `git push -u origin fix/my-fix`, then `gh pr create --fill` |
| After a rejected push, `main` says *ahead of 'origin/main' by 1 commit* | Your commit is only local. `git switch -c fix/my-fix` takes it with you; then on `main` run `git switch main && git reset --hard origin/main` to clean up |
| No **Rules → Rulesets** in Settings | Use **Settings → Branches → Add classic branch protection rule**: pattern `main`, tick **Require a pull request before merging** and **Do not allow bypassing the above settings** |
| `rejected… fetch first` | Someone (maybe you, on GitHub) changed `main`. Run `git pull`, then `git push` again |
| `gh: command not found` | Codespaces: rebuild with **F1 → Codespaces: Rebuild Container**. Own PC: [Windows setup step 7](../docs/local-setup-windows.md#7-install-github-cli-and-sign-in) |
| `gh` says *not logged in* or `git push` asks for a password | Run `gh auth login`, then `gh auth setup-git` |
| `gh pr create` asks "Where should we push the branch?" | Choose your own repo (`YOUR-USERNAME/devops-roadmap-basics`) |
| Stuck in a strange editor after `git commit` | You forgot `-m`. Type `:wq` and press <kbd>Enter</kbd> to save and exit |

## 🔧 Git config troubleshooting

**See your settings and where each one comes from:**
```bash
git config --list --show-origin     # every setting + the file it's in
git config user.email               # the email THIS repo will use
```
> 💡 **Global vs local.** `--global` applies to every repo on this computer (saved in `~/.gitconfig`). Without `--global`, a setting applies to **this repo only** (saved in `.git/config`) and wins over the global one. Handy if you use a work and a personal GitHub account on one PC: set the work email globally, and the personal one locally in personal repos (or the reverse).

| Problem / message | Why | Fix |
|---|---|---|
| `Author identity unknown` / `*** Please tell me who you are.` | No name or email set | `git config --global user.name "Your Name"` and `git config --global user.email "you@…"`, then commit again |
| Commit on GitHub shows a **grey avatar** or **someone else's name** | The commit email isn't one linked to your GitHub account | Set the right email (your no-reply address), then fix the last commit: `git commit --amend --reset-author --no-edit` and `git push --force-with-lease` *(only on your own branch)* |
| `GH007: Your push would publish a private email address` | GitHub blocks pushes that expose your private email | `git config --global user.email "ID+USERNAME@users.noreply.github.com"`, then `git commit --amend --reset-author --no-edit` and push again |
| Typo in your name or email | | Run the same `git config --global user.name …` again (it overwrites). Remove a setting: `git config --global --unset user.name` |
| `fatal: detected dubious ownership in repository at '…'` | The folder belongs to another user (common under `/mnt/c/...` in WSL, or after copying folders) | `git config --global --add safe.directory '/full/path/to/repo'` (Git prints the exact command). Better on WSL: keep repos in `~/` |
| `hint: You have divergent branches…` / `fatal: Need to specify how to reconcile divergent branches` | GitHub and your PC both have new commits, and Git asks how to combine them | `git config --global pull.rebase false`, then `git pull` again (it creates a merge commit) |
| `Support for password authentication was removed` / push asks for a password | GitHub doesn't accept account passwords for Git | `gh auth login` then `gh auth setup-git` ([Windows guide, step 7](../docs/local-setup-windows.md#7-install-github-cli-and-sign-in)). Never paste a token into chat or a file |
| `git commit` opens a strange editor (vim) | No `-m` and the default editor is vim | Type `:wq` + <kbd>Enter</kbd> to save and exit (`:q!` to cancel). Avoid it: `git config --global core.editor "code --wait"` |
| New repo starts on `master`, GitHub uses `main` | Old default branch name | `git config --global init.defaultBranch main`. For an existing repo: `git branch -m master main` |
| `warning: LF will be replaced by CRLF` / scripts fail with `$'\r': command not found` (Windows) | Windows and Linux use different line endings | In WSL: `git config --global core.autocrlf input`, and use Git **inside Ubuntu**, not Git for Windows, for repos in WSL |
| Settings "don't work" | A local setting overrides the global one | `git config --list --show-origin` shows which file wins. Remove the local one: `git config --unset user.email` |

➡️ Next: [Lab 3: Docker basics](03-docker-basics.md)
