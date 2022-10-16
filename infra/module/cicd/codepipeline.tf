resource "aws_codepipeline" "pipeline" {
  name     = "klier-blog-pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "GitHub"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = var.repository
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"

      }
    }
  }

  stage {
    name = "ContinuousIntegration"

    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }

    action {
      category         = "Test"
      name             = "UnitTests"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["test_output"]

      configuration = {
        ProjectName = aws_codebuild_project.unit_test.name
      }
    }

    action {
      category        = "Test"
      name            = "Lint"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.lint.name
      }
    }
  }

  stage {
    name = "DeployStaging"
    action {
      category        = "Build"
      name            = "DeployStaging"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.deploy_staging.name
      }
    }
  }

  stage {
    name = "DeployProd"
    action {
      category  = "Approval"
      name      = "ApproveProd"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 1
    }

    action {
      category        = "Build"
      name            = "DeployProd"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 2

      configuration = {
        ProjectName = aws_codebuild_project.deploy_prod.name
      }
    }
  }
}
