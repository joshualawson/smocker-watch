FROM thiht/smocker

RUN apk update --no-cache \
  && apk add curl inotify-tools

COPY ./entrypoint.sh /opt

WORKDIR /opt

ENTRYPOINT [ "./entrypoint.sh" ]