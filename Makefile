UHD_REPO    ?= git@gitlab.home.lan:yuriy/uhd.git
UHD_VERSION ?= v4.10.0.0
BUILD_DIR   ?= uhd
GIT_EMAIL   ?= $(shell git config user.email 2>/dev/null || echo "crimea82@protonmail.com")
GIT_NAME    ?= $(shell git config user.name 2>/dev/null || echo "yuriy")

PATCHES := $(sort $(wildcard *.patch))

.PHONY: all patch clean

all: patch

$(BUILD_DIR):
	git clone $(UHD_REPO) $(BUILD_DIR)
	cd $(BUILD_DIR) && git checkout $(UHD_VERSION)
	cd $(BUILD_DIR) && git config user.email "$(GIT_EMAIL)" && git config user.name "$(GIT_NAME)"

patch: $(BUILD_DIR)
	cd $(BUILD_DIR) && git am $(addprefix $(CURDIR)/,$(PATCHES))

clean:
	rm -rf $(BUILD_DIR)
