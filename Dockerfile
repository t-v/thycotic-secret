FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

RUN yum repolist --disablerepo=* && \
    yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms > /dev/null && \
    yum-config-manager --enable rhel-7-server-extras-rpms > /dev/null && \
    yum-config-manager --enable rhel-7-server-ose-3.9-rpms > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms > /dev/null  && \
    yum install -y python27-python-pip python2-openshift
RUN /usr/bin/pip2.7 install --no-cache-dir zeep
RUN mkdir /.ansible
RUN chmod -Rf 775 /.ansible
RUN chmod -Rf 775 /thycotic
RUN chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
