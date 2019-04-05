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
        libxslt1-dev \
        build-base \
 && pip3 install --upgrade \
        pip \
        cffi \
 && pip3 install \
        ansible \
        ansible-lint \
        openshift \
        zeep \
 && apk del \
        .build-deps \
 && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible \
 && echo 'localhost' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

COPY entrypoint /usr/local/bin/

COPY ansible/ /thycotic
USER 1001

WORKDIR /thycotic

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
