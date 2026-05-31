# Academic CV Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a new English academic CV in `cv/` using the Typst `imprecv` template, accurate publication metadata, and a rendered PDF.

**Architecture:** Reuse `imprecv` as the base layout, but override the default section flow so the final document reads like an academic CV instead of a general resume. Keep the data in a YAML file for template compatibility, keep publications in a local `.bib`, and compile a single Typst entrypoint that pulls both together.

**Tech Stack:** Typst 0.14.x, `@preview/imprecv:1.0.1`, YAML, BibTeX, shell verification commands

---

## File Structure

- Create: `cv/cv.typ`
- Create: `cv/cv.yml`
- Create: `cv/publications.bib`
- Create: `cv/README.md`
- Create: `cv/cv.pdf`
- Modify: `docs/superpowers/plans/2026-05-30-academic-cv.md`

### Task 1: Prepare Publication Metadata

**Files:**
- Create: `cv/publications.bib`
- Test: `sed -n '1,220p' cv/publications.bib`

- [ ] **Step 1: Gather exact BibTeX entries for the four approved works**

Run:

```bash
curl -fsSL https://arxiv.org/bibtex/2604.14269
curl -fsSL https://arxiv.org/bibtex/2409.20025
curl -fsSL https://arxiv.org/bibtex/2505.23373
curl -fsSL -H 'Accept: application/x-bibtex' https://doi.org/10.1038/s42005-024-01662-1
```

Expected: four entries with exact titles, authors, year, and canonical URLs/DOIs.

- [ ] **Step 2: Write `cv/publications.bib`**

Include one cleaned BibTeX entry per paper, preserving canonical metadata and stable citation keys.

- [ ] **Step 3: Verify the local BibTeX file**

Run: `sed -n '1,220p' cv/publications.bib`
Expected: four complete entries, readable author lists, no placeholder fields.

### Task 2: Build Academic CV Data Files

**Files:**
- Create: `cv/cv.yml`
- Create: `cv/README.md`
- Test: `sed -n '1,260p' cv/cv.yml`

- [ ] **Step 1: Write `cv/cv.yml` with the approved academic structure**

The YAML should define:
- header/contact data
- research interests
- education
- research positions
- software and talk entries
- awards

- [ ] **Step 2: Write `cv/README.md`**

Document:
- the source files
- the compile command
- the output PDF path

- [ ] **Step 3: Verify the YAML structure**

Run: `sed -n '1,260p' cv/cv.yml`
Expected: all approved sections exist, removed sections do not appear, dates are normalized.

### Task 3: Implement the Typst Entry Point

**Files:**
- Create: `cv/cv.typ`
- Test: `typst compile cv/cv.typ cv/cv.pdf`

- [ ] **Step 1: Create a Typst entrypoint that imports `@preview/imprecv:1.0.1`**

The file should:
- load `cv.yml`
- set local typography overrides using installed fonts
- override section rendering as needed for `Research Interests`, `Research Positions`, `Software & Talks`, and `Publications & Preprints`
- render the bibliography from `publications.bib`

- [ ] **Step 2: Compile the CV**

Run: `typst compile cv/cv.typ cv/cv.pdf`
Expected: exit code 0 and no missing-file errors.

- [ ] **Step 3: Verify the output artifact exists**

Run: `ls -l cv/cv.pdf`
Expected: `cv/cv.pdf` exists and has a non-zero size.

### Task 4: Final Content Verification

**Files:**
- Modify: `cv/cv.typ`
- Modify: `cv/cv.yml`
- Modify: `cv/publications.bib`
- Test: `typst compile cv/cv.typ cv/cv.pdf`

- [ ] **Step 1: Check that the final content matches the approved scope**

Verify manually against the spec:
- includes `Research Interests`, `Education`, `Research Positions`, `Publications & Preprints`, `Software & Talks`, `Awards`
- excludes 2020 cryptography, 2022 graph signal processing, and `Skills`

- [ ] **Step 2: Recompile after any final wording adjustments**

Run: `typst compile cv/cv.typ cv/cv.pdf`
Expected: exit code 0.

- [ ] **Step 3: Verify repository status**

Run: `git status --short`
Expected: only the intended `cv/` files and plan/spec changes appear.
