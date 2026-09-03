# Pi installation restore

Source of truth for the user-level Pi setup lives in this dotfiles repo.

## Tracked state

- Global Pi settings: `pi/.pi/agent/settings.json`
- Global first-party skills/prompts/extensions: `pi/.pi/agent/`
- Repo-local Pi resources for this dotfiles repo: `.pi/`
- Third-party Pi packages: `packages` in `pi/.pi/agent/settings.json`

Pi also discovers shared Agent Skills from `~/.agents/skills`; those are managed outside Pi and are not part of this Pi restore path unless separately stowed or reinstalled by their own tool.

Do not commit Pi runtime state such as `auth.json`, `trust.json`, `sessions/`, `npm/`, `git/`, logs, or model caches.

## Restore on a new machine

1. Install Pi and GNU Stow.
2. Clone this repo to `~/.dotfiles`.
3. Stow the Pi package:

   ```bash
   cd ~/.dotfiles
   stow pi
   ```

4. Install the pinned Pi packages:

   ```bash
   pi update --extensions
   pi list
   ```

If the full dotfiles install is desired, run `./stow_install.sh` instead of `stow pi`.

## Adding future Pi packages or skills

- Prefer package installs over copying third-party skills directly into `~/.pi/agent/skills`.
- Pin npm packages with an explicit version, for example `npm:package-name@1.2.3`.
- Pin git packages with a tag or commit SHA, for example `https://github.com/user/repo@<commit-sha>`.
- After installing, commit the changed `pi/.pi/agent/settings.json`.
- Keep personal skills you author in `pi/.pi/agent/skills/<name>/SKILL.md` so Stow can recreate them.

Current pinned third-party packages are recorded in `pi/.pi/agent/settings.json`.
