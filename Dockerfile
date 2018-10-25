FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    git \
    python-pip \
    apt-transport-https \
    ca-certificates \
    curl \
    groff \
    less \
    software-properties-common \
    openssl \
#BEGIN Install docker
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable" \
 && apt-get update \
 && apt-get install -y docker-ce \
#END Install docker
#BEGIN Install kubectl
 && apt-get update && apt-get install -y apt-transport-https \
 && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
 && apt-get update \
 && apt-get install -y kubectl \
#END Install kubectl
#Cleanup
 && rm -rf /var/lib/apt/lists/*

#Install AWS IAM Authenticator
RUN curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator

#Install forge
#Use this forked version until https://github.com/datawire/forge/issues/102 is fixed
RUN cd /root \
    && git clone https://github.com/ai-neamtu/forge \
    && cd forge \
    && git checkout f7f7e683e95b8ff152305793130e3aee88786ea6 \
    && pip install -e . \
    && python setup.py install \
    && forge --version

#Install AWS CLI
RUN pip install awscli --upgrade --user \
 && ln -s /root/.local/bin/aws /usr/local/bin/aws

