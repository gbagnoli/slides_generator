all: develop

cmd = pandoc --css reveal.js/dist/theme/sky.css --css slides.css -s -i -t revealjs slides-generated.md -V transition:none -V theme:sky -o

clean:
	@rm -rf slides-dev.html slides-generated.md

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
