resource "aws_ecr_repository" "weather-station-dev" {
  name                 = "weather-station-dev"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "weather-station-staging" {
  name                 = "weather-station-staging"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "weather-station-prod" {
  name                 = "weather-station-prod"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}