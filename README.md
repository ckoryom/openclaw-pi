# Ubuntu + Node 22 Dockerfile (Raspberry Pi 3 / armv7)

This repository provides a `Dockerfile` that uses a stable Ubuntu base and installs Node 22. It is written so you can build and publish an image that will run on a Raspberry Pi 3 (armv7). The Dockerfile defaults to an interactive shell so you can attach and develop inside the container.

**Quick file list**
- `Dockerfile`: Ubuntu base + Node 22 installation
- `.dockerignore`: common ignores

**Build & push (from an x86 host, cross-build for armv7)**

1. Register QEMU emulation (one-time on build host):

```bash
# Use one of these to register qemu handlers so buildx can cross-build
docker run --rm --privileged tonistiigi/binfmt:latest --install all
# OR
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

2. Create and bootstrap a buildx builder (if you don't already have one):

```bash
docker buildx create --name mybuilder --driver docker-container --use
docker buildx inspect --bootstrap
```

3. Build and push for Raspberry Pi 3 (armv7):

```bash
# Replace registry.example.com/youruser/imagename:tag with your registry
docker buildx build --platform linux/arm/v7 -t registry.example.com/youruser/imagename:tag --push .
```

Notes:
- `--platform linux/arm/v7` targets Raspberry Pi 3 (armv7l). Adjust if you need `arm64`.
- `--push` sends the image directly to the registry. If you want to test locally on the build machine, you can use `--load` instead of `--push` (but `--load` only supports single-platform builds and will load into the local daemon).

**Build & run directly on Raspberry Pi 3**

If you have Docker on the Pi, you can build on-device (slower but straightforward):

```bash
docker build -t mynode-ubuntu:latest .
docker run -it --rm --name node-ubuntu -v "$PWD":/app -w /app mynode-ubuntu:latest
```

To attach to the running container from another shell:

```bash
docker exec -it node-ubuntu bash
```

**Verify Node**

Inside the container run:

```bash
node -v   # should show v22.x
npm -v
```

**Tips & security**
- The image creates a non-root user `nodeuser` and starts as that user for safer development.
- For production images, consider using a smaller base (e.g., `debian:slim`) or multi-stage builds to reduce image size.

If you want, I can also add a GitHub Actions workflow to automatically build and push multi-arch images to your registry.
