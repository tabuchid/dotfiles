export JIRA_EMAIL="$(op read 'op://Private/Jira API Token/email' --account my.1password.com)"
export JIRA_API_TOKEN="$(op read 'op://Private/Jira API Token/credential' --account my.1password.com)"
export JIRA_DOMAIN="$(op read 'op://Private/Jira API Token/domain' --account my.1password.com)"

export GITHUB_PACKAGES_TOKEN="$(op read 'op://Private/GitHub Packages Token/credential' --account my.1password.com)"

export SENTRY_AUTH_TOKEN="$(op read 'op://Private/Sentry Auth Token/credential' --account my.1password.com)"
export SENTRY_ORG="$(op read 'op://Private/Sentry Auth Token/org' --account my.1password.com)"
