# ML Model Deployment with GitHub Actions and Terraform

## Project Description

This project implements an automated workflow using GitHub Actions and Terraform to train a Machine Learning model, package it, and deploy it on AWS. The deployed infrastructure includes S3 for prediction storage, Lambda to serve the model, API Gateway to handle requests, and Route 53 to provide a custom URL.

## Project Structure

.
├── README.md
├── iac
│   ├── main.tf
│   ├── modules
│   │   ├── apigateway
│   │   │   ├── main.tf
│   │   │   └── outputs.tf
│   │   ├── iam
│   │   │   └── main.tf
│   │   ├── lambda
│   │   │   └── main.tf
│   │   ├── route53
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── s3
│   │       └── main.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── ml_deployment
│   ├── iris_model.joblib
│   └── lambda_function.py
└── ml_prediction
    └── iris_model.py


## GitHub Action Workflow

### How It Works

The GitHub Actions workflow is located in `.github/workflows/deploy.yml` and performs the following steps:

1. **Checkout Repository**: Retrieves the code from the repository.
2. **Set up Python**: Configures the Python 3.8 environment.
3. **Install Dependencies**: Installs the required dependencies (joblib, scikit-learn, boto3).
4. **Train and Save Model**: Executes the script to train the model and saves the `iris_model.joblib` file.
5. **Package Lambda Function**: Creates a ZIP file containing the Lambda function code and the trained model.
6. **Install Terraform**: Sets up Terraform.
7. **Terraform Init and Apply**: Deploys the infrastructure on AWS.

### Triggering the Workflow

The workflow runs manually in the `main` branch. Ensure you have configured the AWS secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) in the GitHub repository.

## Testing the Model via API

### Steps to Test the Model

1. **Successful Deployment**: Once the deployment is successful, the API URL is shown in the output of the GitHub Actions workflow.
2. **Make POST Requests**: Use `curl` or a similar tool to send POST requests to the API URL.

#### Example POST Request

```sh
curl -X POST https://api-url/predict \
    -H "Content-Type: application/json" \
    -d '{"features": [5.1, 3.5, 1.4, 0.2], "species_names": ["setosa", "versicolor", "virginica"]}'

### Expected Response

The API will respond with a URL pointing to the JSON file in the S3 bucket containing the prediction:

`{
  "url": "https://s3bucket.s3.amazonaws.com/predictions/request_id.json"
}`

Training the Model Locally
--------------------------

### Steps to Train the Model Locally

1.  **Install Dependencies**: Ensure you have `joblib` and `scikit-learn` installed. You can install them with pip:

    `pip install joblib scikit-learn`

2.  **Run the Training Script**: Navigate to the project directory and execute the training script:

    `python ml_prediction/iris_model.py`

3.  **Saved Model**: The trained model will be saved as `iris_model.joblib` in the `ml_deployment` directory.

Detailed File and Directory Structure
-------------------------------------

-   **`iac/`**: Contains the Terraform configuration for deploying the infrastructure.
    -   **`modules/`**: Reusable Terraform modules.
        -   **`apigateway/`**: API Gateway configuration.
        -   **`iam/`**: IAM configuration for Lambda permissions.
        -   **`lambda/`**: Lambda function configuration.
        -   **`route53/`**: Route 53 configuration for the custom domain.
        -   **`s3/`**: S3 bucket configuration.
-   **`ml_deployment/`**: Contains the trained model and Lambda function code.
    -   **`lambda_function.py`**: Lambda function code.
    -   **`iris_model.joblib`**: Trained model file.
-   **`ml_prediction/`**: Contains the script to train the model.
    -   **`iris_model.py`**: Model training script.
