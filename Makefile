all: build

build:
	docker build --tag=avezila/postgresql .

release: build
	@docker build --tag=avezila/postgresql:$(shell cat VERSION) .
