workflow "Build and publish the website" {
  on = "push"
  resolves = ["Publish"]
}

action "Theme dependencies" {
  uses = "apache/camel-website@master"
  runs = "yarn"
  args = "--non-interactive --frozen-lockfile --cwd antora-ui-camel install"
}

action "Build theme" {
  uses = "apache/camel-website@master"
  needs = ["Theme dependencies"]
  runs = "yarn"
  args = "--non-interactive --frozen-lockfile --cwd antora-ui-camel gulp"
}

action "Website dependencies" {
  uses = "apache/camel-website@master"
  runs = "yarn"
  args = "--non-interactive --frozen-lockfile install"
}

action "Build website" {
  uses = "apache/camel-website@master"
  needs = ["Build theme","Website dependencies"]
  runs = "yarn"
  args = "--non-interactive --frozen-lockfile build"
}

action "On master branch" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  needs = ["Build website"]
  args = "branch master"
}

action "Publish" {
  uses = "apache/camel-website@master"
  needs = ["On master branch"]
  runs = "publish"
  secrets = ["GITHUB_TOKEN"]
}

