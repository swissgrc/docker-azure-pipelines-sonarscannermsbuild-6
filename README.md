# Docker image for running Sonar Scanner for .NET 6 in an Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-sonarscannermsbuild-6/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-sonarscannermsbuild-6/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-sonarscannermsbuild-6/actions/workflows/publish.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=swissgrc_docker-azure-pipelines-sonarscannermsbuild-6&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=swissgrc_docker-azure-pipelines-sonarscannermsbuild-6) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-sonarscannermsbuild.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-sonarscannermsbuild) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-sonarscannermsbuild.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-sonarscannermsbuild)
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

| Tag        | Description                                     | Base Image                                 | .NET SDK | NodeJS  | Git          | Git LFS | Size                                                                                                                                         |
|------------|-------------------------------------------------|--------------------------------------------|----------|---------|--------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------|
| 6-unstable | Latest unstable release (from `develop` branch) | swissgrc/azure-pipelines-openjdk:17.0.10.0 | 6.0.420  | 20.12.1 | 1:2.39.2-1.1 | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-sonarscannermsbuild/6-unstable?style=flat-square) |

### Configuration

These environment variables are supported:

| Environment variable   | Default value              | Description                                 |
|------------------------|----------------------------|---------------------------------------------|
| DOTNET_VERSION         | `6.0.420`                  | Version of .NET SDK installed in the image. |
| NODE_VERSION           | `20.12.1-1nodesource1`     | Version of Node.js installed in the image.  |
| GIT_VERSION            | `1:2.39.2-1.1`             | Version of Git installed in the image.      |
| GITLFS_VERSION         | `3.5.1`                    | Version of Git LFS installed in the image.  |

[Sonar Scanner for .NET]: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-msbuild/
[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
