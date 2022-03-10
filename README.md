<p align="center">
  <a href="https://codeclimate.com/github/fosterful/scheduler/maintainability"><img src="https://api.codeclimate.com/v1/badges/aaf7efce352e6a023791/maintainability" alt="Maintainability"></a>
  <a href="https://codeclimate.com/github/fosterful/scheduler/test_coverage"><img src="https://api.codeclimate.com/v1/badges/aaf7efce352e6a023791/test_coverage" alt="Test Coverage"></a>
  <a href="https://gitter.im/office-moms-and-dads/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
  <img src="https://badges.gitter.im/office-moms-and-dads/community.svg" alt="Gitter Chat Link"></a>
</p>

<br>

---

# Scheduler

## Overview

### Who are we?

Fosterful, a nonprofit organization, is a community of qualified volunteers partnering with child welfare offices to provide a nurturing environment for children entering foster care.

Fosterful’ 5-year vision is to establish and sustain sites throughout Washington and Idaho where children entering care transition with minimal trauma into their foster care placement.

## What does the scheduler do?

It is a Ruby/Rails based app that allows the coordination of scheduling between various workers and volunteers supporting children entering the foster care system. Specifically, it is designed to alert volunteers when there is need of a kind person to sit with children during a scary time, often on short notice. For more information about the organization, please visit [Fosterful](http://www.fosterful.org).

<hr />

## Table of Contents

- [Overview](#overview)
  - [Who are we](#who-are-we?)
  - [What does the scheduler do](#what-does-it-do)
- [Development Environment Setup](#development-environment-setup)
  - [Helpful Docker Commands](#helpful-docker-commands)
  - [Rails Commands in a Docker World](#rails-commands-in-a-docker-world)
  - [System Tests](#system-tests)
- [Contributing to the Effort](#contributing-to-the-effort)
  - [Guide for Contributing to the Project](#ways-to-contribute-to-the-project)
  - [Reporting Issues](#reporting-issues)
  - [Contacting Us](#contacting-us)
- [Technologies Used](#technologies-used)
- [License](#license)
  <hr />

## Development Environment Setup

1. [Download Docker CE for Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac)
   > Note: remove boot2docker or other Docker implementations if any were previously installed
2. Copy the `env.example` file to `.env`
   `cp env.example .env`

> Note: On Mac, make sure to append `:docker-compose.mac.yml` to `COMPOSE_FILE` to take advantage of cached volumes

3. Run `docker-compose up`
4. Open a browser to localhost:3000 to verify that the app is up.

### Helpful Docker Commands

- `docker-compose up` Starts fresh containers `-d` starts it in daemon mode
- `docker-compose down` Stops and removes containers(all data too)
- `docker-compose stop` Stops running containers but persists data
- `docker-compose start` Starts containers with persisted data
- `docker system prune` Cleans up unused containers, networks, and images `-a` removes all
  > Note: it is recommended to run the clean up commands weekly
- `docker ps` Lists all running containers
- `docker-compose run rails bash` Starts a bash session on rails, bringing up only dependent services.
- `docker exec -it ID_FROM_DOCKER_PS bash`. Connects another bash session to a running container.
- `docker attach ID_FROM_DOCKER_PS` Attach is useful for pry debugging in a running container
  > Note: To detach use `ctrl-p + ctrl-q`

### Rails Commands in a Docker World

Now that the app is running in Docker we will run all Rails and Rake commands in the container.

Here are a few examples:

> Note: this is expecting the containers are up

- `docker-compose exec rails bundle exec rake db:migrate`
- `docker-compose exec rails bundle exec rails c`

The pattern is docker-compose exec (container_name) rails or rake command.
This pattern works for non-Rails commands also.

- `docker-compose exec rails bash` will open the terminal on the container

### System Tests

System tests open the browser and make assertions against the content of the
page or verify expected behavior. These tests can be run in headless mode (the
default), which means that they are executed in a virtual browser. If you would
like them to be run in an actual, viewable browser, you will need to disable
headless mode by setting the HEADLESS environment variable to 'false' and ensure
you have the [ChromeDriver WebDriver](https://sites.google.com/a/chromium.org/chromedriver/downloads)
downloaded and installed on your host machine.

E.g. `HEADLESS=false bundle exec rspec spec/system/mytest_spec.rb`

If you are running in non-headless mode, you'll need to be sure you have the ChromeDriver running and able to accept connections from the IP the server is running on. This can be done by running ChromeDriver in a separate tab/console via:

`./chromedriver --whitelisted-ips`

<hr />

## Contributing to the Effort

First, we would like to thank you for having an interest in helping with this project! There are several things you can do:

- Help with issues
  - Close open issues by fixing them and making a pull request
  - Reproduce an issue for you or others to fix
- Refactor code
  - Before you put in the work, please open a new issue so we can discuss it.

### Contribution Guide

Fork this repository, clone your forked repo, and then [setup your environment](#development-environment-setup). Then make a branch, with a descriptive name, for the specific issue that you want to tackle.

- Make changes to fix the relevant issue, making your commit messages conform to our [commit message guidelines](#commit-message-guidelines) listed below. If you need step by step help please see [how to contribute step by step](#how-to-contribute-step-by-step)

- Please write tests and make sure that you have full coverage for all lines for your code.

  - After running rspec, the coverage will be updated and can be viewed.

  - To check the coverage of your tests, open coverage/index.html in a browser. You may need to drag the file from your editor to a new browser tab.

- After you have made changes and have passing specs with full coverage, please submit a pull request to merge your created branch with master.

#### Commit message guidelines

1. Please make the first line short and descriptive.

2. Please insert a blank line between the subject and any additional message content.

### How to Contribute Step by Step

Fork the Repository

- On the top right of the Fosterful repository, click fork.
- Click on the green "Clone or Download" button. Copy the provided link to your clipboard.

Clone Project to Local Machine

- Navigate to your desired directory with terminal and type in:

```
git clone <pasted-in-link-from-your-clipboard>
```

Create a Branch

- Create a branch in the repository directory by running:

```
git checkout -b <add-your-new-branch-name>
```

Make Necessary Changes

- Edit the file(s). To see your changes after a save type:

```
git status
```

- It will show red files stating there are files modified not staged for commit.

- If you would like to see the changes made to the files type:

```
git diff
```

Add Your Files to Git

- To add a file and stage the changes for commit type:

```
`git add <new-or-modified-file-name>`
```

Commit Changes to Git

- Commit your changes to git by writing a thoughtful commit message. Commit messages are written in present tense (ie: "add contact page..." not "added contact page...").

```
git commit <"Well thought out commit message, specifying exactly what changes were made.">
```

Push Changes to GitHub

- Push your changes to GitHub by using:

```
git push origin <branch-name>
```

- Make sure you push it to the branch created and do not push it to master.

Submit Changes for Review

- In the project's repository on GitHub, click on the "Compare & pull request" button. Enter information on the changes made inside of the form provided.

### Reporting Issues

If you encounter a bug or odd behavior that appears unintentional, please open an issue ticket and clearly describe the problem, reproducing it exactly if possible.

### Contacting the maintainers

For all other questions and concerns related to this project, please open an issue with a short but clear description. Responses will be as quick as possible, so Thank You in advance for your patience.

---

## Technologies Used

- Docker
- PostgreSQL
- React
- Ruby-On-Rails

---

## Support and Contact details

Interested in finding out more about what we do, or how you can support our mission? Please visit [https://fosterful.org](https://fosterful.org).

If after reading about us, you still have questions, you can [contact us](mailto:info@fosterful.org) directly via email.

---

## License

[![license](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE.md)

This software is licensed under the [MIT license](LICENSE.md).
