# Lab 5: CI/CD with GitHub Actions (60 min)

## 🎯 Goals
- Understand **CI** (Continuous Integration) and **CD** (Continuous Delivery/Deployment)
- Watch a pipeline run automatically on every push and pull request
- Make CI a **required check**, so a red ❌ pull request **cannot be merged**
- **Break** the build on purpose, see it blocked, then fix it ✅

## 💡 The idea
Imagine 10 developers changing the same app every day. Who checks that nothing broke? A **robot**.

- **CI:** every time code is pushed, automatically **test** it and **build** it.
- **CD:** if everything passes, automatically **release/deploy** it.

```
 branch + PR ──► GitHub Actions ──► [ Run tests ] ──pass──► [ Build Docker image + smoke test ] ──► ✅ Merge allowed
                                        │
                                      fail ──► ❌ Merge blocked, tell the developer
```

## 🛠️ Steps

### 1. Run the tests yourself first
```bash
cd app
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt -r requirements-dev.txt
python -m pytest -v
cd ..
```
✅ `3 passed`. Look at `app/tests/test_app.py`: each `test_…` function checks one thing.

### 2. Read the pipeline
```bash
cat .github/workflows/ci.yml
```
- `on:` **when** it runs (every push to `main`, every pull request)
- `jobs:` **what** runs: `test`, then `build` (`needs: test` means build only runs if tests pass)
- `steps:` the commands, the same kind you typed in Lab 3 and in step 1 above

### 3. Trigger it with a pull request
Your earlier work already ran it! On GitHub, open your repo → **Actions** tab and click the latest run.

`main` is protected since Lab 2, so make a branch and a PR:
```bash
git switch main && git pull
git switch -c ci/practice
echo "- CI runs on every pull request" >> NOTES.md
git commit -am "Trigger CI"
git push -u origin ci/practice
gh pr create --fill
gh pr checks --watch      # live: 🟡 pending → ✅ pass (about 1 minute)
```
Open the PR in the browser (`gh pr view --web`): at the bottom you'll see the two checks, **Run tests** and **Build and smoke-test Docker image**, with green ticks.

> 💡 Other ways to watch: the **Actions** tab, or `gh run watch` / `gh run list` in the terminal.

Don't merge yet. First, make the checks **required**.

### 4. Make CI a required check 🔒
Right now a PR could still be merged even if the tests fail. Let's stop that. On GitHub: **Settings → Rules → Rulesets → Protect main** (from Lab 2):
1. Tick ✅ **Require status checks to pass**.
2. Click **Add checks**, type and select **Run tests**, then **Build and smoke-test Docker image** (they appear because they've already run).
3. Click **Save changes**.

Now merge the PR. Its checks are green, so it's allowed:
```bash
gh pr merge --merge --delete-branch
```

### 5. Break it on purpose 🔨
New branch for a new change:
```bash
git switch -c fix/change-greeting
```
Change the app's greeting in `app/app.py`:
```python
greeting = os.getenv("GREETING", "Hello, DevOps!")
```
to
```python
greeting = os.getenv("GREETING", "Hi there!")
```
Save, then:
```bash
git commit -am "Change greeting"
git push -u origin fix/change-greeting
gh pr create --fill
gh pr checks --watch
```
❌ **Run tests** fails. Read the error (`gh pr checks` → click the link, or the **Actions** tab): `test_home_says_hello` expected `Hello, DevOps!`. Notice that **Build** never ran.

Now try to merge anyway:
```bash
gh pr merge --merge
```
🚫 GitHub refuses: the required check **Run tests** didn't pass. On the PR page the button says **Merging is blocked**. **The pipeline just protected `main` from a change nobody checked.** That's CI's whole job.

### 6. Fix it
On the same branch, either change the greeting back, **or** update the test to match the new behaviour in `app/tests/test_app.py`:
```python
    assert b"Hi there!" in response.data
```
Run `cd app && python -m pytest -v && cd ..` locally first (with the app's virtual environment activated), then push to the **same branch**. The PR updates by itself:
```bash
git commit -am "Update test for new greeting"
git push
gh pr checks --watch      # ✅ both green
gh pr merge --merge --delete-branch
```
✅ Merged into `main`, safely.

### 7. Add a status badge to your README
Same flow, as a quick practice:
```bash
git switch -c docs/ci-badge
```
Edit `README.md` and add this line at the top (replace `YOUR-USERNAME`):
```markdown
![CI](https://github.com/YOUR-USERNAME/devops-roadmap-basics/actions/workflows/ci.yml/badge.svg)
```
```bash
git commit -am "Add CI badge"
git push -u origin docs/ci-badge
gh pr create --fill && gh pr checks --watch && gh pr merge --merge --delete-branch
```
Look at your repo's front page.

## ✅ Checkpoint
- [ ] You saw a green ✅ run and a red ❌ run
- [ ] A PR with failing tests was **blocked** from merging
- [ ] You can explain why **Build** didn't run when tests failed
- [ ] Your README shows a CI badge

## 🏋️ Mini challenge
Using a branch and a PR, add a 4th test that checks `/health` returns `status` equal to `"ok"` using a different style, or tests a page that doesn't exist returns `404`:
```python
def test_unknown_page_is_404():
    assert client().get("/nope").status_code == 404
```

## 💡 Where does CD come in?
In real projects, one more job would **push the image to a registry** and **deploy** it (to AWS, Azure, Kubernetes…). Same idea: just more steps in the YAML file.

## 🆘 Troubleshooting
| Problem | Fix |
|---|---|
| No runs in the Actions tab | Click **Actions** → enable workflows if GitHub asks ("I understand my workflows…") |
| `pytest: command not found`, `ModuleNotFoundError` or `externally-managed-environment` | From the `app` folder, create and activate a virtual environment with `python3 -m venv .venv` and `source .venv/bin/activate`, then install dependencies with `python -m pip install -r requirements.txt -r requirements-dev.txt` and run `python -m pytest -v`. If `venv` is unavailable, install your OS's Python venv package first (for Debian/Ubuntu: `sudo apt install python3-venv`). |
| `gh pr checks` says *no checks reported* | The run hasn't started yet. GitHub can take **up to 1–2 minutes** to start CI on a new PR. Wait, then run `gh pr checks --watch` again |
| `GH013` / push to `main` rejected | `main` is protected (Lab 2). Push a branch and open a PR instead |
| Can't find **Run tests** under *Add checks* | The checks must have run at least once: finish step 3 first, wait for ✅, then add them |
| PR stuck on *Expected — Waiting for status to be reported* | The check name doesn't match exactly. Remove it and re-add it from the list (don't type a new name) |
| `gh pr merge` says the base branch policy prohibits the merge | That's the protection working: fix the failing check first |
| Push rejected on your branch | `git pull`, then `git push` |

➡️ Next: [Lab 6: Cloud, IaC & Monitoring](06-cloud-iac-monitoring.md)
