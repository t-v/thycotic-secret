FROM registry.redhat.io/ansible-runner-12/ansible-runner:latest

COPY ansible/ /thycotic

RUN chown -Rf 1001 /usr/bin/ansible* && \
    chown -Rf 1001 /thycotic && \
    chown -Rf 1001 /etc/ansible

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]