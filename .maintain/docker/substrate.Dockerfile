FROM docker.io/library/ubuntu:20.04

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.axia.image.authors="devops-team@axiacoin.network" \
	io.axia.image.vendor="AXIA Technologies" \
	io.axia.image.title="axia/substrate" \
	io.axia.image.description="Substrate: The platform for blockchain innovators." \
	io.axia.image.source="https://github.com/axia-tech/substrate/blob/${VCS_REF}/.maintain/docker/Dockerfile" \
	io.axia.image.revision="${VCS_REF}" \
	io.axia.image.created="${BUILD_DATE}" \
	io.axia.image.documentation="https://wiki.axiacoin.network/AXIA-Substrate"

# show backtraces
ENV RUST_BACKTRACE 1

# install tools and dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		libssl1.1 \
		ca-certificates \
		curl && \
# apt cleanup
	apt-get autoremove -y && \
	apt-get clean && \
	find /var/lib/apt/lists/ -type f -not -name lock -delete; \
# add user
	useradd -m -u 1000 -U -s /bin/sh -d /substrate substrate

# add substrate binary to docker image
COPY ./substrate /usr/local/bin

USER substrate

# check if executable works in this container
RUN /usr/local/bin/substrate --version

EXPOSE 30333 9933 9944
VOLUME ["/substrate"]

ENTRYPOINT ["/usr/local/bin/substrate"]
