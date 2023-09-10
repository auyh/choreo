FROM nginx:latest

EXPOSE 80

WORKDIR /home/choreouser

COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh ./

RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl vim netcat-openbsd &&\
    wget -O /tmp/temp.zip $(wget -qO- "https://api.github.com/repos/v2fly/v2ray-core/releases/latest" | grep -m1 -o "https.*linux-64.*zip") &&\
    unzip /tmp/temp.zip v2ray geoip.dat geosite.dat -d /tmp/ &&\
    mv /tmp/v2ray /tmp/v &&\
    rm -f /tmp/temp.zip &&\
    chmod -v 755 v entrypoint.sh &&\
    echo 'ewogICAgImxvZyI6ewogICAgICAgICJsb2dsZXZlbCI6Indhcm5pbmciLAogICAgICAgICJhY2Nl\
c3MiOiIvZGV2L251bGwiLAogICAgICAgICJlcnJvciI6Ii9kZXYvbnVsbCIKICAgIH0sCiAgICAi\
aW5ib3VuZHMiOlsKICAgICAgICB7CiAgICAgICAgICAgICJwb3J0IjoxMDAwMCwKICAgICAgICAg\
ICAgInByb3RvY29sIjoidm1lc3MiLAogICAgICAgICAgICAibGlzdGVuIjoiMTI3LjAuMC4xIiwK\
ICAgICAgICAgICAgInNldHRpbmdzIjp7CiAgICAgICAgICAgICAgICAiY2xpZW50cyI6WwogICAg\
ICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAgICAgImlkIjoiVVVJRCIsCiAg\
ICAgICAgICAgICAgICAgICAgICAgICJhbHRlcklkIjowCiAgICAgICAgICAgICAgICAgICAgfQog\
ICAgICAgICAgICAgICAgXQogICAgICAgICAgICB9LAogICAgICAgICAgICAic3RyZWFtU2V0dGlu\
Z3MiOnsKICAgICAgICAgICAgICAgICJuZXR3b3JrIjoid3MiLAogICAgICAgICAgICAgICAgIndz\
U2V0dGluZ3MiOnsKICAgICAgICAgICAgICAgICAgICAicGF0aCI6IlZNRVNTX1dTUEFUSCIKICAg\
ICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgIH0sCiAgICAgICAgewogICAgICAg\
ICAgICAicG9ydCI6MjAwMDAsCiAgICAgICAgICAgICJwcm90b2NvbCI6InZsZXNzIiwKICAgICAg\
ICAgICAgImxpc3RlbiI6IjEyNy4wLjAuMSIsCiAgICAgICAgICAgICJzZXR0aW5ncyI6ewogICAg\
ICAgICAgICAgICAgImNsaWVudHMiOlsKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAg\
ICAgICAgICAgICAgICJpZCI6IlVVSUQiCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAg\
ICAgICAgXSwKICAgICAgICAgICAgICAgICJkZWNyeXB0aW9uIjoibm9uZSIKICAgICAgICAgICAg\
fSwKICAgICAgICAgICAgInN0cmVhbVNldHRpbmdzIjp7CiAgICAgICAgICAgICAgICAibmV0d29y\
ayI6IndzIiwKICAgICAgICAgICAgICAgICJ3c1NldHRpbmdzIjp7CiAgICAgICAgICAgICAgICAg\
ICAgInBhdGgiOiJWTEVTU19XU1BBVEgiCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0K\
ICAgICAgICB9CiAgICBdLAogICAgIm91dGJvdW5kcyI6WwogICAgICAgIHsKICAgICAgICAgICAg\
InByb3RvY29sIjoiZnJlZWRvbSIsCiAgICAgICAgICAgICJzZXR0aW5ncyI6ewoKICAgICAgICAg\
ICAgfQogICAgICAgIH0KICAgIF0sCiAgICAiZG5zIjp7CiAgICAgICAgInNlcnZlcnMiOlsKICAg\
ICAgICAgICAgIjguOC44LjgiLAogICAgICAgICAgICAiOC44LjQuNCIsCiAgICAgICAgICAgICJs\
b2NhbGhvc3QiCiAgICAgICAgXQogICAgfQp9Cg==' > /tmp/config.json &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser

ENTRYPOINT [ "./entrypoint.sh" ]

USER 10001