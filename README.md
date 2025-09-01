# InfraPuzzles

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
![Kubernetes](https://img.shields.io/badge/kubernetes-326CE5?&style=plastic&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat&logo=helm)

A collection of advanced IaC code examples tackling real-world SRE challenges. These aren't your basic "hello world" setups—they're puzzles drawn from production-scale problems like autoscaling clusters, zero-downtime migrations, and secure networking. Perfect for SREs, DevOps engineers, or anyone leveling up their Infrastructure as Code (IaC) game.


## Why InfraPuzzles?

As an SRE with experience scaling cloud systems on GCP and AWS, I've encountered plenty of tricky scenarios that standard docs don't cover. This repo shares reusable snippets and modules for those "gotcha" moments, like optimizing resource allocation in Kubernetes or ensuring high availability during DB migrations. Use them to:

- Solve complex infra puzzles in your own projects.
- Learn best practices for reliability and scalability.
- See practical applications of tools like GKE, Istio, and Cloud SQL.

Each example includes explanations, architecture diagrams (where relevant), and setup instructions to make them easy to adapt.

## Puzzles 

- [FinOps](./finOps/): Financial analysis of the operations
- [Helm](./helm/): Interesting Helm Examples
    - [Rollout Restart](./helm/rollout-restart/)
- [Istio](./istio/): Intersting Istio Deployments
    - [Multi Cluster Connect](./istio/multiClusterConnect/)
- [Kubernetes](./k8s/): Interesting kubernetes workings
    - [Finalizers in Namespace](./k8s/finalisingNamespace.md)

## Contributing

Got a tough infra puzzle? Contributions welcome! Fork the repo, add your example in a new directory, include a mini-README, and submit a PR. Follow these guidelines:
- Keep code modular and documented.
- Focus on SRE-relevant challenges like scalability, security, or observability.

## Contact

Questions or collaborations? Reach out:
- Email: peeyush12210@gmail.com
- LinkedIn: [Peeyush Tyagi](https://www.linkedin.com/in/peeyush-tyagi)

Happy puzzling! 🚀