# Academic Homepage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a single-page English academic homepage for Zhongyi Ni in this Hugo + LoveIt repository, using the existing CV data as the primary content source.

**Architecture:** Keep the site on the existing Hugo + LoveIt stack, but override the homepage locally with a custom single-page template. Use `cv/cv.yml` as the source of truth for structured academic data by reading it directly from the repository and unmarshaling it in the template, add only a small homepage-specific data file for the custom about blurb and hero summary, and style the page through Hugo's `assets/css/_custom.scss` override entrypoint.

**Tech Stack:** Hugo 0.145.0 extended, LoveIt theme, Go template partials, YAML data files, SCSS, local static assets

---

## File Structure

- Create: `assets/css/_custom.scss`
- Create: `content/_index.md`
- Create: `data/homepage.yml`
- Create: `layouts/index.html`
- Create: `layouts/partials/academic-home.html`
- Create: `static/images/profile.jpg`
- Modify: `hugo.toml`
- Modify: `cv/cv.yml`
- Test: `./scripts/hugo`
- Test: `./scripts/hugo-server`

## Notes Before Execution

- `public/` and `resources/` are gitignored in this repository, so the implementation should verify the site with local builds but should not plan to commit generated output.
- The repository currently has no root `assets/` directory. Creating `assets/css/_custom.scss` is the intended LoveIt extension point and will be picked up by `themes/LoveIt/assets/css/style.scss`.
- `cv/cv.yml` already drives the Typst CV. Additive homepage fields are acceptable, but existing CV fields should not be renamed or restructured in a way that would break `cv/cv.typ`.
- `cv/cv.pdf` is outside Hugo's `static/` directory. The implementation should make it publicly available through Hugo without copying it into a second maintained directory.

### Task 1: Add Homepage-Specific Data Fields

**Files:**
- Modify: `cv/cv.yml`
- Create: `data/homepage.yml`
- Test: `sed -n '1,260p' cv/cv.yml`
- Test: `sed -n '1,220p' data/homepage.yml`

- [ ] **Step 1: Extend `cv/cv.yml` only with additive homepage fields**

Add a `homepage` block near the top level of `cv/cv.yml` without changing existing CV keys. The new block should look like:

```yaml
homepage:
  heroSummary: Research in quantum error correction, tensor-network methods, and quantum computing.
  keywords:
    - Quantum error correction
    - Tensor networks
    - Variational quantum algorithms
    - Quantum control
```

Also add explicit reverse-chronological sort keys to each publication entry:

```yaml
publicationEntries:
  - sortKey: 2026-04
    authors: ...
    title: ...
  - sortKey: 2025-05
    authors: ...
    title: ...
```

Use one sortable `YYYY-MM` key per entry so the homepage template does not guess ordering from venue text.

- [ ] **Step 2: Create `data/homepage.yml` for hand-written homepage-only copy**

Write `data/homepage.yml` with:

```yaml
about: >-
  Zhongyi Ni is a PhD student in Physics at The Hong Kong University of Science
  and Technology (Guangzhou), where he works with Prof. Jin-Guo Liu. His
  research focuses on quantum error correction, tensor-network methods, and
  quantum computing, with interests spanning variational quantum algorithms and
  quantum control.
hero:
  affiliation: The Hong Kong University of Science and Technology (Guangzhou)
contact:
  locationLabel: Guangzhou, China
```

This file exists only for text that does not belong in the CV schema.

- [ ] **Step 3: Verify the data files**

Run:

```bash
sed -n '1,260p' cv/cv.yml
sed -n '1,220p' data/homepage.yml
```

Expected: `cv/cv.yml` still contains all CV sections used by Typst, and both files contain no placeholder text.

- [ ] **Step 4: Commit the data preparation**

Run:

```bash
git add cv/cv.yml data/homepage.yml
git commit -m "feat: add academic homepage data"
```

Expected: one commit containing only the homepage data changes.

