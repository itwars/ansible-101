FROM alpine
RUN	set -x \
	&& apk update \
	&& apk upgrade \
	&& apk add --no-cache ansible openssh-client \
	&& mkdir /etc/ansible \
	&& mkdir /root/.ssh \
	&& rm -rf /var/cache/apk/* 
ENV ANSIBLE_HOST_KEY_CHECKING=False
ENTRYPOINT ["ansible"]

