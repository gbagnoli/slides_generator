# Installing

## update revealjs

`make update_reveal'

## Install pandoc

* MacOSX: `brew install pandoc`
* Ubuntu: `apt-get install pandoc`

## Add the git hook

```
cp bin/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Develop

`make develop` will build the slides in dev mode. It will use the local
`revealjs` code from the submodule. If you want, you can serve the files
with an embedded dev webserver with `make serve`

Under `bin/` there is a handy script `bin/rebuild` which will watch the files
with `inotify` on linux (`fswatch` on mac) and rebuilds the slides in develop
mode when the `slides.md` file changes.
On linux, it supports a `-s` switch which will make the rebuild script also run
the integrated webserver - i.e. `./bin/release -s`.
This is not supported yet on macos.

## Structuring the slides - and config

revealjs [configuration](https://revealjs.com/config/) can be used by passing
`-V var:value` to pandoc in the Makefile. To pass false to booleans that
defaults to true pass `0` instead (i.e. `-V flag:0`)

More helps on format on the [pandoc
documentation](https://pandoc.org/chunkedhtml-demo/10-slide-shows.html)

## Compile for release

`make release`. It will generate a standalone `slides.html` with all the needed
files embedded.
The git hook automatically does this and commits the results on commit.
