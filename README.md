# Azure Kubernetes Deployment with Python Microservice

This repository provides an end-to-end solution to provision an **Azure Kubernetes Service (AKS)** cluster, deploy a containerized Python microservice to it, and automate the process using CI/CD pipelines.

---

## **Features**
- Provision a Kubernetes cluster on Azure using **Terraform**.
- Deploy a Python microservice using Kubernetes manifests.
- Use **Azure Container Registry (ACR)** to store container images.
- Automate the build and deployment process with GitHub Actions.

---

## **Prerequisites**
1. **Azure Account**: Sign up for an [Azure account](https://azure.microsoft.com/free/) if you don't already have one.
2. **Terraform**: Install [Terraform](https://www.terraform.io/downloads) (v1.5.0 or higher).
3. **Azure CLI**: Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
4. **Kubectl**: Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
5. **GitHub Account**: Fork this repository and configure it in your GitHub account.

---

## **Project Setup Guide**

### **Step 1: Clone the Repository**

```bash
git clone https://github.com/OmarReda/Microservices.git
cd Microservices
```

---

### **Step 2: Configure Azure Credentials**

1.	Login to Azure:
```bash
az login
```
2.	Set your Azure subscription ID as an environment variable:
```bash
export ARM_SUBSCRIPTION_ID=<your-subscription-id>
export ARM_CLIENT_ID=<client-id>
export ARM_CLIENT_SECRET=<client-secret>
export ARM_TENANT_ID=<tenant-id>
```

You can create a Service Principal if needed:
```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<your-subscription-id>" --query="{clientId:appId, clientSecret:password, tenantId:tenant}"
```

---

### **Step 3: Provision Kubernetes Cluster with Terraform**

1.	Navigate to the Terraform directory:
```bash
cd terraform
```
2.	Initialize Terraform:
```bash
terraform init
```
3.	Validate the Terraform configuration:
```bash
terraform validate
```
4.	Plan the infrastructure changes:
```bash
terraform plan
```
5.	Apply the changes:
```bash
terraform apply
```	
6.	Save the kubeconfig output to access your cluster:
```bash
echo "$(terraform output kube_config)" > kubeconfig
export KUBECONFIG=kubeconfig
```

This will create the following resources:
- Azure Resource Group
- Azure Kubernetes Service (AKS) cluster
- Azure Container Registry (ACR)

---

### **Step 4: Push Python App to ACR**

1.	Build and push the Docker image to ACR using the provided GitHub Actions workflow:
    - Trigger Workflow:
    - Go to the Actions tab in your GitHub repository.
    - Select the “Code Build and Deploy” workflow.
    - Trigger it manually or push changes to the main branch.
2.	Verify the image in your ACR:
```bash
az acr repository list --name <acr-name> --output table
```

---

### **Step 5: Deploy Python App to Kubernetes**

1.	Deploy the Kubernetes manifests:
```bash
kubectl apply -f ops/AKS Deployment/deployment.yaml
kubectl apply -f k8s/AKS Deployment/service.yaml
kubectl apply -f k8s/AKS Deployment/ingress.yaml
```
2.	Verify the deployment:
```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```
3.	Access your application:
    - Use the external IP of the ingress or LoadBalancer to access the app.

--- 

### **Step 6: Automate Deployment Using GitHub Actions**

1.	Kubernetes Deployment Workflow:
    - A separate workflow automates the Kubernetes deployment.
    - Trigger this workflow manually from the Actions tab or upon updates to the k8s/ directory.
2.	ACR Login and KubeConfig Secrets:
	- Ensure the following secrets are configured in your GitHub repository:
	- AZURE_CLIENT_ID
	- AZURE_CLIENT_SECRET
	- AZURE_TENANT_ID
	- KUBECONFIG

---

### **Important Notes**

- Accessing the Application:
    - Use the external IP of the LoadBalancer or Ingress Controller.
    - If using Ingress, update your DNS to point to the external IP.
- Terraform State:
    - Store terraform.tfstate in a secure backend for shared state management.
- Testing Locally:
    - Use Docker Compose to run the Python app locally if needed.