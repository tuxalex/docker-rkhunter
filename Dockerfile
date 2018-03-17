# PASO 1
FROM alpine:latest

ARG VERSIONRK=1.4.6
ARG VERSIONRKCORTA=1.4

COPY files/createversion.sh /root

WORKDIR /root

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache openssl bash wget && \
    rm /var/cache/apk/*

RUN wget "https://sourceforge.net/projects/rkhunter/files/latest/download?source=files" -O rkhunter-$VERSIONRK.tar.gz \
    && tar -xvf rkhunter-$VERSIONRK.tar.gz \
    && cd /root/rkhunter-$VERSIONRK \
    && mkdir -p /root/data/$VERSIONRKCORTA/i18n/$VERSIONRK \
    && echo $VERSIONRK > /root/data/rkhunter_latest.dat \
    && cp ./files/i18n/* /root/data/$VERSIONRKCORTA/i18n/$VERSIONRK/ \
    && cp ./files/mirrors.dat ./files/programs_bad.dat ./files/backdoorports.dat ./files/suspscan.dat /root/data/ \
    && /root/createversion.sh $VERSIONRK $VERSIONRKCORTA \
    && /root/rkhunter-$VERSIONRK/installer.sh --install

CMD rkhunter --versioncheck && rkhunter --update && rkhunter -c
