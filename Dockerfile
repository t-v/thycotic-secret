FROM registry.access.redhat.com/ansible-runner-12/ansible-runner

COPY ansible/ /thycotic

ENV LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64

RUN yum repolist --disablerepo=* && \
    yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms > /dev/null && \
    yum-config-manager --enable rhel-7-server-extras-rpms > /dev/null && \
    yum-config-manager --enable rhel-7-server-ose-3.9-rpms > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms > /dev/null && \
    yum install -y rh-python36-python-pip && \
    #scl enable python27 bash && \
    #source scl_source enable python27 && \
    #export LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir zeep && \
    pip install --no-cache-dir openshift && \
    mkdir /.ansible && \
    chmod -R 775 /.ansible && \
    chmod -R 775 /thycotic && \
    chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
