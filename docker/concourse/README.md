Docker images used for concourse-web and concourse-worker as part of [rehab.earth](https://github.com/Klazomenai/rehab.earth)

Docker hub images: [docker/klazomenai/concourse.rehab.earth/](https://hub.docker.com/r/klazomenai/concourse.rehab.earth/)

To update the image:
```sh
docker login
docker build -t klazomenai/concourse.rehab.earth:latest .
docker push klazomenai/concourse.rehab.earth:latest
```
