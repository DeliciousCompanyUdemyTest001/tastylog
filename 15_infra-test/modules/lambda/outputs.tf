output "invoke_arn" {
  value = aws_lambda_function.app_server.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.app_server.function_name
}