# README: http://makefiletutorial.com
TARGET_PATH   = /src/app
VOLUME_PATH   = $(shell pwd):$(TARGET_PATH)
RUBY_IMAGE    = krates/toolbox:2.4.9-6
DOCKER_SOCKET = /var/run/docker.sock:/var/run/docker.sock

# Courtesy of: https://stackoverflow.com/a/49524393/3072002
# Common env variables (https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES)
.EXPORT_ALL_VARIABLES:
VERSION=$(shell cat VERSION)

# Adding PHONY to a target will prevent make from confusing the phony target with a file name.
# In this case, if `test` folder exists, `make test` will still be run.
# .PHONY: ...

integration: wipe
	docker-compose run -e "TRACE=${TRACE}" toolbox -c "./build/travis/before_install.sh && ./build/travis/test_e2e.sh"

trace: export TRACE=1
trace: integration

wipe: down volumes
	docker ps -aq | xargs -r docker rm -f

down:
	@docker-compose down

volumes:
	@docker volume prune --force