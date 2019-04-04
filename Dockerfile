FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

RUN easy_install pip &&\
    pip install --no-cache-dir zeep && \
    pip install --no-cache-dir openshift && \
    mkdir /.ansible && \
    chmod -Rf 775 /.ansible && \
    chmod -Rf 775 /thycotic && \
    chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
