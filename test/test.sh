#!/bin/bash
#set -euo pipefail

#echo === health
#url=localhost:8080/myservice
# http $url/health
url=localhost:8080
http $url/health

# kubectl get mappings -A
# kubectl describe mapping myservice-map1
# kubectl describe mapping myservice-map2

# this doesn't work unless local
#grpc=myservice.MyService
#grpcurl -plaintext 192.168.99.100:30506  ${grpc}/Health

# but this is OK
../build/client  -config client-config.yaml

# elvis is OK too (something with reflection?)

#echo === REST endpoint on 8080/myservice
#curl -X POST  http://localhost:8080/hello -d '{ "myserviceing": { "first_name": "John" } }'
#
#echo === grpcurl
#
#grpcurl -plaintext localhost:52052 describe myredis.KVService
#
#grpcurl -d '{ "myserviceing": { "first_name": "Ivo" } }' \
#     -plaintext localhost:52052  myredis.KVService/myservice
#
#echo === grpc go client
#[[ -f build/client ]] && build/client
#
#
#echo " "
#
#echo === evans CLI
#
#echo '{ "myserviceing": { "first_name": "Ivo" } }' | evans --port 52052 --package myservice --service KVService --call myservice myservice/myservice.proto
#
#echo === evans REPL
#
#echo evans myservice/myservice.proto --repl --host localhost --port 52052 -r
#
#echo evans myservice/myservice.proto --repl --host 192.168.99.100 --port 30506 -r
#
#echo package myservice
#echo service KVService
#echo call myservice

#  pod=$(kubectl get pod -l app=hello -o  jsonpath='{.items[0].metadata.name}')
#  kubectl port-forward $pod 52052:52052 8080:8080

# amb.
# http://192.168.99.100:30506/myservice

# url=http://192.168.99.100:30506/myservice
# http $url/health
# curl -X POST $url/hello -d '{ "myserviceing": { "first_name": "John", "last_name": "Doe" } }'

# grpcurl -plaintext 192.168.99.100:30506 myredis.KVService/Health
