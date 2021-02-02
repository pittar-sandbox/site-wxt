
default:
	make help

## shell:  make a shell into docker container
.PHONY: shell
shell: 
	docker exec -it scmspc-drupal /bin/bash 

## rootshell:  make a root sell into docker container 
.PHONY: rootshell
rootshell: 
	docker exec -u root -it scmspc-drupal /bin/bash 

.PHONY: help
help : Makefile 
	@sed -n 's/^##//p' $<

.PHONY: getpods
getpods:
	oc get pods | grep Run
	

%:
	@:


