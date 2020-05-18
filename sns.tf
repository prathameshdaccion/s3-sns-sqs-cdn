resource "aws_sns_topic" "topic" {
  name = var.topic_name

  policy = <<POLICY
{
 "Version": "2008-10-17",
 "Id": "example-ID",
 "Statement": [
  {
   "Sid": "example-statement-ID",
   "Effect": "Allow",
   "Principal": {
    "AWS":"*"  
   },
   "Action": [
    "SNS:Publish"
   ],
   "Resource": "arn:aws:sns:ap-south-1:596811042610:${var.topic_name}",
   "Condition": {
      "ArnLike": { "aws:SourceArn": "arn:aws:s3:::${var.bucket_name}" }
   }
  }
 ]
}
POLICY

  depends_on = [ aws_s3_bucket.bucket ]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket  = var.bucket_name

  topic {
    topic_arn     = "arn:aws:sns:ap-south-1:596811042610:${var.topic_name}"
    events        = ["s3:ObjectCreated:*","s3:ObjectRemoved:*"]
  }

  depends_on = [ aws_s3_bucket.bucket, aws_sns_topic.topic ]
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sqs_queue.arn}"
}