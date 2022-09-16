/* # create python 3.10 lambda function that uses access_user role 


# terraform\modules\lambda\lambda.tf
resource "aws_lambda_function" "lambda" {
    function_name = "lambda"
    role = var.access_user_arn
    handler = "app.handler"
    runtime = "python3.10" */
