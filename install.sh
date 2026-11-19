#!/bin/bash
# research-engine skill installer — macOS & Linux
# Installs the agent skill into both global skill directories, and sets up
# the engine it depends on (clone + venv) when it is not present yet.
set -e

SKILL_REPO="Keng0nion/research-engine-skill"
ENGINE_REPO="Keng0nion/research-engine"
ENGINE_DIR="${RESEARCH_ENGINE_HOME:-$HOME/Documents/Dev/research-engine}"
DESTS=("$HOME/.zcode/skills" "$HOME/.agents/skills")

command -v git >/dev/null 2>&1 || { echo "error: git is required"; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
git clone --depth 1 "https://github.com/$SKILL_REPO.git" "$TMP/skill" >/dev/null 2>&1 \
  || { echo "error: could not clone https://github.com/$SKILL_REPO"; exit 1; }

for dest in "${DESTS[@]}"; do
  mkdir -p "$dest"
  if [ -e "$dest/research-engine" ]; then
    rm -r "$dest/research-engine"
  fi
  cp -R "$TMP/skill/research-engine" "$dest/"
  echo "installed:" "$dest/research-engine"
done

if [ ! -e "$ENGINE_DIR/bin/researchctl" ]; then
  echo
  echo "engine not found at" "$ENGINE_DIR" "— cloning it now"
  mkdir -p "$(dirname "$ENGINE_DIR")"
  git clone "https://github.com/$ENGINE_REPO.git" "$ENGINE_DIR"
  if command -v uv >/dev/null 2>&1; then
    (cd "$ENGINE_DIR" && uv venv --python 3.12 .venv && uv pip install --python .venv/bin/python .)
  else
    echo "note: uv is not installed — get it from https://docs.astral.sh/uv/getting-started/installation/ then run:"
    echo "  cd" "$ENGINE_DIR" "&& uv venv --python 3.12 .venv && uv pip install --python .venv/bin/python ."
  fi
fi

echo
echo "done — the skill is available on the agent's next turn."
echo "engine:" "$ENGINE_DIR" "(override the location with RESEARCH_ENGINE_HOME)"
echo "first check:" "$ENGINE_DIR/bin/researchctl" "providers"
