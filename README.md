# cdnjs-workspace

Use docker to pack our working environment, based on Ubuntu 18.04 (Bionic Beaver).

## Table of Contents

- [Note](#note)
- [Usage](#usage)
  - [For the first time setup](#for-the-first-time-setup)
    - [Get workspace docker image](#get-workspace-docker-image)
      - [Download and load pre-built image](#download-and-load-pre-built-image)
      - [Build image from scratch](#build-image-from-scratch)
    - [Create container from image](#create-container-from-image)
    - [Setup git user info](#setup-git-user-info)
    - [Setup your own remote on each repositories, start hacking!](#setup-your-own-remote-on-each-repositories-start-hacking)
  - [For future usage](#for-future-usage)
    - [Make sure the container started](#make-sure-the-container-started)
    - [Enter into the container](#enter-into-the-container)
    - [Go to the working directory, start hacking!](#go-to-the-working-directory-start-hacking)

## Note

This docker environment will prepare the common repositories we need to work with CDNJS project, please note that due to the repository disk space use issue, a full cloned and checkouted cdnjs main repository will use more than 88 GB disk space, so we use a shallow cloned cdnjs main repository with sparseCheckout enabled.

## Usage

### For the first time setup

#### Get workspace docker image

You can download the image we built then load it, or build your own.

##### Download and load pre-built image

It'll take about 5 mins to load the docker images, it depends on your hardware performance, please get a cup of tea or coffee during the load process.

```sh
$ wget https://cdnjs.peterdavehello.org/cdnjs-workspace-docker.txz
$ docker load --input cdnjs-workspace-docker.txz
```

or

##### Build image from scratch

```sh
$ docker build -t cdnjs-workspace .
```

#### Create container from image

```sh
$ docker run --hostname cdnjs-workspace -it cdnjs-workspace --name cdnjs-workspace bash
```

#### Setup git user info

```sh
$ git config --global user.name  "User"
$ git config --global user.email "User@github.com"
```

#### Setup your own remote on each repositories, start hacking!

```
cdnjs-workspace / # cd ~/cdnjs/
cdnjs-workspace ~/cdnjs # ls
atom-extension/  autoupdate/  bot/  buildScript/  cdnjs/  cdnjs-drone-ci/  cdnjs-importer/  new-website/  script/  tutorials/  workspace/
```

### For future usage

#### Make sure the container started

```sh
$ docker start cdnjs-workspace
```

#### Enter into the container

```sh
$ docker exec -it cdnjs-workspace bash
```

#### Go to the working directory, start hacking!

```
cdnjs-workspace / # cd ~/cdnjs/
cdnjs-workspace ~/cdnjs # ls
atom-extension/  autoupdate/  bot/  buildScript/  cdnjs/  cdnjs-drone-ci/  cdnjs-importer/  new-website/  script/  tutorials/  workspace/
```
