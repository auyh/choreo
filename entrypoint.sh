#!/usr/bin/env bash

# 生成配置文件
cat > /tmp/config <<EOF
ewogICAgImxvZyI6ewogICAgICAgICJsb2dsZXZlbCI6Indhcm5pbmciLAogICAgICAgICJhY2Nl
c3MiOiIvZGV2L251bGwiLAogICAgICAgICJlcnJvciI6Ii9kZXYvbnVsbCIKICAgIH0sCiAgICAi
aW5ib3VuZHMiOlsKICAgICAgICB7CiAgICAgICAgICAgICJwb3J0IjoxMDAwMCwKICAgICAgICAg
ICAgInByb3RvY29sIjoidm1lc3MiLAogICAgICAgICAgICAibGlzdGVuIjoiMC4wLjAuMCIsCiAg
ICAgICAgICAgICJzZXR0aW5ncyI6ewogICAgICAgICAgICAgICAgImNsaWVudHMiOlsKICAgICAg
ICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgICJpZCI6IlVVSUQiLAogICAg
ICAgICAgICAgICAgICAgICAgICAiYWx0ZXJJZCI6MAogICAgICAgICAgICAgICAgICAgIH0KICAg
ICAgICAgICAgICAgIF0KICAgICAgICAgICAgfSwKICAgICAgICAgICAgInN0cmVhbVNldHRpbmdz
Ijp7CiAgICAgICAgICAgICAgICAibmV0d29yayI6IndzIiwKICAgICAgICAgICAgICAgICJ3c1Nl
dHRpbmdzIjp7CiAgICAgICAgICAgICAgICAgICAgInBhdGgiOiIvdm1lc3MiCiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInBv
cnQiOjIwMDAwLAogICAgICAgICAgICAicHJvdG9jb2wiOiJ2bGVzcyIsCiAgICAgICAgICAgICJs
aXN0ZW4iOiIwLjAuMC4wIiwKICAgICAgICAgICAgInNldHRpbmdzIjp7CiAgICAgICAgICAgICAg
ICAiY2xpZW50cyI6WwogICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAg
ICAgImlkIjoiVVVJRCIKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBdLAog
ICAgICAgICAgICAgICAgImRlY3J5cHRpb24iOiJub25lIgogICAgICAgICAgICB9LAogICAgICAg
ICAgICAic3RyZWFtU2V0dGluZ3MiOnsKICAgICAgICAgICAgICAgICJuZXR3b3JrIjoid3MiLAog
ICAgICAgICAgICAgICAgIndzU2V0dGluZ3MiOnsKICAgICAgICAgICAgICAgICAgICAicGF0aCI6
Ii92bGVzcyIKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgfQogICAgICAgIH0KICAgIF0s
CiAgICAib3V0Ym91bmRzIjpbCiAgICAgICAgewogICAgICAgICAgICAicHJvdG9jb2wiOiJmcmVl
ZG9tIiwKICAgICAgICAgICAgInNldHRpbmdzIjp7CgogICAgICAgICAgICB9CiAgICAgICAgfQog
ICAgXSwKICAgICJkbnMiOnsKICAgICAgICAic2VydmVycyI6WwogICAgICAgICAgICAiOC44Ljgu
OCIsCiAgICAgICAgICAgICI4LjguNC40IiwKICAgICAgICAgICAgImxvY2FsaG9zdCIKICAgICAg
ICBdCiAgICB9Cn0KCg==
EOF

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
base64 -d /tmp/config > /tmp/config.json
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
VMESS_WSPATH=${VMESS_WSPATH:-'/vmess'}
VLESS_WSPATH=${VLESS_WSPATH:-'/vless'}
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g" /tmp/config.json

# 伪装 v2ray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
cp v /tmp/${RELEASE_RANDOMNESS}
base64 /tmp/config.json > /tmp/config

# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
if [ -n "${NEZHA_SERVER}" ] && [ -n "${NEZHA_PORT}" ] && [ -n "${NEZHA_KEY}" ]; then
  TLS=${NEZHA_TLS:+'--tls'}
  wget -O /tmp/nezha-agent.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").zip
  unzip /tmp/nezha-agent.zip -d /tmp
  chmod +x /tmp/nezha-agent
  rm -f /tmp/nezha-agent.zip
  nohup /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${TLS} 2>&1 &
fi

# 运行 nginx 和 v2ray
nginx
base64 -d /tmp/config > /tmp/config.json
/tmp/${RELEASE_RANDOMNESS} run -c /tmp/config.json
