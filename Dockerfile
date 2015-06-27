FROM ubuntu:14.04

###############
# grab packages
RUN apt-get update -y
RUN apt-get install -y \
  vim-nox \
  zsh \
  git \
  curl \
  wget \
  apt-transport-https
RUN echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update -y
RUN apt-get install -y \
  lxc-docker-1.6.0 \
  python-pip
##-##

########################
# setup user environment
RUN cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
RUN /usr/sbin/update-locale LANG=en_US.UTF-8
ENV HOME /root
ENV LC_ALL en_US.UTF-8
##-##

##############
# data volumes
#
# I have persistent stuff on my server organized like so:
#
#   - /data (stuff my containers work with)
#   - /shared (configuration stuff my containers need)
#   - /projects (stuff I make)
#
# These all get mounted in ~, which in this case is /root.
#
RUN mkdir $HOME/data/
VOLUME $HOME/data/
RUN mkdir $HOME/shared/
VOLUME $HOME/shared
RUN mkdir $HOME/projects/
VOLUME $HOME/projects/
##-##

##############
# zsh + prezto
RUN chsh -s /bin/zsh
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git $HOME/.zprezto
RUN ln -s $HOME/.zprezto/runcoms/zlogin $HOME/.zlogin
RUN ln -s $HOME/.zprezto/runcoms/zlogout $HOME/.zlogout
RUN ln -s $HOME/.zprezto/runcoms/zshenv $HOME/.zshenv
##-##

#####
# vim
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# - vim plugins
WORKDIR $HOME/.vim/bundle
RUN git clone git://github.com/jtratner/vim-flavored-markdown.git
RUN git clone git://github.com/altercation/vim-colors-solarized.git
RUN git clone https://github.com/ekalinin/Dockerfile.vim
##-##

####################
# rbenv + ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
##-##

###############
# bitbucket-cli
RUN pip install bitbucket-cli
##-##

###########
# add files
ADD vimrc $HOME/.vimrc
ADD gitconfig $HOME/.gitconfig
ADD zpreztorc $HOME/.zpreztorc
ADD zprofile $HOME/.zprofile
ADD zshrc $HOME/.zshrc
##-##

#############
# final stuff
WORKDIR /root
USER root
CMD /bin/zsh
##-##
