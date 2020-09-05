import * as cdk from '@aws-cdk/core';
import * as iam from '@aws-cdk/aws-iam';
import * as ecs from '@aws-cdk/aws-ecs';
import * as ec2 from '@aws-cdk/aws-ec2';
import * as ecr from '@aws-cdk/aws-ecr';
import * as ecsPatterns from '@aws-cdk/aws-ecs-patterns';
import { StackProps } from '@aws-cdk/core';

interface InfraProps extends cdk.StackProps {
  ecrRepo: ecr.IRepository
}
export class InfrastructureStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: InfraProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, "MyVpc", {
      maxAzs: 3 // Default is all AZs in region
    });

    const cluster = new ecs.Cluster(this, "MyCluster", {
      vpc: vpc
    });

    // Create a load-balanced Fargate service and make it public
    new ecsPatterns.ApplicationLoadBalancedFargateService(this, "MyFargateService", {
      // taskDefinition: new ecs.FargateTaskDefinition(this, 'FargateTask', {

      // }),
      cluster: cluster, // Required
      cpu: 256, // Default is 256
      desiredCount: 1, // Default is 1
      taskImageOptions: {
        containerPort: 3000,
        image: ecs.ContainerImage.fromEcrRepository(props.ecrRepo),
      },
      memoryLimitMiB: 2048, // Default is 512
      publicLoadBalancer: true // Default is false
    });
  }
}
