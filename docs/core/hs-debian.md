# imhshekhar47/debian:latest

## Build
```bash
cd $IMAGES_DIR
./build.sh core/hs-debian
```

### Run
```bash
docker run --rm -it \
    --name=debian \
    imhshekhar47/debian:latest
```