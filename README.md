# Angular Build Once Deploy Anywhere

This project demonstrates how you can load the application configuration from an external JSON file, make it
available throughout your application and how to set up a CI/CD pipeline in AWS.
Read the accompanying blog post at
the [mimacom blog](https://blog.mimacom.com/build-once-run-anywhere-with-angular-and-aws).

## Repository structure

```
├── buildspec - the CodeBuild spec files
├── config    - the templates for the environment specific configuration
├── infra     - the Terraform code for all the AWS resources
└── src       - the main application source code
```

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change
any of the source files.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag
for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Using the example infrastructure code

There is some Terraform code in the `infra` directory that sets up the AWS resources for the deployment described in the
article.

### Preparation

To get the most out of the example, you should fork the repository, so you can make commits to it as you like.

If you did fork the repository, you should change the repository name in the [infra/locals.tf](./infra/locals.tf) file.

### How to apply the Terraform code

1. Follow
   the [Get Started - AWS](https://learn.hashicorp.com/collections/terraform/aws-get-started?utm_source=terraform_io_download)
   guide until Terraform is ready to be used with AWS.
2. Set the `AWS_REGION` environment variable in your terminal to a valid AWS region (e.g. `eu-central-1`)
3. (optional) Set the `AWS_PROFILE` environment variable, if your system is configured for multiple AWS accounts
4. Change to the `infra` directory
5. Run `terraform init`
6. Run `terraform apply` and confirm the resource creations
7. Complete the CodeStar GitHub connection by
   1. Going to the AWS console
   2. Then to the deployment pipeline
   3. Click on "Edit"
   4. Click on "Edit Stage" in the Source stage
   5. Click on the edit button (notepad icon) in the GitHub action
   6. Follow the steps to authorize CodeStar to connect to GitHub

### How to trigger the pipeline

Any commit to the `main` branch triggers the pipeline.

## Any questions or issues?

If something doesn't work for you or if you have any questions, you can open an issue in the GitHub repository.
