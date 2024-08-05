{
    "Version": "2012-10-17",
    "Id": "sns-owner-policy",
    "Statement": [
      {
        "Sid": "AllowOwnerOnly",
        "Effect": "Allow",
        "Principal": {
            "AWS": "*"
        },
        "Action": [
          "SNS:Publish",
          "SNS:RemovePermission",
          "SNS:SetTopicAttributes",
          "SNS:DeleteTopic",
          "SNS:ListSubscriptionsByTopic",
          "SNS:GetTopicAttributes",
          "SNS:AddPermission",
          "SNS:Subscribe"
        ],
        "Resource": "arn:aws:sns:ap-northeast-1:${ACCOUNT_ID}:${topic}",
        "Condition": {
            "StringEquals": {
                "AWS:SourceOwner": "${ACCOUNT_ID}"
            }
        }
      }
    ]
}