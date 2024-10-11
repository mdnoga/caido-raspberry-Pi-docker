# caido-raspberryPi-docker

Dockerfile to run Cadio CLI on RaspberryPi

The purpose of this is to run Caido-cli in a docker container on a Raspberry Pi. Then access it from other machine that we're doing our testing from, like a Kali VM and/or a Windows VM.

* Please note this a work in progress so some things may not work and I'm sure there are easier/better ways of doing some of this. 

### Get started

After cloning the dockerfile, build it
```bash
sudo docker build -t caido-rpi .
```

Spin up the container and expose the port. 
```bash
sudo docker run --rm -p 7000:8080 caido-rpi
```

Profit!!! (or, just have fun hacking things )

### Project Persistence 

Projects created in the Docker container are not saved between restarts.

Mount a volume (external drive plugged onto the Pi) to keep your data on and to avoid losing data between Caido updates and/or restarts.

```bash
sudo docker run -d \
    --restart always \
    --user root \
    -e NB_UID=1000 \
    -e NB_GID=1000 \
    -p 7000:8080 \
    --name caido-storage \
    -v /mnt:/root/.local/share/caido \
    caido-rpi
```

Having problems, check the docker logs

```bash
sudo docker logs --tail 50 --follow --timestamps {containerID}
```

Now that we have Caido running smoohtly in the docker container, we need to proxy traffic to it from what ever other machine your testing on. 

Proxy local to RPi
```bash
ssh -L 8080:127.0.0.1:8080 whiskey@192.168.1.126
```