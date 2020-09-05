import * as cdk from '@aws-cdk/core';
import * as lambda from '@aws-cdk/aws-lambda';
import { Rule, Schedule } from '@aws-cdk/aws-events';
import * as targets from '@aws-cdk/aws-events-targets';
import * as path from 'path';
export class CommitStatusStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: cdk.StackProps) {
    super(scope, id, props);

    const githubNotifyLambda = new lambda.Function(this, 'GithubNotifier', {
      runtime: lambda.Runtime.NODEJS_10_X,
      handler: 'index.handler',
      functionName: "GithbCommitStatus",
      code: lambda.Code.fromAsset(path.join(__dirname, 'resources/commit-status-lambda')),
    })
    new Rule(this, 'CodePipelineAlert', {
      eventPattern: {
        source: [
          "aws.codepipeline"
        ]
      },
      targets: [new targets.LambdaFunction(githubNotifyLambda)]
    })
  }
}
