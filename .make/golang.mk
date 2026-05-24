GOFLAGS += -cover -covermode=atomic -race -shuffle=on -mod=readonly -trimpath

# files used by go generate
define GO_GENERATE_SOURCES
$(strip
)
endef

# files produces by go generate
define GO_GENERATE_TARGETS
$(strip
)
endef

define TEST_PACKAGES
$(strip
internal
pkg
)
endef

GO_SOURCES = $(shell git ls-files '*.go') $(strip ${GO_GENERATE_TARGETS})

all: bin/kubegraph
all: gomod2nix.toml

dist:: GOFLAGS=
dist::
	goreleaser release --clean --snapshot --skip archive,before,nfpm,sign --release-notes CHANGELOG.md

.PHONY: coverage
coverage: build/coverage/unit.txt
	go tool cover -func=$<

test::
	gotestdox ${GOFLAGS} ./...

## make magic, not war ;)

build/coverage/unit.txt: ${GO_SOURCES} go.sum | build/coverage/
	gotestdox -covermode=atomic -race -shuffle=on -mod=readonly -trimpath --coverprofile=$@ $(addprefix ./,$(addsuffix /...,${TEST_PACKAGES}))
	sed -i'' '#\.gen\.go:|\.pb\.go:|\.pb\.gw\.go:|\.sql\.go:|\.xo\.go:#d' $@

bin/%: ${GO_SOURCES} go.sum
	go build -race -mod=readonly -trimpath -o ./$@ ./cmd/$(patsubst bin/%,%,$@)/...

go.sum: GOFLAGS-=-mod-readonly
go.sum: ${GO_SOURCES} go.mod
	@go mod tidy -v -x
	@touch $@

gomod2nix.toml: go.sum
	gomod2nix generate

build/coverage/%.html: build/coverage/%.txt
	go tool cover -html=$< -o $@

${GO_GENERATE_TARGETS} &: ${GO_GENERATE_SOURCES}
	go generate ./...

hooks/pre-bump::
	goreleaser check
	goreleaser healthcheck

hooks/post-bump::
	goreleaser release --clean --release-notes CHANGELOG.md
