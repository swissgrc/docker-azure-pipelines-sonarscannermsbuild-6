# Base image containing dependencies used in builder and final image
FROM swissgrc/azure-pipelines-openjdk:17.0.6.0 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_11/curl versioning=loose
ENV CURL_VERSION=7.74.0-1.3+deb11u7

RUN apt-get update -y && \
  # Install necessary dependencies
  apt-get install -y --no-install-recommends curl=${CURL_VERSION} && \
  # Add Git LFS PPA
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
  # Add NodeJS PPA
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
  # Add .NET PPA
  curl -o /tmp/packages-microsoft-prod.deb https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb && \
  dpkg -i /tmp/packages-microsoft-prod.deb && \
  rm -rf /tmp/*


# Final image
FROM base AS final

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-sonarscannermsbuild"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-sonarscannermsbuild"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /
# Copy NodeJS PPA keyring
COPY --from=build /usr/share/keyrings/ /usr/share/keyrings 
# Copy Git LFS PPA keyring
COPY --from=build /etc/apt/keyrings/ /etc/apt/keyrings
# Copy .NET keyring
COPY --from=build /etc/apt/trusted.gpg.d/ /etc/apt/trusted.gpg.d
COPY --from=build /etc/apt/sources.list.d/ /etc/apt/sources.list.d

# Install Git

# renovate: datasource=repology depName=debian_11_backports/git versioning=loose
ENV GIT_VERSION=1:2.39.2-1~bpo11+1

RUN echo "deb http://deb.debian.org/debian bullseye-backports main" | tee /etc/apt/sources.list.d/bullseye-backports.list && \
  apt-get update -y && \
  # Install Git
  apt-get install -y --no-install-recommends -t bullseye-backports git=${GIT_VERSION} && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  git version
  
# Install Git LFS

# renovate: datasource=github-tags depName=git-lfs/git-lfs extractVersion=^v(?<version>.*)$
ENV GITLFS_VERSION=3.3.0

RUN apt-get update -y && \
  # Install Git LFS
  apt-get install -y --no-install-recommends git-lfs=${GITLFS_VERSION}  && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  git lfs version

# Install NodeJS

# renovate: datasource=github-tags depName=nodejs/node extractVersion=^v(?<version>.*)$
ENV NODE_VERSION=16.19.1

# Install NodeJS

RUN apt-get update -y && \
  # Install NodeJs
  apt-get install -y --no-install-recommends nodejs=${NODE_VERSION}-deb-1nodesource1 && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  node -v

# Install .NET

# renovate: datasource=github-tags depName=dotnet/sdk extractVersion=^v(?<version>.*)$
ENV DOTNET_VERSION=6.0.406

ENV \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true \
    # Disable telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip

RUN apt-get update -y && \
  # Install .NET
  apt-get install -y --no-install-recommends dotnet-sdk-6.0=${DOTNET_VERSION}-1 && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  dotnet --info

# Install Dependencies required for dotnet test coverage

# renovate: datasource=repology depName=debian_11/libxml2 versioning=loose
ENV LIBXML_VERSION=2.9.10+dfsg-6.7+deb11u3

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends libxml2=${LIBXML_VERSION} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
