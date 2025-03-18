param(
    [string]$Mime        = "image/x-icon",
    [string]$Title       = "",
    [string]$FaviconFile = "vite.svg"
)

Write-Host "Running update_html.ps1..."
Write-Host "  Mime:        $Mime"
Write-Host "  Title:       $Title"
Write-Host "  FaviconFile: $FaviconFile"

# 1. Replace type="..." & href="..." only in <link rel="icon"...>
(Get-Content '.\frontend\dist\index.html') `
-replace '(?<=<link[^>]*rel="icon"[^>]*type=")[^"]*', $Mime `
-replace '(?<=<link[^>]*rel="icon"[^>]*href=")[^"]*', $FaviconFile `
| Set-Content '.\frontend\dist\index.html'

Write-Host "[INFO] Favicon type & href replaced."

# 2. Replace <title>...</title>
if ($Title -ne "") {
    (Get-Content '.\frontend\dist\index.html') `
    -replace '(?<=<title>)(.*?)(?=</title>)', $Title `
    | Set-Content '.\frontend\dist\index.html'
    
    Write-Host "[INFO] Title replaced."
} else {
    Write-Host "[WARNING] Title is empty, skipping."
}
