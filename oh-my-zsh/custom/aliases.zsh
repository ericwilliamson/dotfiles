# ssh
alias datviper="ssh bccain@viper.cis.ksu.edu"
alias datcg="ssh bccain@cougar.cis.ksu.edu"
alias ksuX="ssh -X bccain@cislinux.cis.ksu.edu"

# Reload ZSH
alias reload='. ~/.zshrc'

# pianobar
alias pb="pianobar"

# clear
alias cl="clear"

# ls
alias ls="ls -GF"
alias ll="ls -GlAh"
alias l="ls -Glh"
alias la='ls -GA'

# XSB
# alias xsb="~/Downloads/XSB/bin/xsb"


# grc overrides for ls
# Made possible through contributions from generous benefactors like
# `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias ll="gls -lAh --color"
  alias l="gls -lh --color"
  alias la='gls -A --color'
fi

# VIM
alias v='vim'
alias vf='vim -f'

# Latex
alias lpdf='pdflatex'
alias lrtf='latex2rtf'

# Word is for opening RTF files quickly in Microsoft Word
alias word='open -a "Microsoft Word"'
alias skim='open -a "Skim"'

# Python
alias p='python'

# git
alias gl='git pull'
alias glo='git pull origin master'
alias gp='git push'
alias gpo='git push origin master'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias go='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'

# todo.txt-cli
function t() { 
  if [ $# -eq 0 ]; then
    todo.sh ls
  else
    todo.sh $* 
  fi
}
alias n="t ls +next"

# rails
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'
alias a='autotest -rails'
alias tlog='tail -f log/development.log'
alias scaffold='script/generate nifty_scaffold'
alias migrate='rake db:migrate db:test:clone'
alias rst='touch tmp/restart.txt'

# commands starting with % for pasting from web
alias %=' '