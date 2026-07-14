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