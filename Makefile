build-image:
	docker build -t laixintao/blue-nginx:0.1.0 .

build: build-image
	docker run -v $(PWD)/bin:/nginx-build/bin laixintao/blue-nginx:0.1.0