### Task 2: Add a Managed Portrait Asset

**Files:**
- Create: `static/images/profile.jpg`
- Test: `file static/images/profile.jpg`
- Test: `ls -lh static/images/profile.jpg`

- [ ] **Step 1: Copy the approved portrait into the site's static assets**

Run:

```bash
mkdir -p static/images
cp '/Users/nzy/Desktop/thumbnail_Capture One Catalog0287.jpg' static/images/profile.jpg
```

Expected: `static/images/profile.jpg` exists as the site-managed portrait asset.

- [ ] **Step 2: Verify the copied image**

Run:

```bash
file static/images/profile.jpg
ls -lh static/images/profile.jpg
```

Expected: JPEG image data is reported and the file size is non-zero.

- [ ] **Step 3: Commit the portrait asset**

Run:

```bash
git add static/images/profile.jpg
git commit -m "feat: add homepage portrait asset"
```

Expected: one commit containing only the copied portrait.

### Task 3: Make the CV Directory Publicly Reachable in Hugo

**Files:**
- Modify: `hugo.toml`
- Test: `sed -n '1,260p' hugo.toml`

- [ ] **Step 1: Add a Hugo module mount for the existing `cv/` directory**

Append this block to `hugo.toml`:

```toml
[module]
  [[module.mounts]]
    source = "static"
    target = "static"

  [[module.mounts]]
    source = "content"
    target = "content"

  [[module.mounts]]
    source = "layouts"
    target = "layouts"

  [[module.mounts]]
    source = "data"
    target = "data"

  [[module.mounts]]
    source = "assets"
    target = "assets"

  [[module.mounts]]
    source = "archetypes"
    target = "archetypes"

  [[module.mounts]]
    source = "cv"
    target = "static/cv"
```

This keeps `cv/cv.pdf` as the maintained source while making it available at `/cv/cv.pdf`. It also avoids relying on single-file mounts.

- [ ] **Step 2: Verify the config change**

Run:

```bash
sed -n '1,260p' hugo.toml
```

Expected: the new `[module]` section is present exactly once, and existing site params remain intact.

- [ ] **Step 3: Commit the mount configuration**

Run:

```bash
git add hugo.toml
git commit -m "feat: mount cv pdf into site output"
```

Expected: one config-only commit.

### Task 4: Replace Blog Navigation With Section Anchors

**Files:**
- Modify: `hugo.toml`
- Test: `sed -n '1,260p' hugo.toml`

- [ ] **Step 1: Replace the current main menu configuration with homepage anchors**

Edit the `[menu]` section in `hugo.toml` so it becomes:

```toml
[menu]
  [[menu.main]]
    identifier = "about"
    name = "About"
    url = "#about"
    weight = 1

  [[menu.main]]
    identifier = "research"
    name = "Research"
    url = "#research"
    weight = 2

  [[menu.main]]
    identifier = "publications"
    name = "Publications"
    url = "#publications"
    weight = 3

  [[menu.main]]
    identifier = "software"
    name = "Software & Talks"
    url = "#software-talks"
    weight = 4

  [[menu.main]]
    identifier = "experience"
    name = "Experience"
    url = "#experience"
    weight = 5

  [[menu.main]]
    identifier = "contact"
    name = "Contact"
    url = "#contact"
    weight = 6
```

Also set the homepage post feed off in `hugo.toml`:

```toml
[params.home.posts]
  enable = false
```

- [ ] **Step 2: Verify the menu and posts configuration**

Run:

```bash
sed -n '1,260p' hugo.toml
```

Expected: there is no `Posts` menu item and the home posts block explicitly disables posts.

- [ ] **Step 3: Commit the navigation config**

Run:

```bash
git add hugo.toml
git commit -m "feat: switch homepage navigation to section anchors"
```

Expected: one commit containing only the menu/posts config changes on top of prior config edits.

### Task 5: Add a Local Homepage Template Override

