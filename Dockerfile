FROM scratch
MAINTAINER Nils Petzall <nils.petzall@gmail.com>

ARG repo
ARG build

LABEL hello-http-go.repo=${repo}
LABEL hello-http-go.build=${build}

ADD dist/linux_amd64/hello-http-go /
ENTRYPOINT ["/hello-http-go"]
