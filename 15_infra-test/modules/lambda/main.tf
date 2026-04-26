# ---------------------------------------------
# Lambda
# ---------------------------------------------
resource "aws_lambda_function" "app_server" {
    function_name = "udemy-cicd-test-app-server"
    role = aws_iam_role.lambda_exec_role.arn
    handler = "index.handler"
    runtime = "nodejs22.x"

    filename         =  var.lambda_zip_path
    source_code_hash = filebase64sha256(var.lambda_zip_path)
    # filename         = "${path.module}/app/lambda.zip"
    # source_code_hash = filebase64sha256("${path.module}/app/lambda.zip")
}


resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }
    ]
  })
}


# # CloudWatch Logs権限
# resource "aws_iam_role_policy_attachment" "lambda_basic" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

