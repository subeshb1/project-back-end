#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { InfrastructureStack, PipeLineStack } from '../lib/stacks';

const app = new cdk.App();
new PipeLineStack(app, 'PipeLineStack', {

});
new InfrastructureStack(app, 'InfrastructureStack', {

});
