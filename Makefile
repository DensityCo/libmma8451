HASH := $(shell git rev-parse --short=10 HEAD)
OS := $(shell uname)
ARCH := $(shell uname -m)
ifeq ($(OS), Linux)
J := $(bc -l << "2*$(shell nproc --all")
endif

ifeq ($(OS), Darwin)
J := 8
#J := $(shell system_profiler | awk '/Number of CPUs/ {print $$4}{next;}')
endif

$(info building with $(J) threads)
SHELL := /bin/bash

BASE.DIR=$(PWD)
DOWNLOADS.DIR=$(BASE.DIR)/downloads
INSTALLED.HOST.DIR=$(BASE.DIR)/installed.host
INSTALLED.TARGET.DIR=$(BASE.DIR)/installed.target
CMAKE.VERSION=3.14.5
CMAKE.URL=https://github.com/Kitware/CMake/archive/v$(CMAKE.VERSION).tar.gz
CMAKE.DIR=$(DOWNLOADS.DIR)/CMake-$(CMAKE.VERSION)
CMAKE.ARCHIVE=v$(CMAKE.VERSION).tar.gz
CMAKE.BIN=$(INSTALLED.HOST.DIR)/bin/cmake
GTEST.VERSION=1.8.1
GTEST.ARCHIVE=release-$(GTEST.VERSION).tar.gz
GTEST.URL=https://github.com/google/googletest/archive/$(GTEST.ARCHIVE)
GTEST.DIR=$(DOWNLOADS.DIR)/googletest-release-1.8.1
GTEST.BUILD=$(DOWNLOADS.DIR)/build.googletest
SOURCE.DIR=$(BASE.DIR)/source
BUILD.DIR=$(BASE.DIR)/build
BETTERENUMS.VERSION=0.11.2
BETTERENUMS.DIR=$(DOWNLOADS.DIR)/better-enums-$(BETTERENUMS.VERSION)
BETTERENUMS.ARCHIVE=$(BETTERENUMS.VERSION).tar.gz
BETTERENUMS.URL=https://github.com/aantron/better-enums/archive/$(BETTERENUMS.ARCHIVE)
BIN.DIR=$(INSTALLED.HOST.DIR)/bin
LIB.DIR=$(INSTALLED.HOST.DIR)/lib
TESTS.BIN=$(BIN.DIR)/tests
TESTS.DIR=$(BASE.DIR)/tests
TESTS.BUILD=$(BASE.DIR)/build.tests

ci: clean bootstrap

bootstrap: submodule cmake gtest betterenums

ctags: .FORCE
	cd $(BASE.DIR) && ctags -R --exclude=.git --exclude=installed.host --exclude=downloads --exclude=documents --exclude=installed.target --exclude=documents  --exclude=build.*  .

betterenums: .FORCE
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget $(BETTERENUMS.URL) && tar xf $(BETTERENUMS.ARCHIVE)
	mkdir -p $(INSTALLED.HOST.DIR)/include
	cp $(BETTERENUMS.DIR)/enum.h $(INSTALLED.HOST.DIR)/include

gtest.fetch: .FORCE
	mkdir -p $(DOWNLOADS.DIR)
	cd $(DOWNLOADS.DIR) && wget $(GTEST.URL) && tar xf $(GTEST.ARCHIVE)

gtest: gtest.fetch
	rm -rf $(GTEST.BUILD)
	mkdir -p $(GTEST.BUILD) && cd $(GTEST.BUILD) && $(CMAKE.BIN) -DCMAKE_INSTALL_PREFIX=$(INSTALLED.HOST.DIR) $(GTEST.DIR) && make -j$(J) install

gtest.clean: .FORCE
	rm -rf $(GTEST.BUILD)
	rm -rf $(DOWNLOADS.DIR)/$(GTEST.ARCHIVE)

tests.build: .FORCE
	mkdir -p $(TESTS.BUILD)
	cd $(TESTS.BUILD) && $(CMAKE.BIN) -DCMAKE_PREFIX_PATH=$(INSTALLED.HOST.DIR) -DCMAKE_INSTALL_PREFIX=$(INSTALLED.HOST.DIR) $(TESTS.DIR) && make install

tests.run: .FORCE
	LD_LIBRARY_PATH=$(LIB.DIR) $(TESTS.BIN)

tests.gdb: .FORCE
	LD_LIBRARY_PATH=$(LIB.DIR) gdb $(TESTS.BIN)

tests.clean: .FORCE
	rm -rf $(TESTS.BUILD)

tests: tests.clean tests.build tests.run

submodule: .FORCE
	git submodule init
	git submodule update

cmake.fetch: .FORCE
	mkdir -p $(DOWNLOADS.DIR)
	cd $(DOWNLOADS.DIR) && wget $(CMAKE.URL) && cd $(DOWNLOADS.DIR) &&  tar xf $(CMAKE.ARCHIVE)

cmake: cmake.clean cmake.fetch
	cd $(CMAKE.DIR) && ./configure --prefix=$(INSTALLED.HOST.DIR) --no-system-zlib --parallel=8  && make -j4 install

cmake.clean: .FORCE
	rm -f $(DOWNLOADS.DIR)/$(CMAKE.ARCHIVE)
	rm -rf $(CMAKE.DIR)

clean: cmake.clean library.clean
	rm -rf $(INSTALLED.HOST.DIR)
	rm -rf $(DOWNLOADS.DIR)
	rm -rf $(TESTS.BUILD)

.FORCE:
