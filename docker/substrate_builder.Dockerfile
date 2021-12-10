# This is the build stage for Substrate. Here we create the binary.
FROM docker.io/axiatech/ci-linux:production as builder

WORKDIR /substrate
COPY . /substrate
RUN cargo build --locked --release

# This is the 2nd stage: a very small image where we copy the Substrate binary."
FROM docker.io/library/ubuntu:20.04
LABEL description="Multistage Docker image for Substrate: a platform for web3" \
	io.axia.image.type="builder" \
	io.axia.image.authors="chevdor@gmail.com, devops-team@axiacoin.network" \
	io.axia.image.vendor="AXIA Technologies" \
	io.axia.image.description="Substrate is a next-generation framework for blockchain innovation 🚀" \
	io.axia.image.source="https://github.com/axiatech/axia/blob/${VCS_REF}/docker/substrate_builder.Dockerfile" \
	io.axia.image.documentation="https://github.com/axiatech/axia/"

COPY --from=builder /substrate/target/release/substrate /usr/local/bin
COPY --from=builder /substrate/target/release/subkey /usr/local/bin
COPY --from=builder /substrate/target/release/node-template /usr/local/bin
COPY --from=builder /substrate/target/release/chain-spec-builder /usr/local/bin

RUN useradd -m -u 1000 -U -s /bin/sh -d /substrate substrate && \
	mkdir -p /data /substrate/.local/share/substrate && \
	chown -R substrate:substrate /data && \
	ln -s /data /substrate/.local/share/substrate && \
# unclutter and minimize the attack surface
	rm -rf /usr/bin /usr/sbin && \
# Sanity checks
	ldd /usr/local/bin/substrate && \
	/usr/local/bin/substrate --version

USER substrate
EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]
