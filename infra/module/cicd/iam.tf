resource "aws_iam_role" "pipeline" {
  name               = "AWSCodePipelineServiceRole-eu-central-1-klier-blog-pipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_policy.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "pipeline" {
  policy = data.aws_iam_policy_document.pipeline.json
  role   = aws_iam_role.pipeline.name
}

data "aws_iam_policy_document" "pipeline" {
  statement {
    effect  = "Allow"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [aws_codestarconnections_connection.github.arn]
  }

  statement {
    effect  = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
    resources = [
      aws_codebuild_project.build.arn,
      aws_codebuild_project.unit_test.arn,
      aws_codebuild_project.lint.arn,
      aws_codebuild_project.deploy_test.arn,
      aws_codebuild_project.deploy_prod.arn,
    ]
  }
}
