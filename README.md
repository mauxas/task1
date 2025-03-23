# Devops task

This Terraform module sets up an Amazon Elastic Kubernetes Service (EKS) cluster and deploys a simple application architecture where one app calls another.

## Architecture

The architecture consists of:

* **EKS Cluster:** A Kubernetes cluster managed by AWS EKS.
* **Receiver App:** An application (e.g., a simple HTTP server) deployed in the `receiver` namespace. It's designed to receive requests.
* **Transmitter Apps:** Three applications deployed as follows:
    * `transmitter`: Deployed in the `transmitter` namespace. This app is configured to successfully communicate with the `receiver` app.
    * `transmitter-same-ns-diff-name-test`: Deployed in the same namespace. This app is expected to be blocked from communicating with the `receiver` app due to network policies which allow only app: `transmitter`
    * `transmitter-diff-ns-same-name-test`: Deployed in the default namespace.This app is expected to be blocked from communicating with the `receiver` app due to network policies which allow only from `treansmitter` namespace.


## Prerequisites

* AWS Account
* Terraform
* kubectl
* AWS CLI

## Usage

1.  **Clone the Repository:**

    ```bash
    git clone <your-repository-url>
    cd modules/main
    ```

2.  **Configure AWS Credentials:**

    * Ensure your AWS credentials are configured correctly using environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`) or an AWS CLI profile.

3.  **Customize Variables (Optional):**

    * Review the `main.tf` file and customize any variables as needed (e.g., VPC CIDR block, instance types, etc.).

4.  **Initialize Terraform:**

    * Execute: terraform init

5.  **Apply Terraform Configuration:**

    * Execute: terraform apply

## Terraform Modules

The Terraform code is organized into modules:

* **`modules/vpc`:** This module creates the Virtual Private Cloud (VPC) and subnets for the EKS cluster.
* **`modules/eks`:** This module creates the EKS cluster and node groups.
* **`modules/helm`:** This module deploys the applications using Helm charts and creates the network policies.
* **`modules/main`:** This module orchestrates the deployment of the `vpc`, `eks`, and `helm` modules, integrating them into a complete environment.
