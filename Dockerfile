FROM registry.access.redhat.com/ansible-runner-11/ansible-runner:latest

COPY ansible/ /thycotic

ENTRYPOINT ["/thycotic/runansible.sh"]