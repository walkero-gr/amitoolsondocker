[![Build Status](https://drone-gh.intercube.gr/api/badges/walkero-gr/amitoolsondocker/status.svg)](https://drone-gh.intercube.gr/walkero-gr/amitoolsondocker)
[![Docker Pulls](https://img.shields.io/docker/pulls/walkero/amitoolsondocker?color=brightgreen)](https://hub.docker.com/r/walkero/amitoolsondocker)

# amitoolsondocker
amitoolsondocker is a docker image that includes amitools by Christian Vogelgsang (https://github.com/cnvogelg/amitools) and a basic installation of AROS 68k nightly build. The purpose of this project is to provide an out of the box solution for simple jobs, like changing file protection bits using vamos tool.

## AmigaOS 68k development image
The **amitoolsondocker:latest** image contains the following software:

| app               | version               | source
|-------------------|-----------------------|-----------------------------------|
| amitools          | v0.5.0                | https://github.com/cnvogelg/amitools
| AROS 68K          | 20200714-nightly      | http://www.aros.org


## How to create a docker container

To create a container based on one of these images, run in the terminal:

```bash
docker run -it --rm --name amitools -v "$PWD"/code:/opt/code -w /opt/code walkero/amitoolsondocker:latest /bin/bash
```

If you want to use it with **docker-compose**, you can create a *docker-compose.yml* file, with the following content:

```yaml
version: '3'

services:
  amitools:
    image: 'walkero/amitoolsondocker:latest'
    volumes:
      - './code:/opt/code'
```

And then you can create and get into the container by doing the following:
```bash
docker-compose up -d
docker-compose amitools exec bash
```

To compile your project you have to get into the container, inside the */opt/code/projectname* folder, which is shared with the host machine, and run the compilation.

## Use vamos with included AROS

To use vamos with the included AROS nightly version you have to do the following

```bash
# create and get into amitools container
docker run -it --rm --name amitools -v "$PWD"/code:/opt/code -w /opt/code walkero/amitoolsondocker:latest /bin/bash

# run protect command from the AROS installation using vamos to change the list command protection attributes
vamos -C 68020 -V aros:/home/aros -a C:aros:c -a Libs:aros:Libs C:Protect c:list ADD srwed
```
- `-C 68020` emulates a 68020 CPU
- `-V aros:/home/aros` creates a volume named `aros` which has the files from the folde `/home/aros`
- `-a C:aros:c` creates an assign `C` to `aros:c` folder
- `-a Libs:aros:Libs` creates an assign `Libs` to `aros:Libs` folder
- `C:Protect` is the 68K binary to execute and `c:list ADD srwed` are the command arguments

For more info on vamos tool, checkout the following section of Guides and Info

## Guides and info
* https://github.com/cnvogelg/amitools#contents
* http://lallafa.de/blog/amiga-projects/amitools/vamos/

## Bug reports or feature request
If you have any issues with the image or you need help on using it or you would like to request any new feature, please contact me by opening an issue at https://github.com/walkero-gr/amitoolsondocker/issues
