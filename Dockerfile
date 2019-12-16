FROM fluent/fluentd:v1.8-1
MAINTAINER YOUR_NAME <bc@beckonconn.com>

USER root

RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 # cutomize following instruction as you wish
 && sudo gem install fluent-plugin-sumologic \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

RUN groupadd -r fluent && useradd -r -g fluent fluent \
    # for log storage (maybe shared with host)
    && mkdir -p /fluentd/log \
    # configuration/plugins path (default: copied from .)
    && mkdir -p /fluentd/etc /fluentd/plugins \
    && chown -R fluent /fluentd && chgrp -R fluent /fluentd

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

USER fluent

ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
