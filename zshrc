#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Joshua Gonzales <jfmgonzales@outlook.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

if [[ -d $HOME/shared/ssh ]]; then
  ln -s $HOME/shared/ssh $HOME/.ssh
fi

if [[ -d $HOME/projects/bin ]]; then
  ln -s $HOME/projects/bin $HOME/bin
fi

if [[ -f $HOME/shared/bitbucket ]]; then
  ln -s $HOME/shared/bitbucket $HOME/.bitbucket
fi

eval "$(rbenv init -)"

alias compose='docker-compose'
alias d='docker'
alias dps='docker ps'
alias dim='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
