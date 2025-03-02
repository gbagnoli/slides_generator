SHELL := /bin/bash
all: develop

cmd = pandoc --css reveal.js/dist/theme/sky.css --css slides.css -s -i -t revealjs slides-generated.md -V transition:none -V theme:sky -o

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

bin/static-web-server:
	@echo "Downloaded the last release of static-web-server"
	$(shell curl -sL https://api.github.com/repos/static-web-server/static-web-server/releases | jq -r '.[0].assets[] | select(.name | contains("i686-unknown-linux-gnu")) | .browser_download_url' | xargs curl -sL | tar -C bin/ --wildcards -xzf - '*/static-web-server' --strip-components=1)

serve: develop bin/static-web-server
	bin/static-web-server -p 3333 -d .
