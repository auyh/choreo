FROM debian:latest

EXPOSE 80

WORKDIR /home/choreouser

# COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh ./

RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl vim netcat-openbsd &&\
    wget -O temp.zip $(wget -qO- "https://api.github.com/repos/v2fly/v2ray-core/releases/latest" | grep -m1 -o "https.*linux-64.*zip") &&\
    unzip temp.zip v2ray geoip.dat geosite.dat &&\
    mv v2ray v &&\
    rm -f temp.zip &&\
    chmod -v 755 v entrypoint.sh &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser

ENTRYPOINT [ "./entrypoint.sh" ]

USER 10001
