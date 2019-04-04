FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

RUN mkdir /.ansible && \
    chown -Rf 1001 /thycotic &&\
    chown -Rf 1001 /.ansible

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]