Import-Module WindowsDisplayManager
$primaryDisplay = WindowsDisplayManager\GetPrimaryDisplay

Write-Host "Update Successful?: $($primaryDisplay.SetResolution(3440,1440,144) -and $primaryDisplay.EnableHdr())"