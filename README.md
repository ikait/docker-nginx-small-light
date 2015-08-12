[![Circle CI](https://circleci.com/gh/ikait/docker-nginx_small_light/tree/dev.svg?style=badge)](https://circleci.com/gh/ikait/docker-nginx_small_light/tree/dev)

# docker-nginx_small_light

Dockerfile for nginx container with [ngx_small_light](https://github.com/cubicdaiya/ngx_small_light).

## Usage

1. Clone this.
2. Confirm nginx.conf. In particular, editing `proxy_pass` directive is required.
3. Run  
```
  $ docker run --rm -p 80:80 ikai/nginx_small_light
```

## URL

### Raw image

    http://<S3_BUCKET_URL>/image.jpg

### via Reverse Proxy

    http://<YOUR_HOST>/image.jpg

### Converted image

    http://<YOUR_HOST>/small_light(q=50,of=jpeg,dw=300)/image.jpg
