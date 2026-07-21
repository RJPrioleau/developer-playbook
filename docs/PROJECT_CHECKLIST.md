# PROJECT_CHECKLIST.md

## 🎯 Purpose

Provide a repeatable checklist for creating a new Python software project from scratch.

The goal is to ensure every project begins with a consistent structure, isolated environment, dependency management, documentation, and Git workflow.

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

## Create Git Repository

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

These files preserve the established AI collaboration, teaching, machine-switch, and session-handoff workflows in every new project.

Run the following commands from the **new project's root directory**. This procedure assumes the new project and `developer-playbook` are sibling directories inside the same `PycharmProjects` directory.

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

Confirm the displayed path ends with the new project's directory name. Do not run the copy commands from inside `developer-playbook`.

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

If `Resolve-Path` reports that the path does not exist, the repositories are not siblings. Set the path explicitly instead:

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

If either command returns `True`, stop and inspect that file. Do not overwrite an existing project's instructions or handoff history with a fresh template.

### Step 4 - Create the Documentation Directory

```powershell
New-Item -ItemType Directory -Path '.\docs' -Force
```

`-Force` makes this safe when the `docs` directory already exists. It does not delete or replace files inside the directory.

### Step 5 - Copy Both Templates

```powershell
Copy-Item -LiteralPath (Join-Path $playbookRoot 'templates\ai-collaboration\AGENTS.md') -Destination '.\AGENTS.md'
Copy-Item -LiteralPath (Join-Path $playbookRoot 'templates\ai-collaboration\COLLABORATION.md') -Destination '.\docs\COLLABORATION.md'
```

The resulting project layout should include:

```text
<project-name>/
├── AGENTS.md
└── docs/
    └── COLLABORATION.md
```

The files are copied, not linked. Each project keeps its own instructions, project-specific decisions, and continuity history.

### Step 6 - Replace the AGENTS.md Placeholders

Open the new project's `AGENTS.md` in PyCharm. Replace every angle-bracket placeholder as follows:

| Placeholder | Replace it with | Example |
|---|---|---|
| `<PROJECT_NAME>` | The human-readable project name | `Expense Tracker` |
| `<ONE_SENTENCE_PROJECT_PURPOSE>` | One sentence describing what the project is intended to do | `Build a local application for recording and reviewing personal expenses.` |
| `<PRIMARY_RUN_COMMAND>` | The normal PowerShell command used to start the project | `python app.py` |
| `<PRIMARY_VERIFICATION_COMMAND>` | The normal command used to run the project's main test or verification suite | `python -m pytest` |
| `<OPTIONAL_PROJECT_DOCUMENTATION>` | A real project-specific document and its purpose, or delete the entire bullet when none exists | `docs/data_dictionary.md — field definitions and data contracts.` |
| `<PROJECT_SPECIFIC_INSTRUCTION_OR_REMOVE_THIS_LINE>` | A durable rule unique to this repository, or delete the bullet when none has been established | `Keep database migrations backward compatible.` |

If the run or verification command has not been established yet, replace the placeholder with `Not established yet` rather than guessing or leaving the placeholder unresolved. Update it when the real command is proven.

Do not add speculative project rules. Add project-specific instructions only when the project creates a real need for them.

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

Read the customized `AGENTS.md` once before the initial commit. Confirm that its project name, purpose, commands, documentation links, and project-specific instructions are accurate.

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

🚧 Planned for a future revision.

This workflow will document the complete process for setting up an existing GitHub project on a new workstation, including:

- Cloning the repository
- Creating a new virtual environment
- Activating the virtual environment
- Installing dependencies from `requirements.txt`
- Configuring PyCharm
- Verifying the development environment

---

# Lessons Learned

Document any project setup improvements or lessons learned here so future projects continue to improve.
