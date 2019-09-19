# imhshekhar47/centos-jre8:latest

## Build
```bash
cd $IMAGES_DIR
./build.sh core/hs-centos-jre8
```

### Run
```bash
docker run --rm -it \
    --name=centos \
    imhshekhar47/centos-jre8:latest
```