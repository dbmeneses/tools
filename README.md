# SonarQube Server local development setup tools

Toggle the admin password to remove warnings, get an appropriate local development license, and get a user API token for SQS.

## Usage

1. Create a GitHub token with `repo` permission and configure SSO
1. `export GITHUB_TOKEN=<that token>`
1. `source setup-sq.sh`
1. Select how much of SQS you want to configure:
   * If you want to do everything, `setup_sq`
   * If you just need a license, `_set_license`

## TODO

* [ ] Fix password setting to meet new password requirements
