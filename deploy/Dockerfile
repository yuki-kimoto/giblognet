FROM alpine:3.9

# Update OS and install dependencies
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk --no-cache add \
        tini \
        bash \
        shadow \
        perl \
        git \
        openssh-server \
        perl-dev \
        gcc \
        g++ \
        curl \
        wget \
        make

# Create user giblognet
RUN set -x \
    && useradd -m giblognet \
    && mkdir -m 700 /home/giblognet/.ssh \
    && usermod -p '*' giblognet \
    && touch /home/giblognet/.ssh/authorized_keys \
    && chmod 600 /home/giblognet/.ssh/authorized_keys \
    && chown -R giblognet:giblognet /home/giblognet/.ssh \
    && sed -i 's/#PasswordAuthentication yes.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#ChallengeResponseAuthentication yes.*/ChallengeResponseAuthentication no /' /etc/ssh/sshd_config

USER giblognet

# Install Giblog Net
RUN set -x \
    && git --version \
    && perl -v \
    && curl -kL https://github.com/yuki-kimoto/giblognet/archive/latest.tar.gz \
        > /home/giblognet/giblognet-latest.tar.gz \
    && mkdir /home/giblognet/giblognet \
    && tar -zxf /home/giblognet/giblognet-latest.tar.gz \
        --strip-components=1 -C /home/giblognet/giblognet \
    && rm -f /home/giblognet/giblognet-latest.tar.gz \
    && cd /home/giblognet/giblognet \
    && PERL_USE_UNSAFE_INC=1 ./setup_module \
    && prove t \
    && ./setup_database

USER root

# Clean obsolete Packages
RUN set -x \
    && apk del --no-cache \
        perl-dev \
        gcc \
        g++ \
        curl \
        wget \
        make

# Copy start script
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

# Expose default HTTP connector port.
EXPOSE 10020
EXPOSE 22

# Set volume mount point
VOLUME ["/home/giblognet"]

# Set the default working directory as the installation directory.
WORKDIR /home/giblognet

# Set entrypoint to invoke tini as PID1
ENTRYPOINT ["/sbin/tini","--","/docker-entrypoint.sh"]
