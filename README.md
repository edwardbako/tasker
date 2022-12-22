Development Setup on Debian / Ubuntu
==

This guides assumes that you have Ubuntu 20.04 installation with administrator rights. This guide will work analogous with all other distributions, but may require slight changes in the required packages.

**Tasker** Development Environment will be installed with a PostgreSQL database.\
**Please note:** This guide is NOT suitable for a production setup, but only for developing with it!
***
# Prepare your environment

We need an active Ruby and Node JS environment to run **Tasker**. To this end, we need some packages installed on the system.

CPU recommendation: 4 CPUs, Memory recommendation: 8 better 16 GB.
```shell
sudo apt-get update
sudo apt-get install git curl build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libreadline-dev
```
***
## Install Ruby
Use [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build#readme) to install Ruby. We always require the latest ruby versions, and you can check which version is required by checking the Gemfile for the `ruby "~> X.Y"` statement. At the time of writing, this version is “3.1.2”

### Install rbenv and ruby-build
rbenv is a ruby version manager that lets you quickly switch between ruby versions. ruby-build is an addon to rbenv that installs ruby versions.
```shell
# Install rbenv locally for the dev user
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
# Optional: Compile bash extensions
cd ~/.rbenv && src/configure && make -C src
# Add rbenv to the shell's $PATH.
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# Run rbenv-init and follow the instructions to initialize rbenv on any shell
~/.rbenv/bin/rbenv init
# Issue the recommended command from the stdout of the last command
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
# Source bashrc
source ~/.bashrc
```
### Installing ruby-build
ruby-build is an addon to rbenv that installs ruby versions
```shell
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

### Installing ruby-3.0
With both installed, we can now install the actual ruby version 3.0. You can check available ruby versions with `rbenv install --list`. At the time of this writing, the latest stable version is `3.1.2` which we also require.

We suggest you install the version we require in the Gemfile. Search for the `ruby '~> X.Y.Z'` line and install that version.
```shell
# Install the required version as read from the Gemfile
rbenv install 3.1.2
```
This might take a while depending on whether ruby is built from source. After it is complete, you need to tell rbenv to globally activate this version
```shell
rbenv global 3.1.2
rbenv rehash
```
You also need to install [bundler](https://github.com/bundler/bundler/), the ruby gem bundler (remark: if you run into an error, first try with a fresh reboot).

If you get `Command 'gem' not found...` here, ensure you followed the instructions `rbenv init` command to ensure it is loaded in your shell.
***
## Setup Postgresql database
Next, install a PostgreSQL database.

```shell
[dev@debian]> sudo apt-get install postgresql postgresql-client
```
Create the tasker database user and accompanied database.
```shell
sudo su postgres
[postgres@ubuntu]> createuser -d -P tasker

# Exit the shell as postgres
[postgres@ubuntu]> exit
```
***
## Install Node.js
We will install the latest LTS version of Node.js via [nodenv](https://github.com/nodenv/nodenv). This is basically the same steps as for rbenv:

### Install nodenv
```shell
# Install nodenv
git clone https://github.com/nodenv/nodenv.git ~/.nodenv
# Optional: Install bash extensions
cd ~/.nodenv && src/configure && make -C src
# Add nodenv to the shell's $PATH.
echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bashrc

# Run nodenv init and follow the instructions to initialize nodenv on any shell
~/.nodenv/bin/nodenv init
# Issue the recommended command from the stdout of the last command
echo 'eval "$(nodenv init -)"' >> ~/.bashrc
# Source bashrc
source ~/.bashrc
```
### Install node-build
```shell
git clone https://github.com/nodenv/node-build.git $(nodenv root)/plugins/node-build
```
### Install latest LTS node version
You can find the latest LTS version here: [nodejs.org/en/download/](https://nodejs.org/en/download/)

At the time of writing this is v18.12.1 Install and activate it with:
```shell
nodenv install 18.12.1
nodenv global 18.12.1
nodenv rehash
```
### Update NPM to the latest version
```shell
npm install npm@latest -g
```
### Install Yarn package manager
```shell
npm install yarn -g
```
***
## Verify your installation
You should now have an active ruby and node installation. Verify that it works with these commands.
```shell
ruby --version
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]

bundler --version
Bundler version 2.3.25

node --version
v18.12.1

npm --version
9.2.0

yarn --version
1.22.19
```
***
## Install Tasker Sources
In order to create a pull request to the core OpenProject repository, you will want to fork it to your own GitHub account. This allows you to create branches and push changes and finally opening a pull request for us to review.

To do that, go to [github.com/edwardbako/tasker](https://github.com/edwardbako/tasker) and press “Fork” on the upper right corner.
```shell
# Download the repository
# If you want to create a pull request, replace the URL with your own fork as described above
mkdir ~/dev
cd ~/dev
git clone https://github.com/edwardbako/tasker.git
cd tasker
```
## Configure Tasker
```shell
# Configure the database configuration file in config/database.yml (relative to the tasker-directory.
vim config/database.yml
```
Now edit the database credentials.
```shell
# Create master.key file for encription
vim config/master.key

# And setup credentials
rails credentials:edit
```
It should look like this (just with your database name, username, and password):
```yaml
postgresql:
  development:
    username: tasker
    password: password
```
## Finish the installation of Tasker
Install code dependencies, link plugin modules and export translation files.

* gem dependencies (If you get errors here, you’re likely missing a development dependency for your distribution)
* node_modules
* link plugin frontend modules
* and export frontend localization files
```shell
bundle install
yarn install
```
Now, run the following tasks to seed the dev database, and prepare the test setup for running tests locally.
```shell
RAILS_ENV=development rails db:create db:migrate db:seed
RAILS_ENV=development rails db:test:prepare
```
# Run Tasker through foreman
You can run all required workers of Tasker through `foreman`, which combines them in a single tab. This is useful for starting out, however most developers end up running the tasks in separate shells for better understanding of the log output, since foreman will combine all of them.
```shell
#Juset simply run
bin/dev
```
The application will be available at `http://127.0.0.1:3000`

## Start Coding
Please have a look at our [development guidelines]() for tips and guides on how to start coding. We have advice on how to get your changes back into the Tasker core as smooth as possible.

## Testing Tasker
By default, every Rails application has three environments: development, test, and production.

Each environment's configuration can be modified similarly. In this case, we can modify our test environment by changing the options found in `config/environments/test.rb`.

>Your tests are run under `RAILS_ENV=test`.

We like to have automated tests for every new developed feature. Run test suite.
```shell
bin/rails test

# To run system test
bin/rails test:system

# All of the tests run by command
bin/rails test:all
```

### Troubleshooting
The Tasker logfile can be found in `log/development.log`.

If an error occurs, it should be logged there (as well as in the output to STDOUT/STDERR of the rails server process).

### Questions, Comments, and Feedback
If you have any further questions, comments, feedback, or an idea to enhance this guide, please tell us at the [github issues].

##### Sections to cover: 
* ###### Services (job queues, cache servers, search engines, etc.)

* ###### Deployment instructions
