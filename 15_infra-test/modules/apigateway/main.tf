# ---------------------------------------------
# API Gateway
# ---------------------------------------------

# API Gateway（HTTP API）
resource "aws_apigatewayv2_api" "api" {
  name          = "app-http-api"
  protocol_type = "HTTP"
}

# Lambda統合
resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = var.integration_type
  integration_uri        = var.integration_uri
  payload_format_version = "2.0"
}

# ルート（IAM認証）
resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /"

  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "AWS_IAM"
}

# ステージ
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# LambdaにInvoke権限を付与
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.route_target
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}