FROM alpine:3.14

ENV TERRAFORM_VERSION=1.3.6

RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    unzip \
    make && \
    wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ENTRYPOINT [ "make" ]

CMD [ "help" ]
