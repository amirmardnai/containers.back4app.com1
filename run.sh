#!/bin/sh

if [ -z "$UUID" ]; then
  UUID="90cd4a77-141a-43c9-991b-08263cfe9c10"
fi

# کانفیگ پروکسی VLESS مخفی شده (روی پورت 8081 داخلی گوش می‌دهد)
B64="ewogICJsb2ciOiB7ImxvZ2xldmVsIjogIndhcm5pbmcifSwKICAiaW5ib3VuZHMiOiBbewogICAgInBvcnQiOiA4MDgxLAogICAgInByb3RvY29sIjogInZsZXNzIiwKICAgICJzZXR0aW5ncyI6IHsKICAgICAgImNsaWVudHMiOiBbeyJpZCI6ICJSRVBMQUNFX1VVSUQiLCAibGV2ZWwiOiAwfV0sCiAgICAgICJkZWNyeXB0aW9uIjogIm5vbmUiCiAgICB9LAogICAgInN0cmVhbVNldHRpbmdzIjogewogICAgICAibmV0d29yayI6ICJ3cyIsCiAgICAgICJ3c1NldHRpbmdzIjogeyJwYXRoIjogIi9hcGkvdjEvc3RyZWFtIn0KICAgIH0KICB9XSwKICAib3V0Ym91bmRzIjogW3sicHJvdG9jb2wiOiAiZnJlZWRvbSJ9XQp9"

# تولید کانفیگ
echo "$B64" | base64 -d > /tmp/cfg_tmpl.json
sed -e "s/REPLACE_UUID/${UUID}/g" /tmp/cfg_tmpl.json > /etc/model-worker.json

# اجرای پروکسی مخفی در پس‌زمینه
/usr/local/bin/model-worker -config /etc/model-worker.json &

# اجرای NGINX به عنوان سرور اصلی روی پورت 7860
echo "Starting AI Model Backend Server..."
nginx -g "daemon off;"
