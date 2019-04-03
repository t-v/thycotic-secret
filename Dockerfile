FROM registry.redhat.io/ansible-runner-12/ansible-runner:latest

COPY ansible/ /thycotic

ENTRYPOINT ["/thycotic/runansible.sh"]