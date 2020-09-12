import * as cdk from "@aws-cdk/core";
import * as lambda from "@aws-cdk/aws-lambda";
import { Rule, Schedule } from "@aws-cdk/aws-events";
import * as sns from "@aws-cdk/aws-sns";
import * as iam from "@aws-cdk/aws-iam";
import * as path from "path";
import { SnsEventSource } from "@aws-cdk/aws-lambda-event-sources";
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
      reservedConcurrentExecutions: 1
    });

    const pipelineStatusSNS = new sns.Topic(this, "PipelineStatusTopic", {
      displayName: "PipeLineStatusTopic",
      topicName: "pipeline-status-topic",
    });

    pipelineStatusSNS.grantPublish({
      grantPrincipal: new iam.ServicePrincipal('codestar-notifications.amazonaws.com')
    })

    new cdk.CfnOutput(this, "PipelineStatusTopicOutput", {
      exportName: "pipeLineStatusTopicArnOutput",
      value: pipelineStatusSNS.topicArn,
    });

    githubNotifyLambda.addEventSource(new SnsEventSource(pipelineStatusSNS));
  }
}
