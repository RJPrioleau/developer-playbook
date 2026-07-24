# PROJECT_CHECKLIST.md

## 🎯 Purpose

Provide a repeatable checklist for creating a new Python software project from scratch.

The goal is to ensure every project begins with a consistent structure, isolated environment, dependency management,
documentation, and Git workflow.

---

## ⏱️ Estimated Setup Time

15–30 minutes (assuming the development workstation has already been configured).

---

## 🤔 Philosophy

Every new project should begin with the same repeatable process.

Each step should include:

- The task
- The command(s)
- Verification
- Notes

The objective is to eliminate guesswork and create consistency across every software project.

---

## Start a Guided Project Setup

Use this option when you want an AI assistant to guide you through the checklist
and explain the terminal commands as you run them.

### Step 1 - Open the Developer Playbook

Before starting the conversation, make sure `developer-playbook` is open as the
current project in PyCharm. This gives the AI assistant access to this checklist
and the reusable AI collaboration templates.

### Step 2 - Send the Starting Prompt

```text
Read docs/PROJECT_CHECKLIST.md. Help me create a new project using the checklist, including the reusable AI collaboration templates. Teach me as we go.
```

The assistant should gather the new project's details before creating anything,
guide you through one verified phase at a time, and explain what each command
does rather than assuming you already know it.

---

# Workflow 1 - Create a New Project

---

# Phase 1 - Create the Project

## Create the Project Directory

- [ ] Project directory created

### General Pattern

```powershell
mkdir <project-name>
cd <project-name>
```

### Example

```powershell
mkdir developer-playbook
cd developer-playbook
```

### Verification

```powershell
pwd
```

Confirm PowerShell is inside the new project directory.

### Notes

---

# Phase 2 - Initialize Git

## Method 1 - Create a Local Git Repository

- [ ] Repository initialized

### Command

```powershell
git init
```

### Verification

```powershell
git status
```

Expected Result:

Git reports that the current directory is now a Git repository.

### Notes

## Method 2 - Create and Connect a GitHub Repository with GitHub CLI

Use this method when the project should begin with both a local Git repository and a connected GitHub repository.

- [ ] GitHub CLI available
- [ ] GitHub authentication verified
- [ ] Local Git repository initialized
- [ ] GitHub repository created
- [ ] `origin` remote added
- [ ] Repository identity and visibility verified

### Step 1 - Verify GitHub CLI

```powershell
gh --version
```

This confirms that GitHub CLI is installed and available through `PATH`.

### Step 2 - Verify GitHub Authentication

```powershell
gh auth status
```

Confirm the intended GitHub account is active and the token includes the `repo` scope. Never share an unmasked
authentication token.

### Step 3 - Initialize the Local Repository

```powershell
git init -b main
```

The `-b main` option explicitly names the initial branch `main`.

### Step 4 - Create and Connect the GitHub Repository

#### Private Repository

```powershell
gh repo create <project-name> --private --source=. --remote=origin
```

#### Public Repository

```powershell
gh repo create <project-name> --public --source=. --remote=origin
```

#### Real-World Example

```powershell
gh repo create recipe-dashboard --public --source=. --remote=origin
```

Command breakdown:

- `gh repo create <project-name>` creates the repository under the active GitHub account.
- `--private` or `--public` sets repository visibility.
- `--source=.` identifies the current local Git repository as the source.
- `--remote=origin` adds the new GitHub repository as the conventional `origin` remote.

Do not include `--push` before the initial commit exists.

### Step 5 - Verify the Local Remote

```powershell
git remote -v
```

Confirm that both fetch and push URLs for `origin` point to the intended GitHub repository.

### Step 6 - Verify GitHub Repository Metadata

```powershell
gh repo view --json nameWithOwner,visibility,url
```

Confirm the repository owner, name, visibility, and URL.

### Notes

Choose either Method 1 or Method 2. Do not initialize the same local repository twice.

Method 2 was verified while creating the public
`RJPrioleau/recipe-dashboard` repository from an empty local Git repository.
---

# Phase 3 - Create the Virtual Environment

## Create Virtual Environment

- [ ] Virtual environment created

### General Pattern

```powershell
python -m venv <environment-name>
```

### Recommended Command

```powershell
python -m venv venv
```

### Verification

Confirm the following folder exists:

```text
venv\
```

### Notes

Use `venv` as the standard virtual environment name for all Python projects.

---

## Activate Virtual Environment

