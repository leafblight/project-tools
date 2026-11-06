# project-tools

Small command-line helpers for everyday work.

## Install

```bash
./install.sh
```

This symlinks every script in `bin/` into `~/.local/bin`. If that directory is not on your `PATH`, it is added to your `~/.zshrc` / `~/.bashrc` (restart your shell or `source` the file afterwards).

- Scripts are linked, not copied — editing or `git pull`-ing this repo updates them automatically.
- Existing non-symlink files with the same name are never overwritten; they are skipped with a message.
- Re-run `./install.sh` after adding new scripts to `bin/`. It is safe to run multiple times.
- To install somewhere else: `DEST_DIR=/some/dir ./install.sh`.

## Tools

### `myjira` — list your open Jira tickets

Lists all Jira issues assigned to you that are not done (To Do, In Progress, In Review, On Hold, Ready For Test, …), grouped by status.

Requires `curl`, `jq` and `column`.

#### Get a Jira token (one-time)

1. In Jira, click your avatar → **Profile** → **Personal Access Tokens** → **Create token**.
2. Save it:

   ```bash
   mkdir -p ~/.config && echo 'YOUR_TOKEN' > ~/.config/jira-token && chmod 600 ~/.config/jira-token
   ```

   Alternatively, export `JIRA_TOKEN` in your shell config.

#### Usage

```bash
myjira                                                  # open tickets assigned to you
myjira 'project = UU AND status = "Ready For Test"'     # any custom JQL
```

Defaults to `https://jira.fnox.se`; override with `JIRA_URL=...`.

No output usually means the token is missing, wrong or expired.
