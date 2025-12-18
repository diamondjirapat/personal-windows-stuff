# powershell -ExecutionPolicy Bypass -File .\winget.ps1

function Get-WingetId {
    param ($inputString)

    if ($inputString -match "--id[ =]?([^ ]+)") {
        return $Matches[1]
    }

    if ($inputString -match "winget install ([^ ]+)") {
        return $Matches[1]
    }

    return $inputString
}

# https://winstall.app/
$appsRaw = @(
    "Google.Chrome",
    "7zip.7zip",
    "Microsoft.VisualStudioCode",
    "Discord.Discord",
    "Valve.Steam",
    "Microsoft.DirectX",
    "OBSProject.OBSStudio",
    "Docker.DockerDesktop",
    "JetBrains.PyCharm",
    # "Spotify.Spotify",
    "winget install --id=GitHub.GitHubDesktop  -e",
    "winget install --id=REALiX.HWiNFO  -e",
    "winget install --id=Geeks3D.FurMark.2  -e",
    "winget install --id=Python.Python.3.14  -e",
    "winget install --id=qBittorrent.qBittorrent  -e",
    "winget install --id=pizzaboxer.Bloxstrap  -e",
    "winget install --id=Canva.Affinity  -e",
    "Ytmdesktop.Ytmdesktop"
)
$appsToInstall = $appsRaw | ForEach-Object { Get-WingetId $_ }

# -------------------------------

Write-Host "Starting app installation with Winget..." -ForegroundColor Cyan

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "Winget not found on this system. Skipping app installation."
}

foreach ($app in $appsToInstall) {
    Write-Host "Attempting to install: $app" -ForegroundColor Yellow
    
    winget install --id $app -e --silent --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully installed $app" -ForegroundColor Green
    } else {
        Write-Warning "Failed to install $app"
    }
}

Write-Host "All apps processed." -ForegroundColor Cyan
Write-Host "Script finished!" -ForegroundColor Green

