# rtmp-nginx-ultimate
Multi-platform streaming container based soluton


[**Docker**](https://www.docker.com/) image with [**Nginx**](http://nginx.org/en/)
using the [**nginx-rtmp-module**](https://github.com/arut/nginx-rtmp-module)
module for streaming and [**Stunnel**](https://www.stunnel.org/) to add TLS encryption functionality.


## Description

This [**Docker**](https://www.docker.com/) image can be used to create an RTMP server for multimedia / video 
streaming using [**Nginx**](http://nginx.org/en/), [**nginx-rtmp-module**](https://github.com/arut/nginx-rtmp-module) 
and [**Stunnel**](https://www.stunnel.org/),
built from the current latest sources (Nginx 1.18.0 , nginx-rtmp-module 1.2.1 and Stunnel 4).

This was inspired by other similar previous images from [thiagoeolima](https://hub.docker.com/r/thiagoeolima/nginx-rtmps),
[dvdgiessen](https://hub.docker.com/r/dvdgiessen/nginx-rtmp-docker/), 
[jasonrivers](https://hub.docker.com/r/jasonrivers/nginx-rtmp/), 
[aevumdecessus](https://hub.docker.com/r/aevumdecessus/docker-nginx-rtmp/) and by an 
[OBS Studio post](https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/).

The main motivation was to do streaming to multiple platform at same time from [**OBS Studio**](https://obsproject.com/).

**GitHub repo**: <https://github.com/cloudsteak/rtmp-nginx-ultimate>

**Docker Hub image**: <????>

## Details

## How to use

* For the simplest case, just run a container with this image:

```bash
docker run -d -p 1935:1935 --name dj-nginx-rtmps cloudsteak/rtmp-nginx-ultimate
```

* Facebook & Restream & Own Srtream Server (Ant Media)

```bash
docker run -d -p 1935:1935 -e FACEBOOK_KEY=<key> -e RESTREAM_KEY=<key> -e STREAMSERVER_KEY=<key> --name dj-nginx-rtmps cloudsteak/rtmp-nginx-ultimate
```

* Facebook and Youtube:

```bash
docker run -d -p 1935:1935 -e FACEBOOK_KEY=<key> -e YOUTUBE_KEY=<key> --name dj-nginx-rtmps cloudsteak/rtmp-nginx-ultimate
```

* OBS

```bash
rtmp://localhost:1935/live
```

* Instagram:

```bash
docker run -d -p 1935:1935 -e INSTAGRAM_KEY=<key> --name dj-nginx-rtmps cloudsteak/rtmp-nginx-ultimate
```

* OBS

```bash
rtmp://localhost:1935/instagram
```


## How to test with OBS Studio

* Run a container with the command above


* Open [OBS Studio](https://obsproject.com/)
* Click the "Settings" button
* Go to the "Stream" section
* In "Stream Type" select "Custom Streaming Server"
* In the "URL" enter the `rtmp://<ip_of_host>/live` replacing `<ip_of_host>` with the IP of the host in which the container is running. For example: `rtmp://192.168.0.30/live`
* In the "Stream key" use a "key" that will be used later in the client URL to display that specific stream. For example: `test`
* Click the "OK" button
* In the section "Sources" click de "Add" button (`+`) and select a source (for example "Screen Capture") and configure it as you need
* Click the "Start Streaming" button

## Debugging

If something is not working you can check the logs of the container with:

```bash
docker logs dj-nginx-rtmps
```

## Extending

If you need to modify the configurations you can create a file `nginx.conf` and replace the one in this image using a `Dockerfile` that is based on the image, for example:

```Dockerfile
FROM cloudsteak/rtmp-nginx-ultimate

COPY nginx.conf /etc/nginx/nginx.conf
```

The current `nginx.conf` contains:

```Nginx
worker_processes auto;
rtmp_auto_push on;
rtmp_auto_push_reconnect 1s;
events {}
rtmp {
    server {
        listen 1935;
        listen [::]:1935 ipv6only=on;
        chunk_size 4096;

        application live {
            live on;
            record off;
	    #push rtmp://a.rtmp.youtube.com/live2/<key>;
	    #push rtmp://127.0.0.1:19350/rtmp/<key>;
        }
        
        application instagram {
            live on;
            record off;
            #push rtmp://127.0.0.1:19351/rtmp/<key>;
        }

    }

}
```



# Hints for stream urls:
* Azure Media Services: push rtmp://<event>.channel.media.azure.net:1935 app=live/<key>;
* Restream: push rtmp://live.restream.io/live/<key>;
* StreamServer: push rtmp://stream.djsipp.hu/LiveApp/<key>;
* Facebook - DJ Sipp: push 'rtmp://127.0.0.1:19350/rtmp/<key1>?s_bl=1&s_ps=1&s_psm=1&s_sw=0&s_vt=api-s&a=<key2>';