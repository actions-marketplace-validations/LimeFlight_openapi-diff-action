#!/usr/bin/pwsh

## Load up some common functionality for interacting
## with the GitHub Actions/Workflow environment
. ./lib/ActionsCore.ps1

## Pull in some inputs
$NewFile = Get-ActionInput head_spec -Required
$OldFile   = Get-ActionInput base_spec
$GitHubToken =  Get-ActionInput $github_token
$AddComment = [boolean] Get-ActionInput $add_comment
$GitHubEventPath = Get-ActionInput $github_event_path
$GitHubRepository = Get-ActionInput $github_repository

Write-Host "Starting"

Write-Host $NewFile
Write-Host $OldFile
Write-Host $GitHubToken
Write-Host $AddComment
Write-Host $GitHubEventPath

$ActionEvent = ConvertFrom-Json $GitHubEventPath
Write-Host $ActionEvent 

$PullRequest = $ActionEvent.pull_request.number
Write-Host $PullRequest 

# Install openapi-diff-action from nuget
dotnet tool install --global yaos.OpenAPI.Diff.Action --version 1.0.0-alpha

# Run openapi-diff-action with args from github action
openapi-diff-action $GitHubToken $GitHubRepository $PullRequest $OldFile $NewFile $AddComment