# DevOps Roadmap Basics 🚀

A **one-day, hands-on introduction to DevOps** for complete beginners.

You'll take one small web app through a complete DevOps workflow, all in your web browser:

```
  Write code ──► Save it in Git ──► Package it with Docker ──► Test & build automatically (CI/CD)
                                                                         │
            Watch it with monitoring ◄── Create infrastructure as code ◄─┘
```

> **Nothing to install.** Everything runs in **GitHub Codespaces**: a Linux computer in your browser with Git, Docker, Python and Terraform already set up. It works on any Windows PC, even when you can't install software.

---

## ✅ Before the seminar

1. Create a free GitHub account at <https://github.com/signup>.
2. Use Google Chrome or Microsoft Edge.

That's it.

## ▶️ Start here

1. Click **Use this template → Create a new repository** (top right of this page). Name it `devops-roadmap-basics` and keep it **Public**.
2. In **your new repository**, click **Code → Codespaces → Create codespace on main**.
3. Wait 1–2 minutes. When the terminal at the bottom shows a `$` prompt, you're ready.

Step-by-step walkthrough: [Lab 0: Setup](labs/00-setup.md).

---

## 🗓️ Agenda (one day)

| Time | Session | What you'll do |
|---|---|---|
| 09:00 | [0. Setup & What is DevOps?](labs/00-setup.md) | Open your Codespace and learn the big picture |
| 09:45 | [1. Linux terminal basics](labs/01-linux-basics.md) | Move around, create and read files |
| 10:30 | ☕ Break | |
| 10:45 | [2. Git & GitHub](labs/02-git-basics.md) | Commit changes and use short-lived branches + pull requests |
| 11:45 | [3. Docker basics](labs/03-docker-basics.md) | Run containers and build your own image |
| 12:45 | 🍽️ Lunch | |
| 13:30 | [4. Docker Compose](labs/04-docker-compose.md) | Run the app and a database together |
| 14:15 | [💬 Discussion: Containers, Kubernetes & architecture](labs/04b-discussion-containers-kubernetes-architecture.md) | VMs vs containers, Kubernetes, monolith vs microservices, web app vs API *(talk only, no hands-on)* |
| 14:45 | [5. CI/CD with GitHub Actions](labs/05-ci-cd-github-actions.md) | Automatic tests and builds on every push |
| 15:45 | ☕ Break | |
| 16:00 | [6. Cloud, IaC & Monitoring](labs/06-cloud-iac-monitoring.md) | Terraform basics + a live Grafana dashboard |
| 17:00 | [7. Wrap-up & your roadmap](labs/07-wrap-up.md) | What to learn next |

## 📁 What's in this repo

| Folder / file | What it is |
|---|---|
| `app/` | A tiny Python web app (Flask) with tests and a `Dockerfile` |
| `compose.yaml` | Runs the app + Redis (and optionally Prometheus + Grafana) |
| `.github/workflows/ci.yml` | The CI/CD pipeline |
| `iac/` | Terraform examples (no cloud account needed) |
| `monitoring/` | Prometheus and Grafana configuration |
| `labs/` | Step-by-step guides for each session |
| `scripts/` | `start.sh` starts the app, Grafana and Prometheus and prints the links ([ports guide](docs/ports.md)) · `cleanup.sh` stops and removes all lab containers after the session |
| `docs/` | [Run & open the 3 ports](docs/ports.md), [Cheat sheet](docs/cheatsheet.md), [Windows local setup](docs/local-setup-windows.md), [What to learn next](docs/roadmap.md) |
| `instructor/` | [Instructor guide](instructor/INSTRUCTOR_GUIDE.md): timing, prep checklist and backup plans |

## 🆘 Stuck?

- Check the **Troubleshooting** section at the bottom of each lab.
- Look up a command in the [cheat sheet](docs/cheatsheet.md).
- Ask your neighbour, then the instructor. Helping each other is very DevOps. 🙂

---

Made by [John Ed Manauis](https://neo64347.github.io/portfolio-manauis/), DevOps Engineer. Free to use for teaching under the [MIT License](LICENSE).
