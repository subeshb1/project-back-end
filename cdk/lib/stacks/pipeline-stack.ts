import { SecretValue, Stack, Construct, StackProps } from '@aws-cdk/core';
import * as codepipelineActions from '@aws-cdk/aws-codepipeline-actions';
import * as codepipeline from '@aws-cdk/aws-codepipeline';
import * as codebuild from '@aws-cdk/aws-codebuild';
import * as s3 from '@aws-cdk/aws-s3';
import * as iam from '@aws-cdk/aws-iam';
import * as ecr from '@aws-cdk/aws-ecr';
export interface PipelineStackProps extends StackProps {
  readonly envType: string;
}
export class PipeLineStack extends Stack {
  constructor(scope: Construct, id: string, props?: PipelineStackProps) {
    super(scope, id, props);

    const ecrRepo = new ecr.Repository(this, `${props?.envType}-back-end`);

    const sourceOutput = new codepipeline.Artifact("SourceOutput")
    const codeBuildOutput = new codepipeline.Artifact("CodeBuildOutput")
    const codeBuildRole = new iam.Role(this, 'CodeBuildRole', {
      assumedBy: new iam.ServicePrincipal('codebuild.amazonaws.com'),
    });
    codeBuildRole.addToPolicy(new iam.PolicyStatement({
      resources: ["*"],
      actions: ["ecr:*"],
      effect: iam.Effect.ALLOW,
    }));

    const builder = new codebuild.PipelineProject(this, "BuildAndTest", {
      role: codeBuildRole,
      environment: {
        buildImage: codebuild.LinuxBuildImage.AMAZON_LINUX_2_3,
        privileged: true,
        environmentVariables: {
          "ENV_TYPE": {
            value: props?.envType,
          },
          "ECR_REPO_URI": {
            value: ecrRepo.repositoryUri
          }
        }
      },
      cache: codebuild.Cache.local(codebuild.LocalCacheMode.DOCKER_LAYER, codebuild.LocalCacheMode.CUSTOM),
      buildSpec: codebuild.BuildSpec.fromObject({
        version: '0.2',
        phases: {
          install: {
            commands: [
              "eval `aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email`",
              'docker volume create --name=postgres-volume',
              'docker-compose up -d postgres',
              'docker build . -t back-end',
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
              'cd cdk && npm run build && cdk synth'
            ],
          },
          post_build: {
            commands: [
              "docker tag back-end ${ECR_REPO_URI}:${VERSION}",
              "docker push ${ECR_REPO_URI}:${VERSION}",
              `cat <<< $(jq -r 'walk(if type == "object" and has("Stages") then . | walk(if type == "object" and has ("Actions") then . | walk(if type == "object" and has ("RoleArn") then . | del(.RoleArn) else . end) else . end) else . end) | .' cdk.out/PipeLineStack.template.json) > cdk.out/PipeLineStack.template.json`
            ]
          }
        },
        artifacts: {
          files: [
            "**/*"
          ],
          'base-directory': "cdk/cdk.out"
        },
        "cache": {
          paths: ['node_modules/**/*']
        }
      })
    })


    const pipeLineRole = new iam.Role(this, 'CodePipeLineRole', {
      assumedBy: new iam.ServicePrincipal('codepipeline.amazonaws.com'),
    });

    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:StopBuild"],
        effect: iam.Effect.ALLOW,
        resources: [builder.projectArn]
      })
    )
    new codepipeline.Pipeline(this, `${props?.envType}-Pipeline`, {
      role: pipeLineRole,
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
                project: builder,
                outputs: [codeBuildOutput]
              }
            )
          ]
        }
      ]
    });
  }
}
