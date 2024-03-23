FROM alpine
LABEL maintainer "Vincent RABAH vincent.rabah@gmail.com"
RUN	set -x \
	&& apk update \
	&& apk upgrade \
	&& apk add --no-cache openssh-server python3 \
	&& rm -rf /var/cache/apk/* \
  &&  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  &&  echo 'root:toor' | chpasswd \
  &&  mkdir /run/sshd \
  &&  ssh-keygen -A

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

