redo-ifchange module-name
exec >&2
go test -benchmem -bench . `cat module-name`/...
