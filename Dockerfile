FROM reg.cnrancher.com/pipeline/jenkins:2.60.2

RUN mkdir -p /home/jenkins
ENV HOME /home/jenkins
# setup our local files first
ADD docker-wrapper.sh /usr/local/bin/docker-wrapper
# add customized jenkins home
COPY ./jenkins_home /var/rancher/jenkins_home

# add tools for cicd
# rancher cli & cihelper
ADD cihelper /usr/local/bin/cihelper
ADD rancher /usr/local/bin/rancher
