[CmdletBinding()]
param(
    [Parameter()]
    [string]$ProjectPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$script:Counts = @{ Pass = 0; Warn = 0; Fail = 0 }

function Write-Result {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("PASS", "WARN", "FAIL", "INFO")]
        [string]$Level,
        [Parameter(Mandatory)]
        [string]$Message,
        [string]$NextStep
    )

    if ($Level -ne "INFO") {
        $key = $Level.Substring(0, 1) + $Level.Substring(1).ToLowerInvariant()
        $script:Counts[$key]++
    }
    Write-Host ("[{0}] {1}" -f $Level, $Message)
    if ($NextStep) {
        Write-Host ("       Next: {0}" -f $NextStep)
    }
}

function Get-ApplicationPath {
    param([Parameter(Mandatory)][string]$Name)

    $command = Get-Command -Name $Name -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($command) { return $command.Source }
    return $null
}

function Invoke-CapturedCommand {
    param(
        [Parameter(Mandatory)][string]$Executable,
        [string[]]$Arguments = @()
    )

    try {
        $output = & $Executable @Arguments 2>&1
        return [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Output = (($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine).Trim()
        }
    }
    catch {
        return [pscustomobject]@{ ExitCode = 1; Output = $_.Exception.Message }
    }
}

function Get-WherePaths {
    param([Parameter(Mandatory)][string]$Name)

    $output = & "$env:SystemRoot\System32\where.exe" $Name 2>$null
    if ($LASTEXITCODE -ne 0) { return @() }
    return @($output | Where-Object { $_ } | ForEach-Object { $_.Trim() })
}

function Get-NormalizedPath {
    param([Parameter(Mandatory)][string]$Path)

    $expanded = [Environment]::ExpandEnvironmentVariables($Path.Trim().Trim('"'))
    try {
        return [System.IO.Path]::GetFullPath($expanded).TrimEnd('\').ToLowerInvariant()
    }
    catch {
        return $expanded.TrimEnd('\').ToLowerInvariant()
    }
}

function Test-WindowsEnvironment {
    Write-Host "`n=== Phase 1 - Machine Validation ==="
    $isWindowsPlatform = [Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT
    if ($isWindowsPlatform) {
        $caption = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
        Write-Result PASS "Windows detected: $caption"
    }
    else {
        Write-Result FAIL "This audit supports Windows 11 development workstations." `
            -NextStep "Run it on a Windows 11 machine."
    }
}

function Test-PowerShell {
    Write-Result INFO "Current host: $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion)"
    $pwshPath = Get-ApplicationPath "pwsh"
    if ($pwshPath) {
        $version = Invoke-CapturedCommand $pwshPath @("--version")
        if ($version.ExitCode -eq 0) {
            Write-Result PASS "PowerShell 7 is available: $($version.Output) at $pwshPath"
        }
        else {
            Write-Result FAIL "pwsh was found but did not run successfully." -NextStep "Run: pwsh --version"
        }
    }
    else {
        Write-Result FAIL "PowerShell 7 is not available through pwsh." `
            -NextStep "Review the PowerShell section in docs\WORKSTATION_SETUP.md."
    }

    $windowsPowerShell = Get-ApplicationPath "powershell"
    if ($windowsPowerShell) {
        Write-Result INFO "Windows PowerShell is at $windowsPowerShell. powershell.exe and pwsh.exe are different products."
    }
    if ($PSVersionTable.PSEdition -eq "Desktop") {
        Write-Result WARN "The audit is running under Windows PowerShell 5.1." `
            -NextStep "Open a fresh PowerShell 7 session with pwsh and run the audit again."
    }
    elseif ($PSVersionTable.PSVersion.Major -ge 7) {
        Write-Result PASS "The audit is running under PowerShell 7 or newer."
    }
    else {
        Write-Result FAIL "The current PowerShell host is older than version 7."
    }
}

function Test-Python {
    $allPaths = @{}
    foreach ($name in @("python", "py", "pip")) {
        $paths = @(Get-WherePaths $name)
        if ($paths.Count -eq 0) {
            Write-Result FAIL "$name is unavailable." `
                -NextStep "Review Python installation and PATH in docs\WORKSTATION_SETUP.md."
            continue
        }
        $allPaths[$name] = $paths
        Write-Result INFO "$name paths returned by where.exe:"
        $paths | ForEach-Object { Write-Host "       $_" }
        $resolved = Get-ApplicationPath $name
        Write-Result INFO "Get-Command $name resolved to $resolved"
        $version = Invoke-CapturedCommand $resolved @("--version")
        if ($version.ExitCode -eq 0) {
            Write-Result PASS "$name reports: $($version.Output)"
        }
        else {
            Write-Result FAIL "$name was found but version detection failed." -NextStep "Run: $name --version"
        }
    }

    if ($allPaths.ContainsKey("python")) {
        if ($allPaths.python[0] -match "\\WindowsApps\\") {
            Write-Result WARN "WindowsApps resolves before the desired Python installation." `
                -NextStep "Inspect where.exe python and User and Machine PATH order."
        }
        else {
            Write-Result PASS "Python is not being intercepted by a WindowsApps path."
        }
        if ($allPaths.python.Count -gt 1) {
            Write-Result WARN "Multiple Python executables are available; this can be valid when intentional." `
                -NextStep "Compare where.exe python, where.exe py, and project interpreter settings."
        }
    }

    $pythonPath = Get-ApplicationPath "python"
    $pipPath = Get-ApplicationPath "pip"
    if ($pythonPath -and $pipPath) {
        $prefix = Invoke-CapturedCommand $pythonPath @("-c", "import sys; print(sys.prefix)")
        $pip = Invoke-CapturedCommand $pipPath @("--version")
        if ($prefix.ExitCode -eq 0 -and $pip.Output -notlike "*$($prefix.Output)*") {
            Write-Result WARN "pip may point to a different Python installation than python." `
                -NextStep "Run: python -m pip --version"
        }
        else {
            Write-Result PASS "pip appears consistent with the resolved Python installation."
        }
    }
}

function Test-PathScope {
    param([Parameter(Mandatory)][ValidateSet("User", "Machine")][string]$Scope)

    $raw = [Environment]::GetEnvironmentVariable("Path", $Scope)
    if ($null -eq $raw) {
        Write-Result WARN "$Scope PATH is not defined."
        return
    }
    $entries = @($raw -split ";")
    $quoteCount = @($raw.ToCharArray() | Where-Object { $_ -eq '"' }).Count
    $malformedQuotedEntry = $entries | Where-Object {
        @($_.ToCharArray() | Where-Object { $_ -eq '"' }).Count % 2 -ne 0
    }
    if ($quoteCount % 2 -ne 0 -or $malformedQuotedEntry) {
        Write-Result FAIL "$Scope PATH contains unmatched quotation marks." `
            -NextStep "Inspect the $Scope PATH without editing it."
    }
    else {
        Write-Result PASS "$Scope PATH has balanced quotation marks."
    }

    if ($entries | Where-Object { [string]::IsNullOrWhiteSpace($_) }) {
        Write-Result WARN "$Scope PATH contains an empty entry."
    }
    $seen = @{}
    foreach ($entry in ($entries | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        $normalized = Get-NormalizedPath $entry
        if ($seen.ContainsKey($normalized)) {
            Write-Result WARN "$Scope PATH contains a duplicate entry: $entry"
        }
        else {
            $seen[$normalized] = $true
        }
        $expanded = [Environment]::ExpandEnvironmentVariables($entry.Trim().Trim('"'))
        try {
            $entryExists = Test-Path -LiteralPath $expanded -ErrorAction Stop
            if (-not $entryExists) {
                Write-Result WARN "$Scope PATH entry does not exist: $entry" `
                    -NextStep "Confirm whether related software was uninstalled before changing PATH."
            }
        }
        catch {
            Write-Result WARN "$Scope PATH entry could not be inspected: $entry" `
                -NextStep "Review its permissions and existence without changing PATH."
        }
        if ($Scope -eq "Machine" -and $expanded -like "$env:USERPROFILE*") {
            Write-Result WARN "Machine PATH contains a user-profile path: $entry" `
                -NextStep "Confirm whether this belongs in User PATH instead."
        }
    }

    if ($Scope -eq "User") {
        $windowsAppsIndex = -1
        $pythonIndex = -1
        for ($index = 0; $index -lt $entries.Count; $index++) {
            if ($windowsAppsIndex -lt 0 -and $entries[$index] -match "\\WindowsApps\\?$") {
                $windowsAppsIndex = $index
            }
            if ($pythonIndex -lt 0 -and $entries[$index] -match "\\Python[^\\]*\\?$") {
                $pythonIndex = $index
            }
        }
        if ($windowsAppsIndex -ge 0 -and ($pythonIndex -lt 0 -or $windowsAppsIndex -lt $pythonIndex)) {
            Write-Result WARN "WindowsApps appears before a Python installation in User PATH." `
                -NextStep "Compare PATH order with where.exe python before making changes."
        }
    }
}

function Test-PathIntegrity {
    Test-PathScope "User"
    Test-PathScope "Machine"
    foreach ($name in @("git", "gh", "pwsh")) {
        $path = Get-ApplicationPath $name
        if ($path) {
            Write-Result PASS "$name command directory is available through PATH: $([IO.Path]::GetDirectoryName($path))"
        }
    }
}

function Test-Git {
    $gitPath = Get-ApplicationPath "git"
    if (-not $gitPath) {
        Write-Result FAIL "Git is unavailable." -NextStep "Review docs\WORKSTATION_SETUP.md."
        return
    }
    $version = Invoke-CapturedCommand $gitPath @("--version")
    Write-Result PASS "$($version.Output) at $gitPath"
    $lfs = Invoke-CapturedCommand $gitPath @("lfs", "version")
    if ($lfs.ExitCode -eq 0) {
        Write-Result PASS "Git LFS is available: $($lfs.Output)"
    }
    else {
        Write-Result FAIL "Git LFS is unavailable." -NextStep "Review the Git LFS section in docs\WORKSTATION_SETUP.md."
    }
    foreach ($key in @("user.name", "user.email")) {
        $value = Invoke-CapturedCommand $gitPath @("config", "--global", "--get", $key)
        if ($value.ExitCode -eq 0 -and $value.Output) {
            Write-Result PASS "Global Git $key is configured: $($value.Output)"
        }
        else {
            Write-Result WARN "Global Git $key is not configured." -NextStep "Review Git identity before creating commits."
        }
    }
}

function Test-GitHubCli {
    $ghPath = Get-ApplicationPath "gh"
    $commonExecutable = "C:\Program Files\GitHub CLI\gh.exe"
    if (-not $ghPath) {
        if (Test-Path -LiteralPath $commonExecutable) {
            Write-Result FAIL "GitHub CLI exists but is not available through PATH." `
                -NextStep "Inspect PATH and verify again in a fresh terminal."
        }
        else {
            Write-Result FAIL "GitHub CLI is unavailable." -NextStep "Review docs\WORKSTATION_SETUP.md."
        }
        return
    }
    $version = Invoke-CapturedCommand $ghPath @("--version")
    Write-Result PASS "GitHub CLI is available: $($version.Output.Split([Environment]::NewLine)[0])"
    $auth = Invoke-CapturedCommand $ghPath @("auth", "status")
    if ($auth.ExitCode -eq 0) {
        Write-Result PASS "GitHub CLI reports active authentication."
    }
    elseif ($auth.Output -match "not logged|no accounts|authentication|token") {
        Write-Result WARN "GitHub CLI is installed but authentication is not active." `
            -NextStep "Run gh auth status, then authenticate deliberately if needed."
    }
    else {
        Write-Result WARN "GitHub authentication could not be confirmed; connectivity may be unavailable." `
            -NextStep "Run gh auth status again when network access is available."
    }
}

function Find-PyCharm {
    $commandPath = Get-ApplicationPath "pycharm64.exe"
    if ($commandPath) { return $commandPath }
    $roots = @(
        (Join-Path $env:LOCALAPPDATA "Programs\PyCharm"),
        (Join-Path $env:LOCALAPPDATA "JetBrains\Toolbox\apps"),
        "C:\Program Files\JetBrains"
    )
    foreach ($root in $roots) {
        if (Test-Path -LiteralPath $root) {
            $match = Get-ChildItem -LiteralPath $root -Filter "pycharm64.exe" -File -Recurse -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if ($match) { return $match.FullName }
        }
    }
    return $null
}

function Test-PyCharm {
    $path = Find-PyCharm
    if (-not $path) {
        Write-Result FAIL "PyCharm was not detected." -NextStep "Confirm its installation and launcher location."
        return
    }
    $version = (Get-Item -LiteralPath $path).VersionInfo.ProductVersion
    if ($version) {
        Write-Result PASS "PyCharm $version detected at $path"
    }
    else {
        Write-Result PASS "PyCharm detected at $path"
    }
    Write-Result INFO "The script cannot prove which shell an open PyCharm tab uses. Run `$PSVersionTable.PSVersion in a new tab."
}

function Test-Workspace {
    Write-Host "`n=== Phase 2 - Workspace Validation ==="
    $workspace = Join-Path $env:USERPROFILE "Python-Projects"
    if (-not (Test-Path -LiteralPath $workspace)) {
        Write-Result WARN "Standard workspace is missing: $workspace" `
            -NextStep "Review the standard; do not move repositories automatically."
        return
    }
    if ((Get-Item -LiteralPath $workspace).PSIsContainer) {
        Write-Result PASS "Standard workspace exists and is a directory: $workspace"
    }
    else {
        Write-Result FAIL "Standard workspace path exists but is not a directory: $workspace"
    }
    foreach ($name in @("PycharmProjects", "IdeaProjects")) {
        $legacyPath = Join-Path $env:USERPROFILE $name
        if (Test-Path -LiteralPath $legacyPath) {
            Write-Result INFO "Legacy workspace may coexist with the standard: $legacyPath"
        }
    }

    $ghPath = Get-ApplicationPath "gh"
    if ($ghPath) {
        $repositoryAccess = Invoke-CapturedCommand $ghPath @("repo", "list", "--limit", "1", "--json", "nameWithOwner")
        if ($repositoryAccess.ExitCode -eq 0) {
            Write-Result PASS "GitHub repository access succeeded through the authenticated CLI."
        }
        elseif ($repositoryAccess.Output -match "not logged|authentication|token") {
            Write-Result WARN "GitHub repository access could not be verified because authentication is inactive." `
                -NextStep "Run gh auth status; do not authenticate automatically."
        }
        else {
            Write-Result WARN "GitHub repository access could not be verified; connectivity may be unavailable." `
                -NextStep "Retry gh repo list --limit 1 when network access is available."
        }
    }
    else {
        Write-Result WARN "GitHub repository access was skipped because gh is unavailable."
    }
}

function Test-Project {
    Write-Host "`n=== Phase 3 - Project Validation ==="
    if (-not $ProjectPath) {
        Write-Result INFO "Project validation skipped because -ProjectPath was not supplied."
        return
    }
    if (-not (Test-Path -LiteralPath $ProjectPath)) {
        Write-Result FAIL "Project path does not exist: $ProjectPath"
        return
    }
    $item = Get-Item -LiteralPath $ProjectPath
    if (-not $item.PSIsContainer) {
        Write-Result FAIL "Project path is not a directory: $ProjectPath"
        return
    }
    $project = $item.FullName.TrimEnd('\')
    Write-Result PASS "Project directory exists: $project"

    $gitPath = Get-ApplicationPath "git"
    if ($gitPath) {
        $inside = Invoke-CapturedCommand $gitPath @("-C", $project, "rev-parse", "--is-inside-work-tree")
        if ($inside.ExitCode -eq 0 -and $inside.Output -eq "true") {
            Write-Result PASS "Project appears to be a Git repository."
            $branch = Invoke-CapturedCommand $gitPath @("-C", $project, "branch", "--show-current")
            Write-Result INFO $(if ($branch.Output) { "Current branch: $($branch.Output)" } else { "No named branch is checked out." })
            $status = Invoke-CapturedCommand $gitPath @("-C", $project, "status", "--short")
            if ($status.Output) {
                Write-Result WARN "Working tree contains changes; this is not a machine failure."
                $status.Output.Split([Environment]::NewLine) | ForEach-Object { Write-Host "       $_" }
            }
            else {
                Write-Result PASS "Project working tree is clean."
            }
            $remotes = Invoke-CapturedCommand $gitPath @("-C", $project, "remote", "-v")
            if ($remotes.Output) {
                Write-Result INFO "Configured remotes (not contacted):"
                $remotes.Output.Split([Environment]::NewLine) | ForEach-Object { Write-Host "       $_" }
            }
            else {
                Write-Result WARN "Project has no configured Git remotes."
            }
        }
        else {
            Write-Result WARN "Project directory does not appear to be a Git repository."
        }
    }

    $venvFound = $false
    foreach ($name in @(".venv", "venv")) {
        $venvPath = Join-Path $project $name
        if (Test-Path -LiteralPath $venvPath -PathType Container) {
            Write-Result INFO "Common virtual environment directory found: $venvPath"
            $venvFound = $true
        }
    }
    if (-not $venvFound) {
        Write-Result INFO "No .venv or venv directory found; another environment strategy may be valid."
    }

    $pythonPath = Get-ApplicationPath "python"
    if ($pythonPath) {
        $executable = Invoke-CapturedCommand $pythonPath @("-c", "import sys; print(sys.executable)")
        Write-Result INFO "Active python reports sys.executable: $($executable.Output)"
        if ((Get-NormalizedPath $executable.Output).StartsWith((Get-NormalizedPath $project))) {
            Write-Result PASS "The active Python executable is inside the project directory."
        }
        else {
            Write-Result WARN "The active Python executable is outside the project directory." `
                -NextStep "Confirm the intended interpreter; do not recreate an environment automatically."
        }
    }
}

function Write-Summary {
    Write-Host "`n=== Summary ==="
    Write-Host "Passed checks : $($script:Counts.Pass)"
    Write-Host "Warnings      : $($script:Counts.Warn)"
    Write-Host "Failed checks : $($script:Counts.Fail)"
    if ($script:Counts.Fail -gt 0) {
        Write-Host "Overall status: FAIL"
        return 1
    }
    if ($script:Counts.Warn -gt 0) {
        Write-Host "Overall status: PASS WITH WARNINGS"
        return 0
    }
    Write-Host "Overall status: PASS"
    return 0
}

Write-Host "Developer Workstation Audit"
Write-Host "Read-only verification; no repairs will be attempted."
Test-WindowsEnvironment
Test-PowerShell
Test-Python
Test-PathIntegrity
Test-Git
Test-GitHubCli
Test-PyCharm
Test-Workspace
Test-Project
$exitCode = Write-Summary
exit $exitCode
