# Windows Development Workstation Setup

## 🎯 Purpose

Document a repeatable process for configuring or repairing a Windows development workstation.

The target configuration is:

- Windows 11
- PowerShell 7 as the preferred terminal shell
- Python Install Manager
- Python 3.14.6 as the current machine-level Python
- Working `python`, `py`, and `pip` commands
- Git and Git LFS
- GitHub CLI with authenticated repository access
- A configured Git identity
- PyCharm
- Project-specific virtual environments
- New repositories stored in `C:\Users\<username>\Python-Projects`

Existing repositories may remain in `PycharmProjects`, `IdeaProjects`, or another location. Do not move active repositories automatically during workstation setup. Repository migration is a separate, deliberate task.

---

## 🤔 Engineering Method

Use the same method for every setup or repair:

1. Observe the current state.
2. Verify it with commands.
3. Change one thing at a time.
4. Close and reopen affected applications or terminals when required.
5. Verify the change immediately.
6. Continue only after verification passes.

> Never assume a configuration change took effect. Verify it immediately in a fresh session.

Installer success messages prove only that an installer finished. They do not prove that Windows can find the command or that PyCharm inherited the new environment.

PyCharm settings changes apply only to newly created terminal sessions. Close existing terminal tabs completely and create new ones before testing a changed shell or `PATH`.

Setup establishes the workstation standard. Use the
[Windows Workstation Audit](WORKSTATION_AUDIT.md) to verify that standard before troubleshooting
or repairing a machine. Review failed checks first, make repairs deliberately, and verify each
change in a fresh session.

---

## ⏱️ Estimated Setup Time

Allow 30–60 minutes when installations work normally. PATH repairs, restarts, and troubleshooting may take longer.

---

# Phase 1 - Observe and Preserve the Current State

## Record Existing Repositories

Before installing tools or changing environment variables, identify existing development directories and repositories. Preserve them in place.

Common existing locations include:

```text
C:\Users\<username>\PycharmProjects
C:\Users\<username>\IdeaProjects
C:\Users\<username>\Python-Projects
```

Do not move an active repository merely to satisfy the new directory standard. Confirm that important work is committed and pushed before any later migration.

## Observe the Current Commands

Open PowerShell and run:

```powershell
$PSVersionTable.PSVersion
python --version
py --version
pip --version
git --version
git lfs version
gh --version
```

Missing-command errors are useful evidence. Record them and install or repair one component at a time.

Use these commands to discover what Windows actually resolves:

```powershell
where.exe python
Get-Command python
```

Replace `python` with another command such as `py`, `pip`, `git`, `gh`, `pwsh`, or `pycharm64.exe` when investigating that tool.

---

# Phase 2 - Create the Standard Workspace

