#
# docker build -t "swquinn/oracle11g" --force-rm=true /vagrant
#
# The MIT License (MIT)
#
# Copyright (c) 2014 extesla
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#
# ORACLE 11G on CENTOS 6
# ======================
#
# What is this?
# ----------------------
# This Docker file is designed as a means of streamlining an Oracle 11g install
# in a Linux environment by specifically dockerizing the installation and
# treating it more like a packaged process rather than a long-winded and, quite
# frankly, frustrating installation process.
#
# Why CentOS?
# ----------------------
# Oracle's databases (as I have been told) are certified on RED HAT Linux
# distributions of which CentOS is interoperable.
#
# How do I use this?
# ----------------------
# If you are not familiar with Docker, you should familiarize yourself with its
# concepts first. For those of you that are familiar with Docker, or those of
# you brave souls for whom caution is something to be thrown to the wind...
#
# Before you can run the docker build command, you need to do some work first,
# I know, quit your complaining. When being built, the docker container will
# copy over two directories: the "config" directory, and the "installer"
# directory.
#
# The "config" directory contains configuration excerpts and content which will
# need to be applied to the container during the configuration and installation
# process for Oracle.
#
# The "installation" directory should hold the actual Oracle database installer
# content (you can provide the two-part archive, or explode it yourself in this
# directory). YOU must provide the content for the installation directory, and
# as such, the installation directory is purposefully ignored from the repo that
# this Dockerfile is tracked in.
#
# THE INSTALLATION DIRECTORY NEEDS TO BE CREATED AND POPULATED WITH YOUR COPY OF
# THE ORACLE INSTALLER!
#
# Once you've taken care of all of the pre-requisites, you can run the following
# script:
#
#   $ ./install-oracle
#
#
FROM centos:centos6
MAINTAINER Sean Quinn <swquinn@gmail.com>

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
RUN yum -y clean all;
RUN yum -y install binutils compat-libstdc++-33.x86_64 elfutils-libelf \
    elfutils-libelf-devel gcc gcc-c++ glibc glibc-common glibc-devel \
    glibc-headers ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel \
    make sysstat unixodbc unixodbc-devel unzip zlibc; yum -y clean all;
RUN ln -s /usr/lib/x86_64-linux-gnu /usr/lib64; \
    ln -sf /bin/bash /bin/sh;
RUN mkdir -p /opt/app/oracle/product/11g
RUN mkdir -p /var/opt/oracle
RUN mkdir -p /tmp/orainst

# Create user groups and users, add user to groups.
RUN /usr/sbin/groupadd -g 5001 oinstall; \
    /usr/sbin/groupadd -g 5002 dba; \
    /usr/sbin/useradd  -u 5001 -m -g oinstall -G dba,oinstall -s /bin/bash oracle; \
    echo "oracle:password"|chpasswd;

#
#
#
ADD orainst /tmp/orainst

# 
# Copy over the configuration files to the /var/opt/oracle/config directory
# in the container.
#
# Once you've done this, move the oraInst.loc file to the /etc directory.
#
ADD config /var/opt/oracle

#
# Explode the Oracle installation files into the installer.
#
RUN unzip "/tmp/orainst/*.zip" -d /tmp/orainst

# Assign ownership and permissions to the oracle directories, recursively.
RUN chown -R oracle:oinstall /opt/app
RUN chown -R oracle:oinstall /tmp/orainst
RUN chmod -R 775 /opt/app
RUN chmod +x /tmp/orainst/database/runInstaller

# Modify the Oracle environment settings, export them to the bash profile.
ENV TMP /tmp
ENV TMPDIR /tmp
ENV HOSTNAME localhost
ENV ORACLE_SID orcl
ENV ORACLE_BASE /opt/app/oracle
ENV ORACLE_HOME /opt/app/oracle/product/11g
ENV LD_LIBRARY_PATH $ORACLE_HOME/lib:/lib:/usr/lib
ENV CLASSPATH $ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
ENV PATH $ORACLE_HOME/bin:$PATH

EXPOSE 1521

#
# Change to the Oracle user, and run the installer.
#
#USER oracle

#ENTRYPOINT ["/tmp/orainst/database/runInstaller"]
#CMD ["--help"]
