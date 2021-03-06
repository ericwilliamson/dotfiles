#! /bin/bash

# Brian Cain
#
# A simple bash script for setting up
# an Operating System with my dotfiles

# Function to determine package manager
function determine_package_manager() {
  which yum > /dev/null && {
    echo "yum"
    export OSPACKMAN="yum"
    return;
  }
  which apt-get > /dev/null && {
    echo "apt-get"
    export OSPACKMAN="aptget"
    return;
  }
  which brew > /dev/null && {
    echo "homebrew"
    export OSPACKMAN="homebrew"
    return;
  }
}

# Adds a symbolic link to files in ~/.dotfiles
# to your home directory.
function symlink_files() {
  ignoredfiles=(LICENSE readme.md install.sh update-zsh.sh zsh-theme vim-colors)

  for f in $(ls -d *); do
    if [[ ${ignoredfiles[@]} =~ $f ]]; then
      echo "Skipping $f ..."
    else
        link_file $f
    fi
  done
}

# symlink a file
# arguments: filename
function link_file(){
  echo "linking ~/.$1"
  if ! $(ln -s "$PWD/$1" "$HOME/.$1");  then
    echo "Replace file '~/.$1'?"
    read -p "[Y/n]?: " Q_REPLACE_FILE
    if [[ $Q_REPLACE_FILE != 'n' ]]; then
      replace_file $1
    fi
  fi
}

# replace file
# arguments: filename
function replace_file() {
  echo "replacing ~/.$1"
  ln -sf "$PWD/$1" "$HOME/.$1"
}

function setup_git() {
  echo 'Setting up git config...'
  read -p 'Enter Github username: ' GIT_USER
  git config --global user.name "$GIT_USER"
  read -p 'Enter email: ' GIT_EMAIL
  git config --global user.email $GIT_EMAIL
  git config --global core.editor vim
  git config --global color.ui true
  git config --global color.diff auto
  git config --global color.status auto
  git config --global color.branch auto
  # extras
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit"
  git config --global alias.pr "! f() { git fetch $1 pull/$2/head:PR-$2-$3 && git checkout PR-$2-$3;}; f"
  git config --global alias.plclone "! f() { cd ${GIT_PREFIX:-.} && git clone git@github.com:puppetlabs/$1.git -o puppetlabs && cd $1 && git remote add ericwilliamson git@github.com:ericwilliamson/$1.git; }; f"

  # global git ignore
  ln -sf "${PWD}/.gitignore-global" "${HOME}/.gitignore"

}

function setup_antigen() {
  echo 'Setting up antigen (zsh package manager)'
  git clone https://github.com/zsh-users/antigen.git "${HOME}/.antigen"
}

echo "Setting up Operating System..."

set -e
(
  determine_package_manager

  # general package array
  declare -a packages=('vim' 'git' 'tree' 'htop' 'wget' 'curl' 'tmux')

  if [[ $OSPACKMAN == "homebrew" ]]; then
    echo "You are running homebrew."
    echo "Using Homebrew to install packages..."
    brew update
    declare -a macpackages=('findutils' 'gist' 'hub' 'the_silver_searcher', 'z')
    brew install "${packages[@]}" "${macpackages[@]}"
  elif [[ "$OSPACKMAN" == "yum" ]]; then
    echo "You are running yum."
    echo "Using yum to install packages...."
    sudo yum update
    sudo yum install -y epel-release
    sudo yum install -y "${packages[@]}" zsh cmake
  elif [[ "$OSPACKMAN" == "aptget" ]]; then
    echo "You are running apt-get"
    echo "Using apt-get to install packages...."
    sudo apt-get update
    sudo apt-get install "${packages[@]}" zsh
  else
    echo "Could not determine OS. Exiting..."
    exit 1
  fi

  echo "Installing oh-my-zsh"
  source update-zsh.sh
  echo "Installing dotfiles"
  symlink_files

  echo "Installing vim vundles..."
  vim +BundleInstall +qall

  echo "Installing vim-colors"
  $(ln -sf "$PWD/vim-colors" "$HOME/.vim/colors")
  echo "Changing shells to ZSH"
  chsh -s /bin/zsh

  echo "Configuring git"
  setup_git

  echo "Operating System setup complete."
  echo "Reloading session"
  exec zsh


)
