FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

RUN yum -y install python-pip python2-openshift
RUN pip install --no-cache-dir zeep
RUN mkdir /.ansible
RUN chmod -Rf 775 /.ansible
RUN chmod -Rf 775 /thycotic
RUN chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
