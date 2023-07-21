# The following tf code provisions AWS codePipeline with the 
# required resources and sets it to track changes 
# in the application branch of the repository.

# Build project, it will be used by the pipeline below
resource "aws_codebuild_project" "hw-app-codebuild" {
  name           = "${var.env_name}-codebuild-project"
  description    = "test_codebuild_project_cache"
  build_timeout  = "5"
  queued_timeout = "5"
  
  service_role = "arn:aws:iam::528100219426:role/service-role/codebuild-test-hw-app-service-role" 
  
  artifacts {
    type = "CODEPIPELINE"
  }
  
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }

  source {
  type            = "CODEPIPELINE"
  buildspec       = "buildspec.yml"
  git_clone_depth = 1
  }

  
  source_version = "feature/application"
  tags = {
    Name = "${var.env_name}-codebuild-projecr"
  }
}

# GitHub token
data "aws_ssm_parameter" "github-token" {
    name = "g-auth-token"
}

resource "aws_s3_bucket" "bucket-for-pipeline" {
  bucket = "${var.env_name}-pipeline-bucket-123123"
  force_destroy = true
  tags = {
    Name = "${var.env_name}-pipeline-bucket"
  }
}

# Pipeline 
resource "aws_codepipeline" "my_pipeline" {
  name     = "my-pipeline"
  role_arn = "arn:aws:iam::528100219426:role/service-role/test-service-role-codepipeline"
  depends_on = [ aws_s3_bucket.bucket-for-pipeline ]

  artifact_store {
    location = "${var.env_name}-pipeline-bucket-123123"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn = "arn:aws:codestar-connections:eu-central-1:528100219426:connection/71c0c6d0-c8cb-4f2b-8ec4-3f0beeda3399"
        FullRepositoryId = "makexcake/commit-hw-2"  # "https://github.com/makexcake/commit-hw-2.git"
        BranchName  = "feature/application"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = "${var.env_name}-codebuild-project"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "DeployAction"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      version          = "1"
      input_artifacts  = ["BuildArtifact"]

      configuration = {
        ClusterName     = "${var.env_name}-cluster"
        ServiceName     = "homework-app"
        FileName        = "imagedefinitions.json"
        #RoleArn         = "arn:aws:iam::528100219426:role/ecsTaskExecutionRole"
      }
    }
  }

  tags = {
    Name = "${var.env_name}-codePipeline"
  }  
}


