UHD_REPO    ?= https://github.com/EttusResearch/uhd.git
UHD_VERSION ?= v4.10.0.0
BUILD_DIR   ?= uhd

PATCHES := $(sort $(wildcard *.patch))

.PHONY: all patch clean

all: patch

$(BUILD_DIR):
	git clone $(UHD_REPO) $(BUILD_DIR)
	cd $(BUILD_DIR) && git checkout $(UHD_VERSION)

patch: $(BUILD_DIR)
	cd $(BUILD_DIR) && git am $(addprefix $(CURDIR)/,$(PATCHES))

clean:
	rm -rf $(BUILD_DIR)
