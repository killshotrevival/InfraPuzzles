# Helm Charts: Edge Cases & Production Lessons Learned

This repository contains Helm charts and documentation covering various edge cases and challenges we've encountered while working with Helm in production environments. These are real-world problems that aren't commonly discussed in tutorials but can cause significant issues in production.

## 🚨 Why This Repository Exists

Helm is an excellent tool for managing Kubernetes applications, but it has several edge cases and gotchas that can catch even experienced engineers off guard. This repository documents our battle scars and solutions to help others avoid the same pitfalls.

## 📚 Edge Cases Covered

### Configuration Drift & Pod Restarts
**Problem**: Configuration changes don't automatically trigger pod restarts, leading to configuration drift and security vulnerabilities.

**Impact**: 
- Database connection failures due to stale credentials
- Security vulnerabilities from outdated API keys
- Hours of debugging and manual pod restarts
- Customer-facing outages

**Solution**: [Checksum Annotation Pattern](./rollout-restart/) - Using SHA256 checksums in annotations to force StatefulSet updates when configuration changes.

**Location**: [`./rollout-restart/`](./rollout-restart/)

## 🛠️ Tools & Utilities

### Helm Chart Testing
- [Helm Test](https://helm.sh/docs/chart_tests/) for chart validation
- [Chart Testing](https://github.com/helm/chart-testing) for linting and testing
- [Helm Unit](https://github.com/quintush/helm-unittest) for unit testing

### Security Scanning
- [Helm Security](https://github.com/helm/helm-security) for vulnerability scanning
- [Checkov](https://www.checkov.io/) for infrastructure security
- [Trivy](https://trivy.dev/) for container scanning

### Monitoring & Observability
- [Helm Dashboard](https://github.com/komodorio/helm-dashboard) for chart management
- [Helm Diff](https://github.com/databus23/helm-diff) for change visualization
- [Helm History](https://helm.sh/docs/helm/helm_history/) for deployment tracking

## 📖 Best Practices

### Chart Design
1. **Always use semantic versioning** for your charts
4. **Document all values** with examples and descriptions
5. **Test across multiple Kubernetes versions**

### Deployment Strategy
1. **Use blue-green or canary deployments** for critical applications
2. **Implement proper rollback procedures**
3. **Monitor deployment health** with readiness and liveness probes
4. **Use Helm hooks sparingly** and test thoroughly
5. **Implement deployment notifications** and logging

### Security
1. **Never commit secrets** to version control
2. **Use external secret management** when possible
3. **Implement RBAC** for chart access
4. **Scan charts for vulnerabilities** regularly
5. **Use signed charts** in production

## 🧪 Testing & Validation

### Local Testing
```bash
# Install dependencies
helm dependency build

# Lint the chart
helm lint .

# Test template rendering
helm template . --values values.yaml

# Dry run installation
helm install --dry-run --debug my-release .
```

### CI/CD Integration
```yaml
# Example GitHub Actions workflow
- name: Lint Helm Chart
  run: helm lint .

- name: Test Helm Chart
  run: helm test my-release

- name: Deploy to Staging
  run: helm upgrade --install my-release . --namespace staging
```

## ⚠️ Disclaimer

These solutions are based on our production experiences and may not work in all environments. Always test thoroughly in your specific context and consider the implications for your use case.

---

**Remember**: Helm is a powerful tool, but with great power comes great responsibility. Test thoroughly, monitor deployments, and always have a rollback plan ready.