- [ ] Virtual environment activated

### Command

```powershell
.\venv\Scripts\Activate.ps1
```

### Verification

The PowerShell prompt should begin with:

```text
(venv)
```

Example:

```text
(venv) PS C:\Users\<username>\Python-Projects\<project-name>>
```

### Notes

The virtual environment isolates project dependencies from the rest of the system.

---

# Phase 4 - Configure Git Ignore

## Create .gitignore

- [ ] .gitignore created

### Command

```powershell
New-Item .gitignore
```

### Recommended Starting Contents

```gitignore
# Virtual Environment
venv/
.venv/

# Python
__pycache__/
*.py[cod]

# PyCharm
.idea/

# Environment Variables
.env
.env.*

# Operating System
.DS_Store
Thumbs.db

# Logs
*.log
*.tmp
```

### Verification

```powershell
git status
```

Confirm that ignored files (such as `venv/` and `.idea/`) do not appear as untracked files.

### Notes

Only ignore files that are machine-specific, automatically generated, temporary, or contain sensitive information.

---

# Phase 5 - Dependency Management

## Upgrade pip

- [ ] pip upgraded

### Command

```powershell
python -m pip install --upgrade pip
```

### Verification

```powershell
pip --version
```

### Notes

---

## Install Project Dependencies

- [ ] Initial dependencies installed

### General Pattern

```powershell
pip install <package-name>
```

### Example

```powershell
pip install pandas flask requests
```

### Notes

Install only the packages currently required by the project.

---

## Create requirements.txt

- [ ] requirements.txt created

### Command

```powershell
pip freeze > requirements.txt
```

### Verification

```powershell
Get-Content requirements.txt
```

Confirm installed package names and versions are listed.

### Notes

Commit `requirements.txt`.

Do **not** commit the `venv` directory.

The virtual environment is disposable.

`requirements.txt` is the portable description of the project's dependencies.

---

# Phase 6 - Create Project Documentation

## Create README

- [ ] README.md created

```powershell
New-Item README.md
```

---

## Create Roadmap

- [ ] ROADMAP.md created

```powershell
New-Item ROADMAP.md
```

---

## Create Changelog

- [ ] CHANGELOG.md created

```powershell
New-Item CHANGELOG.md
```

---

## Add AI Collaboration Files

- [ ] Developer Playbook synchronized
- [ ] `AGENTS.md` copied to the project root
- [ ] `COLLABORATION.md` copied to the project's `docs` directory
- [ ] Project placeholders replaced
- [ ] Collaboration files verified

These files preserve the established AI collaboration, teaching, machine-switch, and session-handoff workflows in every
new project.

Run the following commands from the **new project's root directory**. This procedure assumes the new project and
`developer-playbook` are sibling directories inside the same `PycharmProjects` directory.

Expected starting layout:

```text
PycharmProjects/
├── developer-playbook/
└── <project-name>/       <- PowerShell must be here
```

### Step 1 - Confirm the Current Directory

```powershell
Get-Location
```

Confirm the displayed path ends with the new project's directory name. Do not run the copy commands from inside
`developer-playbook`.

### Step 2 - Locate and Synchronize the Developer Playbook

```powershell
$playbookRoot = (Resolve-Path '..\developer-playbook').Path
git -C $playbookRoot pull
```

What these commands do:

- `Resolve-Path` finds the full path to the sibling `developer-playbook` repository.
- `.Path` stores that path as plain text in `$playbookRoot`.
- `git -C $playbookRoot pull` updates the Playbook before its templates are copied.

Expected Git result:

```text
Already up to date.
```

If `Resolve-Path` reports that the path does not exist, the repositories are not siblings. Set the path explicitly
instead:

```powershell
$playbookRoot = 'C:\Users\<username>\PycharmProjects\developer-playbook'
```

Replace `<username>` with the Windows account-directory name shown in `Get-Location`.

### Step 3 - Confirm the Destination Files Do Not Already Exist

```powershell
Test-Path -LiteralPath '.\AGENTS.md'
Test-Path -LiteralPath '.\docs\COLLABORATION.md'
```

Both commands should return:

```text
False
```

If either command returns `True`, stop and inspect that file. Do not overwrite an existing project's instructions or
handoff history with a fresh template.

### Step 4 - Create the Documentation Directory

```powershell
New-Item -ItemType Directory -Path '.\docs' -Force
```

`-Force` makes this safe when the `docs` directory already exists. It does not delete or replace files inside the
directory.

