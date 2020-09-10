import * as cdk from "@aws-cdk/core";
import * as lambda from "@aws-cdk/aws-lambda";
import { Rule, Schedule } from "@aws-cdk/aws-events";
import * as sns from "@aws-cdk/aws-sns";
import * as sqs from "@aws-cdk/aws-sqs";
import * as iam from "@aws-cdk/aws-iam";
import * as path from "path";
import { SqsSubscription } from "@aws-cdk/aws-sns-subscriptions";
import { SqsEventSource } from "@aws-cdk/aws-lambda-event-sources";
export class CommitStatusStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: cdk.StackProps) {
    super(scope, id, props);

    const githubNotifyLambda = new lambda.Function(this, "GithubNotifier", {
      runtime: lambda.Runtime.NODEJS_10_X,
      handler: "index.handler",
      functionName: "GithbCommitStatus",
      code: lambda.Code.fromAsset(
        path.join(__dirname, "resources/commit-status-lambda")
      ),
    });

    const pipelineStatusSNS = new sns.Topic(this, "PipelineStatusTopic", {
      displayName: "PipeLineStatusTopic",
      topicName: "pipeline-status-topic",
    });

    const notificationQueue = new sqs.Queue(this, "PipelineNotificationQueue", {
      fifo: false,
    });

    // notificationQueue.grantSendMessages({
    //   grantPrincipal: new iam.ArnPrincipal(pipelineStatusSNS.topicArn),
    // });

    pipelineStatusSNS.addSubscription(new SqsSubscription(notificationQueue));

    pipelineStatusSNS.grantPublish({
      grantPrincipal: new iam.ServicePrincipal(
        "codestar-notifications.amazonaws.com"
      ),
    });

    new cdk.CfnOutput(this, "PipelineStatusTopicOutput", {
      exportName: "pipeLineStatusTopicArnOutput",
      value: pipelineStatusSNS.topicArn,
    });

    githubNotifyLambda.addEventSource(new SqsEventSource(notificationQueue));
  }
}
