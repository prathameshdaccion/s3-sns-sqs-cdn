resource "aws_sqs_queue" "sqs_queue" {
  name   = "${var.sqs_queue_name}"
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = "${aws_sqs_queue.sqs_queue.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "SQS:SendMessage",
      "Resource": "${aws_sqs_queue.sqs_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.topic.arn}"
        }
      }
    }
  ]
}
POLICY
}
