MOD = go.cypherpunks.ru/gogost/v4
LDFLAGS = -X $(MOD).Version=$(VERSION)

all: streebog256 streebog512

streebog256:
	GOPATH=$(GOPATH) go build -ldflags "$(LDFLAGS)" $(MOD)/cmd/streebog256

streebog512:
	GOPATH=$(GOPATH) go build -ldflags "$(LDFLAGS)" $(MOD)/cmd/streebog512

bench:
	GOPATH=$(GOPATH) go test -benchmem -bench . $(MOD)/...
