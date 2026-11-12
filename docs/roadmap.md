# Your DevOps roadmap 🗺️ (what to learn next)

Go step by step. Each stage builds on the last. Spend **2–4 weeks** per stage, practising a little every day.

```
 1. Linux & networking ─► 2. Git ─► 3. Scripting ─► 4. Docker ─► 5. CI/CD ─► 6. Cloud ─► 7. IaC ─► 8. Kubernetes ─► 9. Observability
     (today: basics)    (today)                  (today)      (today)               (today)                       (today)
```

| # | Stage | Learn | Free resources |
|---|---|---|---|
| 1 | **Linux & networking** | Files, permissions, processes, SSH, DNS, HTTP, ports | [Linux Journey](https://linuxjourney.com), [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) (a game!) |
| 2 | **Git** | Branches, merge conflicts, pull requests | [Learn Git Branching](https://learngitbranching.js.org) (interactive) |
| 3 | **Scripting** | Bash scripts, then Python for automation | [Automate the Boring Stuff with Python](https://automatetheboringstuff.com) |
| 4 | **Containers** | Dockerfiles, volumes, networks, image size | [Docker docs: Get started](https://docs.docker.com/get-started/) |
| 5 | **CI/CD** | GitHub Actions: matrix builds, secrets, publishing images | [GitHub Actions docs](https://docs.github.com/actions) |
| 6 | **Cloud** | One provider well (AWS is the most common): compute, storage, networking, IAM | [AWS Skill Builder: Cloud Practitioner Essentials](https://skillbuilder.aws) (free) |
| 7 | **Infrastructure as Code** | Terraform with a real cloud provider, state, modules | [HashiCorp Terraform tutorials](https://developer.hashicorp.com/terraform/tutorials) |
| 8 | **Kubernetes** | Pods, Deployments, Services | [Kubernetes basics tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/), [Killercoda](https://killercoda.com) (browser labs) |
| 9 | **Observability** | Metrics, logs, alerts: Prometheus, Grafana, Loki | [Grafana tutorials](https://grafana.com/tutorials/) |

The full interactive map: **<https://roadmap.sh/devops>**

## 🛠️ Project ideas for your portfolio
1. **Your portfolio site** on GitHub Pages, deployed by a GitHub Actions workflow.
2. **Extend today's app:** add a Redis **volume**, publish the image to GitHub Container Registry from CI.
3. **Deploy it to the cloud** with Terraform (AWS free tier), and remember to `destroy` afterwards!
4. **Add an alert** in Grafana that fires when the app is down.

## 🎓 Certifications (later, when you're ready)
- AWS Certified Cloud Practitioner → AWS Solutions Architect / SysOps / Developer Associate
- HashiCorp Certified: Terraform Associate
- Certified Kubernetes Application Developer (CKAD)

> Tip: projects on GitHub + a short write-up of what you learned often impress interviewers more than certificates alone.
