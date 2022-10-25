resource "aws_iam_role" "RoleForCodeBuild" {
  name = "RoleForCodeBuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-ecr" {
  role       = aws_iam_role.RoleForCodeBuild.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach-cloudwatch" {
  role       = aws_iam_role.RoleForCodeBuild.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach-codebuild" {
  role       = aws_iam_role.RoleForCodeBuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_codebuild_project" "weather-station-dev" {
  name          = "weather-station-dev"
  description   = "weather-station-dev"
  build_timeout = "5"
  service_role  = aws_iam_role.RoleForCodeBuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
    encryption_disabled    = false
    override_artifact_name = false
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "us-east-2"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = "454451034868"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = "weather-station-dev"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }
    environment_variable {
      name  = "CONTAINER_NAME"
      type  = "PLAINTEXT"
      value = "weather-station-dev"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "weather-station-dev"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "DISABLED"
      encryption_disabled = "false"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mercury640/weather-station-master.git"
    insecure_ssl        = false
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "dev"
}


resource "aws_codebuild_project" "weather-station-staging" {
  name          = "weather-station-staging"
  description   = "weather-station-staging"
  build_timeout = "5"
  service_role  = aws_iam_role.RoleForCodeBuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
    encryption_disabled    = false
    override_artifact_name = false
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "us-east-2"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = "454451034868"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = "weather-station-staging"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }
    environment_variable {
      name  = "CONTAINER_NAME"
      type  = "PLAINTEXT"
      value = "weather-station-staging"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "weather-station-staging"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "DISABLED"
      encryption_disabled = "false"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mercury640/weather-station-master.git"
    insecure_ssl        = false
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "staging"
}

resource "aws_codebuild_project" "weather-station-prod" {
  name          = "weather-station-prod"
  description   = "weather-station-prod"
  build_timeout = "5"
  service_role  = aws_iam_role.RoleForCodeBuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
    encryption_disabled    = false
    override_artifact_name = false
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "us-east-2"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = "454451034868"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = "weather-station-prod"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }
    environment_variable {
      name  = "CONTAINER_NAME"
      type  = "PLAINTEXT"
      value = "weather-station-prod"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "weather-station-staging"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "DISABLED"
      encryption_disabled = "false"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mercury640/weather-station-master.git"
    insecure_ssl        = false
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "staging"
}