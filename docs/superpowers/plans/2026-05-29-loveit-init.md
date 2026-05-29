# LoveIt Initialization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Initialize this repository as a reproducible Hugo site using the LoveIt theme with a pinned, project-local Hugo Extended toolchain.

**Architecture:** Use a standard Hugo site rooted at the repository top level, add LoveIt as a git submodule under `themes/LoveIt`, and run the site through a repository-local Hugo `0.145.0` extended binary fetched into an ignored tools directory. Base configuration comes from LoveIt's `exampleSite/hugo.toml`, trimmed only enough to boot cleanly as a fresh site.

**Tech Stack:** Git, Hugo Extended 0.145.0, LoveIt `release` branch, POSIX shell scripts

---

## File Structure

- Create: `.gitignore`
- Create: `.gitmodules`
- Create: `archetypes/default.md`
- Create: `content/posts/.gitkeep`
- Create: `data/.gitkeep`
- Create: `layouts/.gitkeep`
- Create: `static/.gitkeep`
- Create: `themes/`
- Create: `tools/`
- Create: `scripts/bootstrap-hugo`
- Create: `scripts/hugo`
- Create: `scripts/hugo-server`
- Create: `hugo.toml`
- Create: `README.md`
- Modify: git metadata by adding the LoveIt submodule entry

### Task 1: Add Repository Ignore Rules

**Files:**
- Create: `.gitignore`
- Test: `git status --short`

- [ ] **Step 1: Write the ignore file**

```gitignore
.DS_Store
.hugo_build.lock
public/
resources/
.tools/
.superpowers/
```

- [ ] **Step 2: Verify the file contents**

Run: `sed -n '1,120p' .gitignore`
Expected: shows the six ignore entries above

- [ ] **Step 3: Check git status**

Run: `git status --short`
Expected: `.gitignore` appears as a new tracked file, while ignored paths do not appear

- [ ] **Step 4: Commit**

```bash
git add .gitignore
git commit -m "chore: add initial ignore rules"
```

### Task 2: Scaffold the Hugo Site Skeleton

**Files:**
- Create: `archetypes/default.md`
- Create: `content/posts/.gitkeep`
- Create: `data/.gitkeep`
- Create: `layouts/.gitkeep`
- Create: `static/.gitkeep`
- Create: `themes/.gitkeep`
- Test: `find archetypes content data layouts static themes -maxdepth 2 -print`

- [ ] **Step 1: Create the directory layout**

Run: `mkdir -p archetypes content/posts data layouts static themes`
Expected: the six top-level Hugo directories exist

- [ ] **Step 2: Add the default archetype**

```markdown
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
---
```

- [ ] **Step 3: Add keep files for empty directories**

Run: `touch content/posts/.gitkeep data/.gitkeep layouts/.gitkeep static/.gitkeep themes/.gitkeep`
Expected: empty directories remain trackable in git before content exists

- [ ] **Step 4: Verify the skeleton**

Run: `find archetypes content data layouts static themes -maxdepth 2 -print | sort`
Expected: includes `archetypes/default.md` and the five `.gitkeep` files

- [ ] **Step 5: Commit**

```bash
git add archetypes content data layouts static themes
git commit -m "chore: scaffold Hugo site skeleton"
```

### Task 3: Add the LoveIt Theme as a Git Submodule

**Files:**
- Create: `.gitmodules`
- Modify: `themes/LoveIt`
- Test: `git submodule status`

- [ ] **Step 1: Add the submodule**

Run: `git submodule add -b release https://github.com/dillonzq/LoveIt.git themes/LoveIt`
Expected: `themes/LoveIt` is created and `.gitmodules` is added

- [ ] **Step 2: Verify submodule metadata**

Run: `cat .gitmodules`
Expected:

```ini
[submodule "themes/LoveIt"]
	path = themes/LoveIt
	url = https://github.com/dillonzq/LoveIt.git
	branch = release
```

- [ ] **Step 3: Verify the submodule checkout**

Run: `git submodule status`
Expected: one line with a commit hash followed by `themes/LoveIt`

- [ ] **Step 4: Commit**

```bash
git add .gitmodules themes/LoveIt
git commit -m "chore: add LoveIt theme submodule"
```

### Task 4: Add Project-Local Hugo Bootstrap Scripts

**Files:**
- Create: `scripts/bootstrap-hugo`
- Create: `scripts/hugo`
- Create: `scripts/hugo-server`
- Modify: `.gitignore`
- Test: `bash scripts/bootstrap-hugo`

- [ ] **Step 1: Update ignore rules for the local tool cache**

Append to `.gitignore` only if not already present:

```gitignore
.tools/
```

- [ ] **Step 2: Create `scripts/bootstrap-hugo`**

```bash
#!/bin/sh
set -eu

VERSION="0.145.0"
OS="$(uname -s)"
ARCH="$(uname -m)"
ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
TOOLS_DIR="$ROOT_DIR/.tools"
INSTALL_DIR="$TOOLS_DIR/hugo-extended-$VERSION"
BIN="$INSTALL_DIR/hugo"
TMP_DIR="$TOOLS_DIR/tmp"

if [ -x "$BIN" ]; then
  printf '%s\n' "$BIN"
  exit 0
fi

mkdir -p "$INSTALL_DIR" "$TMP_DIR"

case "$OS-$ARCH" in
  Darwin-arm64|Darwin-x86_64)
    ARCHIVE="hugo_extended_${VERSION}_darwin-universal.tar.gz"
    ;;
  *)
    echo "Unsupported platform: $OS-$ARCH" >&2
    exit 1
    ;;
esac

URL="https://github.com/gohugoio/hugo/releases/download/v${VERSION}/${ARCHIVE}"
ARCHIVE_PATH="$TMP_DIR/$ARCHIVE"
EXTRACT_DIR="$TMP_DIR/hugo-$VERSION-extract"

rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

curl -fsSL "$URL" -o "$ARCHIVE_PATH"
tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR"
install -m 755 "$EXTRACT_DIR/hugo" "$BIN"

printf '%s\n' "$BIN"
```

