#!/bin/sh

set -ue

RepositoryName="${INPUT_REPOSITORY_NAME}"
AwsRegion="${INPUT_AWS_REGION}"
BranchName="${INPUT_BRANCH_NAME}"
CodeCommitUrl="https://git-codecommit.${AwsRegion}.amazonaws.com/v1/repos/${RepositoryName}"

git config --global --add safe.directory /github/workspace
git config --global credential.'https://git-codecommit.*.amazonaws.com'.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

# Add the CodeCommit remote repository
echo "Adding the CodeCommit remote repository: ${CodeCommitUrl}"
git remote add sync ${CodeCommitUrl}

# Push the specific branch to the CodeCommit repository
echo "Pushing the specific branch into CodeCommit: ${BranchName}"
git push sync ${BranchName} --force
