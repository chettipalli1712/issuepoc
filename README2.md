# SonarQube Project Setup  

This guide outlines the steps required to set up a SonarQube project and integrate it into a GitHub Actions workflow.  

---

## Prerequisites  

1. **Access to SonarQube Portal**  
   - You must be added to the Access Control List (ACL) to access the SonarQube portal.  
   - Submit a ServiceNow request with the following details:  
     - **Name**  
     - **Email**  
     - **Team/Project Name**  

2. **GitHub Repository Access**  
   - Ensure you have access to the GitHub repository where the SonarQube integration will be configured.  

---

## Steps to Set Up a SonarQube Project  

### 1. Gain Access to the SonarQube Portal  

   - Submit a ServiceNow request to the appropriate team to get added to the ACL.  
   - Once access is granted, log in to the SonarQube portal using your organizational credentials.  

### 2. Create a Project in SonarQube  

1. **Log in to the Portal**  
   - Navigate to the SonarQube portal URL provided by your organization.  
2. **Create a New Project**  
   - Go to the **Projects** section and click **Create Project**.  
   - Provide the following details:  
     - **Project Name:** Name of your project.  
     - **Project Key:** A unique identifier for the project. This key will be used in the GitHub Actions workflow.  
3. **Save the Project Key**  
   - Note down the **Project Key** displayed on the project dashboard.  

### 3. Generate a SonarQube Token  

1. **Access Your Profile**  
   - Click on your profile icon in the top-right corner and select **My Account**.  
2. **Generate a Token**  
   - Navigate to the **Tokens** section.  
   - Click **Generate Token**, provide a name (e.g., `github-actions-token`), and set an expiration date if required.  
   - Copy the generated token immediately, as it will not be displayed again.  

---

## Add SonarQube Credentials to GitHub Actions  

1. **Go to Repository Settings**  
   - In your GitHub repository, navigate to **Settings** > **Secrets and variables** > **Actions**.  
2. **Add Secrets**  
   - Click **New repository secret** and add the following:  
     - **SONARQUBE_PROJECT_KEY:** Paste the project key.  
     - **SONARQUBE_TOKEN:** Paste the generated token.  

---

## Update the GitHub Actions Workflow  

Add the SonarQube integration to your GitHub Actions workflow file. Below is an example configuration:  

```yaml
jobs:
  sonar-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@v2
        env:
          SONAR_HOST_URL: ${{ secrets.SONARQUBE_URL }}
          SONAR_TOKEN: ${{ secrets.SONARQUBE_TOKEN }}
        with:
          args: >
            -Dsonar.projectKey=${{ secrets.SONARQUBE_PROJECT_KEY }}
            -Dsonar.organization=<your-organization>
