import * as cdk from '@aws-cdk/core';
import * as iam from '@aws-cdk/aws-iam';

export class InfrastructureStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    new iam.Role(this, 'TestRole', {
      assumedBy: new iam.ServicePrincipal('iam.amazonaws.com')
    })
    // The code that defines your stack goes here
  }
}
