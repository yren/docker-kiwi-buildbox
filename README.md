# docker-kiwi-buildbox

### build box base
* Docker-build-box-base is an image to install dependent tools, such as git, jdk, m4
* remake (GNU Make 3.82+dbg0.9) is more debugable than GNU MAKE. (https://github.com/rocky/remake/wiki/Installing)

```
docker build --rm -t yren/kiwi-buildbox-base .
docker tag yren/kiwi-buildbox-base yren/kiwi-buildbox-base:0.1
docker push yren/kiwi-buildbox-base:0.1
```

### build box
```
docker build --rm -t yren/kiwi-buildbox .
docker tag yren/kiwi-buildbox yren/kiwi-buildbox:0.1
docker push yren/kiwi-buildbox:0.1
```