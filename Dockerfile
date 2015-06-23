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
RUN cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
RUN /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

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
RUN DEBIAN_FRONTEND=noninteractive vim -u $HOME/.vim/vundle.vim +PluginInstall +qall

# shared parts
RUN ln -s /shared/.ssh

RUN chown -R dev:dev /home/dev
USER dev
