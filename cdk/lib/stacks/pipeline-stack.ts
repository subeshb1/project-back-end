import { SecretValue, Stack, Construct, StackProps } from '@aws-cdk/core';
import * as codepipelineActions from '@aws-cdk/aws-codepipeline-actions';
import * as codepipeline from '@aws-cdk/aws-codepipeline';
import * as codebuild from '@aws-cdk/aws-codebuild';
import * as s3 from '@aws-cdk/aws-s3';
import * as iam from '@aws-cdk/aws-iam';
export interface PipelineStackProps extends StackProps {
  readonly envType: string;
  readonly accountId: string;
}
export class PipeLineStack extends Stack {
  constructor(scope: Construct, id: string, props?: PipelineStackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here
    const sourceOutput = new codepipeline.Artifact("SourceOutput")
    const builder = new codebuild.PipelineProject(this, "BuildAndTest", {
      environment: {
        buildImage: codebuild.LinuxBuildImage.AMAZON_LINUX_2_3,
        privileged: true,
        environmentVariables: {
          "ENV_TYPE": {
            value: props?.envType,
          },
          "ACCOUNT_ID": {
            value: props?.accountId,
          }
        }
      },
      buildSpec: codebuild.BuildSpec.fromObject({
        version: '0.2',
        phases: {
          install: {
            commands: [
              'docker volume create --name=postgres-volume',
              'docker-compose up -d postgres',
              'RAILS_ENV=test docker-compose up create-db',
              'npm i -g aws-cdk',
              "(cd cdk && npm i)"
            ]
          },
          build: {
            commands: [
              "echo 'RUNNING SPECS'",
              'docker-compose up test',
              "echo 'Building artifacts'",
              'export VERSION=$(cat .version)',
              'docker build . -t ${ENV_TYPE}-back-end:${VERSION}',
              'cd cdk && npm run build && cdk synth'
            ],
          },
          post_build: {
            commands: [
              "docker tag ${ENV_TYPE}-back-end:${VERSION} ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ENV_TYPE}-back-end:${VERSION}",
              "eval `aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email`",
              "docker push ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ENV_TYPE}-back-end:${VERSION}"
            ]
          }
        },
        artifacts: {
          files: [
            "cdk/cdk.out/*"
          ]
        }
      })
    })

    new codepipeline.Pipeline(this, `${props?.envType}-Pipeline`, {
      artifactBucket: new s3.Bucket(this, `${props?.envType}-Bucket`, {
        encryption: s3.BucketEncryption.UNENCRYPTED,
      }),
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
        },
        {
          stageName: "Build",
          actions: [
            new codepipelineActions.CodeBuildAction(
              {
                actionName: "Build",
                input: sourceOutput,
                project: builder
              }
            )
          ]
        }
      ]
    });
  }
}