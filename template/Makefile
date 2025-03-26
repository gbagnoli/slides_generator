SHELL := /bin/bash
all: develop
theme = sky

cmd = pandoc --css reveal.js/dist/theme/$(theme).css --css slides.css \
				-s -i -t revealjs --slide-level=2 \
				-V transition:none -V theme:$(theme) -V revealjs-url:reveal.js \
				slides-generated.md -o

clean:
	@rm -rf slides-dev.html slides-generated.md

clean_all: clean
	@rm -f bin/static-web-server

sub: clean
	@./bin/substitute slides.md slides-generated.md

develop: sub
	$(cmd) slides-dev.html
	@rm -f slides-generated.md

release: sub
	$(cmd) {{outfile}}.html --embed-resources --standalone
	@rm -f slides-generated.md

update_reveal:
	git submodule sync
	git submodule foreach git pull

download_server:
	FORCE_DOWNLOAD=true NO_SERVE=true bin/serve

serve: develop
	bin/serve -p 3333 -d .
