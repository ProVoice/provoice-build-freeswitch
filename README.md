# provoice-build-freeswitch
ProVoice packages build environment for FreeSWITCH using Docker

## About

This project aims to make reproducable Debian packages of FreeSWITCH for Ubuntu 24.04 LTS by using Docker. We have chosen to use upstream MySQL packages instead of the default packages in the Ubuntu repository. Feel free to remove these lines in the Dockerfile if that would fit your environment better. Create an empty directory for the packages and run the container to build the Debian packages.

In this build we are removing the Cluecon advertisements from the CLI. Version numbers for the packages have to be set through environmental variables while running the Docker container.

FreeSWITCH is part of the [ProVoice platform](https://provoice.eu).

## Building the packages

1. Clone the repository, initialize the Git submodules and build the Docker image
```bash
git clone https://github.com/ProVoice/provoice-build-freeswitch.git
cd provoice-build-freeswitch
git submodule init
git submodule update --remote
( cd freeswitch; git checkout v1.10.12 )
( cd freeswitch-sounds; git checkout master )
( cd sofia-sip; git checkout v1.13.17 )
( cd spandsp; git checkout master )
sudo docker build -t provoice-build-freeswitch .
```
2. Create a directory for the packages
```bash
mkdir packages
```
3. Run the container to build the packages
```bash
sudo docker run -it \
 --rm \
 -v `pwd`/packages:/app/packages \
 -v `pwd`/patches:/app/patches \
 -e FREESWITCH_VERSION='1.10.12' \
 -e SOFIASIP_VERSION='1.13.17' \
 -e SPANDSP_VERSION='3.0.0' \
 -e FSSOUNDS_VERSION='1.0.53' \
 -e FSSOUNDS_VERSION_CALLIE='1.0.53' \
 -e FSSOUNDS_VERSION_ALLISON='1.0.2' \
 -e FSSOUNDS_VERSION_JUNE='1.0.51' \
provoice-build-freeswitch
```
The packages and source files should now be in the `packages` directory and ready to install on Ubuntu 24.04 LTS.

Note: in order to get AMR support (bring your own licensing) in FreeSWITCH you need to install the libraries included in Ubuntu and copy them to the AMR modules source directories, right before bootstrapping and building the FreeSWITCH packages.

```
...

apt install libvo-amrwbenc0 libvo-amrwbenc-dev libopencore-amrwb0 libopencore-amrwb-dev libopencore-amrnb0 libopencore-amrnb-dev

# Copy over AMR files

RUN cp /usr/include/opencore-amrnb/interf_enc.h src/mod/codecs/mod_amr/
RUN cp /usr/include/opencore-amrnb/interf_dec.h src/mod/codecs/mod_amr/
RUN cp /usr/include/opencore-amrwb/dec_if.h  src/mod/codecs/mod_amrwb/
RUN cp /usr/include/vo-amrwbenc/enc_if.h src/mod/codecs/mod_amrwb/

# Bootstrap FreeSWITCH Debian files
( cd debian && ./bootstrap.sh )

...
```
