#!/bin/bash
set -e

echo "🚀 Frontend Deployment"

{{frontendInstallCommand}}
{{frontendBuildCommand}}

echo "Build completed. Add your hosting-specific upload steps."
echo "Suggested target bucket: {{frontendBucketName}}"
