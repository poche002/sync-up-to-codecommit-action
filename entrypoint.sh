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

### Uncomment if you want to push the main branch to the CodeCommit repository
# Fetch the main branch from the GitHub repository
# git fetch origin main
# Push the main branch to the CodeCommit repository
# git push sync main:main

# Fetch the specific branch from the GitHub repository
echo "Fetching the specific branch: ${BranchName}"
git fetch origin ${BranchName}

# Fetch the latest commits from the CodeCommit repository
#echo "Fetching the latest commits from the CodeCommit repository"
#git fetch sync ${BranchName}

echo "$(git --version)"

# List the commits that are present on the CodeCommit repository
echo "Listing the commits that the branch is ahead of main in origin 2"
git rev-list "origin/main..VVVC1-1834-fix-repos-sync"

# List the commits that are present on the local branch but not on the CodeCommit repository
echo "Listing the commits that the branch is ahead of main in CodeCommit"
git log sync/main..sync/VVVC1-1834-fix-repos-sync --oneline

# Push the specific branch to the CodeCommit repository
# echo "Pushing the specific branch into CodeCommit: ${BranchName}"
# git push sync ${BranchName} --force
