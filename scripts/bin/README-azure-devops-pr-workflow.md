# Azure DevOps PR workflow

CLI + Neovim workflow for reviewing Azure DevOps PRs without disturbing an active checkout.

## One-time Azure DevOps CLI setup

```sh
az extension add --name azure-devops
az devops configure --defaults \
  organization=https://dev.azure.com/epiroc-it \
  project=Harmony
```

## Review someone else's PR

From any worktree of the repo:

```sh
ado-pr-list
ado-pr-open 210778
ado-pr-worktree 210778 --submodules
cd ../registrydatamanager-webapp-pr-210778
nvim .
```

Review against the PR target branch:

```sh
git diff --stat origin/main...HEAD
git diff origin/main...HEAD
git log --oneline origin/main..HEAD
```

For Neovim, use Fugitive/Diffview/Gitsigns when available:

```vim
:DiffviewOpen origin/main...HEAD
:G log --oneline origin/main..HEAD
```

Run the smallest relevant validation, for example:

```sh
dotnet build RegistryDataManager.Web/RegistryDataManager.Web.csproj
dotnet test RegistryDataManager.Tests/RegistryDataManager.Tests.csproj --filter "FullyQualifiedName~SomeFeature"
```

Use Azure DevOps web UI for final inline review comments, policy/build visibility, and approval:

```sh
ado-pr-open 210778
```

Clean up when done:

```sh
cd ../registrydatamanager-webapp
ado-pr-clean 210778 --force
```

`--force` is useful in this repo because builds can dirty generated Swagger files and worktrees with submodules may require double-force removal.

## Create your own task branch and PR

```sh
git fetch origin main
git worktree add ../registrydatamanager-webapp-211083 -b feature/211083 origin/main
cd ../registrydatamanager-webapp-211083
nvim .
# code, build, test
git push -u origin feature/211083
az repos pr create \
  --repository registrydatamanager-webapp \
  --source-branch feature/211083 \
  --target-branch main \
  --title "Task 211083: ..." \
  --description "..."
```

## Helper commands

- `ado-pr-list` — list active PRs for the current repo.
- `ado-pr-open <pr-id>` — open PR in browser.
- `ado-pr-worktree <pr-id> [path] [--submodules]` — create detached review worktree for PR source branch.
- `ado-pr-clean <pr-id> [path] [--force]` — remove review worktree.
