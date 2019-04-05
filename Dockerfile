FROM registry.access.redhat.com/ansible-runner-12/ansible-runner
# https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/ansible-runner-12/ansible-runner
# https://access.redhat.com/downloads/content/python27-python-pip/8.1.2-3.el7/noarch/fd431d51/package

COPY ansible/ /thycotic

#ENV LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64

# RUN yum repolist --disablerepo=* && \
#     yum-config-manager --disable \* > /dev/null && \
#     yum-config-manager --enable rhel-7-server-rpms > /dev/null && \
#     yum-config-manager --enable rhel-7-server-extras-rpms > /dev/null && \
#     yum-config-manager --enable rhel-7-server-ose-3.9-rpms > /dev/null && \
#     yum-config-manager --enable rhel-server-rhscl-7-rpms > /dev/null && \
    #yum install -y python27-python-pip python2-openshift && \
RUN easy_install pip && \
    # scl enable python27 bash && \
    # source scl_source enable python27 && \
    # export LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 && \
    python -m pip install --no-cache-dir --upgrade pip && \
    python -m pip install --no-cache-dir openshift && \
    python -m pip install --no-cache-dir zeep && \
    mkdir /.ansible && \
    chmod -R 775 /.ansible && \
    chmod -R 775 /thycotic && \
    chmod g+w /etc/passwd

USER 1001

ENTRYPOINT ["/thycotic/runansible.sh"]
