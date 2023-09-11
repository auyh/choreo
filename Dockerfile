FROM debian:latest

EXPOSE 80

WORKDIR /home/choreouser

COPY entrypoint.sh ./

RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl vim netcat-openbsd &&\
    wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip &&\
    unzip temp.zip xray geoip.dat geosite.dat &&\
    mv xray x &&\
    rm -f temp.zip &&\
    chmod -v 755 x entrypoint.sh &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser

ENTRYPOINT [ "./entrypoint.sh" ]

USER 10001
