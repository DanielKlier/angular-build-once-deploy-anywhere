resource "aws_codebuild_project" "deploy_staging" {
  name = "klier-blog-pipeline-deploy-staging"

  service_role = aws_iam_role.deploy_staging_service_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "BUCKET"
      value = data.aws_s3_bucket.deploy_bucket.id
    }

    environment_variable {
      name  = "DISTRIBUTION_ID"
      value = var.cloudfront_staging_dist_id
    }

    environment_variable {
      name  = "ENV"
      value = "staging"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec/deploy.yml"
  }
}


resource "aws_iam_role" "deploy_staging_service_role" {
  name               = "klier-blog-pipeline-deploy-staging"
  assume_role_policy = data.aws_iam_policy_document.deploy_staging_service_assume_role_policy.json
}

data "aws_iam_policy_document" "deploy_staging_service_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild_deploy_staging_role_policy" {
  name   = "klier-blog-pipeline-deploy-staging"
  role   = aws_iam_role.deploy_staging_service_role.name
  policy = data.aws_iam_policy_document.codebuild_deploy_staging_role_policy.json
}

data "aws_iam_policy_document" "codebuild_deploy_staging_role_policy" {
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
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.pipeline_bucket.arn,
      "${aws_s3_bucket.pipeline_bucket.arn}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${data.aws_s3_bucket.deploy_bucket.arn}/staging/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]
    resources = [
      data.aws_s3_bucket.deploy_bucket.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      data.aws_cloudfront_distribution.staging.arn
    ]
  }
}
