FROM mongo:5.0

RUN apt update
RUN apt install awscli -y

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh

ENV MONGODB_URI ""
ENV MONGODB_OPLOG ""
ENV BUCKET_URI ""
ENV ENV_NAME  ""
ENV MY_POD_NAMESPACE ""
ENV MONGODB_ROOT_PASSWORD ""
ENV AWS_ROLE_ARN ""
ENV AWS_WEB_IDENTITY_TOKEN_FILE ""
ENV AWS_DEFAULT_REGION ""

CMD ["/scripts/backup-mongodb.sh"]
      