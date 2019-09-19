# imhshekhar47/debian-jre8:latest

## Build
```bash
cd $IMAGES_DIR
./build.sh core/hs-debian-jre8
```

### Run
```bash
docker run --rm -it \
    --name=debian \
    imhshekhar47/debian-jre8:latest
```