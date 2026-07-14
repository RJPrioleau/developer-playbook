# WORKSTATION_SETUP.md

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

## Python

- [ ] Installed

### Verification

```powershell
python --version
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

Clone any GitHub repository.

```powershell
git clone <repository-url>
```

Expected Result:

Repository clones successfully without authentication errors.

### Notes

---

# Phase 4 - Final Workstation Validation

- [ ] Git operational
- [ ] Python operational
- [ ] pip operational
- [ ] PyCharm launcher operational
- [ ] GitHub authentication operational
- [ ] Able to clone repositories
- [ ] Able to open repositories in PyCharm

---

# Phase 5 - Lessons Learned

Document any workstation-specific issues or discoveries made during setup.

### Example

- Surface Pro required adding the PyCharm 2026.1.2 `bin` directory to the Windows PATH.
- Battle Station required adding the PyCharm 2023.3.4 `bin` directory to the Windows PATH.
- Avoid using `setx PATH "$env:Path"` because long PATH variables may be truncated.