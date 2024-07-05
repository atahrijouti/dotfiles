Import-Module WindowsDisplayManager
$primaryDisplay = WindowsDisplayManager\GetPrimaryDisplay

Write-Host "Update Successful?: $($primaryDisplay.SetResolution(1920,1080,60) -and $primaryDisplay.DisableHdr())"