NAME = gitlab-runner
VERSION = 0.0.1
VERSION_ALIASES =	0.0 0 latest
TITLE = GitLab Runner
DESCRIPTION = An image with cowsay
SOURCE_URL = https://github.com/tmaier/scaleway-gitlab-runner
VENDOR_URL = http://tobiasmaier.info/

IMAGE_VOLUME_SIZE = 50G
IMAGE_BOOTSCRIPT = stable
IMAGE_NAME = GitLab Runner (0.0)

## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
