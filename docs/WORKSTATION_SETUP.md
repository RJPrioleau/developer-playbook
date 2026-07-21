# Workstation Status

| Component | Status |
|-----------|--------|
| Folder Structure | ✅ |
| Git | ✅ |
| Python | ✅ |
| pip | ✅ |
| GitHub CLI | ✅ |
| PyCharm | ✅ |
| PATH | ✅ |
| Git Authentication | ✅ |
| Final Validation | ✅ |

---


## 🎯 Purpose

Document the complete process for configuring a Windows development workstation.

The goal is to make building or rebuilding a development environment repeatable, consistent, and reliable.

---

## ⏱️ Estimated Setup Time

30–60 minutes (assuming software installers are already available).

---

## 🤔 Philosophy

This document serves as the standard operating procedure (SOP) for setting up a development workstation.

Every completed step should be verifiable.

If a new lesson is learned while configuring a workstation, update this document so future setups become easier.

---

## 📋 Workstation Standards

Development repositories are stored in:

```text
C:\Users\<username>\Python-Projects
```

Primary IDE:

- PyCharm

Preferred Terminal:

- PowerShell

PyCharm should launch using:

```powershell
pycharm64.exe .
```

Every workstation must successfully complete all verification steps before being considered production-ready.

---

## 🖥️ Verified Workstations

- Battle Station
- Surface Pro

---

# Phase 1 - Folder Structure

## Development Directory

- [ ] Created

### Example

```text
C:\Users\<username>\Python-Projects
```

### Verification

Confirm all development repositories will be stored in this directory.

### Notes

---

# Phase 2 - Install Required Software

## Git

- [ ] Installed

### Verification

```powershell
git --version
```

### Notes

---

## GitHub CLI

- [ ] Installed

### Verification

```powershell
gh --version
```

### Notes

Used for:

- Repository creation
- Repository cloning
- Authentication
- Pull requests
- Releases

---

## Python

- [ ] Installed

### Verification

```powershell
python --version
py --version
pip --version
```

### Notes

---

## pip

- [ ] Installed

### Verification

```powershell
pip --version
```

### Notes

---

## PyCharm

- [ ] Installed

### Verification

Launch PyCharm successfully.

### Notes

---

## PowerShell

- [ ] Installed

### Verification

```powershell
$PSVersionTable.PSVersion
```

### Notes

---

# Phase 3 - Configure Development Environment

## Git Configuration

- [ ] Complete

### Verification

```powershell
git config --list
```

### Notes

---

## Inspect User PATH

- [ ] Complete

Before changing the PATH variable:

```powershell
([Environment]::GetEnvironmentVariable("Path", "User") -split ";") |
    ForEach-Object { "'$_'" }
```

### Notes

---

## Backup User PATH

- [ ] Complete

Before modifying the PATH variable:

```powershell
[Environment]::GetEnvironmentVariable("Path", "User") |
    Out-File "$([Environment]::GetFolderPath('Desktop'))\UserPath_Backup.txt"
```

### Verification

```powershell
Test-Path "$([Environment]::GetFolderPath('Desktop'))\UserPath_Backup.txt"
```

Expected Result:

```text
True
```

### Notes

---

## Environment Variables (PATH)

- [ ] Complete

### Verification

Run:

```powershell
pycharm64.exe .
```

Expected Result:

- PyCharm launches successfully.
- The current directory opens as a project.

### Notes

---

## GitHub Authentication

- [ ] Complete

### Verification

Authenticate using GitHub CLI.

```powershell
gh auth login
```

Then verify access by cloning a repository.

```powershell
gh repo clone owner/repository
```

Expected Result:

Repository clones successfully without authentication errors.

### Notes

---

# Phase 4 - Final Workstation Validation

- [ ] Git operational
- [ ] GitHub CLI operational
- [ ] Python operational
- [ ] pip operational
- [ ] PyCharm launcher operational
- [ ] GitHub authentication operational
- [ ] Able to clone repositories
- [ ] Able to open repositories in PyCharm

## Verification

Run:

```powershell
python --version
py --version
pip --version
git --version
gh --version
pycharm64.exe .
```

Expected Result:

- All commands execute successfully.
- PyCharm launches and opens the current directory as a project.

---

# Phase 5 - Machine Notes

Document workstation-specific details, issues, and discoveries made during setup. Every computer develops its own configuration quirks.

## Battle Station

**Operating System:** Windows 11

**Python:** 3.14.6

**PyCharm:**

- 2023.3.4

**Desktop:**

- Redirected to OneDrive

**PATH:**

- Includes the PyCharm `bin` directory
- Includes Python 3.14
- Includes Python Scripts

**Notes:**

- GitHub CLI installed

## Surface Pro

**Processor:** ARM

**PyCharm:**

- 2026.1.2

**PATH:**

- Includes the PyCharm `bin` directory

**Notes:**

- Uses a different PATH configuration than Battle Station

## General Notes

- Avoid using `setx PATH "$env:Path"` because long PATH variables may be truncated.

---

# Recovery

Recovery steps should be performed in order. Do not skip verification between steps.

If something breaks:

1. Verify PATH.
2. Verify Python.
3. Verify Git.
4. Verify GitHub CLI.
5. Restore the PATH backup if necessary.
