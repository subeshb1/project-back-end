import {
  SecretValue,
  Stack,
  Construct,
  StackProps,
  CfnOutput,
} from "@aws-cdk/core";
import * as cdk from "@aws-cdk/core";
import * as codepipelineActions from "@aws-cdk/aws-codepipeline-actions";
import * as codepipeline from "@aws-cdk/aws-codepipeline";
import * as codebuild from "@aws-cdk/aws-codebuild";
import * as s3 from "@aws-cdk/aws-s3";
import * as iam from "@aws-cdk/aws-iam";
import * as ecr from "@aws-cdk/aws-ecr";
import * as codestarnotifications from "@aws-cdk/aws-codestarnotifications";
import * as codedeploy from "@aws-cdk/aws-codedeploy";
export interface PipelineStackProps extends StackProps {
  readonly envType: string;
}
export class PipeLineStack extends Stack {
  readonly ecrRepo: ecr.IRepository;
  constructor(scope: Construct, id: string, props: PipelineStackProps) {
    super(scope, id, props);

    const ecrRepo = new ecr.Repository(this, `${props?.envType}-back-end`, {
      repositoryName: `${props?.envType}-back-end`,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    this.ecrRepo = ecrRepo;

    const sourceOutput = new codepipeline.Artifact("SourceOutput");
    const codeBuildOutput = new codepipeline.Artifact("CodeBuildOutput");
    const dockerImageOutput = new codepipeline.Artifact("DockerImageOutput");
    const ecsDeployOutput = new codepipeline.Artifact("ECSDeployOutput");
    const codeBuildRole = new iam.Role(this, "CodeBuildRole", {
      assumedBy: new iam.ServicePrincipal("codebuild.amazonaws.com"),
    });
    codeBuildRole.addToPolicy(
      new iam.PolicyStatement({
        resources: ["*"],
        actions: ["ecr:*", "ecs:*", "cloudformation:*"],
        effect: iam.Effect.ALLOW,
      })
    );

    const builder = new codebuild.PipelineProject(this, "Synth", {
      role: codeBuildRole,
      environment: {
        buildImage: codebuild.LinuxBuildImage.AMAZON_LINUX_2_3,
        privileged: false,
        environmentVariables: {
          ENV_TYPE: {
            value: props?.envType,
          },
        },
      },
      cache: codebuild.Cache.local(
        codebuild.LocalCacheMode.DOCKER_LAYER,
        codebuild.LocalCacheMode.CUSTOM
      ),
      buildSpec: codebuild.BuildSpec.fromObject({
        version: "0.2",
        phases: {
          install: {
            commands: ["npm i -g aws-cdk", "(cd cdk && npm i)"],
          },
          build: {
            commands: ["cd cdk && npm run build && cdk synth"],
          },
        },
        artifacts: {
          files: ["**/*"],
          "base-directory": "cdk/cdk.out",
        },
        cache: {
          paths: ["node_modules/**/*"],
        },
      }),
    });

    const appBuilder = new codebuild.PipelineProject(this, "BuildAndTest", {
      role: codeBuildRole,
      environment: {
        buildImage: codebuild.LinuxBuildImage.AMAZON_LINUX_2_3,
        privileged: true,
        environmentVariables: {
          ENV_TYPE: {
            value: props?.envType,
          },
          ECR_REPO_URI: {
            value: ecrRepo.repositoryUri,
          },
        },
      },
      buildSpec: codebuild.BuildSpec.fromObject({
        version: "0.2",
        phases: {
          install: {
            commands: [
              "docker volume create --name=postgres-volume",
              "docker-compose up -d postgres",
              "docker build . -t back-end",
              "RAILS_ENV=test docker-compose up create-db",
              "eval `aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email`",
            ],
          },
          build: {
            commands: [
              "echo 'RUNNING SPECS'",
              "docker-compose up test",
              "echo 'Building artifacts'",
              "export VERSION=$(cat .version)",
            ],
          },
          post_build: {
            commands: [
              "docker tag back-end ${ECR_REPO_URI}:${VERSION}",
              "docker push ${ECR_REPO_URI}:${VERSION}",
              `printf '{"ImageURI":"%s"}'  $ECR_REPO_URI:$VERSION > /imageDetail.json`,
            ],
          },
        },
        artifacts: {
          files: ["/imageDetail.json"],
          "discard-paths": "yes",
        },
      }),
    });

    const ecsCodeBuild = new codebuild.PipelineProject(this, "ECSCodeDeploy", {
      role: codeBuildRole,
      environment: {
        buildImage: codebuild.LinuxBuildImage.AMAZON_LINUX_2_3,
        privileged: false,
        environmentVariables: {
          ENV_TYPE: {
            value: props?.envType,
          },
          ECR_REPO_URI: {
            value: ecrRepo.repositoryUri,
          },
        },
      },
      buildSpec: codebuild.BuildSpec.fromObject({
        version: "0.2",
        phases: {
          build: {
            commands: ["cd ./code-deploy", "./deployer.sh"],
          },
        },
        artifacts: {
          files: ["**/*"],
          "base-directory": "code-deploy",
        },
      }),
    });

    const pipelineDeployRole = new iam.Role(this, "PipelineDeployRole", {
      assumedBy: new iam.ServicePrincipal("cloudformation.amazonaws.com"),
    });

    pipelineDeployRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["*"],
        effect: iam.Effect.ALLOW,
        resources: ["*"],
      })
    );

