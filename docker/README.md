# Substrate Builder Docker Image

The Docker image in this folder is a `builder` image. It is self contained and allow users to build the binaries themselves.
There is no requirement on having Rust or any other toolchain installed but a working Docker environment.

Unlike the `axia/axia` image which contains a single binary (`axia`!) used by default, the image in this folder builds and contains several binaries and you need to provide the name of the binary to be called.

You should refer to the .Dockerfile for the actual list. At the time of editing, the list of included binaries is:

- substrate
- subkey
- node-template
- chain-spec-builder

The image can be used by passing the selected binary followed by the appropriate tags for this binary.

Your best guess to get started is to pass the `--help flag`. Here are a few examples:

- `docker run --rm -it axia/substrate substrate --version`
- `docker run --rm -it axia/substrate subkey --help`
- `docker run --rm -it axia/substrate node-template --version`
- `docker run --rm -it axia/substrate chain-spec-builder --help`
