# COMMANDS.md

**Version:** 1.0

Last Updated: 2026-07-22

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

## Quick Navigation

- [Create and Connect a GitHub Repository](#create-and-connect-a-github-repository-gh-repo-create)
- [Open a Project in PyCharm](#open-a-project-in-pycharm)
- [Locate an Installed Program](#locate-an-installed-program-get-childitem)
- [Change Directory](#change-directory-set-location)
- [Display Current Directory](#display-current-directory-get-location)
- [Display the Complete Path of a File](#display-the-complete-path-of-a-file-resolve-path)
- [Create Files and Directories](#create-files-and-directories-new-item-and-mkdir)
- [Delete Files](#delete-files-remove-item)
- [Search Python Files for a Function or Text](#search-python-files-for-a-function-or-text)
- [Open a Specific File in PyCharm](#open-a-specific-file-in-pycharm)
- [Display a File in the Terminal](#display-a-file-in-the-terminal)
- [Display the Beginning of a File](#display-the-beginning-of-a-file)
- [Display a Specific Portion of a File](#display-a-specific-portion-of-a-file)
- [Display Matching Text with Surrounding Context](#display-matching-text-with-surrounding-context)
- [Workflow: Locate, Inspect, and Open Code](#workflow-locate-inspect-and-open-code)
- [Run a Python Function from PowerShell](#run-a-python-function-from-powershell)
- [Run Multiline Python from PowerShell](#run-multiline-python-from-powershell)

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

## Create and Connect a GitHub Repository (gh repo create)

### Purpose

Create a GitHub repository from an existing local Git repository and configure
the local `origin` remote without using the GitHub website.

---

### Alias

None

---

### Full Command

```powershell
gh repo create <project-name> --private --source=. --remote=origin
```

Use `--public` instead of `--private` when the repository should be publicly
visible.

---

### General Pattern

Run these commands from the new project directory:

```powershell
git init -b main
gh auth status
gh repo create <project-name> <visibility-flag> --source=. --remote=origin
```

Replace `<visibility-flag>` with either `--private` or `--public`.

Create the initial commit, then publish it:

```powershell
git push -u origin main
```

---

### Real-World Example

Create the public Recipe Dashboard repository from its empty local Git
repository:

```powershell
gh repo create recipe-dashboard --public --source=. --remote=origin
```

The successful command created:

```text
https://github.com/RJPrioleau/recipe-dashboard
```

It also added this local remote:

```text
origin  https://github.com/RJPrioleau/recipe-dashboard.git
```

---

### Breakdown

`gh repo create <project-name>`

Creates a new repository under the active GitHub account.

`--private` or `--public`

Sets the GitHub repository's visibility.

`--source=.`

Uses the current local Git repository as the source. The `.` represents the
current directory.

`--remote=origin`

Adds the created GitHub repository as the local remote named `origin`.

`git push -u origin main`

Publishes the first commit and configures local `main` to track `origin/main`.
Afterward, later pushes can normally use `git push`.

---

### Verification

Confirm GitHub CLI authentication before creating the repository:

```powershell
gh auth status
```

Confirm the local fetch and push URLs:

```powershell
git remote -v
```

Confirm the repository identity, visibility, and URL on GitHub:

```powershell
gh repo view --json nameWithOwner,visibility,url
```

After the first push, confirm the default branch:

```powershell
gh repo view --json nameWithOwner,visibility,defaultBranchRef
```

Confirm the local branch is synchronized:

```powershell
git status
```

---

### Common Mistakes

- Running the command outside the intended local repository.
- Selecting `--public` when the repository should be private, or the reverse.
- Omitting `--source=.` and failing to associate the current repository.
- Omitting `--remote=origin` and leaving the local repository without a remote.
- Including `--push` before an initial commit exists.
- Running `git push` before upstream tracking exists. Use
  `git push -u origin main` for the first push.
- Copying the PowerShell prompt text, such as `PS C:\...>`, as part of a command.
- Sharing the authentication token printed by `gh auth status`. Redact the token
  before sharing terminal output.

---

### When I Use It

- Starting a new repository entirely from PowerShell.
- Creating and connecting GitHub without using the website.
- Choosing repository visibility explicitly during project setup.
- Verifying the local-to-remote connection before the first commit is pushed.

---

### Related Commands

```powershell
gh --version
gh auth status
git init -b main
git remote -v
git push -u origin main
git status
```

---

### Lo Notes

This workflow was verified while creating `recipe-dashboard`. The main lesson
is that `gh repo create` can create the GitHub repository and configure the
local remote in one command. The first commit is still created with Git, and
the first push uses `-u` to establish upstream tracking.

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

## Locate an Installed Program (Get-ChildItem)
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

## Change Directory (Set-Location)

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

## Display Current Directory (Get-Location)

### 🎯 Purpose

Display the current working directory in the PowerShell terminal.

### ⚙️ What It Does

Shows the full path of the directory the terminal is currently operating in.

### 🤔 Why It Matters

Useful for confirming your current location before running commands that depend on the working directory, such as Git commands, Python scripts, or file operations.

### 📌 Alias

```powershell
pwd
```

### 💻 Full Command

```powershell
Get-Location
```

### 📖 General Pattern

```powershell
Get-Location
```

### 📝 Examples

Display the current directory.

```powershell
pwd
```

Example Output

```text
Path
----
C:\Users\ridin\PycharmProjects\developer-playbook
```

### 🔍 Breakdown

**Get-Location**

Returns the current working directory.

**pwd**

PowerShell alias for `Get-Location`.

The returned path represents where commands are currently being executed.

### ⚠️ Common Mistakes

Assuming you are in the correct directory before running commands.

Always verify your location with:

```powershell
pwd
```

before running commands such as:

```powershell
git add .

python app.py
```

Running commands from the wrong directory is a common cause of errors.

### 🔗 Related Commands

```powershell
cd
ls
ii
Get-ChildItem
```

### 💡 Lo Notes

One of the first commands to run whenever a terminal behaves unexpectedly.

If Git, Python, or another command isn't finding files, verify the current working directory before troubleshooting anything else.

## Display the Complete Path of a File (Resolve-Path)

### 🎯 Purpose

Convert a relative file or directory path into its complete absolute path.

### ⚙️ What It Does

`Resolve-Path` finds an existing item and returns a path object containing its resolved location.

This replaces the manual process of running `pwd`, copying the current directory, copying the filename, and joining the two values yourself.

### 🤔 Why It Matters

Useful when another tool, application, or conversation needs the exact location of a file. It also prevents missing separators, duplicated directory names, and other mistakes caused by assembling paths manually.

### 📌 Alias

```powershell
rvpa
```

This alias executes the `Resolve-Path` cmdlet.

### 💻 Full Command

```powershell
Resolve-Path
```

### 📖 General Patterns

Display the resolved path as a PowerShell path object:

```powershell
Resolve-Path ".\<relative-path>"
```

Return only the complete path as plain text:

```powershell
(Resolve-Path ".\<relative-path>").Path
```

Retrieve the same complete path from the file's metadata:

```powershell
(Get-Item ".\<relative-path>").FullName
```

### 📝 Examples

From the `recipe-dashboard` project root, display the complete path to `PRODUCT.md`:

```powershell
Resolve-Path ".\docs\PRODUCT.md"
```

Example output:

```text
Path
----
C:\Users\Jaypr\Python-Projects\recipe-dashboard\docs\PRODUCT.md
```

Return only the path text:

```powershell
(Resolve-Path ".\docs\PRODUCT.md").Path
```

Resolve a filename containing spaces:

```powershell
(Resolve-Path ".\docs\ChatGPT_Conversations\Initial Conversation - 20260722.pdf").Path
```

Use `Get-Item` as an alternative:

```powershell
(Get-Item ".\docs\PRODUCT.md").FullName
```

### 🔍 Breakdown

**Resolve-Path**

Resolves the supplied path and returns information about its complete location.

**Relative path prefix (`.\`)**

Represents the terminal's current directory. The rest of the relative path is resolved from that location.

**Parentheses**

Cause `Resolve-Path` or `Get-Item` to run before PowerShell accesses a property on the returned object.

**.Path**

Selects only the resolved path string from the object returned by `Resolve-Path`.

**Get-Item**

Retrieves the file or directory as a PowerShell object.

**.FullName**

Selects the item's complete path from the object returned by `Get-Item`.

### Requirements

The target file or directory must already exist. The relative path must also be correct for the terminal's current location.

### ✅ Verification

Confirm the current location when a relative path does not resolve:

```powershell
Get-Location
```

Confirm that the target exists:

```powershell
Test-Path ".\docs\PRODUCT.md"
```

`Test-Path` returns `True` when the path exists.

### ⚠️ Common Mistakes

- Running the command from a different directory than the relative path assumes.
- Omitting quotes around a path containing spaces.
- Expecting `Resolve-Path` to create a missing file or directory.
- Copying the `Path` table heading when only the complete path text is needed. Use `(Resolve-Path "<path>").Path` instead.
- Copying the `PS C:\...>` prompt as part of the path.

### 🔗 Related Commands

```powershell
Get-Item
Get-Location
Test-Path
```

### 💡 Lo Notes

This command was documented after manually combining the output of `pwd` with a filename to obtain a complete path.

Use `Resolve-Path` to let PowerShell assemble and validate the path. Add `.Path` when another tool needs the result as plain text.

## Create Files and Directories (New-Item and mkdir)

### 🎯 Purpose

Create one or more files or directories from PowerShell, including items inside another directory without changing the terminal's current location.

### ⚙️ What It Does

`New-Item` creates a new item at each path supplied to it. The `-ItemType` parameter specifies whether the item is a file or a directory.

In Windows PowerShell, `mkdir` is a convenience function that calls `New-Item` with the item type set to `Directory`. It creates directories only.

### 🤔 Why It Matters

Useful for creating project files and directories quickly while remaining at the project root. A relative path can point into an existing subdirectory, so changing directories first is unnecessary.

For example, from:

```text
PS C:\Users\Jaypr\Python-Projects\recipe-dashboard>
```

you can create a file inside `docs` by including `docs` in the path.

### 📌 Aliases and Shortcuts

```powershell
ni
mkdir
```

`ni` is an alias for `New-Item`.

Use `mkdir` when creating directories. Use `New-Item` or `ni` when creating files or when you want the item type to be explicit.

### 💻 Full Command

```powershell
New-Item
```

### 📖 General Patterns

Create one file:

```powershell
New-Item -Path ".\<filename>" -ItemType File
```

For a simple interactive command, the `-Path` parameter name and item type can be omitted:

```powershell
ni ".\<filename>"
```

For filesystem paths, `New-Item` creates a file by default when `-ItemType` is omitted. Writing `-ItemType File` makes the intent explicit.

Create one directory:

```powershell
New-Item -Path ".\<directory-name>" -ItemType Directory
```

Create multiple files at once:

```powershell
New-Item -Path ".\<first-file>", ".\<second-file>" -ItemType File
```

Create multiple directories at once:

```powershell
New-Item -Path ".\<first-directory>", ".\<second-directory>" -ItemType Directory
```

Create multiple directories with `mkdir`:

```powershell
mkdir ".\<first-directory>", ".\<second-directory>"
```

Create an item inside a different existing directory:

```powershell
New-Item -Path ".\<directory>\<filename>" -ItemType File
```

### Optional `-Path` Parameter Name

`-Path` is the first positional parameter of `New-Item`. When the path is the first unnamed value after the command, PowerShell assigns that value to `-Path` automatically.

The path value is still required, but writing the parameter name is optional in this position. These commands are equivalent:

```powershell
New-Item -Path "DATA_DICTIONARY.md"
New-Item "DATA_DICTIONARY.md"
ni -Path "DATA_DICTIONARY.md"
ni "DATA_DICTIONARY.md"
```

The shorter positional form is convenient for simple commands entered directly in the terminal. The explicit form is useful while learning, in documentation, in scripts, or whenever naming parameters makes a longer command easier to understand.

Both forms can target a different directory without changing the terminal's current location:

```powershell
ni -Path ".\docs\DATA_DICTIONARY.md"
ni ".\docs\DATA_DICTIONARY.md"
```

### 📝 Examples

From the `recipe-dashboard` project root, create `GLOSSARY.md` inside the existing `docs` directory without changing directories:

```powershell
New-Item -Path ".\docs\GLOSSARY.md" -ItemType File
```

Create two files in `docs` at once:

```powershell
New-Item -Path ".\docs\GLOSSARY.md", ".\docs\SOURCES.md" -ItemType File
```

Create two directories at the project root:

```powershell
New-Item -Path ".\data", ".\tests" -ItemType Directory
```

Create two directories inside `docs` with `mkdir`:

```powershell
mkdir ".\docs\guides", ".\docs\examples"
```

Create a file using an absolute path, regardless of the terminal's current location:

```powershell
New-Item -Path "C:\Users\Jaypr\Python-Projects\recipe-dashboard\docs\GLOSSARY.md" -ItemType File
```

### 🔍 Breakdown

**New-Item**

Creates a new item at the specified path.

**-Path**

Specifies where to create the item. It accepts one path or multiple comma-separated paths.

The parameter name is optional when its value is supplied in the first positional slot. Omitting `-Path` does not mean there is no path; PowerShell interprets the first unnamed value as the path.

**-ItemType File**

Creates an empty file.

**-ItemType Directory**

Creates a directory.

**mkdir**

Creates a directory without requiring `-ItemType Directory`.

**Relative path prefix (`.\`)**

Represents the terminal's current directory. For example, `.\docs\GLOSSARY.md` means `GLOSSARY.md` inside the `docs` directory beneath the current location.

**Absolute path**

A complete path beginning with a drive letter, such as `C:\Users\Jaypr\...`. It does not depend on the terminal's current directory.

### ✅ Verification

Confirm that the new items exist:

```powershell
Get-ChildItem ".\docs"
```

Check one specific path:

```powershell
Test-Path ".\docs\GLOSSARY.md"
```

`Test-Path` returns `True` when the item exists.

### ⚠️ Common Mistakes

- Thinking that `-Path` itself is required. The path value is required, but the parameter name can be omitted when the path is in the first positional slot.
- Assuming `-ItemType File` is always required. It is optional for filesystem files, although using it can make scripts and documentation clearer.
- Using `mkdir` to create a file; `mkdir` creates directories only.
- Forgetting that relative paths are resolved from the terminal's current directory.
- Supplying a nested path whose parent directory does not exist.
- Reusing a path that already exists without first checking it. PowerShell may report that the item already exists.
- Copying the `PS C:\...>` prompt text as part of the command.

Use quotes around paths that contain spaces.

### 🔗 Related Commands

```powershell
Get-ChildItem
Get-Location
Set-Location
Test-Path
```

### 💡 Lo Notes

The important pattern is that a command can target another directory through its path. The terminal does not have to move into that directory first.

Use a relative path when the target is inside the current project. Use an absolute path when the command should work independently of the current terminal location.

## Delete Files (Remove-Item)

### 🎯 Purpose

Delete one or more files from PowerShell, including files in another directory without changing the terminal's current location.

### ⚙️ What It Does

`Remove-Item` removes the item at the specified path.

For normal filesystem use, a file deleted with `Remove-Item` does not go to the Recycle Bin. Treat the operation as permanent.

### 🤔 Why It Matters

Useful for removing an unwanted file directly from the terminal while keeping the target path explicit and verifiable.

### 📌 Aliases

```powershell
del
ri
rm
```

These aliases execute the `Remove-Item` cmdlet. The full command is clearer in scripts and documentation.

### 💻 Full Command

```powershell
Remove-Item
```

### 📖 General Patterns

Preview a deletion without performing it:

```powershell
Remove-Item -LiteralPath ".\<filename>" -WhatIf
```

Delete one file:

```powershell
Remove-Item -LiteralPath ".\<filename>"
```

Delete one file using the concise interactive form:

```powershell
ri ".\<filename>"
```

Delete multiple specific files:

```powershell
Remove-Item -LiteralPath ".\<first-file>", ".\<second-file>"
```

Request confirmation before deleting:

```powershell
Remove-Item -LiteralPath ".\<filename>" -Confirm
```

### Positional `-Path` and `-LiteralPath`

`-Path` is the first positional parameter of `Remove-Item`. When a filename or path is the first unnamed value after the command, PowerShell assigns it to `-Path` automatically.

These commands are equivalent:

```powershell
Remove-Item -Path "20260722_Design_phase_complete.docx"
Remove-Item "20260722_Design_phase_complete.docx"
ri -Path "20260722_Design_phase_complete.docx"
ri "20260722_Design_phase_complete.docx"
```

The filename is a relative path. When the file is in the terminal's current directory, only its name is needed.

The short form can also target another directory without changing locations:

```powershell
ri ".\docs\OLD_NOTES.md"
```

The important distinction is that an unnamed positional value binds to `-Path`, not `-LiteralPath`.

`-Path` supports wildcard characters such as `*`, `?`, and `[]`. `-LiteralPath` treats every character as part of the exact filename and must be written explicitly:

```powershell
ri -LiteralPath "notes[1].txt"
```

Use the concise positional form for a simple, known filename entered interactively. Use explicit `-LiteralPath` in scripts, for filenames containing wildcard characters, or whenever identifying one exact target is more important than brevity.

### 📝 Examples

From the `recipe-dashboard` project root, preview deleting a file inside `docs`:

```powershell
Remove-Item -LiteralPath ".\docs\OLD_NOTES.md" -WhatIf
```

Delete the file after confirming the preview points to the correct target:

```powershell
Remove-Item -LiteralPath ".\docs\OLD_NOTES.md"
```

Delete two specific files at once:

```powershell
Remove-Item -LiteralPath ".\draft-one.txt", ".\draft-two.txt"
```

Delete a file using its complete path:

```powershell
Remove-Item -LiteralPath "C:\Users\Jaypr\Python-Projects\recipe-dashboard\docs\OLD_NOTES.md"
```

### 🔍 Breakdown

**Remove-Item**

Deletes the specified file or directory.

**-LiteralPath**

Identifies the exact target. PowerShell does not interpret wildcard characters such as `*` or `?` when they appear in a literal path.

**-Path**

Identifies one or more targets and supports wildcard matching. Its parameter name can be omitted when the path is supplied as the first positional argument.

**-WhatIf**

Displays what PowerShell would remove without performing the deletion.

**-Confirm**

Requests confirmation before PowerShell performs the deletion.

### ✅ Safer Workflow

Confirm that the target exists:

```powershell
Test-Path -LiteralPath ".\docs\OLD_NOTES.md"
```

Inspect the exact item:

```powershell
Get-Item -LiteralPath ".\docs\OLD_NOTES.md"
```

Preview the deletion:

```powershell
Remove-Item -LiteralPath ".\docs\OLD_NOTES.md" -WhatIf
```

Delete only after the path is correct:

```powershell
Remove-Item -LiteralPath ".\docs\OLD_NOTES.md"
```

Verify that the file no longer exists:

```powershell
Test-Path -LiteralPath ".\docs\OLD_NOTES.md"
```

The final `Test-Path` should return `False`.

### ⚠️ Common Mistakes

- Assuming that `ri "<filename>"` uses `-LiteralPath`. The positional argument binds to `-Path`.
- Assuming the file can always be recovered from the Recycle Bin.
- Deleting before verifying the current directory and target path.
- Using a wildcard when only one specific file should be removed.
- Omitting quotes around paths containing spaces.
- Copying the `PS C:\...>` prompt as part of the command.
- Using `-Force` automatically instead of understanding why a normal deletion failed.

This entry intentionally does not provide a recursive directory-deletion command. Recursive deletion has a larger impact and requires additional path verification.

### 🔗 Related Commands

```powershell
Get-Item
Get-Location
Resolve-Path
Test-Path
```

### 💡 Lo Notes

Use `-LiteralPath` when deleting a known file and `-WhatIf` when there is any uncertainty about the target.

The short aliases are convenient at the terminal, but `Remove-Item` makes the destructive action easier to recognize before running it.

For a simple file in the current directory, `ri "<filename>"` is a reasonable interactive shortcut. Remember that the filename is still a path value even though the `-Path` parameter name is omitted.

## Search Python Files for a Function or Text

### 🎯 Purpose

Find which Python file contains a specific function, class, variable, or text pattern.

### ⚙️ What It Does

Searches every Python file in the current directory and its subdirectories, then displays matching lines with their file paths and line numbers.

### 🤔 Why It Matters

Useful when you remember the name of a function or piece of code but do not remember which file contains it.

### 📌 Aliases

```powershell
gci
sls
```

- `gci` is an alias for `Get-ChildItem`.
- `sls` is an alias for `Select-String`.

### 💻 Full Commands

```powershell
Get-ChildItem
Select-String
```

### 📖 General Pattern

```powershell
Get-ChildItem -Path <search-location> -Recurse -File -Filter <file-pattern> |
    Select-String -Pattern "<search-text>"
```

### 📝 Example — Full Commands

Search all Python files for the `get_basic_recommendation` function:

```powershell
Get-ChildItem -Path . -Recurse -File -Filter *.py |
    Select-String -Pattern "def get_basic_recommendation"
```

### 📝 Example — Aliases

```powershell
gci -Recurse -File -Filter *.py | sls "def get_basic_recommendation"
```

### 🔍 Breakdown

**`-Path .`**

Starts the search in the current directory.

**`-Recurse`**

Searches all subdirectories.

**`-File`**

Returns files only.

**`-Filter *.py`**

Limits the search to Python files.

**`|`**

Passes the files found by `Get-ChildItem` into `Select-String`.

**`-Pattern`**

Defines the text to search for inside each file.

### ⚠️ Common Mistakes

Do not place a space between the hyphen and parameter name.

Incorrect:

```powershell
- File *.py
```

Correct:

```powershell
-File -Filter *.py
```

### 🔗 Related Commands

```powershell
Get-Content
Select-String
Get-ChildItem
```

### 💡 Lo Notes

Used to locate `get_basic_recommendation()` inside:

```text
analysis\recommendation_engine.py
```

Use the full version while learning how the command works. Use the aliases when speed is more important.

---

## Open a Specific File in PyCharm

### 🎯 Purpose

Open a specific project file directly from PowerShell.

### ⚙️ What It Does

Launches PyCharm and opens the file at the supplied path.

### 🤔 Why It Matters

Useful after locating a file through PowerShell and wanting to begin editing it immediately without navigating through the PyCharm project panel.

### 📌 Alias

None.

### 💻 Full Command

```powershell
pycharm64.exe
```

### 📖 General Pattern

```powershell
pycharm64.exe <file-path>
```

### 📝 Example

```powershell
pycharm64.exe .\analysis\recommendation_engine.py
```

### 🔍 Breakdown

**`pycharm64.exe`**

Launches the native PyCharm executable.

**`.\`**

Represents the current directory.

**`analysis\recommendation_engine.py`**

The relative path to the file being opened.

### ⚠️ Common Mistakes

The PyCharm `bin` directory must be included in the Windows `PATH` environment variable.

The command must also be run from a location where the relative file path is valid.

### 🔗 Related Commands

```powershell
pycharm64.exe .
pwd
Get-ChildItem
```

### 💡 Lo Notes

Use:

```powershell
pycharm64.exe .
```

to open the entire current project.

Use:

```powershell
pycharm64.exe <file-path>
```

to open one specific file.

---

## Display a File in the Terminal

### 🎯 Purpose

Display the contents of a text or code file directly in PowerShell.

### ⚙️ What It Does

Reads the specified file and prints its contents in the terminal.

### 🤔 Why It Matters

Useful for reviewing code, configuration files, logs, and documentation without opening the file in an editor.

### 📌 Aliases

```powershell
cat
type
gc
```

These aliases execute the `Get-Content` cmdlet in PowerShell.

### 💻 Full Command

```powershell
Get-Content
```

### 📖 General Pattern

```powershell
Get-Content <file-path>
```

### 📝 Example

```powershell
Get-Content .\analysis\recommendation_engine.py
```

### 🔍 Breakdown

**`Get-Content`**

Reads and displays file contents.

**`<file-path>`**

Identifies the file to read.

### ⚠️ Common Mistakes

Displaying a large file without limiting the output can flood the terminal and make the relevant section difficult to find.

For larger files, combine `Get-Content` with `Select-Object`.

### 🔗 Related Commands

```powershell
Select-Object
Select-String
```

### 💡 Lo Notes

Use this when the entire file is small enough to review comfortably in the terminal.

---

## Display the Beginning of a File

### 🎯 Purpose

Display only the first specified number of lines from a file.

### ⚙️ What It Does

Reads a file and limits the output to the beginning portion.

### 🤔 Why It Matters

Useful when the function, import section, configuration, or other relevant code appears near the top of a large file.

### 📌 Alias

None for the complete command pipeline.

### 💻 Full Commands

```powershell
Get-Content
Select-Object
```

### 📖 General Pattern

```powershell
Get-Content <file-path> | Select-Object -First <line-count>
```

### 📝 Example

Display the first 75 lines:

```powershell
Get-Content .\analysis\recommendation_engine.py | Select-Object -First 75
```

### 🔍 Breakdown

**`Get-Content`**

Reads the file.

**`|`**

Passes the file contents into the next command.

**`Select-Object -First 75`**

Returns only the first 75 lines.

### ⚠️ Common Mistakes

`-First` starts from the beginning of the file. It does not begin at a custom line number.

Use `-Skip` with `-First` when the desired section appears later in the file.

### 🔗 Related Commands

```powershell
Select-Object -Skip
Select-String -Context
```

### 💡 Lo Notes

Useful for quickly reviewing imports, early functions, or configuration at the top of a file.

---

## Display a Specific Portion of a File

### 🎯 Purpose

Display a selected range of lines from a larger file.

### ⚙️ What It Does

Skips a specified number of lines and then displays the next specified number.

### 🤔 Why It Matters

Useful for inspecting a known section without printing the entire file or manually scrolling through it.

### 📌 Alias

None for the complete command pipeline.

### 💻 Full Commands

```powershell
Get-Content
Select-Object
```

### 📖 General Pattern

```powershell
Get-Content <file-path> |
    Select-Object -Skip <lines-to-skip> -First <lines-to-display>
```

### 📝 Example

Skip the first 50 lines and display the next 60:

```powershell
Get-Content .\analysis\recommendation_engine.py |
    Select-Object -Skip 50 -First 60
```

One-line version:

```powershell
Get-Content .\analysis\recommendation_engine.py | Select-Object -Skip 50 -First 60
```

### 🔍 Breakdown

**`-Skip 50`**

Ignores the first 50 lines.

**`-First 60`**

Displays the next 60 lines after the skipped section.

### ⚠️ Common Mistakes

`-Skip 50` begins output after the first 50 lines. It does not necessarily correspond exactly to editor line number 50 because the first returned line is the next line after those skipped.

### 🔗 Related Commands

```powershell
Select-Object -First
Select-String -Context
```

### 💡 Lo Notes

Use this after learning approximately where the relevant code appears in the file.

---

## Display Matching Text with Surrounding Context

### 🎯 Purpose

Find a specific line in a file and display the lines surrounding it.

### ⚙️ What It Does

Searches for a text pattern and prints a chosen number of lines before and after the match.

### 🤔 Why It Matters

Useful for viewing most or all of a function without printing the entire file or knowing its exact line range.

### 📌 Alias

```powershell
sls
```

`sls` is an alias for `Select-String`.

### 💻 Full Command

```powershell
Select-String
```

### 📖 General Pattern

```powershell
Select-String `
    -Path <file-path> `
    -Pattern "<search-text>" `
    -Context <lines-before>,<lines-after>
```

### 📝 Example

Find `get_basic_recommendation()` and display 60 lines after its definition:

```powershell
Select-String `
    -Path .\analysis\recommendation_engine.py `
    -Pattern "def get_basic_recommendation" `
    -Context 0,60
```

### 🔍 Breakdown

**`-Path`**

Specifies the file to search.

**`-Pattern`**

Defines the text to locate.

**`-Context 0,60`**

Displays zero lines before the match and 60 lines after it.

**Backtick: `` ` ``**

Continues the PowerShell command onto the next line.

### ⚠️ Common Mistakes

The backtick must be the final character on the line. A trailing space after it may break command continuation.

PowerShell does not understand where a Python function ends. The context value controls only the number of surrounding lines shown.

### 🔗 Related Commands

```powershell
Get-Content
Select-Object -First
Select-Object -Skip
```

### 💡 Lo Notes

This command was used to display `get_basic_recommendation()` from its definition through its return statement.

It can be combined with the project-wide search workflow:

1. Search all Python files to locate the function.
2. Use the returned path with `Select-String -Context`.
3. Open the file in PyCharm when editing is required.

---

## Workflow: Locate, Inspect, and Open Code

### 🎯 Purpose

Find code anywhere in a project, inspect the relevant section in PowerShell, and then open the file for editing.

### Step 1 — Locate the Function

```powershell
Get-ChildItem -Path . -Recurse -File -Filter *.py |
    Select-String -Pattern "def get_basic_recommendation"
```

### Step 2 — Inspect the Function

```powershell
Select-String `
    -Path .\analysis\recommendation_engine.py `
    -Pattern "def get_basic_recommendation" `
    -Context 0,90
```

### Step 3 — Open the File

```powershell
pycharm64.exe .\analysis\recommendation_engine.py
```

### 💡 Lo Notes

Use the commands together instead of relying on the GUI to search, scroll, and locate code manually.

This workflow improves both PowerShell repetition and familiarity with the project structure.
---
## Run a Python Function from PowerShell

### Purpose

Import and run a Python function directly from PowerShell without creating a
temporary script or launching the full application.

---

### Alias

None

---

### Full Command

```powershell
python -c "from analysis.what_if_engine import run_weight_simulation; from analysis.indicator_weights import INDICATOR_WEIGHTS; engine_config = INDICATOR_WEIGHTS.copy(); engine_config['hit_rate'] = 2; run_weight_simulation(engine_config)"
```

---

### General Pattern

```powershell
python -c "from <module> import <function>; <setup>; <function>(<arguments>)"
```

---

### Example

Run this from the root of the `prizepicks-value-dashboard` repository:

```powershell
python -c "from analysis.what_if_engine import run_weight_simulation; from analysis.indicator_weights import INDICATOR_WEIGHTS; engine_config = INDICATOR_WEIGHTS.copy(); engine_config['hit_rate'] = 2; run_weight_simulation(engine_config)"
```

If the virtual environment is not activated, call the project interpreter directly.

```powershell
.\venv\Scripts\python.exe -c "from analysis.what_if_engine import run_weight_simulation; from analysis.indicator_weights import INDICATOR_WEIGHTS; engine_config = INDICATOR_WEIGHTS.copy(); engine_config['hit_rate'] = 2; run_weight_simulation(engine_config)"
```

---

### Breakdown

`python -c`

Runs the Python code supplied as the next command-line argument.

`from analysis.what_if_engine import run_weight_simulation`

Imports the What-If Engine's development entry point.

`from analysis.indicator_weights import INDICATOR_WEIGHTS`

Imports the production weights as the starting configuration.

`engine_config = INDICATOR_WEIGHTS.copy()`

Creates a separate dictionary so the simulation can change values without
modifying the imported production dictionary.

`engine_config['hit_rate'] = 2`

Changes only the simulated hit-rate weight.

`run_weight_simulation(engine_config)`

Runs the comparison and historical replay with the simulated values.

The outer code string uses double quotes, so the Python dictionary key can use
single quotes without ending the PowerShell argument.

---

### Requirements

- Run from the `prizepicks-value-dashboard` repository root so project imports resolve consistently and relative file paths, including
  `paper_bets.csv`, point to the expected location.
- Use the project's virtual environment, so required packages are available.
- Pass a complete weight dictionary because the recommendation engine accesses
  every required weight by name.

---

### Common Mistakes

- Running from the wrong directory and receiving an import or missing-file error.
- Using `python` when it is not configured in the Windows PATH. Use
  `.\venv\Scripts\python.exe` instead.
- Omitting `.copy()` and unintentionally changing the imported dictionary during
  an interactive Python session.
- Mixing the outer double quotes and inner single quotes incorrectly.
- Passing only `{'hit_rate': 2}` instead of a complete weight dictionary.

---

### When I Use It

- Running the What-If Engine during development.
- Testing one function without launching the full application.
- Trying a configuration change and inspecting its terminal output.
- Interrogating application behavior from PowerShell.

---

### Related Commands

```powershell
pwd
cd
python
.\venv\Scripts\python.exe
```

---

### Lo Notes

This command established a reusable pattern for running project functions from
PowerShell. The lesson is not to memorize the entire line, but to recognize the
pattern: select the correct interpreter, use `-c`, import what is needed, prepare
the inputs, and call the function.

---

## Run Multiline Python from PowerShell

### Purpose

Run several lines of Python from PowerShell without compressing the code into
one hard-to-read `python -c "..."` command or creating a temporary `.py` file.

Use this technique when:

- The one-line `python -c "..."` command is becoming hard to read.
- You need several imports and setup steps.
- You want to test a function directly.
- You do not want to create a temporary script.
- You want to practice both PowerShell and Python execution.

---

### General Pattern

```powershell
$code = @'
<multiline Python code>
'@

python -c $code
```

If the virtual environment is not activated:

```powershell
.\venv\Scripts\python.exe -c $code
```

---

### What a Here-String Is

A PowerShell here-string stores multiline text in a variable while preserving
the line breaks. The opening and closing markers must be placed on their own
lines.

A single-quoted here-string treats its contents as literal text:

```powershell
$text = @'
PowerShell does not expand $variables inside this form.
'@
```

A double-quoted here-string allows PowerShell variable expansion:

```powershell
$name = "PrizePicks"

$text = @"
PowerShell expands $name inside this form.
"@
```

The single-quoted form is usually safer for embedded Python because PowerShell
does not try to expand Python text that resembles a PowerShell variable.

---

### What-If Engine Example

Run this from the root of the `prizepicks-value-dashboard` repository with its
virtual environment activated:

```powershell
$code = @'
from analysis.what_if_engine import run_weight_simulation
from analysis.indicator_weights import INDICATOR_WEIGHTS

engine_config = {
    'indicator_weights': INDICATOR_WEIGHTS.copy()
}

engine_config['indicator_weights']['hit_rate'] = 2

run_weight_simulation(engine_config)
'@

python -c $code
```

This is still a direct `python -c` execution. The difference is that the Python
program is stored in `$code` first, which makes its imports, setup, and function
call easier to read and modify.

---

### Quote-Handling Issue We Discovered

The first version used double quotes for the Python dictionary keys:

```python
engine_config = {
    "indicator_weights": INDICATOR_WEIGHTS.copy()
}
```

When the `$code` variable was passed from Windows PowerShell to Python, the
embedded double quotes were not preserved as expected. Python received the key
as an unquoted name and raised:

```text
NameError: name 'indicator_weights' is not defined
```

Using single quotes for Python string values inside the here-string preserved
the keys correctly:

```python
engine_config = {
    'indicator_weights': INDICATOR_WEIGHTS.copy()
}
```

This was a PowerShell-to-native-command argument-quoting issue, not a problem
with the What-If Engine or Python dictionaries.

---

### When to Use It

- Testing a focused function with several imports or setup statements.
- Trying a small configuration without creating a permanent script.
- Turning a difficult-to-read one-line `python -c` command into readable Python.
- Investigating application behavior from PowerShell.
- Running a short experiment that does not need to be saved or reused by the
  project.

---

### When a Real `.py` Script Is More Appropriate

Create a real Python script when:

- The code will be reused regularly or shared with someone else.
- The command needs arguments, validation, error handling, or documentation.
- The experiment is becoming long or contains several functions.
- The behavior should be tested or tracked in Git.
- The command is becoming an official project entry point or development tool.

A here-string is useful for temporary interrogation. A `.py` file is better
when the code becomes part of the project.

---

### Lo Notes

This technique was learned while verifying the structured configuration for the
PrizePicks What-If Engine. It made a multi-step Python command easier to read,
and the initial `NameError` demonstrated that shell quoting can change code
before Python receives it.

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
