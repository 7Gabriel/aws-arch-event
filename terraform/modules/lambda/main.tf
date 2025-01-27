resource "aws_lambda_function" "lambda" {
  filename         = var.lambda_zip_path
  function_name    = var.function_name
  runtime          = "python3.10"
  handler          = var.handler
  role             = var.role_arn
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = var.environment_variables
  }

  tags = {
    Name = var.function_name
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = var.trigger_principal
  source_arn    = var.trigger_source_arn
}

resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn = var.kinesis_stream_arn
  function_name    = aws_lambda_function.lambda.function_name
  starting_position = "TRIM_HORIZON"
  batch_size = 100
  enabled    = true
}

resource "aws_cloudwatch_event_rule" "lambda_event_rule" {
  name        = "${var.function_name}-event-rule"
  description = "Rule triggered by ${var.function_name}"
  event_bus_name = var.bus_name
  lifecycle {
    create_before_destroy = true
  }
  event_pattern = jsonencode({
    source = ["custom.${var.function_name}"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule      = aws_cloudwatch_event_rule.lambda_event_rule.name
  target_id = "${var.function_name}-event-target"
  arn       = aws_lambda_function.lambda.arn
  event_bus_name = var.bus_name

  depends_on = [aws_cloudwatch_event_rule.lambda_event_rule]
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
}


