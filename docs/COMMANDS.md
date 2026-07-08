# COMMANDS.md

**Version:** 1.0

Last Updated: 2026-07-07

> **Personal Software Development Command Reference**
>
> A living reference for commands, aliases, workflows, and troubleshooting
> learned through real software development.
>
> **Philosophy**
>
> The goal is **not** to memorize commands.
>
> The goal is to understand command **patterns** so they can be adapted to any
> project. Every command in this document should come from solving a real
> problem, not from copying a cheat sheet.

---

# How to Use This Document

Each command should answer the following questions:

- What does it do?
- Why would I use it?
- What is the alias?
- What is the full command?
- What is the general template?
- What is a real-world example?
- What are common mistakes?
- When do I typically use it?
- What did I learn from using it?

Commands move through different sections as they become more familiar.

---

# Understanding PowerShell Aliases

Many PowerShell commands have shorter aliases.

For example:

| Alias | Full Command | Purpose |
|:------|:-------------|:--------|
| `ls` | `Get-ChildItem` | List files and folders |
| `cd` | `Set-Location` | Change directories |
| `pwd` | `Get-Location` | Display current directory |
| `cat` | `Get-Content` | Display file contents |
| `ii` | `Invoke-Item` | Open a file or folder |
| `cls` | `Clear-Host` | Clear the terminal |

Learning both the alias and the full cmdlet makes it easier to:

- Read PowerShell scripts
- Understand Microsoft documentation
- Write your own scripts
- Troubleshoot commands

---

# 🔥 Currently Learning

---

## Open a Project in PyCharm

### Purpose

Launch an existing project directly from PowerShell without opening PyCharm first.

---

### Alias

None

---

### Full Command

```powershell
pycharm64.exe
```

---

### General Pattern

```powershell
pycharm64.exe <project_path>
```

---

### Example

Open the current directory as a PyCharm project.

```powershell
pycharm64.exe .
```

Open a specific project.

```powershell
pycharm64.exe C:\Users\Jaypr\Python-Projects\developer-playbook
```

---

### Breakdown

`pycharm64.exe`

Launches the native PyCharm executable.

`.`

Represents the current working directory.

---

### Requirements

The PyCharm **bin** directory must be added to the Windows **Path**
environment variable.

Example:

```text
C:\Program Files\JetBrains\PyCharm 2023.3.4\bin
```

---

### Common Mistakes

❌ Running

```powershell
pycharm .
```

before configuring the launcher.

❌ Running

```powershell
pycharm.bat .
```

The batch launcher works but keeps the PowerShell session attached.

PyCharm recommends using the native executable instead.

❌ Updating PATH using

```powershell
setx PATH "$env:Path"
```

This may truncate the PATH variable because of Windows length limitations.

Instead:

System Properties → Environment Variables → Path → Edit

---

### When I Use It

- Opening existing projects
- Starting new projects
- Quickly jumping into development from PowerShell

---

### Related Commands

```powershell
cd
pwd
ii
```

---

### Lo Notes

This was the first command documented in the Developer Playbook.

Lessons learned:

- `pycharm` was not recognized.
- `charm` was not available.
- `pycharm.bat` worked but tied up the PowerShell session.
- The native executable (`pycharm64.exe`) provides a better workflow.
- The correct solution was adding PyCharm's **bin** directory to the Windows PATH using the Environment Variables editor.

---

# 🟨 Familiar Commands

*(Commands move here as they become familiar.)*

---

# 🟩 Mastered Commands

*(Commands move here once they become second nature.)*

---

# 📚 Reference Commands

*(Rare or infrequently used commands that are still worth documenting.)*

---

# 🔄 Common Workflows

*(Document multi-step development workflows here.)*

Examples:

- Starting a new project
- Git workflow
- Running a simulation
- Debugging a module
- Replaying historical data