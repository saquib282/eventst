# Project Name

## Prerequisites

- Terraform >= 1.6
- AWS CLI (configured)
- kubectl
- Jenkins

---

## Step 1 — Create Infrastructure (Terraform)

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

> Creates: VPC, subnets, EKS cluster, node groups.

---

## Step 2 — Connect to Cluster

```bash
aws eks update-kubeconfig --region us-east-1 --name <cluster-name>
kubectl get nodes
```

---

## Step 3 — Deploy via CI/CD (Jenkins)

Push to `master` branch — Jenkins pipeline triggers automatically.

**What the pipeline does:**
1. Build Docker image
2. Push image to registry
3. Deploy to Kubernetes using `kubectl apply`

**Manual trigger:**
Go to Jenkins → Select pipeline → Click **Build Now**

---

## Step 4 — Verify Deployment

```bash
kubectl get pods -n eventstrat
kubectl get services -n eventstrat
```

---

## Rollback

```bash
kubectl rollout undo deployment/<service-name> -n eventstrat
```