**Files:**
- Create: `content/_index.md`
- Create: `layouts/index.html`
- Create: `layouts/partials/academic-home.html`
- Test: `sed -n '1,220p' layouts/index.html`
- Test: `sed -n '1,320p' layouts/partials/academic-home.html`

- [ ] **Step 1: Create `content/_index.md` with minimal front matter for the homepage**

Write:

```md
---
title: Zhongyi Ni
type: home
---
```

No body content is required because the homepage will be driven by the custom partial.

- [ ] **Step 2: Create `layouts/index.html` to override LoveIt's default homepage**

Write:

```html
{{ define "content" }}
  <div class="page home academic-home-page">
    {{ partial "academic-home.html" . }}
  </div>
{{ end }}
```

This intentionally bypasses LoveIt's `home/profile` and posts summary rendering.

- [ ] **Step 3: Create `layouts/partials/academic-home.html` with all homepage sections**

Use direct file reading and unmarshal for the CV data, and Hugo data access only for the homepage-only copy:

```go-html-template
{{ $cv := dict }}
{{ with os.ReadFile "cv/cv.yml" }}
  {{ $cv = transform.Unmarshal (dict "format" "yaml") . }}
{{ else }}
  {{ errorf "Unable to read cv/cv.yml" }}
{{ end }}
{{ $home := .Site.Data.homepage }}
```

The partial should render:

```html
{{ $cv := dict }}
{{ with os.ReadFile "cv/cv.yml" }}
  {{ $cv = transform.Unmarshal (dict "format" "yaml") . }}
{{ else }}
  {{ errorf "Unable to read cv/cv.yml" }}
{{ end }}
{{ $home := .Site.Data.homepage }}
{{ $github := "" }}
{{ with index $cv.personal.profiles 0 }}{{ $github = .url }}{{ end }}

<section class="academic-hero" id="top">
  <div class="academic-hero__content">
    <p class="academic-hero__eyebrow">{{ $home.hero.affiliation }}</p>
    <h1>{{ $cv.personal.name }}</h1>
    <p class="academic-hero__title">{{ index $cv.personal.titles 0 }}</p>
    <p class="academic-hero__summary">{{ $cv.homepage.heroSummary }}</p>
    <ul class="academic-hero__keywords">
      {{ range $cv.homepage.keywords }}<li>{{ . }}</li>{{ end }}
    </ul>
    <div class="academic-hero__actions">
      <a class="academic-button academic-button--primary" href="/cv/cv.pdf">Download CV</a>
      <a class="academic-button" href="{{ $github }}" rel="noopener" target="_blank">GitHub</a>
      <a class="academic-button" href="mailto:{{ $cv.personal.email }}">Email</a>
    </div>
  </div>
  <div class="academic-hero__media">
    <img src="/images/profile.jpg" alt="Portrait of {{ $cv.personal.name }}">
  </div>
</section>

<section class="academic-section" id="about">
  <h2>About</h2>
  <p>{{ $home.about }}</p>
</section>

<section class="academic-section" id="research">
  <h2>Research Interests</h2>
  <ul class="academic-tag-list">
    {{ range $cv.researchInterests }}<li>{{ . }}</li>{{ end }}
  </ul>
</section>

<section class="academic-section" id="publications">
  <h2>Publications</h2>
  <ol class="academic-publications">
    {{ range sort $cv.publicationEntries "sortKey" "desc" }}
      <li>
        <p class="academic-publications__authors">{{ .authors | markdownify }}</p>
        <p class="academic-publications__title"><a href="{{ .url }}" rel="noopener" target="_blank">{{ .title }}</a></p>
        <p class="academic-publications__venue">{{ .venue | markdownify }}</p>
      </li>
    {{ end }}
  </ol>
</section>

<section class="academic-section" id="software-talks">
  <h2>Software &amp; Talks</h2>
  <div class="academic-list">
    {{ range $cv.projects }}
      <article class="academic-list__item">
        <h3><a href="{{ .url }}" rel="noopener" target="_blank">{{ .name }}</a></h3>
        <p class="academic-list__meta">{{ .affiliation }}</p>
        {{ with .highlights }}<p>{{ index . 0 }}</p>{{ end }}
      </article>
    {{ end }}
  </div>
</section>

<section class="academic-section" id="experience">
  <h2>Experience</h2>
  <div class="academic-list">
    {{ range $job := $cv.work }}
      {{ range $position := $job.positions }}
        <article class="academic-list__item">
          <h3>{{ $position.position }}</h3>
          <p class="academic-list__meta">{{ $job.organization }} · {{ $job.location }}</p>
          {{ with $position.highlights }}<p>{{ index . 0 }}</p>{{ end }}
        </article>
      {{ end }}
    {{ end }}
  </div>
</section>

<section class="academic-section academic-section--contact" id="contact">
  <h2>Contact</h2>
  <ul class="academic-contact">
    <li><span>Email</span><a href="mailto:{{ $cv.personal.email }}">{{ $cv.personal.email }}</a></li>
    <li><span>GitHub</span><a href="{{ $github }}" rel="noopener" target="_blank">{{ $github }}</a></li>
    <li><span>CV</span><a href="/cv/cv.pdf">cv/cv.pdf</a></li>
    <li><span>Location</span><span>{{ $home.contact.locationLabel }}</span></li>
  </ul>
</section>
```

