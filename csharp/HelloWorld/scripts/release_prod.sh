#!/usr/bin/env bash
set -e

BASE_VERSION=$(xmllint --xpath "//Project/PropertyGroup/Version/text()" Directory.Build.props)
ARTIFACT_NAME=$(xmllint --xpath "//Project/PropertyGroup/Title/text()" HelloWorld.csproj)
TAG=`echo csharp/${ARTIFACT_NAME}/v${BASE_VERSION}`

RESULT=$(git tag -l ${TAG})
if [[ "$RESULT" != ${TAG} ]]; then
    dotnet pack -c Release --no-build
    echo "Release prod artifact"
    find . -name *${BASE_VERSION}.nupkg  | xargs -L1 -I '{}' dotnet nuget push {} -k ${NUGET_KEY} -s ${NUGET_SOURCE}

    # Create tag
    git tag -f ${TAG} ${GITHUB_SHA}
    git push origin --tags
else
    echo "Version is already deployed and tagged"
fi