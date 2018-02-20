FROM alpine:3.7

ENV ETCD_BACKUP_DIR=/backups
ENV ETCDCLI_URL=https://storage.googleapis.com/etcd/v3.2.13/etcd-v3.2.13-linux-amd64.tar.gz

COPY backup.sh /

RUN apk --no-cache update && \
    apk --no-cache add ca-certificates bash curl python py-pip && \
    pip --no-cache-dir install awscli && \
    apk --purge -v del py-pip && \
    mkdir /tmp/etcd/ && \
    curl -L $ETCDCLI_URL -o /tmp/etcd-cli.zip && \
    tar xvzf /tmp/etcd-cli.zip -C /tmp/etcd --strip-components=1 && \
    rm -rf /var/cache/apk/* && \
    mkdir /backup


