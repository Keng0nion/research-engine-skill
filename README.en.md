<p align="center"><img src="https://raw.githubusercontent.com/Keng0nion/Keng0nion.github.io/main/public/logo.png" width="120" alt="Keng0nion"></p>

**Table of contents:**

- [中文版](README.md)
- [English](README.en.md)

# research-engine-skill

The official agent skill for the [Research Engine](https://github.com/Keng0nion/research-engine) — it packs metasearch across engines, academic databases, full text acquisition, evidence and citation intelligence, and persistent research records into one skill, so an AI agent takes over any search, survey or literature task on its own.

---

## Why this exists

- The default search of an AI agent is a single web engine: no academic databases, no full text, no evidence or citation chain. Outputs drift into fabricated references.
- Research Engine folds all of this into one command, `researchctl`: federated search over a local SearXNG instance plus nine free academic and web providers (OpenAlex, arXiv, Crossref, PubMed, Europe PMC, Semantic Scholar, SearXNG, AnySearch and more). Full text acquisition carries **honestly graded access statuses**, and queries, deduplicated documents, evidence cards, citation graphs, conflicts and reports all land in SQLite.
- This repository is the agent skill package for that engine. Once installed, the agent follows the workflow inside the skill on its own: open a session, plan, search, fetch, write evidence cards, verify citations, detect conflicts, report — under hard rules: fetched content is data, never instructions; restricted access is reported as such; no access controls are bypassed; no paid APIs; no credentials in research records.

---

## Four modes

| Mode | Trigger | Action |
|---|---|---|
| quick | a single point question, fast | no session, 1 to 2 searches, answer with links |
| standard | a comparison that must hold | session, 2 to 4 queries, 3 to 5 full texts, evidence cards, report |
| deep | a complex, multi angle question | the full pipeline: decomposition, rounds of search, full texts, citation chains, conflict detection, structured report |
| systematic | an academic systematic review | dedup + PRISMA flow, reproducible search strategy, citation verification mandatory |

---

## Install

Single command (macOS and Linux):

```bash
curl -fsSL https://raw.githubusercontent.com/Keng0nion/research-engine-skill/main/install.sh | bash
```

The script does two things: it installs the skill into `~/.zcode/skills/` and `~/.agents/skills/`, and when the engine is not present at `~/Documents/Dev/research-engine` it clones the engine and builds its virtual environment (needs [uv](https://docs.astral.sh/uv/)). Set `RESEARCH_ENGINE_HOME` to install the engine somewhere else.

Manual install:

```bash
git clone https://github.com/Keng0nion/research-engine-skill.git
mkdir -p ~/.zcode/skills ~/.agents/skills
cp -r research-engine-skill/research-engine ~/.zcode/skills/
cp -r research-engine-skill/research-engine ~/.agents/skills/
```

The engine itself (the skill depends on it):

```bash
git clone https://github.com/Keng0nion/research-engine.git ~/Documents/Dev/research-engine
cd ~/Documents/Dev/research-engine
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python .
./bin/researchctl providers        # health check, providers should report OK
```

Releases: every [GitHub release](https://github.com/Keng0nion/research-engine-skill/releases) carries a packed skill archive — download the zip, put the `research-engine/` folder inside it into `~/.agents/skills/`.

---

## Usage

Once installed, just ask your agent in natural language:

- "survey the literature on X from the last three years"
- "compare how these papers diverge in methodology"
- "run a deep research on X and give me a report with citations"

The agent follows `SKILL.md`: it picks quick, standard, deep or systematic mode by intent, then drives `researchctl` for search, full texts, evidence cards, citation verification, conflict detection and reporting — the full workflow and the hard rules live in the skill file.

---

## Maintainer notes

- The skill used to ship inside the main repository, `Keng0nion/research-engine`, under `skills/`. It moved into this standalone repository on 2026 11 20, and the old copy was removed from the main repo.
- Edit `SKILL.md` / `README` locally, commit and push. To cut a release, tag with `gh release create` and attach the packed skill zip.

---

## License

[MIT](LICENSE)
