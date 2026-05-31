# Academic Homepage Design

Date: 2026-05-31

## Goal

Create a research-oriented personal academic homepage for Zhongyi Ni within the existing Hugo + LoveIt site in this repository.

The site should present current academic identity, research directions, publications, software, talks, experience, and contact information in a single English homepage. It should feel like a formal academic website rather than a blog or a generic personal profile page.

## Confirmed Scope

The implementation will produce a single-page homepage with anchored sections and no separate blog workflow.

Included:

1. A research-oriented hero section
2. A short academic about section
3. A research interests section
4. A complete publications list
5. A software and talks section
6. A concise experience section
7. A contact section
8. A prominent `Download CV` action linking to `cv/cv.pdf`
9. A portrait photo on the homepage

Excluded:

- blog/posts navigation
- news or updates timeline
- Google Scholar, ORCID, or ResearchGate links
- multi-language support
- a separate publications page
- automatic BibTeX-to-page generation machinery

## Information Architecture

The homepage will be a single scrolling page with a fixed top navigation bar that links to anchored sections on the same page.

Recommended section order:

1. `Hero`
2. `About`
3. `Research Interests`
4. `Publications`
5. `Software & Talks`
6. `Experience`
7. `Contact`

This order is intentional:

- the first screen establishes current research identity
- the middle of the page emphasizes publications and scholarly output
- later sections provide supporting context without distracting from the main academic signal

## Hero Section

The hero section is the primary first impression and should be research-led rather than profile-card-led.

Content:

- `Zhongyi Ni`
- current title: `PhD Student in Physics`
- institution context derived from the current academic role
- a concise one-sentence research summary in English
- research keywords
- primary actions: `Download CV`, `GitHub`, `Email`
- portrait photo placed to the right on desktop

Layout behavior:

- desktop: text on the left, portrait on the right
- mobile: single-column flow with text first and photo after or beneath the opening content

The hero must make it immediately clear what Zhongyi Ni works on, not just who he is.

## Section Content

### About

This section will contain a short, formal English paragraph describing the current academic position, research area, and broad interests.

The text should be concise, factual, and suitable for an academic homepage. It should not read like a long autobiography or a grant statement.

### Research Interests

This section will present a short list of current themes derived from `cv/cv.yml`:

- quantum error correction
- tensor networks
- variational quantum algorithms
- quantum control

The presentation can be compact, but the items should be visually distinct for quick scanning.

### Publications

This section will display the complete list of publications and preprints currently represented in the CV materials.

Requirements:

- show the full list on the homepage
- order items in reverse chronological order
- include authors, title, venue or arXiv information, and outbound link
- preserve a clean academic citation feel rather than a marketing card layout

The publication list is one of the central sections of the homepage and should be optimized for readability.

### Software & Talks

This section will highlight scholarly software and research-facing outputs.

Included items:

- `TensorQEC.jl` as the primary software project
- `QuantumClifford.jl` as a contributor role, not as the main project
- the JuliaCon talk on tensor networks for quantum error correction

The section should frame these as academic outputs and technical contributions, not as a general portfolio gallery.

### Experience

This section will summarize relevant academic and research positions:

- Research Assistant, Shanghai Qi Zhi Institute
- PhD Student, HKUST (Guangzhou)
- Visiting Student, Institute for Advanced Study, Tsinghua University

The presentation should be concise and timeline-like, without turning the homepage into a full CV page.

### Contact

The closing section will contain:

- email
- GitHub
- CV link
- current location

This section should be minimal and direct.

## Content Sources And Maintenance Model

The homepage should use `cv/cv.yml` as the primary structured data source.

Primary source responsibilities:

- `cv/cv.yml`: personal identity, research interests, positions, projects, publications, and related structured academic data
- `cv/cv.pdf`: downloadable CV target
- homepage portrait: stored in a site-managed asset location
- `personaldata/resourses.md`: reference-only source used to cross-check links, wording, and any items not yet normalized into `cv/cv.yml`

Rationale:

- `cv/cv.yml` is already structured and close to the homepage data model
- using it reduces duplication between the CV and the homepage
- `personaldata/resourses.md` is useful as source material, but not as the long-term rendering source

The homepage may include a hand-written short English `About` paragraph because that content does not fit cleanly into the CV schema.

## Technical Approach

The site will remain within the existing Hugo + LoveIt stack and reuse the theme's overall infrastructure:

- header behavior
- SEO plumbing
- responsive baseline
- theme styling foundation

The homepage itself should use a custom single-page layout rather than relying only on the default LoveIt profile homepage.

This approach keeps the implementation aligned with the repository's current framework while allowing the homepage to behave like a proper academic site instead of a blog-first theme landing page.

## Visual Direction

The visual tone should be restrained, readable, and academic.

Guidelines:

- avoid a flashy landing-page aesthetic
- keep typography and spacing clear and calm
- emphasize text readability and citation scanning
- use a clean list treatment for publications
- keep software, talks, and experience sections compact
- avoid card-heavy presentation for core academic content
- preserve a professional desktop layout and a stable single-column mobile layout

The site should feel closer to a university research homepage than to a startup landing page.

## Navigation Model

The main navigation should contain only homepage section anchors relevant to the academic page.

Expected behavior:

- no `Posts` entry
- no dead-end links to empty sections
- top navigation scrolls to the corresponding section on the homepage

This keeps the site aligned with the user's current content volume and avoids exposing empty secondary pages.

## Constraints

- write the public-facing site in English
- keep the site single-page for now
- prioritize current academic identity over general biography
- keep the implementation conservative and maintainable
- do not introduce a heavy content-generation pipeline for publications
- avoid creating multiple competing sources of truth for the same academic data

## Validation Requirements

Implementation will be considered complete only if the following checks pass:

1. Hugo builds successfully
2. the local development server renders the homepage correctly
3. navigation anchors jump to the correct sections
4. `Download CV` opens `cv/cv.pdf`
5. publication, GitHub, email, and talk links are present and clickable
6. desktop and mobile layouts do not show overlapping or overflowing text
7. homepage content remains consistent with `cv/cv.yml` and `personaldata/resourses.md`

## Risks And Mitigations

### Theme Default Bias

Risk:
LoveIt's default homepage behavior is closer to a blog or personal profile than to a research homepage.

Mitigation:
Use a custom homepage layout while keeping the rest of the theme infrastructure intact.

### Split Source Material

Risk:
Academic information currently exists in both `cv/` and `personaldata/`.

Mitigation:
Treat `cv/cv.yml` as the primary source and `personaldata/resourses.md` as a verification reference only.

### Future Publication Growth

Risk:
The full publication list is manageable now but could become long later.

Mitigation:
Keep the first version single-page; split into a dedicated publications page only when the content volume justifies it.

## Deliverables

Implementation should produce:

- a customized homepage within the Hugo site
- homepage section navigation via anchors
- a site-managed portrait asset
- a working `Download CV` link to `cv/cv.pdf`
- content populated from the approved academic materials

## Success Criteria

The finished site should let a visitor understand, within one page:

- who Zhongyi Ni is academically
- what research topics he works on
- what publications and software outputs he has produced
- how to access his CV and contact him

If those goals are met without exposing unused blog structure or unnecessary complexity, the design is successful.
