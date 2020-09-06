#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { InfrastructureStack, PipeLineStack,CommitStatusStack } from '../lib';

const app = new cdk.App();
if (!process.env.ENV_TYPE) {
  throw new Error("ENV_TYPE not specified .")
}


new CommitStatusStack(app, "CommitStatusStack", {
  stackName: 'CommitStatusStack'
})

const pipeline = new PipeLineStack(app, 'PipeLineStack', {
  envType: process.env.ENV_TYPE,
  stackName: `${process.env.ENV_TYPE}-code-pipeline`
});

new InfrastructureStack(app, 'InfrastructureStack', {
  // envType: process.env.ENV_TYPE
  envType: process.env.ENV_TYPE,
  ecrRepo: pipeline.ecrRepo
});

app.synth()
