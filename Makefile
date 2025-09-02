.PHONY: all build clean

all: build

build:
	buildah unshare ./buildah-script.sh

clean:
	buildah rmi helloc
