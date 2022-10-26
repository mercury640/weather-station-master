# weather-station-master
To describe how to set up pipeline with GitHub, CodeBuild, ECR, Codepipeline and ECS   

# REPO
3 braches,  "dev" "staging" "prod" prepared for pipelines

# ECR
3 repos "weather-station-dev" "weather-station-staging" "weather-station-prod"

# CodeBuild

3 codebuild projects "weather-station-dev" "weather-station-staging" "weather-station-prod"

# ECS

3 ECS cluster "weather-station-dev" "weather-station-staging" "weather-station-prod"

# CodePipeline

3 pipelines "weather-station-dev" "weather-station-staging" "weather-station-prod"

# Pipeline Flow

GitHub --> get buildspec.yml --> build image accoding to Dockerfile --> push image to ECR --> Deploy image to ECS (EC2)

# Notification

Before applying Terraform, need to update AWS account ID in terraform/codebuild.tf

environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = ""
    }

In additional, to get full function of Terraform code,  still need to add relevant rolse for ECR and also need to update ECR task Difinition manually.
