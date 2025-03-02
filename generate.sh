#!/bin/bash

set -e
set -u
set -o pipefail

AUTHOR="${AUTHOR:-}"
TITLE="${TITLE:-}"
OUTFILE="${SLIDES_FILENAME:-}"
REVEAL="${REVEAL_REPO_URI:-https://github.com/hakimel/reveal.js.git}"

usage() {
  echo "$0 [-h] [-a author] [-t title] [-f filename] [-r reveal_git_url] <target dir>"
  echo
  echo "<target dir> is mandatory: the directory should not exists, but its parent must"
  echo
  echo "Options:"
  echo "-h : show this help"
  echo "-a : set the author. Defaults to $(whoami) if not set"
  echo "-t : set the slides' title. Defaults to 'MY SLIDES' if not set"
  echo "-f : output filename. Defaults to 'slides' if not set. .html suffix is automatically added"
  echo "-r : reveal js git uri. Defaults to $REVEAL"
}

while getopts ":a:t:f:r:h" opt; do
  case $opt in
    a)
      echo "Setting author to $OPTARG"
      AUTHOR="$OPTARG"
      ;;
    t)
      echo "Setting title to $OPTARG"
      TITLE="$OPTARG"
      ;;
    f)
      echo "Setting slides filename: $OPTARG"
      OUTFILE="$OPTARG"
      ;;
    r)
      echo "Setting reveal repo uri to $OPTARG"
      REVEAL="$OPTARG"
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

TARGET=""
if [ $# -lt $OPTIND ]; then
  echo "Missing target directory" >&2
  usage
  exit 1
fi
TARGET="$(eval echo \$$OPTIND)"

if [ -d "$TARGET" ]; then
  echo >&2 "Target directory exists at $TARGET"
  exit 2
elif [ -e "$TARGET" ]; then
  echo >&2 "Target directory exists and is not a directory at $TARGET"
  exit 3
elif [ ! -d "$(dirname "$TARGET")" ]; then
  echo >&2 "Parent directory of $TARGET does not exists"
  exit 4
fi

for cmd in pandoc git make; do
  if ! command -v $cmd &>/dev/null; then
    echo >&2 "$cmd not installed. Makes sure to install it first"
    exit 5
  fi
  echo "Found $cmd at $(command -v $cmd)"
done

if [ -z "$TITLE" ]; then
  echo 'No title provided, setting to "MY SLIDES". You can change it later in slides.md'
  TITLE="MY SLIDES"
fi

if [ -z "$AUTHOR" ]; then
  echo "No author set. Setting it to $(whoami)"
  AUTHOR="$(whoami)"
fi

if [ -z "$OUTFILE" ]; then
  echo "No output filename set. Using 'slides'"
  OUTFILE='slides'
fi

s="sed"
if [[ "$(uname)" == "Darwin" ]]; then
  if ! command -v gsed &>/dev/null; then
    echo >&2 "gsed not found. Please install it with brew install gnu-sed"
    exit 5
  fi
  s="gsed"
fi

pushd "$(dirname "$0")" &> /dev/null
echo "Generating slides in $TARGET"
cp -r template "$TARGET"

echo "Changing author, title and output filename"
$s -i -e "s/{{author}}/$AUTHOR/g" "$TARGET/slides.md"
$s -i -e "s/{{title}}/$TITLE/g" "$TARGET/slides.md"
$s -i -e "s/{{outfile}}/$OUTFILE/g" "$TARGET/bin/pre-commit" "$TARGET/Makefile"

echo "Creating git repository at $TARGET"
pushd "$TARGET" &>/dev/null
mkdir images
touch images/.gitkeep
git init
git commit --allow-empty -m "Initial empty commit"
ln -sf  "../../bin/pre-commit" .git/hooks/pre-commit
git submodule add "$REVEAL"
git add .
git ci -m 'Initial slide skel'

popd &>/dev/null
popd &>/dev/null

echo "Congrats! Your slides are awaiting for you at $TARGET"