    const infraDeployRole = new iam.Role(this, "InfraDeployRole", {
      assumedBy: new iam.ServicePrincipal("cloudformation.amazonaws.com"),
    });

    infraDeployRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["*"],
        effect: iam.Effect.ALLOW,
        resources: ["*"],
      })
    );

    const pipelineSelfUpdate = new codepipelineActions.CloudFormationCreateUpdateStackAction(
      {
        actionName: "UpdatePipeline",
        stackName: `${props.stackName}`,
        adminPermissions: true,
        templatePath: new codepipeline.ArtifactPath(
          codeBuildOutput,
          "PipeLineStack.template.json"
        ),
        deploymentRole: pipelineDeployRole,
      }
    );

    const infraStackDeploy = new codepipelineActions.CloudFormationCreateUpdateStackAction(
      {
        actionName: "DeployInfra",
        stackName: `${props?.envType}-infra`,
        adminPermissions: true,
        templatePath: new codepipeline.ArtifactPath(
          codeBuildOutput,
          "InfrastructureStack.template.json"
        ),
        deploymentRole: infraDeployRole,
      }
    );

    const ecsDeploymentApplication = new codedeploy.EcsApplication(
      this,
      "ECSApplication",
      {
        applicationName: "ECSApplication",
      }
    );
    const ecsDeploymentConfig = codedeploy.EcsDeploymentConfig.ALL_AT_ONCE;

    const ecsDeploymentGroup = codedeploy.EcsDeploymentGroup.fromEcsDeploymentGroupAttributes(
      this,
      "DeploymentGroup",
      {
        application: ecsDeploymentApplication,
        deploymentGroupName: "ECSDEPLOU",
        deploymentConfig: ecsDeploymentConfig,
      }
    );
    const ecsCodeDeploy = new codepipelineActions.CodeDeployEcsDeployAction({
      actionName: "DeployCode",
      deploymentGroup: ecsDeploymentGroup,
      taskDefinitionTemplateFile: new codepipeline.ArtifactPath(
        ecsDeployOutput,
        "taskdef.json"
      ),
      appSpecTemplateFile: new codepipeline.ArtifactPath(
        ecsDeployOutput,
        "appspec.yaml"
      ),
      containerImageInputs: [
        {
          taskDefinitionPlaceholder: "<IMAGE_PLACEHOLDER>",
          input: dockerImageOutput,
        },
      ],
      runOrder: 2,
    });

    const pipeLineRole = new iam.Role(this, "CodePipeLineRole", {
      assumedBy: new iam.ServicePrincipal("codepipeline.amazonaws.com"),
    });

    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:StopBuild",
        ],
        effect: iam.Effect.ALLOW,
        resources: [
          builder.projectArn,
          appBuilder.projectArn,
          ecsCodeBuild.projectArn,
        ],
      })
    );
    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: [
          "cloudformation:CreateStack",
          "cloudformation:DescribeStack*",
          "cloudformation:GetStackPolicy",
          "cloudformation:GetTemplate*",
          "cloudformation:SetStackPolicy",
          "cloudformation:UpdateStack",
          "cloudformation:ValidateTemplate",
        ],
        effect: iam.Effect.ALLOW,
        resources: [
          cdk.Fn.join("", [
            "arn:",
            cdk.Fn.ref("AWS::Partition"),
            ":cloudformation:",
            cdk.Fn.ref("AWS::Region"),
            ":",
            cdk.Fn.ref("AWS::AccountId"),
            `:stack/${props?.stackName}/*`,
          ]),
          cdk.Fn.join("", [
            "arn:",
            cdk.Fn.ref("AWS::Partition"),
            ":cloudformation:",
            cdk.Fn.ref("AWS::Region"),
            ":",
            cdk.Fn.ref("AWS::AccountId"),
            `:stack/${props?.envType}-infra/*`,
          ]),
        ],
      })
    );
    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["iam:PassRole"],
        effect: iam.Effect.ALLOW,
        resources: [pipelineDeployRole.roleArn, infraDeployRole.roleArn],
      })
    );

    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: [
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision",
        ],
        effect: iam.Effect.ALLOW,
        resources: [ecsDeploymentApplication.applicationArn],
      })
    );
    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: [
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision",
        ],
        effect: iam.Effect.ALLOW,
        resources: [ecsDeploymentApplication.applicationArn],
      })
    );
    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["codedeploy:CreateDeployment", "codedeploy:GetDeployment"],
        effect: iam.Effect.ALLOW,
        resources: [ecsDeploymentGroup.deploymentGroupArn],
      })
    );
    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["codedeploy:GetDeploymentConfig"],
        effect: iam.Effect.ALLOW,
        resources: [ecsDeploymentConfig.deploymentConfigArn],
      })
    );

    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["ecs:RegisterTaskDefinition"],
        effect: iam.Effect.ALLOW,
        resources: ["*"],
      })
    );
    pipeLineRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ["iam:PassRole"],
        conditions: {
          StringEqualsIfExists: {
            "iam:PassedToService": ["ecs-tasks.amazonaws.com"],
          },
        },
        effect: iam.Effect.ALLOW,
        resources: ["*"],
      })
    );

    const pipeline = new codepipeline.Pipeline(
      this,
      `${props?.envType}-Pipeline`,
      {
        role: pipeLineRole,
        restartExecutionOnUpdate: true,
        artifactBucket: new s3.Bucket(this, `${props?.envType}-Bucket`, {
          encryption: s3.BucketEncryption.UNENCRYPTED,
          bucketName: `${props?.envType}-bucket-cdk-1232134`,
        }),
        stages: [
          {
            stageName: "GithubSource",
            actions: [
              new codepipelineActions.GitHubSourceAction({
                owner: "subeshb1",
                repo: "project-back-end",
                oauthToken: SecretValue.secretsManager("githubToken"),
                branch: props?.envType === "prod" ? "master" : props?.envType,
                output: sourceOutput,
                actionName: "CodePush",
              }),
            ],
          },
          {
            stageName: "Synthesize",
            actions: [
              new codepipelineActions.CodeBuildAction({
                actionName: "SynthStacks",
                input: sourceOutput,
                project: builder,
                outputs: [codeBuildOutput],
              }),
            ],
          },
          {
            stageName: "PipelineUpdate",
            actions: [pipelineSelfUpdate],
          },
          {
            stageName: "Build",
            actions: [
              new codepipelineActions.CodeBuildAction({
                actionName: "BuildAndTest",
                input: sourceOutput,
                project: appBuilder,
                outputs: [dockerImageOutput],
              }),
            ],
          },
          {
            stageName: "DeployInfra",
            actions: [infraStackDeploy],
          },
          {
            stageName: "DeployCode",
            actions: [
              new codepipelineActions.CodeBuildAction({
                actionName: "BuildSpecAndMigrate",
                input: sourceOutput,
                project: ecsCodeBuild,
                outputs: [ecsDeployOutput],
              }),
              ecsCodeDeploy,
            ],
          },
        ],
      }
    );

    new codestarnotifications.CfnNotificationRule(
      this,
      "NotifyPipelineUpdates",
      {
        resource: pipeline.pipelineArn,
        name: "NotifyPipelineUpdates",
        targets: [
          {
            targetAddress: cdk.Fn.importValue("pipeLineStatusTopicArnOutput"),
            targetType: "SNS",
          },
        ],
        detailType: "FULL",
        eventTypeIds: [
          "codepipeline-pipeline-stage-execution-started",
          "codepipeline-pipeline-stage-execution-succeeded",
          "codepipeline-pipeline-stage-execution-canceled",
          "codepipeline-pipeline-stage-execution-failed",
        ],
      }
    );
    const pipelineCfn = pipeline.node.defaultChild as cdk.CfnResource;
    pipelineCfn.addDeletionOverride("Properties.Stages.1.Actions.0.RoleArn");
    pipelineCfn.addDeletionOverride("Properties.Stages.2.Actions.0.RoleArn");
    pipelineCfn.addDeletionOverride("Properties.Stages.3.Actions.0.RoleArn");
    pipelineCfn.addDeletionOverride("Properties.Stages.4.Actions.0.RoleArn");
    pipelineCfn.addDeletionOverride("Properties.Stages.5.Actions.0.RoleArn");
    pipelineCfn.addDeletionOverride("Properties.Stages.5.Actions.1.RoleArn");
  }
}
