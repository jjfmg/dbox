FROM ubuntu:14.04

# grab packages
RUN apt-get update -y
RUN apt-get install -y \
  vim-nox \
  git \
  curl \
  wget

# setup home environment
RUN useradd dev
RUN mkdir /home/dev
RUN chown -R dev:dev /home/dev
RUN mkdir -p /home/dev/bin
ENV PATH /home/dev/bin:$PATH
WORKDIR /home/dev
ENV HOME /home/dev

# data volumes
RUN mkdir /data/
RUN touch /data/.keep
RUN chown -R dev:dev /data/
VOLUME /data/
RUN mkdir /shared/
RUN touch /shared/.keep
RUN chown -R dev:dev /shared
VOLUME /shared

# vim
ADD vim $HOME/.vim
ADD vimrc $HOME/.vimrc
RUN mkdir -p $HOME/.vim/bundle
RUN git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
RUN vim -E -u NONE -S ~/.vim/vundle.vim +PluginInstall +qall > /dev/null

# shared parts
RUN ln -s /shared/.ssh

RUN chown -R dev:dev /home/dev
USER dev
