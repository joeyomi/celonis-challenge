# Celonis Platform Engineering Challenge

## Module 1: Deploy

### Task1: Dockerize

- Created a Dockerfile for the application.
- Refactored the [SpringBoot app](https://github.com/joeyomi/celonis-challenge/blob/main/src/main/resources/application.properties) to use Environment variables for the API_KEY.
- Added [GitHub Action workflow](https://github.com/joeyomi/celonis-challenge/tree/main/.github/workflows) to build the Docker image.
- Used a Distroless base image to keep the Docker image as small and secure as possible.

To test:

```sh
# Run the image
docker run -p 8080:8080 -e API_KEY="mySecretKey" ghcr.io/joeyomi/celonis-challenge:latest

# Upload a file to the container
curl -X POST \
http://localhost:8080/files \
-H 'Celonis-Auth: mySecretKey' \
-F file=@./Chart.yaml

# Download the file
curl -LO http://localhost:8080/files/Chart.yaml
```

### Task2: Manifests

- Created a [Helm chart](https://github.com/joeyomi/celonis-challenge/tree/main/charts/celonis-challenge) to deploy the application.
- Created [Kubernetes manifests](https://github.com/joeyomi/celonis-challenge/tree/main/k8s) to deploy the application in both [single pod](https://github.com/joeyomi/celonis-challenge/tree/main/k8s/fixed) and [autoscaling](https://github.com/joeyomi/celonis-challenge/tree/main/k8s/autoscaling) modes.
- Added [GitHub Action workflows](https://github.com/joeyomi/celonis-challenge/tree/main/.github/workflows) to test and publish the Helm chart.
- Both Helm chart and manifests include an Ingress resource.
- `API_KEY` is injected via Secrets/ Environment variables.
- Both Helm chart and manifests include Persistent Volume Claims for data persistence.
- **Note:** Autoscaling requires an NFS based Storage Class.

To test:

- Deploy the Helm chart ([README](https://github.com/joeyomi/celonis-challenge/tree/main/charts/celonis-challenge) with instructions and parameters provided).
- OR Apply the manifests:

```sh
# Clone the repo
git clone https://github.com/joeyomi/celonis-challenge.git

# Apply the manifests
kubectl apply -f k8s/fixed
```

### Task3: Improvements

- Move `API_KEY` to an environment variable (already implemented).
- Add logging, metrics, and alerts.
- Switch to Object storage.

## Module 2: Pipeline design

| **Challenge**                    | **Description**                                                                                         | **Solution**                                                                                                                                                                                                                                                                   |
| -------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Configuration Variability**    | Each realm has unique configurations, making their management complex.                                  | To address this, I recommend implementing a **configuration management system/database**. Define and version configurations for each realm, leveraging tools like **Terraform** or **Ansible** for automated deployment.                                                       |
| **Deployment Consistency**       | Ensuring uniform deployments across realms is critical. Manual deployments can introduce discrepancies. | My suggestion is to embrace **containerization** (e.g., Docker) and **orchestration** (e.g., Kubernetes). I would Package IBC components consistently and utilize **Helm charts** for deployment.                                                                              |
| **Environment-Specific Testing** | Testing in a staging realm may not cover all scenarios, leading to realm-specific issues in production. | Create **environment-specific test suites** for each realm. Automate testing, including integration tests against realm-specific services. Leverage **CI/CD pipelines** to validate changes.                                                                                   |
| **Migrations and Sync**          | Realms might have distinct data sources or schemas. Migrating data between them can be challenging.     | Implement robust **schema change management** and **data synchronization processes**. Use tools or scripts to handle schema transformations and ensure data consistency. Use data sinks like Kafka to store incoming data during the transition.                               |
| **Zero-Downtime Upgrades**       | Upgrading realms without disrupting services is crucial. Downtime can impact users and revenue.         | Implement **rolling upgrades** or **blue-green deployments**. Gradually shift traffic to new versions while maintaining the old ones. Use **health checks** to ensure stability during the transition. Use data sinks like Kafka to store incoming data during the transition. |