### Step 5 - Copy Both Templates

```powershell
Copy-Item -LiteralPath (Join-Path $playbookRoot 'templates\ai-collaboration\AGENTS.md') -Destination '.\AGENTS.md'
Copy-Item -LiteralPath (Join-Path $playbookRoot 'templates\ai-collaboration\COLLABORATION.md') -Destination '.\docs\COLLABORATION.md'
```

#### Verify Copy Integrity

```powershell
Get-FileHash -LiteralPath (Join-Path $playbookRoot 'templates\ai-collaboration\AGENTS.md'), '.\AGENTS.md'
Get-FileHash -LiteralPath (Join-Path $playbookRoot 'templates\ai-collaboration\COLLABORATION.md'), '.\docs\COLLABORATION.md'
```

Each source-and-destination pair must report the same SHA-256 hash. Matching hashes prove that the intended template was
copied without modification.

If a pair does not match, inspect the source and destination before continuing. Do not customize or commit the files
until both copies are verified.

The resulting project layout should include:

```text
<project-name>/
├── AGENTS.md
└── docs/
    └── COLLABORATION.md
```

The files are copied, not linked. Each project keeps its own instructions, project-specific decisions, and continuity
history.

### Step 6 - Replace the AGENTS.md Placeholders

Open the new project's `AGENTS.md` in PyCharm. Replace every angle-bracket placeholder as follows:

| Placeholder                                          | Replace it with                                                                                | Example                                                                    |
|------------------------------------------------------|------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `<PROJECT_NAME>`                                     | The human-readable project name                                                                | `Expense Tracker`                                                          |
| `<ONE_SENTENCE_PROJECT_PURPOSE>`                     | One sentence describing what the project is intended to do                                     | `Build a local application for recording and reviewing personal expenses.` |
| `<PRIMARY_RUN_COMMAND>`                              | The normal PowerShell command used to start the project                                        | `python app.py`                                                            |
| `<PRIMARY_VERIFICATION_COMMAND>`                     | The normal command used to run the project's main test or verification suite                   | `python -m pytest`                                                         |
| `<OPTIONAL_PROJECT_DOCUMENTATION>`                   | A real project-specific document and its purpose, or delete the entire bullet when none exists | `docs/data_dictionary.md — field definitions and data contracts.`          |
| `<PROJECT_SPECIFIC_INSTRUCTION_OR_REMOVE_THIS_LINE>` | A durable rule unique to this repository, or delete the bullet when none has been established  | `Keep database migrations backward compatible.`                            |

If the run or verification command has not been established yet, replace the placeholder with `Not established yet`
rather than guessing or leaving the placeholder unresolved. Update it when the real command is proven.

Do not add speculative project rules. Add project-specific instructions only when the project creates a real need for
them.

`docs/COLLABORATION.md` contains reusable workflow standards and normally requires no project-specific editing.

### Step 7 - Verify the Copied and Customized Files

```powershell
Get-Item -LiteralPath '.\AGENTS.md', '.\docs\COLLABORATION.md'
Select-String -Path '.\AGENTS.md', '.\docs\COLLABORATION.md' -Pattern '<[A-Z0-9_]+>'
git status --short
```

Expected results:

- `Get-Item` lists both files.
- `Select-String` produces no output, confirming no template placeholders remain.
- `git status --short` lists `AGENTS.md` and `docs/` as new project files.

Read the customized `AGENTS.md` once before the initial commit. Confirm that its project name, purpose, commands,
documentation links, and project-specific instructions are accurate.

---

# Phase 7 - Create Initial Project Structure

- [ ] Initial project structure created

### Example

```text
<project-name>/
│
├── README.md
├── ROADMAP.md
├── CHANGELOG.md
├── AGENTS.md
├── requirements.txt
├── .gitignore
├── app.py
├── docs/
│   └── COLLABORATION.md
├── tests/
└── venv/
```

### Notes

Create folders only when they serve an actual purpose.

Avoid creating unnecessary directories "just in case."

---

# Phase 8 - First Commit

- [ ] Initial files staged

- [ ] Initial commit created

- [ ] Repository pushed to GitHub

### Commands

```powershell
git add .
git commit -m "Initialize project structure"
```

### First Push After GitHub CLI Repository Creation

```powershell
git push -u origin main
```

The first push publishes `main` and sets `origin/main` as its upstream branch. After upstream tracking exists, later
pushes can use:

