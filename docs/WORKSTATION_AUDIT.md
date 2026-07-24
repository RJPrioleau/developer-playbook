# Windows Workstation Audit

## Purpose

This audit answers whether a Windows 11 development machine matches the standard in
[WORKSTATION_SETUP.md](WORKSTATION_SETUP.md). Setup establishes the standard; this audit
verifies it. Troubleshooting investigates a failed check, and repair deliberately changes the
machine after the evidence is understood.

The audit and its script are universal. They do not contain workstation-specific rules.

> Never assume a configuration change took effect. Verify it immediately in a fresh session.

Use this repair methodology:

1. Observe.
2. Verify.
3. Change one thing only when repairing.
4. Open a fresh terminal or application session.
5. Verify again.
6. Continue only after the result passes.

The verification script is read-only. It reports evidence and next steps but does not install
software, change settings, authenticate accounts, edit PATH, or repair failures.

## Run the Audit

Open PowerShell 7 in the Developer Playbook repository and run:

```powershell
.\verify-workstation.ps1
```

To include an existing project:

```powershell
.\verify-workstation.ps1 -ProjectPath "C:\Users\<username>\Python-Projects\example-project"
```

PowerShell may block locally downloaded scripts under the current execution policy. Inspect the
policy before changing anything:

```powershell
Get-ExecutionPolicy -List
```

For a one-session run, use a process-scoped policy only when local policy permits it:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\verify-workstation.ps1
```

Do not weaken a machine-wide policy merely to run the audit. On a managed computer, follow the
organization's policy.

## Result Meanings

- `[PASS]` confirms that a required condition was observed.
- `[WARN]` identifies a condition that needs review but does not prove the workstation is unusable.
- `[FAIL]` identifies a missing required tool or a structural problem that prevents the standard
  from being satisfied.
- `[INFO]` supplies context without changing the result.

The overall result is `PASS`, `PASS WITH WARNINGS`, or `FAIL`. Warnings do not cause a failure
exit code. One or more failures produce a nonzero exit code.

## Audit Phases

### Phase 1 - Machine Validation

The script checks:

- Windows environment and current PowerShell host
- availability of PowerShell 7 through `pwsh`
- machine-level Python, the Python launcher, pip, and executable resolution
- User and Machine PATH integrity
- Git, Git LFS, global Git identity, GitHub CLI, and GitHub authentication
- PyCharm installation

Multiple Python installations are reported, not automatically failed. If `python` resolves to a
WindowsApps alias that cannot report a version, the audit warns about PATH ordering or App
Execution Alias behavior instead of treating the alias itself as a missing Python installation.
Inconsistent Python and pip installations, malformed PATH entries, and missing command
directories receive results appropriate to their impact.

Duplicate PATH entries are warnings. They are cleanup items unless other evidence shows that they
are changing command resolution. Unmatched quotation marks remain failures because they indicate
structural PATH corruption.

### Phase 2 - Workspace Validation

The script checks that this standard workspace exists and is a directory:

```text
C:\Users\<username>\Python-Projects
```

Missing workspace is a warning; a path at that location that is not a directory is a failure.
Existing repositories elsewhere are not failures. `PycharmProjects`, `IdeaProjects`, and other
legacy folders may coexist with the standard workspace.

GitHub CLI authentication is evidence of account access, but remote network availability can
change. A connectivity problem must not be confused with missing Git or a missing GitHub CLI
installation.

### Phase 3 - Project Validation

Supply `-ProjectPath` to inspect a project without contacting its remote. The script reports
whether the path is a Git repository, its current branch, working-tree state, configured remotes,
common virtual-environment directories, and the active Python executable.

From a newly opened PyCharm terminal inside an existing project, also run:

```powershell
$PSVersionTable.PSVersion
python --version
python -c "import sys; print(sys.executable)"
git status
git remote -v
```

An active project virtual environment may intentionally use an older Python than the machine
default. That is not automatically a failure. Do not recreate or upgrade an existing virtual
environment merely to match the machine Python. Evaluate the project's dependency compatibility
separately.

## Manual Checks

Some checks cannot be proven reliably by a read-only script:

- In a **new** PyCharm terminal tab, run `$PSVersionTable.PSVersion` and confirm it is PowerShell
  7. Changing PyCharm's shell setting does not convert an already-open terminal.
- Open a known project in PyCharm and confirm its intended virtual environment activates.
- Confirm the project can run its own smoke check or test command.
- Confirm GitHub access against a repository you are authorized to use when network access is
  available. The audit deliberately does not clone, fetch, push, or alter a remote.
- Review PATH warnings in context. An absent directory can be a harmless remnant of uninstalled
  software, while an unexpected user-profile entry in Machine PATH requires investigation.

## Interpret and Investigate Results

Start with the first failure, because later checks may depend on it. Read the next-step text
printed beside that result, run the suggested inspection command, and gather evidence before
repairing anything. A warning should be reviewed but does not by itself mean the machine is
unusable.

After a repair:

1. Close the affected terminal or application.
2. Open a fresh session.
3. Run the focused verification command.
4. Run the full audit again.

Do not make several speculative changes between audit runs. A single change followed by fresh
verification preserves the evidence needed to understand the cause.

## Project-Level Smoke Check

Run the project's documented verification command from its repository root with the intended
virtual environment active. Examples include a test suite, framework health check, or a safe
application startup. The workstation audit cannot choose this command because each repository
defines its own contract.

Record the repository path and branch, active Python executable, exact command, exit code, and
relevant output.

## Request Troubleshooting Help

Capture the audit without changing its readable console output:

```powershell
.\verify-workstation.ps1 *>&1 |
    Tee-Object -FilePath ".\workstation-audit.txt"
```

For project mode:

```powershell
.\verify-workstation.ps1 -ProjectPath "C:\Users\<username>\Python-Projects\example-project" *>&1 |
    Tee-Object -FilePath ".\workstation-audit.txt"
```

Review the file before sharing it. Include the failing result, exact command, what changed
immediately before the problem, and whether it was reproduced in a fresh terminal. The script
avoids unrelated environment variables and secrets, but output can include configured Git
identity, executable paths, project paths, branches, and remote URLs.
