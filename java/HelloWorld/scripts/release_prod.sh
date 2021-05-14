#!/usr/bin/env bash
set -e

BASE_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
ARTIFACT_NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.artifactId)
TAG=`echo java/${ARTIFACT_NAME}/v${BASE_VERSION}`
echo $TAG
RESULT=$(git tag -l ${TAG})
echo $RESULT
if [[ "$RESULT" != ${TAG} ]]; then

    echo "Release prod artifact"
    mvn -DskipTests deploy -Prelease

    # Create tag
    git tag -f ${TAG} ${GITHUB_SHA}
    git push origin --tags
else
    echo "Version is already deployed and tagged"
fi