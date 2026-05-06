#!/bin/bash
set -e

echo "🚀 Backend Deployment"

cd infra
terraform init
terraform apply -auto-approve
cd ..

{{backendInstallCommand}}
{{backendBuildCommand}}

if [ "{{deploymentStyle}}" = "aws-ecs" ]; then
  docker build -t {{containerRegistry}} .
  echo "Container build completed. Add your registry push and ECS rollout steps."
else
  echo "Deployment style is {{deploymentStyle}}. Add your platform-specific rollout steps."
fi
