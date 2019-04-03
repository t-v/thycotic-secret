FROM registry.redhat.io/ansible-runner-12/ansible-runner:latest

COPY ansible/ /thycotic

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]