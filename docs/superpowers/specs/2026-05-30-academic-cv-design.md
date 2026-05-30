# Academic CV Design

Date: 2026-05-30

## Goal

Create a new English academic CV under `cv/` using the Typst `imprecv` template, based on the older CV in `personaldata/cv2022/` and the newer updates in `personaldata/resourses.md`.

The output should be a multi-page academic CV rather than a one-page industry resume.

## Confirmed Scope

The CV will include these sections in this order:

1. `Research Interests`
2. `Education`
3. `Research Positions`
4. `Publications & Preprints`
5. `Software & Talks`
6. `Awards`

The CV will not include:

- the 2020 post-quantum cryptography experience
- the 2022 graph signal processing experience
- a `Skills` section

## Header

The header will display:

- `Zhongyi Ni`
- `zni573@connect.hkust-gz.edu.cn`
- `+86 131-2271-2162`
- `github.com/nzy1997`
- `Guangzhou, China`

## Content Decisions

### Research Interests

Keep this brief and aligned with the current academic profile:

- quantum error correction
- tensor networks
- variational quantum algorithms
- quantum control

### Education

Include:

- B.S. in Mathematics and Applied Mathematics, Fudan University
- B.S. in Electronic Information Science and Technology, Fudan University
- Ph.D. studies at The Hong Kong University of Science and Technology (Guangzhou), `2023-present`

### Research Positions

Only include the positions explicitly approved by the user:

- Research Assistant, Shanghai Qi Zhi Institute, `Jul 2022 - Jun 2023`
- Ph.D. Student, The Hong Kong University of Science and Technology (Guangzhou), `2023 - present`
- Visiting Student, Institute for Advanced Study, Tsinghua University, `Jul 2025 - Jul 2026`

The Tsinghua visiting role remains inside `Research Positions`, not in a separate section.

### Publications & Preprints

Use accurate bibliographic metadata rather than handwritten titles from notes. The current source list is in `personaldata/resourses.md`, and the implementation should fetch or reconstruct a clean BibTeX file for the listed works.

All four listed papers are the user's own works, though authorship order differs. The final CV should therefore treat them as publications/preprints, not as reading references.

The implementation should:

- gather exact title, author, venue, year, and URL metadata for the listed papers
- generate a local `.bib` file for the CV
- render the publication list in a standard academic style
- emphasize the user's own name in author lists if the template supports it cleanly

### Software & Talks

Include only research-relevant scholarly outputs:

- `TensorQEC.jl`
- relevant contribution mention for `QuantumClifford.jl` if supportable from existing materials
- JuliaCon talk on tensor networks for quantum error correction

Avoid inflating this section with unrelated links or generic software skills.

### Awards

Carry over the awards already present in the older CV unless implementation finds contradictory newer data:

- China Mathematics Olympic silver medal
- Fudan University scholarships
- Shenzhen Cup mathematical modeling award

## Sources Of Truth

Primary local sources:

- `personaldata/cv2022/cv.tex`
- `personaldata/cv2022/ref.bib`
- `personaldata/resourses.md`

External verification is appropriate for publication metadata and the current `imprecv` template usage.

## Deliverables

Implementation should produce:

- a Typst CV source file under `cv/`
- a BibTeX file under `cv/`
- any minimal supporting assets needed by the template
- a rendered PDF under `cv/`

## Constraints

- Write the CV in English
- Use the Typst `imprecv` template
- Keep the structure conservative and academic
- Prefer concise, factual wording over narrative prose
- Keep edits scoped to the `cv/` area and necessary supporting files only
