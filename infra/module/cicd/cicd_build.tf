resource "aws_codebuild_project" "build" {
  name = "klier-blog-pipeline-build"

  service_role = aws_iam_role.build_service_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec/build.yml"
  }
}


resource "aws_iam_role" "build_service_role" {
  name               = "klier-blog-pipeline-build"
  assume_role_policy = data.aws_iam_policy_document.build_service_assume_role_policy.json
}

data "aws_iam_policy_document" "build_service_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild_build_role_policy" {
  name   = "klier-blog-pipeline-build"
  role   = aws_iam_role.build_service_role.name
  policy = data.aws_iam_policy_document.codebuild_build_role_policy.json
}

data "aws_iam_policy_document" "codebuild_build_role_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "s3:ListObjects",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.pipeline_bucket.arn,
      "${aws_s3_bucket.pipeline_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [aws_codestarconnections_connection.github.arn]
  }
}
