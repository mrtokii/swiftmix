prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/Swiftmix" "$(bindir)/swiftmix"

uninstall:
	rm -rf "$(bindir)/swiftmix"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
