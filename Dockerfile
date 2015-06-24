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
  nano
##-##

########################
# setup user environment
RUN cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
RUN /usr/sbin/update-locale LANG=en_US.UTF-8
  # ENV
ENV HOME /root
ENV LC_ALL en_US.UTF-8
##-##

##############
# data volumes
RUN mkdir /data/
VOLUME /data/
RUN mkdir /shared/
VOLUME /shared
RUN mkdir /projects/
VOLUME /projects/
##-##

#####
# zsh
RUN chsh -s /bin/zsh
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git $HOME/.zprezto
RUN ln -s $HOME/.zprezto/runcoms/zlogin $HOME/.zlogin
RUN ln -s $HOME/.zprezto/runcoms/zlogout $HOME/.zlogout
RUN ln -s $HOME/.zprezto/runcoms/zpreztorc $HOME/.zpreztorc
RUN ln -s $HOME/.zprezto/runcoms/zprofile $HOME/.zprofile
RUN ln -s $HOME/.zprezto/runcoms/zshenv $HOME/.zshenv
RUN ln -s $HOME/.zprezto/runcoms/zshrc $HOME/.zshrc
RUN echo zstyle ':prezto:module:prompt' theme 'steeef' >> $HOME/.zpreztorc
RUN echo 'if [[ -d /shared/.ssh ]]; then\n  ln -s /shared/.ssh $HOME/.ssh;\nfi' >> $HOME/.zprofile
##-##

#####
# vim
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  # vim plugins
WORKDIR $HOME/.vim/bundle
RUN git clone git://github.com/jtratner/vim-flavored-markdown.git
##-##

###########
# add files
ADD vimrc $HOME/.vimrc
ADD gitconfig $HOME/.gitconfig
##-##

#############
# final stuff
WORKDIR /root
USER root
CMD /bin/zsh
##-##
