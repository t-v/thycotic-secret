FROM alpine:3.9

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        rsync \
        sshpass

RUN apk --update add --virtual \
        .build-deps \
        python3-dev \
        libffi-dev \
        openssl-dev \
        libxml2-dev \
        libxslt-dev \
        build-base \
 && pip3 install --upgrade \
        pip \
        cffi \
 && pip3 install \
        ansible \
        ansible-lint \
        lxml \
        openshift \
        zeep \
 && apk del \
        .build-deps \
 && rm -rf /var/cache/apk/*

COPY ansible/ /thycotic

RUN mkdir -p /etc/ansible \
 && echo 'localhost' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config \
 && mkdir /.ansible \
 && chmod -R 775 /.ansible \
 && chmod -R 775 /thycotic \
 && chmod -R 775 /etc/ansible \
 && chmod g+w /etc/passwd

COPY ansible/ /thycotic
USER 1001

WORKDIR /thycotic

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
