import { SecretValue, Stack, Construct, StackProps } from '@aws-cdk/core';
import * as codepipelineActions from '@aws-cdk/aws-codepipeline-actions';
import * as codepipeline from '@aws-cdk/aws-codepipeline';
import * as codebuild from '@aws-cdk/aws-codebuild';

export interface PipelineStackProps extends StackProps {
  readonly envType: string;
}
export class PipeLineStack extends Stack {
  constructor(scope: Construct, id: string, props?: PipelineStackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here
    const sourceOutput = new codepipeline.Artifact("SourceOutput")
    new codepipeline.Pipeline(this, `${props?.envType}-Pipeline`, {
      stages: [
        {
          stageName: "GithubSource",
          actions: [
            new codepipelineActions.GitHubSourceAction(
              {
                owner: 'subeshb1',
                repo: 'project-back-end',
                oauthToken: SecretValue.secretsManager('githubToken'),
                branch: props?.envType === 'prod' ? 'master' : props?.envType,
                output: sourceOutput,
                actionName: 'CodePush'
              }
            )
          ]
        }
      ]
    });
  }
}
