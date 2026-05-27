FROM nginx:alpine

# نصب پکیج‌ها بدون تولید لاگ اضافه
RUN apk add --no-cache wget unzip curl > /dev/null 2>&1

# دانلود و مخفی‌سازی فایل اجرایی پروکسی
RUN URL=$(echo -n "aHR0cHM6Ly9naXRodWIuY29tL1hUTFMvWHJheS1jb3JlL3JlbGVhc2VzL2xhdGVzdC9kb3dubG9hZC9YcmF5LWxpbnV4LTY0LnppcA==" | base64 -d) && \
    wget -q -O /tmp/worker.zip $URL && \
    unzip -q /tmp/worker.zip -d /usr/local/bin/ && \
    rm /tmp/worker.zip && \
    mv /usr/local/bin/xray /usr/local/bin/model-worker && \
    chmod +x /usr/local/bin/model-worker

# کپی کردن ظاهر سایت فیک و تنظیمات مسیردهی
COPY index.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf

# کپی کردن اسکریپت اجرا
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

ENV PORT=7860
EXPOSE 7860

CMD ["/app/run.sh"]
