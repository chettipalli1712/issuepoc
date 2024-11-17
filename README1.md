Certainly! Below is a combined README document that explains both workflows, **SDLC Build-Deploy Dev** and **SDLC Deploy Non-Dev**, in a single document for easy implementation in your GitHub repositories.

---

# SDLC Build-Deploy & Deploy Non-Dev Workflows

This repository includes two GitHub Actions workflows to automate your SDLC (Software Development Lifecycle) pipeline for both development and non-development environments.

- **SDLC Build-Deploy Dev**: This workflow builds and deploys your application to the development environment, including container image building, scanning, testing, and deployment.
- **SDLC Deploy Non-Dev**: This workflow handles deployments to non-development environments such as Test (`tst`), UAT (`uat`, `uat-cac`, `uat-cae`), and Production (`prd`, `prd-cae`, `prd-cac`).

Both workflows can be easily configured and triggered manually through GitHub Actions' `workflow_dispatch` event.

---

## Workflow Overview

### 1. **SDLC Build-Deploy Dev**
This workflow automates the build, deployment, and testing process for development environments. It is triggered manually using `workflow_dispatch`.

#### Key Steps:
1. **Checkout the Repository**: Pulls the latest changes from your repository.
2. **Set Container Image Version**: Reads the version from a `.version` file (if present).
3. **Build Container**: Builds the container image using a specified Dockerfile.
4. **Scan with Snyk**: Scans the container image for vulnerabilities using Snyk.
5. **Run Unit Tests**: Executes automated unit tests.
6. **Deploy to AKS**: Deploys the container to Azure Kubernetes Service (AKS).

### 2. **SDLC Deploy Non-Dev**
This workflow automates the deployment process for non-development environments such as test, UAT, and production environments. It also supports integration tests, release candidate publishing, smoke and performance tests, and DAST scanning.

#### Key Steps:
1. **Run Integration Tests**: Executes integration tests before deploying to `tst`.
2. **Deploy to Test**: Deploys to the `tst` environment.
3. **Publish Release Candidate**: Publishes a release candidate for `uat` and `prd` environments.
4. **Run Smoke Tests**: Executes smoke tests for `uat` and `prd` environments.
5. **Run Performance Tests**: Executes performance tests for `uat` and `prd` environments.
6. **Run DAST Scan**: Performs a Dynamic Application Security Testing (DAST) scan for `uat` and `prd`.
7. **Deploy to UAT/Production**: Deploys to UAT or production environments.

---

## Workflow Trigger

### SDLC Build-Deploy Dev Workflow
Triggered manually through the `workflow_dispatch` event. The user can specify which function to deploy (e.g., `GA-Data`, `Member-Data`, `OA-Data`) and the version of the container image.

### SDLC Deploy Non-Dev Workflow
Also triggered manually via `workflow_dispatch`. The user specifies the environment to deploy (`tst`, `uat`, `prd`, etc.), the container image version, the change ticket number (for production deployments), and the function to deploy.

---

## Inputs for `workflow_dispatch`

### SDLC Build-Deploy Dev Workflow Inputs:
- **`function`** (Required): Specifies the function or module to deploy. Options include:
  - `GA-Data`
  - `Member-Data`
  - `OA-Data`
  
### SDLC Deploy Non-Dev Workflow Inputs:
- **`action`** (Required): The environment to deploy to:
  - `tst` – Test environment
  - `uat-cac` – UAT CAC environment
  - `uat-cae` – UAT CAE environment
  - `uat` – UAT environment
  - `prd-cac` – Production CAC environment
  - `prd-cae` – Production CAE environment
  - `prd` – Production environment
- **`container_img_version`** (Required): The tag for the container image to deploy.
- **`change_ticket`** (Optional): A change ticket number, required only for production deployments.
- **`function`** (Required): The function to deploy (e.g., `GA-Data`, `Member-Data`, `OA-Data`).

---

## Workflow Jobs

### SDLC Build-Deploy Dev Workflow Jobs:

#### 1. **SDLC Setup**
- **Checks out the repository**, sets the container image version and Git commit short SHA.
  
#### 2. **SDLC Build Container**
- **Builds the container** using the Dockerfile located in the specified function folder.

#### 3. **SDLC Scan Container Image - Snyk**
- **Scans the container image** for vulnerabilities using the Snyk API.

#### 4. **SDLC Scan Container Image - Review**
- **Creates an issue** if vulnerabilities are found during the scan.

#### 5. **Run Unit Test Cases**
- **Runs unit tests** after the container image has been scanned.

#### 6. **Deploy Container**
- **Deploys the container** to the development environment (AKS).

### SDLC Deploy Non-Dev Workflow Jobs:

#### 1. **Run Integration Test Cases** (`tst`)
- **Runs integration tests** before deploying to the test environment.

#### 2. **Deploy to Test (`tst`)**
- **Deploys** to the `tst` environment after integration tests.

#### 3. **Publish Release Candidate** (`uat`, `uat-cac`, `uat-cae`)
- **Publishes a release candidate** for the UAT environments.

#### 4. **Run Smoke Test Cases** (`uat`, `uat-cac`, `uat-cae`)
- **Runs smoke tests** for the UAT environments.

#### 5. **Run Performance Test Cases** (`uat`, `uat-cac`, `uat-cae`)
- **Runs performance tests** for the UAT environments.

#### 6. **SDLC Scan DAST - Manual** (`uat`, `uat-cac`, `uat-cae`)
- **Runs a DAST scan** to check for security vulnerabilities in the deployed application.

#### 7. **Deploy to UAT/Production**
- **Deploys to the UAT or production environments**, using the change ticket number for production deployments.

---

## Example Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── sdlc-build-deploy-dev.yml
│       └── sdlc-deploy-non-dev.yml
├── aks-details/
│   ├── GA-Data-aks.json
│   ├── Member-Data-aks.json
│   └── OA-Data-aks.json
├── GA-Data/
│   └── Dockerfile
├── Member-Data/
│   └── Dockerfile
├── OA-Data/
│   └── Dockerfile
├── .version
├── src/
└── README.md
```

---

## How to Implement These Workflows

### Step 1: Create Workflow Files

1. **Create two workflow files** in `.github/workflows/`:
   - `sdlc-build-deploy-dev.yml`
   - `sdlc-deploy-non-dev.yml`
   
2. **Copy the workflow content** from this document into the respective files.

### Step 2: Customize the Configuration Files

- Ensure that the `aks-details/${{ inputs.function }}-aks.json` file exists in your repository and contains the appropriate configuration for your environments.
- If your repository contains a single application with the Dockerfile at the root level, remove the function-related inputs from the workflows.

### Step 3: Set Secrets in GitHub

You will need to configure the following secrets in your repository settings:
- `DOCKER_USERNAME` and `DOCKER_PASSWORD` (for Docker registry authentication).
- `SNYK_TOKEN` (for Snyk API).
- Any necessary secrets for AKS deployment (e.g., Azure credentials, Kubeconfig).

### Step 4: Trigger the Workflow

You can trigger the workflow manually via the GitHub Actions UI:
1. Navigate to the "Actions" tab in your GitHub repository.
2. Select the workflow you want to run (either `SDLC Build-Deploy Dev` or `SDLC Deploy Non-Dev`).
3. Click on **"Run workflow"** and fill in the required input parameters.

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)
- [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/)
- [Snyk Documentation](https://snyk.io/docs/)

---

By following these instructions, you can set up automated SDLC pipelines for both development and non-development environments using GitHub Actions. This ensures efficient and reliable deployments while maintaining best practices for CI/CD.