- [ ] **Step 3: Create `scripts/hugo`**

```bash
#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
BIN="$("$ROOT_DIR/scripts/bootstrap-hugo")"

exec "$BIN" "$@"
```

- [ ] **Step 4: Create `scripts/hugo-server`**

```bash
#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR"
exec "$ROOT_DIR/scripts/hugo" server "$@"
```

- [ ] **Step 5: Make scripts executable**

Run: `chmod +x scripts/bootstrap-hugo scripts/hugo scripts/hugo-server`
Expected: all three scripts are executable

- [ ] **Step 6: Verify bootstrap behavior**

Run: `bash scripts/bootstrap-hugo`
Expected: prints a path ending in `.tools/hugo-extended-0.145.0/hugo`

- [ ] **Step 7: Verify the pinned Hugo version**

Run: `./scripts/hugo version`
Expected: output includes `hugo v0.145.0` and `+extended`

- [ ] **Step 8: Commit**

```bash
git add .gitignore scripts
git commit -m "chore: add local Hugo bootstrap scripts"
```

### Task 5: Add a Minimal LoveIt Site Configuration

**Files:**
- Create: `hugo.toml`
- Test: `./scripts/hugo config | sed -n '1,80p'`

- [ ] **Step 1: Write the initial site config**

```toml
baseURL = "https://example.org/"
title = "Academic Homepage"
theme = "LoveIt"
languageCode = "en"
defaultContentLanguage = "en"
hasCJKLanguage = false
enableRobotsTXT = true
enableEmoji = true

[pagination]
  pagerSize = 10

[params]
  defaultTheme = "auto"
  dateFormat = "2006-01-02"
  title = "Academic Homepage"
  description = "Personal academic website built with Hugo and LoveIt."

  [params.author]
    name = ""
    email = ""
    link = ""

  [params.header]
    desktopMode = "fixed"
    mobileMode = "auto"

    [params.header.title]
      name = "Academic Homepage"
      pre = ""
      post = ""
      typeit = false

  [params.footer]
    enable = true
    hugo = true
    copyright = true
    author = true

  [params.home]
    rss = 10

    [params.home.profile]
      enable = true
      avatarURL = ""
      title = ""
      subtitle = ""
      typeit = false
      social = true
      disclaimer = ""

    [params.home.posts]
      enable = true
      paginate = 6

  [params.social]
    GitHub = ""
    Email = ""
    Googlescholar = ""
    Researchgate = ""
    ORCID = ""
    RSS = true

[menu]
  [[menu.main]]
    identifier = "posts"
    name = "Posts"
    url = "/posts/"
    weight = 1

[outputs]
  home = ["HTML", "RSS", "JSON"]
```

- [ ] **Step 2: Verify Hugo can read the config**

Run: `./scripts/hugo config | sed -n '1,120p'`
Expected: output includes `theme = "LoveIt"` and `title = "Academic Homepage"`

- [ ] **Step 3: Commit**

```bash
git add hugo.toml
git commit -m "chore: add initial LoveIt site config"
```

### Task 6: Add a Minimal README for Local Use

**Files:**
- Create: `README.md`
- Test: `sed -n '1,200p' README.md`

- [ ] **Step 1: Write the project README**

```markdown
# zhongyi.github.io

Personal academic website built with Hugo and the LoveIt theme.

## Local development

Start the local preview server:

```bash
./scripts/hugo-server
```

Run one-off Hugo commands with the pinned binary:

```bash
./scripts/hugo version
./scripts/hugo new posts/example.md
```

## Theme

The site uses LoveIt as a git submodule:

```bash
git submodule update --init --recursive
```
```

- [ ] **Step 2: Verify the README**

Run: `sed -n '1,200p' README.md`
Expected: shows the local preview and submodule instructions above

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add local development readme"
```

### Task 7: Verify the Site Boots Cleanly

**Files:**
- Test: `./scripts/hugo version`
- Test: `./scripts/hugo --gc --minify`
- Test: `./scripts/hugo-server --disableFastRender`

- [ ] **Step 1: Verify the pinned Hugo binary again**

Run: `./scripts/hugo version`
Expected: output includes `hugo v0.145.0` and `+extended`

- [ ] **Step 2: Verify a production-style build**

Run: `./scripts/hugo --gc --minify`
Expected: build completes without configuration errors and produces `public/`

- [ ] **Step 3: Verify the development server starts**

Run: `./scripts/hugo-server --disableFastRender`
Expected: Hugo starts a local server and prints a line containing `Web Server is available at`

- [ ] **Step 4: Stop the development server after verifying startup**

Run: `Ctrl+C`
Expected: the Hugo server exits cleanly

- [ ] **Step 5: Commit final initialization state**

```bash
git add .
git commit -m "chore: initialize LoveIt Hugo site"
```

## Self-Review

- Spec coverage: the plan covers repository initialization, theme setup, pinned Hugo tooling, base configuration, run scripts, and verification.
- Placeholder scan: no `TODO`, `TBD`, or implicit “write tests later” steps remain.
- Type consistency: all scripts resolve the repository root the same way, and all verification commands target the same pinned `0.145.0` Hugo binary.
