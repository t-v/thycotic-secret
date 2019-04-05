FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

ENV LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64

RUN yum repolist --disablerepo=* && \
    yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms > /dev/null && \
    yum-config-manager --enable rhel-7-server-extras-rpms > /dev/null && \
    yum-config-manager --enable rhel-7-server-ose-3.9-rpms > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms > /dev/null && \
    yum install -y python27-python-pip python2-openshift && \
    scl enable python27 bash && \
    source scl_source enable python27 && \
    export LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 && \
    /opt/rh/python27/root/usr/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/rh/python27/root/usr/bin/pip install --no-cache-dir zeep && \
    mkdir /.ansible && \
    chmod 775 -Rf /.ansible && \
    chmod 775 -Rf /thycotic && \
    chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
