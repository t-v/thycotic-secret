FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

ENTRYPOINT ["/thycotic/runansible.sh"]