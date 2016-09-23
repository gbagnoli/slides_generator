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

## Compile

`make release`
