Import-Module WindowsDisplayManager
$primaryDisplay = WindowsDisplayManager\GetPrimaryDisplay

$primaryDisplay.SetResolution(1920,1080,60)
$primaryDisplay.DisableHdr()
