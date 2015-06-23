FROM ubuntu:14.04

###############
# grab packages
RUN apt-get update -y
RUN apt-get install -y \
  vim-nox \
  git \
  curl \
  wget
##-##

########################
# setup user environment
RUN useradd dev
RUN mkdir /home/dev
RUN chown -R dev:dev /home/dev
RUN mkdir -p /home/dev/bin
RUN cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
RUN /usr/sbin/update-locale LANG=en_US.UTF-8
  # ENV
ENV PATH /home/dev/bin:$PATH
ENV HOME /home/dev
ENV LC_ALL en_US.UTF-8
WORKDIR /home/dev
##-##

##############
# data volumes
RUN mkdir /data/
RUN touch /data/.keep
RUN chown -R dev:dev /data/
VOLUME /data/
RUN mkdir /shared/
RUN touch /shared/.keep
RUN chown -R dev:dev /shared
VOLUME /shared
##-##

#####
# vim
ADD vimrc $HOME/.vimrc
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
RUN curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  # vim plugins
RUN git clone git://github.com/jtratner/vim-flavored-markdown.git \
  $HOME/.vim/bundle/vim-flavored-markdown
##-##

##############
# shared parts
RUN ln -s /shared/.ssh
##-##

#############
# final stuff
RUN chown -R dev:dev /home/dev
USER dev
##-##
