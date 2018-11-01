# paths
alias api="cd ~/Work/neb-api"
alias neb="cd ~/Work/neb-www"
alias packages="cd ~/Work/neb-www/packages"
alias admin="cd ~/Work/neb-www/packages/neb-www-admin"
alias booking="cd ~/Work/neb-www/packages/neb-www-booking"
alias practice="cd ~/Work/neb-www/packages/neb-www-practice"
alias www="cd ~/Work/neb-www/packages/neb-www"

# git alias
alias gits="git status -sb"
alias gt="git log --graph --oneline --all"
alias gdo="git diff origin/development $1"

# test alias
alias rt="npm run test"

# colorls
source $(dirname $(gem which colorls))/tab_complete.sh
alias ls='colorls'
alias lc='colorls -lA --sd'

# utilities
function ng() {
  exclusions="--exclude-dir={node_modules,dist,neb-www} --exclude={*.min,*.log,*/coverage/*,*/allure-results/*,coverage-final.json}"
  if [ -z "$2" ]; then
    echo "grep -nr \"$1\" . $exclusions"
    eval "grep -nr \"$1\" . $exclusions"
  else
    echo "grep -nr \"$1\" $2 $exclusions"
    eval "grep -nr \"$1\" $2 $exclusions"
  fi
}

# taskbook
alias tb="/usr/local/Cellar/node/10.6.0/lib/node_modules/taskbook/cli.js"

#ANDROID STUDIO and JAVA HOME for APPIUM
export ANDROID_HOME=/Users/jhallquist/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_171.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# mysql settings
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

export NODE_ENV=development
export MYSQL_GLOBAL_HOST=localhost
export MYSQL_HOST=localhost
export MYSQL_USER=user
export MYSQL_PASSWORD=password

# connect mysql
export ldbconn="mysql -u user"

# docker mysql
alias dbinit="docker run --name mysql --rm -p 3306:3306 -v ~/database_data:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=global -d mysql:5.7"
alias dbrm="docker stop mysql"
alias dbconn="mysql -u user -h 127.0.0.1 -P 3306 -p"

# coverage
alias coverage="open -a \"Google Chrome\" ./coverage/index.html"

# lerna
function lstart() {
  eval "lerna run start --scope @nebula-garage/neb-www-$1 --stream"
}

# karma
function kstart() {
  eval "node_modules/karma/bin/karma start packages/neb-$1/karma.conf.js --debug"
}

# Sets up ssh-agent so we don't have to authenticate every time.
function set_up_ssh_agent()
{
  # eval "$(ssh-agent)" > /dev/null # We don't care about the output.
  ssh-add -l | grep "The agent has no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh-add
  fi
}

# create docker image of branch
function dockBranch() {
  red=`tput setaf 1`
  reset=`tput sgr0`

  if [ ! -f Dockerfile ]; then
    echo "${red}No Dockerfile found${reset}"
    return
  fi

  rmDockBranch

  folder=$(basename "$PWD")
  branch_name=$(git symbolic-ref --short -q HEAD)

  echo "building image $folder with tag $branch_name"
  eval "docker build . -t $branch_name"

  if [ $2 ]; then
    echo "starting $branch_name listening on port $1:$2"
    eval "docker run -p $1:$2 $branch_name"
  elif [ $1 ]; then
    echo "starting $branch_name listening on port $1:80"
    eval "docker run -p $1:80 $branch_name"
  else
    echo "starting $branch_name listening on port 80:80"
    eval "docker run -p 80:80 $branch_name"
  fi
}

function rmDockBranch() {
  branch_name=$(git symbolic-ref --short -q HEAD)
  container_id=$(docker ps -a | awk -v branch_name="$branch_name" '$2 == branch_name {print $1}')

  echo "$container_id"
  if [ -z "$container_id" ]; then
    return
  fi

  echo "removing container id $container_id hosting image $branch_name"
  eval "docker container rm $container_id"

  echo "removing image $branch_name"
  eval "docker rmi $branch_name"
}

function start() {
  echo "NEB_API_URL=http://localhost:$2 lerna run start --stream --scope @nebula-garage/neb-www-$1"
  eval "NEB_API_URL=http://localhost:$2 lerna run start --stream --scope @nebula-garage/neb-www-$1"
}

function build() {
  eval "neb"
  eval "NEB_API_URL=http://localhost:2112 npm run build"
  eval "www"
  eval "dockBranch"
}

set_up_ssh_agent
