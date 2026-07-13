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

## Locate an Installed Program
### 🎯 Purpose
Find the location of an installed program so it can be launched, configured, or troubleshooted.

### ⚙️ What It Does
Recursively searches a directory and its subdirectories for files that match a specified name or filter.

### 🤔 Why It Matters
Useful when you need to locate an executable, verify an installation, configure environment variables, or troubleshoot launcher issues without manually searching through folders.

### 📌 Alias

```powershell
ls
dir
gci
```

These aliases execute the `Get-ChildItem` cmdlet.

### 💻 Full Command

```powershell
Get-ChildItem
```

### 📖 General Pattern

```powershell
Get-ChildItem "<directory>" -Recurse -Filter "<filename>"
```

### 📝 Examples

Locate the PyCharm executable.

```powershell
Get-ChildItem "C:\Program Files\JetBrains" -Recurse -Filter pycharm64.exe
```

Locate the PyCharm batch launcher.

```powershell
Get-ChildItem "C:\Program Files\JetBrains" -Recurse -Filter pycharm.bat
```

### 🔍 Breakdown

**Get-ChildItem**

Retrieves files and folders from a directory.

**-Recurse**

Searches all subdirectories beneath the specified directory.

**-Filter**

Limits the results to items matching the specified filename or pattern.

**"<directory>"**

The starting location for the search.

**"<filename>"**

The name (or pattern) of the file to locate.

### ⚠️ Common Mistakes

Searching the entire `C:\` drive when you already know the program's installation directory.

Start with the most likely installation folder to improve performance.

### 💡 Lo Notes

This command was first documented while configuring the PyCharm launcher on both the Battle Station and the Surface Pro.

Key lesson:

Learn the reusable command pattern first, then remember the real-world example that led to it.

## Change Directory

### 🎯 Purpose

Move from the current directory to another directory in PowerShell.

### ⚙️ What It Does

Changes the terminal's current working location to the specified folder.

### 🤔 Why It Matters

Useful for navigating between projects, folders, and repositories before running commands.

### 📌 Alias

```powershell
cd
```

### 💻 Full Command

```powershell
Set-Location
```

### 📖 General Pattern

```powershell
Set-Location "<directory-path>"
```

### 📝 Examples

Move to a specific project:

```powershell
cd C:\Users\ridin\PycharmProjects\developer-playbook
```

Move up one directory:

```powershell
cd ..
```

Move to the current user's home directory:

```powershell
cd ~
```

### 🔍 Breakdown

**Set-Location**

Changes the current working directory.

**"<directory-path>"**

The destination directory you want to move to.

**..**

Moves up one directory level.

**~**

Moves to the current user's home directory.

**.**

Represents the current directory.

### ⚠️ Common Mistakes

Using spaces in a directory path without surrounding the path in quotation marks.

Example:

```powershell
cd "C:\Program Files\JetBrains"
```

instead of

```powershell
cd C:\Program Files\JetBrains
```

Another common mistake is forgetting where the current working directory is before running commands.

Use:

```powershell
pwd
```

to verify your current location.

### 🔗 Related Commands

```powershell
pwd
ls
ii
Get-Location
```

### 💡 Lo Notes

One of the most frequently used PowerShell commands during development.

Used at the beginning of nearly every development session to navigate between repositories and project folders.

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