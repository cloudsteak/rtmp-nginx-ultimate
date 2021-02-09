#!/bin/bash

set -e

NGINX_TEMPLATE=/etc/nginx/nginx.conf.template
NGINX_CONF=/etc/nginx/nginx.conf 
ENV_OK=0

if [ -n "${YOUTUBE_KEY}" ]; then
	echo "Youtube activate."
	sed -i 's|#youtube|push '"$YOUTUBE_URL"'${YOUTUBE_KEY};|g' $NGINX_TEMPLATE
	ENV_OK=1
else
	sed -i 's|#youtube| |g' $NGINX_TEMPLATE
fi

if [ -n "${FACEBOOK_KEY}" ]; then
	echo "Facebook activate."
	sed -i 's|#facebook|push '"$FACEBOOK_URL"'${FACEBOOK_KEY};|g' $NGINX_TEMPLATE
	ENV_OK=1
else 
	sed -i 's|#facebook| |g' $NGINX_TEMPLATE
fi

if [ -n "${INSTAGRAM_KEY}" ]; then
	echo "Instagram activate."
	sed -i 's|#instagram|push '"$INSTAGRAM_URL"'${INSTAGRAM_KEY};|g' $NGINX_TEMPLATE
	ENV_OK=1
else 
	sed -i 's|#instagram| |g' $NGINX_TEMPLATE
fi

if [ -n "${RESTREAM_KEY}" ]; then
	echo "Restream activate."
	sed -i 's|#restream|push '"$RESTREAM_URL"'${RESTREAM_KEY};|g' $NGINX_TEMPLATE
	ENV_OK=1
else 
	sed -i 's|#restream| |g' $NGINX_TEMPLATE
fi

if [ -n "${STREAMSERVER_KEY}" ]; then
	echo "Streamserver activate."
	sed -i 's|#streamserver|push '"$STREAMSERVER_URL"'${STREAMSERVER_KEY};|g' $NGINX_TEMPLATE
	ENV_OK=1
else 
	sed -i 's|#streamserver| |g' $NGINX_TEMPLATE
fi

if [ $ENV_OK -eq 1 ]; then
    envsubst < $NGINX_TEMPLATE > $NGINX_CONF
else 
	echo "Start local server."
fi

if [ -n "${DEBUG}" ]; then 
	echo $NGINX_CONF
	cat $NGINX_CONF
fi

stunnel4

exec "$@"