```powershell
git push
```

### Verification

```powershell
git status
```

Expected Result:

```text
nothing to commit, working tree clean
```

---

# Workflow 2 - Clone an Existing Project

Use this workflow to continue work on an existing GitHub repository from a new
computer. Run every command from PowerShell and follow the repository's own
instructions when they differ from the general examples below.

## Step 1 - Open the Standard Workspace

New repositories belong under the standard workspace. Existing repositories in
other locations should remain where they are until a separate migration is
planned.

```powershell
Set-Location "$env:USERPROFILE\Python-Projects"
Get-Location
```

Expected location:

```text
C:\Users\<username>\Python-Projects
```

## Step 2 - Verify GitHub Access

```powershell
gh auth status
```

Confirm that the intended GitHub account is active and that the Git operations
protocol is HTTPS.

List repositories when the exact repository name is not known:

```powershell
gh repo list <owner> --limit 100
```

## Step 3 - Check the Destination

Before cloning, confirm that a directory with the repository name does not
already exist:

```powershell
Test-Path -LiteralPath ".\<repository-name>"
```

Expected result:

```text
False
```

If the result is `True`, stop and inspect the existing directory. Do not clone
over it, rename it, or delete it without first determining whether it contains
another clone or uncommitted work.

## Step 4 - Clone the Repository

```powershell
gh repo clone <owner>/<repository-name>
```

Closing the terminal after this command does not undo a successful clone. Open
a new PowerShell terminal and verify the repository without cloning it again:

```powershell
git -C ".\<repository-name>" status
```

Expected result:

```text
On branch <branch-name>
Your branch is up to date with 'origin/<branch-name>'.

nothing to commit, working tree clean
```

## Step 5 - Enter and Inspect the Repository

```powershell
Set-Location ".\<repository-name>"
Get-ChildItem -Force
```

Read the repository instructions before creating an environment or installing
dependencies:

```powershell
Get-Content .\README.md
Get-Content .\AGENTS.md
```

Also inspect the dependency file named by the repository. For a Python project
using `requirements.txt`:

```powershell
Get-Content .\requirements.txt
```

## Step 6 - Verify the Required Python

Check the project documentation for its required Python version, then inspect
the interpreter that will create the virtual environment:

```powershell
python --version
python -c "import sys; print(sys.executable)"
```

Do not create the environment with an incompatible interpreter. Install or
select the required Python version first.

## Step 7 - Create and Activate the Virtual Environment

Virtual environments are machine-specific and should be recreated after
cloning rather than copied between computers:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Verify that the active interpreter is inside the cloned repository:

```powershell
python -c "import sys; print(sys.executable)"
```

Expected pattern:

```text
C:\Users\<username>\Python-Projects\<repository-name>\.venv\Scripts\python.exe
```

## Step 8 - Install Recorded Dependencies

Follow the repository's documented dependency command. For a project using
`requirements.txt`:

```powershell
python -m pip install -r .\requirements.txt
```

Do not install guessed packages individually when the project already records
its dependencies.

## Step 9 - Run the Project Check

Use the verification command documented by the repository. For a Django
project:

```powershell
python .\manage.py check
```

Expected result:

```text
System check identified no issues (0 silenced).
```

Then confirm that generated local files such as `.venv` are ignored:

```powershell
git status
```

The working tree should remain clean unless the repository documents an
intentional setup change.

## Step 10 - Open the Project in PyCharm

From the repository root:

```powershell
pycharm64.exe .
```

Allow PyCharm to finish indexing. Open a **new** PyCharm terminal tab and
verify its interpreter:

```powershell
python --version
python -c "import sys; print(sys.executable)"
```

The executable must point to the repository's `.venv`. A terminal tab that was
already open before interpreter configuration may retain the old environment;
open a new tab before troubleshooting.

## Completion Checklist

- [ ] Repository was cloned under `Python-Projects`
- [ ] GitHub authentication and repository access succeeded
- [ ] Destination was checked before cloning
- [ ] Repository instructions were read
- [ ] Required Python version was confirmed
- [ ] Local virtual environment was created and activated
- [ ] Recorded dependencies installed successfully
- [ ] Project-specific verification passed
- [ ] Git working tree remained clean
- [ ] PyCharm opened the repository
- [ ] A fresh PyCharm terminal used the project virtual environment

---

# Lessons Learned

Document any project setup improvements or lessons learned here so future projects continue to improve.
