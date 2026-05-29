# LoveIt Hugo Site Initialization Design

## Goal

Initialize `/Users/nzy/mcode/zhongyi.github.io` as the final repository for a Hugo site using the LoveIt theme, with a reproducible local environment that avoids global version drift.

## Scope

This design covers environment initialization only:

- initialize the directory as a git repository
- scaffold a standard Hugo site structure
- attach the LoveIt theme from its recommended stable branch
- pin a Hugo Extended version compatible with LoveIt 0.3.x
- provide a local command or script to run the site preview

This design does not cover academic homepage content, navigation structure, or visual customization beyond what is required to boot the site successfully.

## Constraints

- The current directory is empty and should become the final site repository.
- The user chose a stable, repository-local setup over a global Homebrew-managed Hugo installation.
- LoveIt currently recommends 0.3.x, and its README states compatibility with Hugo 0.128.0 through 0.145.0.
- Homebrew currently exposes Hugo 0.162.1, which is outside the recommended LoveIt 0.3.x range.

## Approaches Considered

### Approach 1: Global Homebrew Hugo + Git Submodule Theme

Use Homebrew to install `hugo`, then wire `themes/LoveIt` as a git submodule.

Pros:
- fast local setup
- familiar command surface

Cons:
- current Homebrew Hugo is newer than LoveIt's recommended range
- future global upgrades can silently change local behavior
- reproducibility is weaker across machines

### Approach 2: Repository-Local Hugo Binary + Git Submodule Theme

Keep the theme as a git submodule and pin a compatible Hugo Extended binary through repository-local tooling.

Pros:
- reproducible and isolated
- no dependency on global Hugo version
- easier to share exact setup instructions later

Cons:
- requires one more bootstrap artifact in the repository
- slightly more setup work up front

## Recommended Design

Use Approach 2.

1. Initialize the current directory as a normal git repository.
2. Scaffold a Hugo site directly in the repository root.
3. Add `themes/LoveIt` as a submodule tracking the upstream `release` branch.
4. Pin a Hugo Extended version in the repository and expose it through a small local runner script.
5. Start from LoveIt's `exampleSite/hugo.toml` as the base configuration, then trim it only as needed for a clean boot.

## Repository Layout

Expected top-level layout after initialization:

- `.git/`
- `.gitmodules`
- `archetypes/`
- `assets/`
- `content/`
- `data/`
- `layouts/`
- `static/`
- `themes/LoveIt/`
- `hugo.toml`
- `scripts/`
- `.gitignore`

The pinned Hugo binary should live outside tracked content if practical, or be fetched into a predictable local tools directory that is ignored by git.

## Versioning Strategy

- Theme source: `https://github.com/dillonzq/LoveIt.git`
- Theme branch: `release`
- Hugo flavor: Extended
- Hugo version target: a version within `0.128.0 - 0.145.0`

The exact Hugo patch version should be selected based on currently available upstream release artifacts for macOS arm64, with preference for the latest patch within LoveIt's documented compatible range.

## Run Experience

After initialization, local preview should be one project-local command such as:

```bash
./scripts/hugo-server
```

That command should:

- resolve the pinned Hugo binary
- fail with a clear message if the binary is missing
- run `hugo server` from the repository root

## Verification

Initialization is considered complete when:

- `hugo version` from the pinned binary reports a compatible version
- `themes/LoveIt` exists and is readable
- `hugo server` starts successfully from the project root
- the site builds without immediate configuration errors

## Risks and Mitigations

### Risk: LoveIt recommended range is narrower than its minimum supported range

Mitigation:
- use the documented recommended line, not the looser minimum-only constraint

### Risk: Git submodule branch tracking drifts unexpectedly

Mitigation:
- record the submodule commit in the repository and keep branch metadata only as update intent

### Risk: Hugo artifact download naming differs by platform

Mitigation:
- inspect current release assets before scripting the fetch logic