- [ ] **Step 4: Verify the template files**

Run:

```bash
sed -n '1,220p' layouts/index.html
sed -n '1,320p' layouts/partials/academic-home.html
```

Expected: the homepage sections, anchor ids, and CTA links all exist in template code.

- [ ] **Step 5: Commit the template override**

Run:

```bash
git add content/_index.md layouts/index.html layouts/partials/academic-home.html
git commit -m "feat: add academic homepage template"
```

Expected: one commit with only homepage template files.

### Task 6: Add Homepage Styling Through `_custom.scss`

**Files:**
- Create: `assets/css/_custom.scss`
- Test: `sed -n '1,320p' assets/css/_custom.scss`

- [ ] **Step 1: Create the custom style file at LoveIt's documented override path**

Write `assets/css/_custom.scss` with:

```scss
.academic-home-page {
  padding-bottom: 4rem;
}

.academic-hero {
  display: grid;
  grid-template-columns: minmax(0, 1.5fr) minmax(280px, 0.9fr);
  gap: 2.5rem;
  align-items: center;
  padding: 3rem 0 2rem;
}

.academic-hero h1 {
  margin: 0 0 0.75rem;
  font-size: 2.8rem;
  line-height: 1.08;
}

.academic-hero__title,
.academic-hero__summary {
  margin: 0 0 1rem;
}

.academic-hero__keywords,
.academic-tag-list,
.academic-contact {
  list-style: none;
  padding: 0;
  margin: 0;
}

.academic-hero__keywords,
.academic-tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
}

.academic-hero__keywords li,
.academic-tag-list li {
  padding: 0.35rem 0.75rem;
  border: 1px solid $global-border-color;
  border-radius: 999px;

  [theme=dark] & {
    border-color: $global-border-color-dark;
  }
}

.academic-hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 1.5rem;
}

.academic-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 2.75rem;
  padding: 0 1rem;
  border: 1px solid $global-border-color;
  border-radius: 6px;
  text-decoration: none;

  [theme=dark] & {
    border-color: $global-border-color-dark;
  }
}

.academic-button--primary {
  font-weight: 600;
}

.academic-hero__media img {
  display: block;
  width: 100%;
  max-width: 22rem;
  aspect-ratio: 1 / 1;
  object-fit: cover;
  border-radius: 8px;
}

.academic-section {
  padding-top: 2.5rem;
}

.academic-section h2 {
  margin-bottom: 1rem;
}

.academic-publications {
  margin: 0;
  padding-left: 1.4rem;
}

.academic-publications li + li,
.academic-list__item + .academic-list__item {
  margin-top: 1.25rem;
}

.academic-publications__authors,
.academic-publications__title,
.academic-publications__venue,
.academic-list__item h3,
.academic-list__item p {
  margin: 0;
}

.academic-hero__eyebrow,
.academic-list__meta,
.academic-publications__venue,
.academic-contact span:first-child {
  color: $global-font-secondary-color;

  [theme=dark] & {
    color: $global-font-secondary-color-dark;
  }
}

.academic-publications__title {
  margin-top: 0.25rem;
}

.academic-publications__venue,
.academic-list__meta {
  margin-top: 0.3rem;
}

.academic-contact li {
  display: grid;
  grid-template-columns: 5.5rem minmax(0, 1fr);
  gap: 0.75rem;
  padding: 0.4rem 0;
}

@media (max-width: 900px) {
  .academic-hero {
    grid-template-columns: 1fr;
    padding-top: 2rem;
  }

  .academic-hero__media {
    order: 2;
  }

  .academic-hero__content {
    order: 1;
  }
}

@media (max-width: 640px) {
  .academic-hero h1 {
    font-size: 2.2rem;
  }

  .academic-contact li {
    grid-template-columns: 1fr;
    gap: 0.2rem;
  }
}
```

