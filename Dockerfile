FROM <YourAwsAccountIdHere>.dkr.ecr.eu-west-1.amazonaws.com/alpine:3.19.1

LABEL container.name="alpine-nginx:1.0.0"
LABEL Description="Alpine with nginx"

RUN LAYER=updates \
    && apk update \
    && apk upgrade

# Timezone
ENV TIMEZONE Europe/Bucharest

RUN	LAYER=Install_Nginx && \
	apk add --update nginx && \
	apk add --update tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	mkdir /etc/nginx/certificates && \
	mkdir /www && \
	apk del tzdata && \
	rm -rf /var/cache/apk/*

COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY etc/conf.d/default.conf /etc/nginx/conf.d/default.conf

ADD www/index.html /www/index.html

## File from remote url: https://raw.githubusercontent.com/knyar/nginx-lua-prometheus/0.1-20170610/prometheus.lua (md5sum 7130a22fbe8b1712b1f0189706b31132)
# ADD https://raw.githubusercontent.com/knyar/nginx-lua-prometheus/0.1-20170610/prometheus.lua /usr/local/myapp/remote_files/

# Expose ports
EXPOSE 80

# Entry point
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
