test:
	echo "OH HAI"

pb:
	protoc -I=. --python_out=./app/ proto/events.proto
	mv ./app/proto/*.py ./app/
	rm -rf ./app/proto