- [ ] **Step 2: Verify the style file**

Run:

```bash
sed -n '1,320p' assets/css/_custom.scss
```

Expected: the file contains rules for hero layout, publication list readability, CTA buttons, and mobile collapse behavior.

- [ ] **Step 3: Commit the homepage styles**

Run:

```bash
git add assets/css/_custom.scss
git commit -m "feat: style academic homepage"
```

Expected: one commit containing only the style file.

### Task 7: Verify Template Integration With TDD

**Files:**
- Modify: `layouts/partials/academic-home.html`
- Modify: `data/homepage.yml`
- Modify: `cv/cv.yml`
- Test: `./scripts/hugo`

- [ ] **Step 1: Run Hugo to capture the first real template/data failure**

Run:

```bash
./scripts/hugo
```

Expected: the first run should either pass or fail with a specific template/config error. Record the exact error before editing.

- [ ] **Step 2: Apply only the minimal fix required by the observed error**

If the build fails, patch the exact file named in the error and re-run without changing unrelated structure. Expected likely failure classes are:

```text
1. SCSS compile error in assets/css/_custom.scss
2. template parse or execution error in layouts/partials/academic-home.html
3. config/mount error in hugo.toml
```

Do not introduce new data files or new rendering paths at this stage.

- [ ] **Step 3: Re-run Hugo until the homepage builds**

Run:

```bash
./scripts/hugo
```

Expected: exit code 0 with no template errors.

- [ ] **Step 4: Commit the data-handling fix**

Run:

```bash
git add layouts/partials/academic-home.html data/homepage.yml cv/cv.yml hugo.toml assets/css/_custom.scss
git commit -m "fix: wire homepage data into Hugo templates"
```

Expected: one commit containing only the minimal data/template fixes used to make the build pass.

### Task 8: Verify Homepage Behavior in the Local Site

**Files:**
- Modify: `layouts/partials/academic-home.html`
- Modify: `assets/css/_custom.scss`
- Modify: `hugo.toml`
- Test: `./scripts/hugo-server --disableFastRender`

- [ ] **Step 1: Start the local Hugo server**

Run:

```bash
./scripts/hugo-server --disableFastRender
```

Expected: a local URL such as `http://localhost:1313/` is printed and the process stays running.

- [ ] **Step 2: Manually verify the required behaviors in the browser**

Check:

```text
1. Header menu links scroll to About, Research, Publications, Software & Talks, Experience, and Contact.
2. The homepage has no posts list and no Posts nav entry.
3. The hero shows the portrait, title, summary, keywords, and Download CV / GitHub / Email buttons.
4. Download CV opens /cv/cv.pdf.
5. Publication entries link out correctly.
6. The Software & Talks and Experience sections read cleanly on desktop width.
7. On a narrow viewport, the hero collapses to a single column without overlap.
```

