import * as cdk from "@aws-cdk/core";
import * as iam from "@aws-cdk/aws-iam";
import * as ecs from "@aws-cdk/aws-ecs";
import * as ec2 from "@aws-cdk/aws-ec2";
import * as ecr from "@aws-cdk/aws-ecr";
import * as ecsPatterns from "@aws-cdk/aws-ecs-patterns";
import * as rds from "@aws-cdk/aws-rds";
import { SecretValue } from "@aws-cdk/core";
interface InfraProps extends cdk.StackProps {
  readonly ecrRepo: ecr.IRepository;
  readonly envType: string;
}
export class InfrastructureStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: InfraProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, "MyVpc", {
      subnetConfiguration: [
        {
          name: "Public",
          cidrMask: 24,
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          name: "Isolated",
          cidrMask: 24,
          subnetType: ec2.SubnetType.ISOLATED,
        },
      ],
      maxAzs: 2, // Default is all AZs in region,
    });

    const ecrVPCEndpoint = new ec2.InterfaceVpcEndpoint(
      this,
      "EcrVpcEndpoint",
      {
        service: {
          name: `com.amazonaws.${cdk.Fn.ref("AWS::Region")}.ecr.dkr`,
          port: 443,
        },
        vpc: vpc,
      }
    );

    const cloudLogsVPCEndpoint = new ec2.InterfaceVpcEndpoint(
      this,
      "CloudWatchLogsVpcEndpoint",
      {
        service: {
          name: `com.amazonaws.${cdk.Fn.ref("AWS::Region")}.logs`,
          port: 443,
          privateDnsDefault: true,
        },
        vpc: vpc,
      }
    );

    const cluster = new ecs.Cluster(this, "MyCluster", {
      vpc: vpc,
    });

    const instance = new rds.DatabaseInstance(this, "Instance", {
      engine: rds.DatabaseInstanceEngine.postgres({
        version: rds.PostgresEngineVersion.VER_12,
      }),
      deletionProtection: props.envType === "prod",
      // optional, defaults to m5.large
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.BURSTABLE2,
        ec2.InstanceSize.MICRO
      ),
      masterUsername: "postgres",
      masterUserPassword: SecretValue.plainText("12345678"),
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.ISOLATED,
      },
    });

    // Create a load-balanced Fargate service and make it public
    const backEnd = new ecsPatterns.ApplicationLoadBalancedFargateService(
      this,
      "MyFargateService",
      {
        serviceName: "JobPortal",
        cluster: cluster, // Required
        cpu: 256, // Default is 256
        desiredCount: 1, // Default is 1
        taskImageOptions: {
          containerPort: 3000,
          image: ecs.ContainerImage.fromEcrRepository(props.ecrRepo),
          environment: {
            DB_HOST_NAME: instance.dbInstanceEndpointAddress,
            POSTGRES_DB_PASSWORD: SecretValue.plainText("12345678").toString(),
            RAILS_ENV: "production",
            RACK_ENV: "production",
          },
        },
        memoryLimitMiB: 512, // Default is 512
        publicLoadBalancer: true, // Default is false
      }
    );
    backEnd.targetGroup.configureHealthCheck({
      path: "/api/v1/status",
      enabled: true,
    });

    ecrVPCEndpoint.connections.allowDefaultPortFrom(backEnd.service);
    cloudLogsVPCEndpoint.connections.allowDefaultPortFrom(backEnd.service);
    instance.connections.allowDefaultPortFrom(backEnd.service);
  }
}
