FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]