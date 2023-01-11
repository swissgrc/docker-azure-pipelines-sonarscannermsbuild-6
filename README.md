# Docker image for running Sonar Scanner for .NET in an Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-sonarscannermsbuild/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-sonarscannermsbuild/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-sonarscannermsbuild/actions/workflows/publish.yml) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-sonarscannermsbuild.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-sonarscannermsbuild) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-sonarscannermsbuild.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-sonarscannermsbuild)
<!-- markdownlint-restore -->

Docker image to run [Sonar Scanner for .NET] in [Azure Pipelines container jobs].

## Usage

This image can be used to run Sonar Scanner CLI in [Azure Pipelines container jobs].

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job, add one of the following example tasks and use it with the `container` property.

The following example shows the container used for a deployment step which shows .NET version:

```yaml
  - stage: Build
    jobs:
    - job: Build
      steps:
      - task: SonarCloudPrepare@1
        displayName: 'Prepare analysis configuration'
        target: swissgrc/azure-pipelines-sonarscannermsbuild:latest
        inputs:
          SonarCloud: 'SonarCloud'
          organization: 'myOrganization'
          scannerMode: 'MSBuild'
          projectKey: 'my-project'
          projectName: 'MyProject'
      - bash: |
          dotnet build
        displayName: "Build"
        target: swissgrc/azure-pipelines-sonarscannermsbuild:latest
      - task: SonarCloudAnalyze@1
        displayName: 'Run SonarCloud analysis'
        target: swissgrc/azure-pipelines-sonarscannermsbuild:latest
```

### Tags

| Tag        | Description                                     | Base Image                                | .NET SDK | NodeJS  | Git        | Git LFS | Size                                                                                                                                         |
|------------|-------------------------------------------------|-------------------------------------------|----------|---------|------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------|
| latest     | Latest stable release (from `main` branch)      | swissgrc/azure-pipelines-openjdk:17.0.4.0 | 6.0.403  | 16.18.0 | 1:2.30.2-1 | 3.2.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-sonarscannermsbuild/latest?style=flat-square)   |
| unstable   | Latest unstable release (from `develop` branch) | swissgrc/azure-pipelines-openjdk:17.0.4.1 | 6.0.405  | 16.19.0 | 1:2.30.2-1 | 3.3.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-sonarscannermsbuild/unstable?style=flat-square) |

### Configuration

These environment variables are supported:

| Environment variable   | Default value              | Description                                 |
|------------------------|----------------------------|---------------------------------------------|
| DOTNET_VERSION         | `6.0.405`                  | Version of .NET SDK installed in the image. |
| NODE_VERSION           | `16.19.0-deb-1nodesource1` | Version of Node.js installed in the image.  |
| GIT_VERSION            | `1:2.30.2-1`               | Version of Git installed in the image.      |
| GITLFS_VERSION         | `3.3.0`                    | Version of Git LFS installed in the image.  |

[Sonar Scanner for .NET]: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-msbuild/
[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