Create the directory for new repositories:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\Python-Projects" -Force
```

Verify it:

```powershell
Test-Path "$env:USERPROFILE\Python-Projects"
```

Expected result:

```text
True
```

New repositories should normally be created or cloned into `Python-Projects`. Existing repositories can continue working from their current locations.

---

# Phase 3 - Install and Verify Required Software

Install and verify one tool at a time. Open a fresh terminal after an installation before deciding that its command is unavailable.

## PowerShell 7

Windows 11 includes Windows PowerShell 5.1, but PowerShell 7 is the preferred development shell.

Install PowerShell 7 through WinGet:

```powershell
winget install --id Microsoft.PowerShell
```

Open a completely new PowerShell 7 session and verify:

```powershell
pwsh --version
$PSVersionTable.PSVersion
```

The executable names are different:

- `powershell.exe` launches Windows PowerShell 5.1.
- `pwsh.exe` launches PowerShell 7.

WinGet may report an installed or updated version while the currently open shell still uses its old process and environment. Open a new PowerShell 7 session. If the new version still does not appear, close affected applications and reboot before concluding that the upgrade failed.

## Python Install Manager and Python 3.14.6

Use Python Install Manager to manage the machine-level Python installation. Install the current 3.14 runtime with:

```powershell
pymanager install 3.14
```

After installation, open a fresh terminal and verify:

```powershell
python --version
py --version
pip --version
where.exe python
where.exe py
where.exe pip
```

The target machine-level version for this setup is Python 3.14.6. The first executable returned by `where.exe` normally wins because Windows searches `PATH` in order.

WindowsApps and Microsoft Store application aliases may intercept `python`. If the reported version or path is unexpected, inspect both `where.exe python` and `Get-Command python` before changing anything.

Machine-level Python and project-level Python are separate concerns:

- The machine-level installation supplies a default Python for new work.
- Each project should use its own virtual environment and interpreter.
- An existing project virtual environment may legitimately continue using an older Python.
- Do not recreate or upgrade an existing virtual environment blindly. First review the project's dependencies, documentation, and compatibility requirements.

Inside a project terminal, identify the exact active interpreter:

```powershell
python -c "import sys; print(sys.executable)"
```

A result such as this confirms that the project virtual environment is active:

```text
<project>\venv\Scripts\python.exe
```

## Git

Install Git for Windows when it is missing:

```powershell
winget install --id Git.Git
```

Open a fresh terminal and verify:

```powershell
git --version
```

## Git LFS

Git LFS supports repositories containing large files. Install it when it is missing:

```powershell
winget install --id GitHub.GitLFS
```

Open a fresh terminal, then initialize Git LFS for the current user:

```powershell
git lfs install
```

Verify:

```powershell
git lfs version
```

## GitHub CLI

Install GitHub CLI through WinGet:

```powershell
winget install --id GitHub.cli
```

Open a fresh terminal and verify:

```powershell
gh --version
```

The expected GitHub CLI installation directory is:

```text
C:\Program Files\GitHub CLI
```

If `gh.exe` exists there but `gh` is not recognized, add that directory to `PATH`, open a fresh terminal, and run `gh --version` again. Do not assume the installer added the directory correctly.

After GitHub CLI resolves successfully, continue to [GitHub Authentication](#github-authentication) to sign in and verify repository access.

## PyCharm

Install and launch PyCharm. Confirm that it opens successfully before configuring its terminal and project interpreter.

If the PyCharm command-line launcher has been configured, this command should open the current directory:

```powershell
pycharm64.exe .
```

The launcher is convenient but is not required to use PyCharm.

---

# Phase 4 - Inspect and Repair PATH Safely

PATH order determines which executable Windows runs when multiple files share a command name.

## Inspect User and Machine PATH

Read both values before making changes:

```powershell
[Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::GetEnvironmentVariable("Path", "Machine")
```

For easier line-by-line inspection:

```powershell
([Environment]::GetEnvironmentVariable("Path", "User") -split ";") |
    ForEach-Object { "'$_'" }

([Environment]::GetEnvironmentVariable("Path", "Machine") -split ";") |
    ForEach-Object { "'$_'" }
```

Check for:

- Duplicate entries
- User-specific directories incorrectly stored in Machine PATH
- Unmatched quotation marks
- Empty entries
- Directories that no longer exist
- WindowsApps appearing before the desired Python path
- Newly installed tool directories that are missing

## Back Up PATH Before Editing

Back up the value you intend to change. For Machine PATH:

```powershell
[Environment]::GetEnvironmentVariable("Path", "Machine") |
    Set-Content "$env:USERPROFILE\Desktop\machine-path-backup.txt"
```

For User PATH:

```powershell
[Environment]::GetEnvironmentVariable("Path", "User") |
    Set-Content "$env:USERPROFILE\Desktop\user-path-backup.txt"
```

Verify the backups:

```powershell
Test-Path "$env:USERPROFILE\Desktop\machine-path-backup.txt"
Test-Path "$env:USERPROFILE\Desktop\user-path-backup.txt"
```

Do not blindly replace PATH with a hardcoded value, and avoid `setx PATH "$env:Path"` because long PATH values may be truncated or combined incorrectly.

Machine PATH changes may require an elevated PowerShell session. After any PATH change, close and reopen terminals and PyCharm so new processes inherit the new environment. In some cases, signing out or rebooting Windows is necessary.

## Verify Command Resolution

Use both tools to identify the executable that will actually run:

```powershell
where.exe <command>
Get-Command <command>
```

For example:

```powershell
where.exe gh
Get-Command gh
```

`where.exe` shows matching executables found through command search. `Get-Command` shows what PowerShell resolves, including aliases, functions, cmdlets, and applications.

---

# Phase 5 - Configure Git and GitHub

## Git Identity

Configure the identity attached to new commits:

```powershell
git config --global user.name "<name>"
git config --global user.email "<email>"
```

Verify:

```powershell
git config --global user.name
git config --global user.email
```

The output should match the intended GitHub identity. Do not place personal names or email addresses in this reusable guide.

## GitHub Authentication

Complete the [GitHub CLI](#github-cli) installation and verification steps before authenticating.

Authenticate:

```powershell
gh auth login
```

Follow the prompts for the intended GitHub host, protocol, and browser authentication. Never share an authentication token shown in terminal output.

Verify authentication:

```powershell
gh auth status
```

Verify repository access:

```powershell
gh repo list <github-username> --limit 5
```

Successful output confirms that GitHub CLI can authenticate and read repositories for the intended account.

---

# Phase 6 - Configure PyCharm

## PowerShell 7 Terminal

In PyCharm, open approximately:

```text
Settings → Tools → Terminal → Shell path
```

Set the shell path to:

```text
pwsh.exe
```

After changing it:

1. Close the existing terminal tab completely.
2. Open a brand-new terminal.
3. Run:

```powershell
$PSVersionTable.PSVersion
```

The major version should be `7`. If it still reports Windows PowerShell 5.1, inspect both commands:

```powershell
Get-Command pwsh
Get-Command powershell
```

PyCharm reuses existing terminal sessions, so an open tab cannot prove that a new shell setting failed.

## Project Interpreter and Virtual Environment

PyCharm may automatically activate a project's virtual environment. A prompt beginning with `(venv)` is expected and does not mean that the machine-level Python installation failed.

In the project terminal, verify:

```powershell
python --version
python -c "import sys; print(sys.executable)"
```

Configure each project to use its intended virtual environment through PyCharm's Python interpreter settings. Do not require an existing project's environment to use the same Python version as the machine default.

---

# Phase 7 - Existing Project Smoke Check

Open an existing repository in PyCharm and create a brand-new terminal tab. Run:

```powershell
$PSVersionTable.PSVersion
python --version
python -c "import sys; print(sys.executable)"
git status
```

These commands confirm:

- `$PSVersionTable.PSVersion` — PyCharm opened the correct terminal shell.
- `python --version` — the active project Python version is known.
- `sys.executable` — the exact virtual-environment interpreter is known.
- `git status` — the directory is a healthy Git working tree and its current changes are visible.

An existing project passing this smoke check with an older Python version is acceptable when that is the project's intended environment.

Also verify important tools in the fresh PyCharm terminal:

```powershell
py --version
pip --version
git --version
git lfs version
gh --version
gh auth status
```

Verify from inside the IDE, not only from a standalone terminal. The two applications may have inherited different environment values.

---

# Troubleshooting Lessons

- A successful installer message does not prove that the command resolves correctly.
- PATH order matters; the first matching executable normally wins.
- `where.exe` and `Get-Command` reveal what is actually being executed.
- Open terminals retain the environment they inherited when they started.
- PyCharm reuses existing terminal sessions until those tabs are closed.
- An active virtual environment overrides the machine-level `python` command.
- Existing virtual environments should not be upgraded or recreated casually.
- WindowsApps aliases can intercept Python commands.
- Newly installed tools may require a fresh terminal, restarted application, sign-out, or reboot.
- Machine PATH repairs may require an elevated PowerShell session.
- Verification must also be performed inside PyCharm.

---

# Recovery

Recover one layer at a time:

1. Open a fresh shell and identify its PowerShell version.
2. Inspect command resolution with `where.exe` and `Get-Command`.
3. Inspect User and Machine PATH without editing them.
4. Create current PATH backups.
5. Repair one specific entry or ordering problem.
6. Restart affected terminals and applications.
7. Verify the repaired command immediately.
8. Verify the project interpreter and Git working tree separately.

Do not restore a PATH backup blindly. Compare it with the current state and preserve legitimate tools installed since the backup was created.

---

# Final Workstation Checklist

- [ ] Windows 11 is current
- [ ] `pwsh` opens PowerShell 7
- [ ] PyCharm opens new terminals with PowerShell 7
- [ ] Python Install Manager is operational
- [ ] Machine-level Python reports 3.14.6
- [ ] `python`, `py`, and `pip` resolve to intended executables
- [ ] Git is operational
- [ ] Git LFS is operational
- [ ] Git identity is configured
- [ ] GitHub CLI is operational and authenticated
- [ ] Repository access succeeds
- [ ] PyCharm launches successfully
- [ ] `C:\Users\<username>\Python-Projects` exists for new repositories
- [ ] Existing repositories remain preserved
- [ ] An existing project passes the IDE smoke check

Complete the checklist only from observed command results, not from installer messages or assumptions.
