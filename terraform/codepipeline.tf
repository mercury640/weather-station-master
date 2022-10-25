resource "aws_iam_role" "RoleForCodepipeline" {
  name = "RoleForCodepipeline"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach-codepipeline" {
  role       = aws_iam_role.RoleForCodepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_s3_bucket" "codepipeline-bucket" {
  bucket = "codepipeline-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline-bucket-acl" {
  bucket = aws_s3_bucket.codepipeline-bucket.id
  acl    = "private"
}

resource "aws_codestarconnections_connection" "example" {
  name          = "example-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "weather-station-dev" {
  name     = "weather-station-dev"
  role_arn = aws_iam_role.RoleForCodepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "2"
      output_artifacts = ["source_output"]

      configuration = {
        "ConnectionArn"        = aws_codestarconnections_connection.example.arn
        "Branch"               = "dev"
        "OAuthToken"           = ""
        "Owner"                = "mercury640"
        "PollForSourceChanges" = "false"
        "Repo"                 = "weather-station-master"
      }
      input_artifacts  = []
        namespace        = "SourceVariables"
        region           = "us-east-2"
        run_order        = 1
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      region           = "us-east-2"

      configuration = {
        ProjectName = "weather-station-dev"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName    = "weather-station-dev"
        ServiceName    = "weather-station-dev"
      }
    }
  }
}

resource "aws_codepipeline" "weather-station-staging" {
  name     = "weather-station-staging"
  role_arn = aws_iam_role.RoleForCodepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "2"
      output_artifacts = ["source_output"]

      configuration = {
        "ConnectionArn"        = aws_codestarconnections_connection.example.arn
        "Branch"               = "staging"
        "OAuthToken"           = ""
        "Owner"                = "mercury640"
        "PollForSourceChanges" = "false"
        "Repo"                 = "weather-station-master"
      }
      input_artifacts  = []
        namespace        = "SourceVariables"
        region           = "us-east-2"
        run_order        = 1
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      region           = "us-east-2"

      configuration = {
        ProjectName = "weather-station-staging"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName    = "weather-station-staging"
        ServiceName    = "weather-station-staging"
      }
    }
  }
}

resource "aws_codepipeline" "weather-station-prod" {
  name     = "weather-station-prod"
  role_arn = aws_iam_role.RoleForCodepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "2"
      output_artifacts = ["source_output"]

      configuration = {
        "ConnectionArn"        = aws_codestarconnections_connection.example.arn
        "Branch"               = "prod"
        "OAuthToken"           = ""
        "Owner"                = "mercury640"
        "PollForSourceChanges" = "false"
        "Repo"                 = "weather-station-master"
      }
      input_artifacts  = []
        namespace        = "SourceVariables"
        region           = "us-east-2"
        run_order        = 1
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      region           = "us-east-2"

      configuration = {
        ProjectName = "weather-station-prod"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName    = "weather-station-prod"
        ServiceName    = "weather-station-prod"
      }
    }
  }
}