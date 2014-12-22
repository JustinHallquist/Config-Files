##### Variables #####

# Folder where your diffs are located.
DIFFPATH="/tmp/"

# Default directory to load up.
DEFAULTDIR=~/Code/Work/currica

##### Git Helpers #####

### Aliases ###

### Functions ###

# # Applies a diff patch
# function git_apply_patch()
# {
#   git apply --ignore-space-change --ignore-whitespace --reject --whitespace=fix "$DIFFPATH${1}.patch"
# }

# Creates a diff patch (use for uncommitted changes)
# function git_diff_patch()
# {
#   git diff origin/master --full-index -M > "$DIFFPATH${1}.patch"
# }

# Sends all COMMITTED changes from origin/master to the file name specified in the argument
# For example, git_patch testing would create a file called testing.patch in /d/diffs
# If necessary, make a temporary commit and then reset by doing git reset HEAD^
# function git_patch()
# {
#   git format-patch origin/master --stdout --full-index > "$DIFFPATH${1}.patch"
# }


##### Aliases #####
# Switches to the Dropbox code directory on Mac.
alias macdbc="cd ~/Dropbox/Documents/Documents/Code"

alias qcode="cd ~/Code/Work/currica/"

alias install_vundle="git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim"

alias update_vim_plugins="vim +PluginInstall +qall"

# Creates a symbolic link to a file
# symlink /path/to/original/file /path/to/symlink
alias symlink="ln -s"

alias v="/Applications/MacVim.app/Contents/MacOS/Vim"

# Removes all .rej files.
alias remove_rej='find . -name "*.rej" -exec rm -f {} \;'

# Finds and replaces with multiple newline removal.
# NEed to add single quotes back around rails_helper.
alias dothething='for f in $(find spec/**/*.rb ); do perl -00pi -e "s/require rails_helper\n\n//gm" $f; done'


##### Functions #####

# List out all custom aliases and functions.
function list_commands()
{
  # Create a temp array for storing output
  TEMPARR=()
  # Get all of the alises. First, strip out the 'alias ' text. Second, strip out the value of the aliases.
  TEMPARR+=($(alias | sed -e "s/alias //g" -e "s/=.*//g"))
  # Get all of the functions. First, remove any functions that start with _ (as they are internal git functions). Second, strip out 'declare -f '.
  TEMPARR+=($(declare -F | egrep -v "\<_" | sed "s/declare -f //g"))

  # Sort the array, and print the results with one item per line.
  # If no arguments are given, print out just the git commands.
  if [ $# -eq 0  ] ; then
    printf '%s\n' "${TEMPARR[@]}" | sort | grep git_
  # If we passed in the argument 'a'', print out all commands
  elif [ ${1} == 'all' ]; then
    printf '%s\n' "${TEMPARR[@]}" | sort
  fi
}

# Sets up ssh-agent so we don't have to authenticate every time.
function set_up_ssh_agent()
{
  eval "$(ssh-agent)" > /dev/null # We don't care about the output.
  ssh-add
}

# Reloads bashrc
function reload()
{
  export LAST_DIR=$(pwd) # Save the current working directory so we can switch back to it after reload.
  source ${HOME}/.bashrc
}

function setup_vim()
(
  mkdir ~/.vim/bundle
  install_vundle
  install_ycm
  install_command_t
)

function install_command_t()
(
  cd ~/.vim/bundle/command-t/ruby/command-t
  ruby extconf.rb
  make
)

function install_nokogiri()
(
  gem uninstall nokogiri
  xcode-select --install
  gem install nokogiri
)

# Installs the YCM vim plugin
function install_ycm()
(
  #brew install cmake
  cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd
  ./build.sh --clang-compiler
)

##### Ruby/Rails Aliases #####

# Clears the rails cache.
alias rails_clear_cache="rails runner \"Rails.cache.clear\""

# Re-creates the database for dev with the production data dump.
function setup_dev_database()
(
  echo 'Dropping the database...'
  db=`rake db:drop 2&>1`
  run=`sed -n '/ERROR/p' <<< "$db"`
  if [ -n "$run" ]
  then
    echo 'hmm....'
    exit 1
  else
    echo 'Next steps...'
  fi
  rake db:create
  pg_restore --verbose --clean --no-acl --no-owner -d currica_development ~/Code/Work/currica/currica-db.dump
  rake db:migrate
  rake db:migrate RAILS_ENV=test
  rails runner '@user = User.find_by_email("rreas@q-centrix.com"); @user.password = "cuRR1ca!"; @user.password_confirmation = "cuRR1ca!"; @user.save!;'
)

# Re-creates the database for dev without using the production data dump
function setup_db_structure()
(
  echo 'Dropping the database...'
  db=`rake db:drop 2&>1`
  run=`sed -n '/ERROR/p' <<< "$db"`
  if [ -n "$run" ]
  then
    echo 'hmm....'
    exit 1
  else
    echo 'Next steps...'
  fi
  rake db:create
  rake db:migrate
  rake db:migrate RAILS_ENV=test
)

##### Startup Commands #####

# Changes directory on startup (DOES NOT change home directory).
cd $DEFAULTDIR

# If this is the first time loading the shell, go to default directory.
# Otherwise, go to the directory we were working in before reload
if [[ -z "$LAST_DIR" ]]; then cd $DEFAULTDIR; else cd $LAST_DIR; fi

# Adds Git Auto-Complete.
source ~/git-completion.bash

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin
