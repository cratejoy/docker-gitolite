FROM cratejoy/python-git

MAINTAINER Amir Elaguizy <aelaguiz@gmail.com>

#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
#RUN apt-get update
RUN apt-get -y install sudo openssh-server

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# To avoid annoying "perl: warning: Setting locale failed." errors,
# do not allow the client to pass custom locals, see:
# http://stackoverflow.com/a/2510548/15677
RUN sed -i 's/^AcceptEnv LANG LC_\*$//g' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd

RUN adduser --system --group --shell /bin/sh git
RUN su git -c "mkdir /home/git/bin"

RUN cd /home/git; su git -c "git clone git://github.com/sitaramc/gitolite";
RUN cd /home/git; su git -c "gitolite/install -ln";

ADD ./init.sh /init
ADD ./git_admin.pub /home/git/git_admin.pub
RUN chmod +x /init
ENTRYPOINT ["/init"]

EXPOSE 22
