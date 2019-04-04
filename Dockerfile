FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

RUN pip install zeep && \
    mkdir /.ansible && \
    chmod -Rf 775 /.ansible && \
    chmod -Rf 775 /thycotic && \
    chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
