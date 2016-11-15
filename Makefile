APP									= hello-http-go
REPO								= npetzall/hello-http-go
VERSION 						?= HEAD
BUILD               ?= $(shell git rev-parse --short=8 HEAD)

PLATFORMS           = linux_amd64 linux_arm darwin_amd64

FLAGS_all = CGO_ENABLED=0

FLAGS_linux_amd64   = $(FLAGS_all) GOOS=linux GOARCH=amd64
FLAGS_linux_arm     = $(FLAGS_all) GOOS=linux GOARCH=arm
FLAGS_darwin_amd64  = $(FLAGS_all) GOOS=darwin GOARCH=amd64


msg=@printf "\n\033[0;01m>>> %s\033[0m\n" $1

.DEFAULT_GOAL := build

build:
	$(call msg,"Build binary")
	$(FLAGS_all) go build -ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}" -o bin/hello-http-go .
	./bin/hello-http-go -version
.PHONY: build

test:
	$(call msg,"Run tests")
	go test -v ./...
.PHONY: test

clean:
	$(call msg,"Clean directory")
	rm -rf bin
	rm -rf dist
.PHONY: clean

build-all: $(foreach PLATFORM,$(PLATFORMS),dist/$(PLATFORM)/hello-http-go)
.PHONY: build-all

dist: notHEAD build-all \
$(foreach PLATFORM,$(PLATFORMS),dist/hello-http-go-$(VERSION)-$(PLATFORM).tar.gz)
.PHONY:	dist

dist/%/hello-http-go:
	$(call msg,"Build binary for $*")
	rm -f $@
	mkdir -p $(dir $@)
	$(FLAGS_$*) go build -ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}" -o dist/$*/hello-http-go .

dist/hello-http-go-$(VERSION)-%.tar.gz: notHEAD
	$(call msg,"Create TAR for $*")
	rm -f $@
	mkdir -p $(dir $@)
	tar czf $@ -C dist/$* .

notHEAD:
	@ if [ "$(VERSION)" = "HEAD" ]; then \
	 		echo "Not allowed with VERSION == HEAD"; \
			exit 1; \
		fi

docker-build: dist/linux_amd64/hello-http-go
	$(call msg,"Building docker image")
	docker build -f Dockerfile -t ${REPO}:${BUILD} --build-arg repo=${REPO} --build-arg build=${BUILD} .
.PHONY: docker-build

docker-push: docker-build
	$(call msg, "Pushing docker image")
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
	docker tag ${REPO}:${BUILD} ${REPO}:${VERSION}
	docker push ${REPO}:${VERSION}
.PHONY: docker-push

docker-push-release: docker-build
	$(call msg, "Pushing docker release image")
	docker tag ${REPO}:${BUILD} ${REPO}:latest
	docker push ${REPO}:latest
.PHONY: docker-push-release
