# imhshekhar47/centos:latest

## Build
```bash
cd $IMAGES_DIR
./build.sh core/hs-centos
```

### Run
```bash
docker run --rm -it \
    --name=centos \
    imhshekhar47/centos:latest
```