Below is a README document tailored for users who want to implement the provided GitHub Actions workflow in their repositories. This README will help them understand how to configure, use, and customize the workflow for their specific needs.

---

# SDLC Build-Deploy Dev Workflow

This GitHub Actions workflow automates the SDLC pipeline for building, scanning, testing, and deploying containerized applications. It is designed to integrate with a variety of tools, including Docker, Snyk, and Azure Kubernetes Service (AKS). You can customize this workflow for your own project to automate the deployment of applications in a consistent and repeatable manner.

## Workflow Overview

The workflow is designed to perform the following tasks:
1. **Setup**: Retrieves necessary metadata like Git commit hash and container image version.
2. **Build Container**: Builds a Docker image based on the provided `Dockerfile` and context.
3. **Security Scanning**: Scans the built container image for vulnerabilities using Snyk.
4. **Review**: Creates an issue if vulnerabilities are found in the container image.
5. **Unit Testing**: Runs automated unit tests for the code.
6. **Deployment**: Deploys the container image to a Kubernetes cluster (AKS) using the specified configuration.

## Workflow Trigger

### `workflow_dispatch`
This workflow is manually triggered via the GitHub Actions UI, with an input option to specify which environment or function to deploy to. The default function is `GA-Data`, but it can be configured to support other environments, like `Member-Data` or `OA-Data`.

### Optional Trigger on Push

You can uncomment the `push` trigger to automatically run this workflow on commits to specific branches (e.g., `feature/**`).

```yaml
on:
  push:
    branches:
      - 'feature/**'  # Uncomment this line if you want to trigger the workflow on feature branch pushes
  workflow_dispatch:
    inputs:
      function:
        type: choice
        required: true
        default: GA-Data
        description: Deploy to
        options:
          - GA-Data
          - Member-Data
          - OA-Data
```

## Workflow Structure

This workflow consists of multiple jobs that execute in sequence:

### 1. `sdlc-setup`
- **Purpose**: This job sets up the environment and prepares metadata, including the container image version and Git commit SHA.
- **Key Steps**:
  - Checkout the repository.
  - Set container image version based on the `.version` file or default to `1.0.0`.
  - Set the Git short SHA.
  
### 2. `sdlc-build-container`
- **Purpose**: Builds the Docker container using the Dockerfile and context specific to the selected function.
- **Key Steps**:
  - Build the Docker image using the specified `Dockerfile`.
  - Uses the `CONTAINER_IMG_VERSION` from the setup job.

### 3. `sdlc-scan-container-image-snyk`
- **Purpose**: Scans the built container image for vulnerabilities using Snyk.
- **Key Steps**:
  - Scan the Docker image with the Snyk security scanner.

### 4. `sdlc-scan-container-review`
- **Purpose**: Reviews the results of the container scan and creates an issue if vulnerabilities are found.
  
### 5. `run-unit-test-cases`
- **Purpose**: Runs automated unit tests on the code base. This job depends on the successful completion of the scan and review steps.

### 6. `deploy-container`
- **Purpose**: Deploys the built and tested container to AKS (Azure Kubernetes Service) using the specified configuration for the environment.
  
---

## How to Implement This Workflow

### Step 1: Setup Workflow File

1. **Create a new file in `.github/workflows/`**. You can name the file `sdlc-build-deploy-dev.yml` or something similar.
2. **Copy the workflow content** into this file.

### Step 2: Customize Inputs and Configuration

If your repository is hosting multiple functions or services, you may need to adjust the workflow to accommodate different contexts.

1. **Function Input**: The workflow supports a function input parameter, which can be used to specify the function or environment you're deploying to. You can adjust the list of available options in the `workflow_dispatch` section.

   ```yaml
   inputs:
     function:
       type: choice
       required: true
       default: GA-Data
       description: Deploy to
       options:
         - GA-Data
         - Member-Data
         - OA-Data
   ```

2. **Docker Context**: If your project uses different `Dockerfile` paths, make sure the context is properly set. For example, if you're building different containers for different services, adjust the `DOCKERFILE` and `DOCKERCONTEXT` variables:

   ```yaml
   DOCKERFILE: ./${{ inputs.function }}/Dockerfile
   DOCKERCONTEXT: ./${{ inputs.function }}
   ```

   If your `Dockerfile` is in the root directory, remove the `${{ inputs.function }}` prefix.

3. **AKS Configuration**: Ensure that the path to your AKS configuration file is correct. This is usually specified under `./aks-details/${{ inputs.function }}-aks.json`.

### Step 3: Add Secrets

For security, this workflow uses GitHub secrets. Make sure the following secrets are set in your repository’s settings:

- `DOCKER_USERNAME` and `DOCKER_PASSWORD` (for Docker registry authentication).
- `SNYK_TOKEN` (for Snyk API).
- Any additional secrets required for your AKS deployment.

### Step 4: Trigger the Workflow

You can trigger the workflow manually through the GitHub Actions interface, or you can configure it to trigger on pushes to specific branches (e.g., feature branches). To trigger manually, go to the "Actions" tab of your repository, select the workflow, and click the "Run workflow" button.

---

## Notes

- If your repository uses a monorepo structure with multiple services or functions, this workflow can be customized to build and deploy each service individually.
- This workflow assumes you're using a Dockerized application and deploying it to an Azure Kubernetes Service (AKS) cluster. If you're using another cloud provider or deployment target, you'll need to modify the deployment step.
- Ensure that your Dockerfile and AKS configurations are in the correct locations as specified in the workflow.

---

## Example Repository Structure

For reference, here’s an example structure for a project using this workflow:

```
.
├── .github/
│   └── workflows/
│       └── sdlc-build-deploy-dev.yml
├── aks-details/
│   └── GA-Data-aks.json
│   └── Member-Data-aks.json
│   └── OA-Data-aks.json
├── GA-Data/
│   └── Dockerfile
├── Member-Data/
│   └── Dockerfile
├── OA-Data/
│   └── Dockerfile
├── .version
├── src/
├── tests/
└── README.md
```

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)
- [Snyk Documentation](https://snyk.io/docs/)
- [Azure Kubernetes Service Documentation](https://learn.microsoft.com/en-us/azure/aks/)

---

By following these steps, you'll be able to easily integrate the SDLC build-deploy pipeline into your repository and automate your development, testing, and deployment processes.

