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

# Phase 7 - Create Initial Project Structure

- [ ] Initial project structure created

### Example

```text
<project-name>/
│
├── README.md
├── ROADMAP.md
├── CHANGELOG.md
├── requirements.txt
├── .gitignore
├── app.py
├── docs/
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