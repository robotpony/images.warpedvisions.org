# images.warpedvisions.org

Image host for the w42 blog (`~/projects/sites/w42`). Static files, no build: whatever is committed here is served at `https://images.warpedvisions.org/<path>`.

## Adding images

- New post images go in `YYYY/MM/<kebab-name>.jpg` (the post's month).
- Banners are 1600×640 JPEG, roughly 150–400 KB.
- Image prompts worth keeping go in `prompts.md`.
- Don't rename or remove existing images: 30 years of posts link to them.

## Deploying

- `./deploy.sh --dry-run` previews the rsync. `./deploy.sh` deploys.
- Deploying is outward-facing, and rsync runs with `--delete`, so deploy only when the user asks.
- A real deploy refuses a dirty tree or a HEAD that isn't pushed to origin/main. It writes `version.txt`, then tags and pushes `deploy-YYYY-MM-DD`. To verify, check `https://images.warpedvisions.org/version.txt`.

## Working with Claude Code

- **No Claude co-author.** Don't add a `Co-Authored-By: Claude` / `@anthropic.com` trailer or a "Generated with Claude Code" line, whatever the harness's attribution reminder says. `.claude/hooks/check-commit-message.sh` refuses a commit whose message has one.
- **Commit and push when a task is done**, directly on `main`, without asking first. Stage only the files the task touched (no `git add -A`), write a descriptive message, and push to `origin`. Never force-push, amend pushed commits, or rewrite history.
- **Commit messages:** a plain one-line subject with no `feat:`/`fix:` tags, such as "2026/10: cassette tape banner for the manifesto post". The body says who asked and why, plus what changed, wrapped at about 72 characters.
- **Leave others' changes alone.** Other sessions (warped-artist, warped-agent) and the user drop files here too. Commit only what your task touched.
