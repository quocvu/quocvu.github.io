---
layout: post
title: Running a AWS Lambda Function on a Schedule
excerpt: "How to setup your your Lambda function to run on schedule like a cron job"
modified: 2016-07-04
tags: [aws, cloud formation, scheduler, lambda function, lambda, log, cloudwatch ]
comments: true
image:
  feature: lighthouse.jpg
  credit:
  creditlink:
---

In this post, we will learn how to setup a Lambda function on AWS, that is triggered
regularly by a CloudWatch event. And as bonus, we will also see how logs produced by
the Lambda function are forwarded to CloudWatch.  This is rather important because
Lambda is an AWS service, thus we do not have access to the console to view our logs.

As a prerequisite, you need [package your Lambda function](http://docs.aws.amazon.com/lambda/latest/dg/nodejs-create-deployment-pkg.html)
and upload to a S3 bucket. Let say we have the code of the Lambda function at
`s3://my-lambda-function-bucket/my-function.zip`.  For this example, let's pretend
our function is written in NodeJS, and the handler (which is the javascript function to
execute when the Lambda function is invoked) is in the `index.js` file and named
`executeMe()`.

The following are CloudFormation snippets that you could put in the `Resources` section
of your CFN templates.

First we create a role for our Lambda function to assume. At the minimum, we need to
grant permissions to write logs to CloudWatch.  If your Lambda function needs access other services
such as S3 or SQS, you can add those permissions to this policy.

{% highlight json linenos %}
"ExampleRole": {
  "Type": "AWS::IAM::Role",
  "Properties": {
    "Path": "/",
    "AssumeRolePolicyDocument": {
      "Version" : "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": [ "lambda.amazonaws.com" ]
          },
          "Action": [ "sts:AssumeRole" ]
        }
      ]
    },
    "Policies": [
      {
        "PolicyName": "example-policy",
        "PolicyDocument": {
          "Version" : "2012-10-17",
          "Statement": [
            {
              "Action" : [ "logs:PutLogEvents", "logs:DescribeLogStreams", "logs:Create" ],
              "Effect" : "Allow",
              "Resource" : [
                "arn:aws:logs:*:*:*"
              ]
            }
          ]
        }
      }
    ]
  }
},
{% endhighlight %}

Now let's create the log group and stream to use with our function. In this example we choose
to keep logs for 90 days. As you can see, a log group may contain multiple log streams (see line 11).

{% highlight json linenos %}
"ExampleLogGroup": {
  "Type": "AWS::Logs::LogGroup",
  "Properties": {
    "RetentionInDays": 90
  }
},

"ExampleLogStream": {
  "Type": "AWS::Logs::LogStream",
  "Properties": {
    "LogGroupName": { "Ref": "ExampleLogGroup" }
  }
}
{% endhighlight %}

Next we create our Lambda function. Line 4 indicates which javascript function to execute and what file
contains it.  Line 5 associates the previously created role to this function. And lines 7-8 point to the
zip file previously uploaded to S3.

{% highlight json linenos %}
"ExampleFunction": {
  "Type": "AWS::Lambda::Function",
  "Properties": {
    "Handler": "index.executeMe",
    "Role": { "Fn::GetAtt" : ["ExampleRole", "Arn"] },
    "Code": {
      "S3Bucket": "my-lambda-function-bucket",
      "S3Key": "my-function.zip"
    },
    "Runtime": "nodejs43",
    "Timeout": "30"
  }
}
{% endhighlight %}

Finally, we create a periodic CloudWatch event every 15 minutes and tie it to our function (line 8).
We also need to give this event the permission to execute the function (line 14-22).

{% highlight json linenos %}
"ExampleEvent": {
  "Type": "AWS::Events::Rule",
  "Properties": {
    "ScheduleExpression": "rate(15 minutes)",
    "Targets": [
      {
        "Id": "ExampleScheduler",
        "Arn": { "Fn::GetAtt": [ "ExampleFunction", "Arn" ] }
      }
    ]
  }
},

"ExamplePermission": {
  "Type": "AWS::Lambda::Permission",
  "Properties": {
    "FunctionName": { "Fn::GetAtt": [ "ExampleFunction", "Arn" ] },
    "Action": "lambda:InvokeFunction",
    "Principal": "events.amazonaws.com",
    "SourceArn": { "Fn::GetAtt": [ "ExampleEvent", "Arn" ] }
  }
}
{% endhighlight %}

I whipped up an simple example to illustrate this.  It's a Lambda function that
monitors a website at regular interval and sends SMS messages when things go wrong.
You can check it out at <https://github.com/quocvu/website-monitor>.