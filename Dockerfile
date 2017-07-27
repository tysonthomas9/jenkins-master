FROM ubuntu:16.04
MAINTAINER Aaron <aaronwlsnn@gmail.com>

ARG jenkins_home=/var/jenkins_home
# expose the port
EXPOSE 8080

# expose slave port
EXPOSE 50000
# required to make docker in docker to work
VOLUME /var/lib/docker

# default jenkins home directory
ENV JENKINS_HOME ${jenkins_home}
# set our user home to the same location
ENV HOME ${jenkins_home}

VOLUME ${jenkins_home}
# set our wrapper
ENTRYPOINT ["/usr/local/bin/docker-wrapper"]
# default command to launch jenkins
CMD java -jar /usr/share/jenkins/jenkins.war

# setup our local files first
ADD docker-wrapper.sh /usr/local/bin/docker-wrapper

# for installing docker related files first
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list
# apparmor is required to run docker server within docker container
RUN apt-get update -qq && apt-get install -qqy wget curl git iptables apt-transport-https ca-certificates apparmor

# for jenkins
RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - \
  && echo deb https://pkg.jenkins.io/debian-stable binary/ >> /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -qqy jenkins

# now we install docker in docker - thanks to https://github.com/jpetazzo/dind
# We install newest docker into our docker in docker container
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
  && tar --strip-components=1 -xvzf docker-latest.tgz -C /usr/local/bin \
  && chmod +x /usr/local/bin/docker
