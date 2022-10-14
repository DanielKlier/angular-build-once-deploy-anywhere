resource "aws_codebuild_project" "unit_test" {
  name = "klier-blog-pipeline-unit-test"

  service_role = aws_iam_role.unit_test_service_role.arn

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
    buildspec = "buildspec/unit-test.yml"
  }
}


resource "aws_iam_role" "unit_test_service_role" {
  name               = "klier-blog-pipeline-unit-test"
  assume_role_policy = data.aws_iam_policy_document.unit_test_service_assume_role_policy.json
}

data "aws_iam_policy_document" "unit_test_service_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild_unit_test_role_policy" {
  name   = "klier-blog-pipeline-unit-test"
  role   = aws_iam_role.unit_test_service_role.name
  policy = data.aws_iam_policy_document.codebuild_unit_test_role_policy.json
}

data "aws_iam_policy_document" "codebuild_unit_test_role_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
