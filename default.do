redo-ifchange module-name
MOD=`cat module-name`
go build -o $3 -ldflags "-X ${MOD}.Version=`cat VERSION`" ${MOD}/cmd/$1
