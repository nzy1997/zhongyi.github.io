# GitHub Pages Deploy Design

Date: 2026-06-01

## Goal

Publish the existing Hugo-based personal website in this repository to the GitHub Pages user-site URL:

`https://nzy1997.github.io/`

The deployment should be automatic so that future pushes to the default branch trigger a rebuild and publish flow without any manual upload step.

## Confirmed Scope

Included:

1. Deploy the current Hugo site to GitHub Pages
2. Use the GitHub Pages user-site domain `https://nzy1997.github.io/`
3. Configure automatic deployment from the repository's default branch
4. Preserve the existing Hugo + LoveIt site structure
5. Verify that the generated site includes homepage assets and the mounted `cv/` static output

Excluded:

- custom domain setup
- homepage redesign
- content editing
- analytics, comments, or other post-launch integrations
- migration to another hosting provider

## Current Repository State

The repository already matches the core requirements for a GitHub Pages user site:

- repository name is `nzy1997.github.io`
- Hugo configuration sets `baseURL = "https://nzy1997.github.io/"`
- the site is built with Hugo and the `LoveIt` theme
- the theme is stored as a git submodule under `themes/LoveIt`
- `cv/` is mounted into `static/cv`, so generated site output must preserve `/cv/*` URLs

This means the remaining work is deployment automation rather than site reconstruction.

## Deployment Options Considered

### Option A: GitHub Actions Deploy To GitHub Pages

Use an Actions workflow that:

1. checks out the repository with submodules
2. installs or configures Hugo
3. builds the site
4. uploads the generated artifact
5. deploys to GitHub Pages

Pros:

- matches current GitHub and Hugo guidance
- keeps build environment consistent
- no separate publish branch to maintain
- future deploys happen automatically on push

Cons:

- requires one-time repository Pages setting update to `GitHub Actions`

### Option B: Local Build And Push `gh-pages`

Build locally and publish generated files to a deployment branch.

Pros:

- conceptually simple

Cons:

- relies on local machine state
- easy to drift from reproducible builds
- adds unnecessary branch management

### Option C: External Hosting Platform

Move deployment to a platform like Netlify or Vercel.

Pros:

- workable for Hugo

Cons:

- unnecessary extra platform for this repository
- weak fit when the repository is already named for a GitHub Pages user site

## Selected Approach

Use Option A: GitHub Actions deployment to GitHub Pages.

This is the smallest and most maintainable path for the current repository. It aligns with the repository naming, the configured base URL, and the user's request for automatic publishing.

## Workflow Design

The repository will add a workflow file at:

`/.github/workflows/hugo.yml`

Expected workflow behavior:

1. Trigger on pushes to the default branch and optionally on manual dispatch
2. Grant the minimal permissions required for Pages deployment
3. Set up the Pages environment
4. Check out the repository with recursive submodule support so `themes/LoveIt` is available
5. Set up a Hugo version compatible with the site
6. Build the site into Hugo's publish directory
7. Upload the generated site as the Pages artifact
8. Deploy the artifact using the official Pages deploy action

The workflow should use GitHub-maintained Pages actions and should not introduce custom publish scripts unless they are needed for this repository.

## GitHub Repository Settings

One repository-side setting is required:

- In GitHub Pages settings, set the build and deployment source to `GitHub Actions`

No custom domain configuration is needed in this phase. No `CNAME` file should be added.

## Hugo Build Considerations

The workflow design must preserve these repository-specific details:

### Theme Submodule

The `LoveIt` theme lives in `themes/LoveIt`, so checkout must include submodules. Without that, the build will fail or render incorrectly.

### Base URL

`hugo.toml` points to `https://nzy1997.github.io/`, which is correct for the current GitHub Pages user site and should remain unchanged.

### CV Static Mount

`hugo.toml` mounts `cv/` to `static/cv`. The deploy flow must build the full site output so that `cv/cv.pdf` and any related static files remain reachable after deployment.

## Validation Requirements

The deployment work is complete only if the following conditions are satisfied:

1. The site builds successfully in the local repository
2. The GitHub Actions workflow file is syntactically valid
3. The workflow checks out submodules correctly
4. The repository can be configured to deploy from `GitHub Actions`
5. After deployment, `https://nzy1997.github.io/` loads successfully
6. The homepage static assets load without broken paths
7. `https://nzy1997.github.io/cv/cv.pdf` is reachable

## Risks And Mitigations

### Missing Theme During CI

Risk:
The Actions runner checks out the repository without submodules, causing the Hugo build to fail.

Mitigation:
Configure checkout with recursive submodules enabled.

### GitHub Pages Source Misconfiguration

Risk:
The workflow succeeds but Pages is still configured for branch-based deployment, so the site does not publish.

Mitigation:
Explicitly switch repository Pages settings to `GitHub Actions`.

### Hidden Build Dependency Mismatch

Risk:
The local helper scripts and CI environment use different Hugo behavior.

Mitigation:
Run a local build verification and use a pinned Hugo setup in Actions.
