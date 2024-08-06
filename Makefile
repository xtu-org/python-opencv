.PHONY: run build login push latest test save

CV ?= 4.10.0
DIST ?= fedora
WORKDIR=/mnt/$$(basename $$(pwd))
ORG=xtu-org
REPO=python-opencv

run: build test login push

build:
	docker build --build-arg OPENCV_VERSION=$(CV) -t ccr.ccs.tencentyun.com/$(ORG)/$(REPO):$(CV)-$(DIST) ./$(DIST)

push:
	@docker push ccr.ccs.tencentyun.com/$(ORG)/$(REPO):$(CV)-$(DIST)

latest:
	@docker pull ccr.ccs.tencentyun.com/$(ORG)/$(REPO):$(CV)-$(DIST)
	@docker tag ccr.ccs.tencentyun.com/$(ORG)/$(REPO):$(CV)-$(DIST) ccr.ccs.tencentyun.com/$(ORG)/$(REPO):latest
	@docker push ccr.ccs.tencentyun.com/$(ORG)/$(REPO):latest

test:
	@docker run --rm -v $$(pwd):$(WORKDIR) -w $(WORKDIR) ccr.ccs.tencentyun.com/$(ORG)/$(REPO):$(CV)-$(DIST) python3 test.py

save:
	@docker save ccr.ccs.tencentyun.com/$(ORG)/$(REPO):$(CV)-$(DIST) | gzip > ccr.ccs.tencentyun.com/$(ORG)_$(REPO)_$(CV)-$(DIST).tar.gz
