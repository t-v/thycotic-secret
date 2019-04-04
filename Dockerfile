FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

RUN mkdir /.ansible && \
    chmod -Rf 775 /.ansible

ENTRYPOINT ["/thycotic/runansible.sh"]