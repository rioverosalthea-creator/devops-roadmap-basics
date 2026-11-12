# Lab 7: Wrap-up & your roadmap (30 min)

## 🎉 What you did today
You took one app through the full DevOps loop:

| ✅ | Skill | Tool you used |
|---|---|---|
| ✅ | Controlled a Linux machine from the terminal | bash |
| ✅ | Tracked changes, protected `main`, and shipped every change through a branch + pull request | Git, GitHub, rulesets |
| ✅ | Packaged an app so it runs the same everywhere | Docker |
| ✅ | Ran a multi-container app with one command | Docker Compose |
| 💬 | Understood VMs vs containers, Kubernetes, monolith vs microservices, web app vs API | Discussion |
| ✅ | Automated testing and building on every push | GitHub Actions |
| ✅ | Created and destroyed infrastructure from code | Terraform |
| ✅ | Watched an app live and caught an outage | Prometheus, Grafana |

That is the foundation of every DevOps job. 🙌

## 🧠 Quick quiz (discuss with your neighbour)
1. What's the difference between an **image** and a **container**?
2. Why did the **Build** job not run when a test failed?
3. Why is it better to create servers with **Terraform** than by clicking in a web console?
4. What does `git push` do? Why did pushing straight to `main` fail after Lab 2?
5. Your app is down at 2 a.m. What tells you before users complain?
6. Name one difference between a **VM** and a **container**, and one job **Kubernetes** does that Docker Compose doesn't.
7. A 3-person start-up: **monolith** or **microservices**? Is `/health` part of a **web app** or an **API**?

<details>
<summary>Answers</summary>

1. An image is the template. A container is a running copy of it.
2. `needs: test`: the pipeline stops early so broken code isn't shipped.
3. It's repeatable, reviewable in Git, and documents itself.
4. Sends your local commits to GitHub. Your `Protect main` ruleset only accepts changes to `main` through a pull request, so work goes on a branch first.
5. Monitoring and alerting (e.g. Prometheus + Grafana).
6. A VM has its own OS (GBs, minutes to boot); a container shares the host kernel (MBs, seconds). Kubernetes runs containers across many machines and self-heals or scales them.
7. Usually a monolith (simpler, faster to start). `/health` is an API: it returns JSON for machines.
</details>

## 🗺️ What to learn next
See **[docs/roadmap.md](../docs/roadmap.md)** for a step-by-step path, free resources and project ideas.

## 🧹 Before you leave
1. Save anything you want to keep, the protected way:
   ```bash
   git switch -c end-of-seminar
   git add -A && git commit -m "End of seminar"
   git push -u origin end-of-seminar
   gh pr create --fill && gh pr checks --watch && gh pr merge --merge --delete-branch
   ```
2. **Stop all the lab containers** (web app, Redis, Prometheus, Grafana, `web1`, `my-app`, `terraform-nginx`):
   ```bash
   bash scripts/cleanup.sh
   ```
   ✅ It ends with *Containers still running: none*. Nothing else on your machine is touched.
   > On your **own PC** and need the disk space back? `bash scripts/cleanup.sh --all` also deletes the lab's images (about 1 GB). They download again next time you start.
3. **Stop your Codespace** to save your free hours: <https://github.com/codespaces> → **⋯** → **Stop codespace** (or in the terminal: `gh codespace stop`).
4. **Optional, set it and forget it:** <https://github.com/settings/codespaces> →
   - **Default idle timeout:** `30` minutes (or less). An idle Codespace stops itself, and all its containers stop with it.
   - **Default retention period:** e.g. `7` days. Stopped Codespaces you don't use are deleted automatically, so they don't use your free storage.
5. Your repository stays on GitHub. It's the start of your DevOps portfolio! ⭐

> 💡 **Why this matters (it's real DevOps!):** forgotten servers and containers cost money and can be a security risk. Real teams clean up after tests the same way: `terraform destroy`, `docker compose down`, auto-shutdown schedules.

## 🙏 Feedback
Tell the instructor one thing you liked and one thing to improve. Thank you!