If any check fails, fix only the responsible template or SCSS before moving on.

- [ ] **Step 3: Stop the server after verification**

Stop the foreground process with `Ctrl+C`.

Expected: the terminal returns to the shell prompt cleanly.

- [ ] **Step 4: Commit the verification-driven polish**

Run:

```bash
git add layouts/partials/academic-home.html assets/css/_custom.scss hugo.toml
git commit -m "fix: polish academic homepage layout and anchors"
```

Expected: one commit containing only fixes discovered during live verification.

### Task 9: Re-Verify the CV Build Still Works

**Files:**
- Modify: `cv/cv.yml`
- Test: `typst compile cv/cv.typ cv/cv.pdf`

- [ ] **Step 1: Rebuild the CV after homepage data changes**

Run:

```bash
typst compile cv/cv.typ cv/cv.pdf
```

Expected: exit code 0 and a regenerated `cv/cv.pdf`.

- [ ] **Step 2: Verify the output artifact still exists**

Run:

```bash
ls -lh cv/cv.pdf
```

Expected: `cv/cv.pdf` exists and has non-zero size.

- [ ] **Step 3: Commit only if a CV compatibility fix was required**

If `cv/cv.yml` or `cv/cv.typ` had to be adjusted for compatibility, run:

```bash
git add cv/cv.yml cv/cv.typ cv/cv.pdf
git commit -m "fix: keep cv build compatible with homepage data"
```

Expected: no commit is needed if the CV already compiles without changes.

### Task 10: Final Verification and Handoff

**Files:**
- Modify: `docs/superpowers/plans/2026-05-31-academic-homepage.md`
- Test: `git status --short`
- Test: `./scripts/hugo`
- Test: `typst compile cv/cv.typ cv/cv.pdf`

- [ ] **Step 1: Run the final verification commands**

Run:

```bash
./scripts/hugo
typst compile cv/cv.typ cv/cv.pdf
git status --short
```

Expected:

- Hugo build passes
- Typst CV compile passes
- `git status --short` shows only intended tracked file changes and no accidental generated output under `public/` or `resources/`

- [ ] **Step 2: Mark completed checkboxes in this plan**

Update this file so every completed step reflects reality. Do not mark any box done before the command or edit actually happened.

- [ ] **Step 3: Commit the finished implementation set**

Run:

```bash
git add assets/css/_custom.scss content/_index.md data/homepage.yml layouts/index.html layouts/partials/academic-home.html static/images/profile.jpg hugo.toml cv/cv.yml docs/superpowers/plans/2026-05-31-academic-homepage.md
git commit -m "feat: launch academic homepage"
```

Expected: one final integration commit if the branch is being kept as a single squashed feature history; otherwise skip this step and preserve the granular commits above.

## Self-Review Checklist

- Spec coverage:
  - single-page homepage: Tasks 4, 5, 8
  - research-oriented hero: Tasks 1, 2, 5, 6
  - About / Research / Publications / Software & Talks / Experience / Contact: Task 5
  - complete publication list: Tasks 1, 5, 7
  - `Download CV`: Tasks 3, 5, 8
  - portrait photo: Task 2
  - no posts/blog/news: Task 4 and Task 8
  - English, restrained design, responsive behavior: Tasks 1, 5, 6, 8
- Placeholder scan:
  - no `TODO` or `TBD` markers remain in the task steps
  - any conditional branch is tied to a specific observed build failure and has a concrete edit path
- Type consistency:
  - homepage data keys are `homepage.heroSummary`, `homepage.keywords`, `about`, `hero.affiliation`, and `contact.locationLabel`
  - anchor ids are `about`, `research`, `publications`, `software-talks`, `experience`, and `contact`
