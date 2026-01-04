Import-Module WindowsDisplayManager
$primaryDisplay = WindowsDisplayManager\GetPrimaryDisplay

$primaryDisplay.SetResolution(3440,1440,144)
$primaryDisplay.DisableHdr()
 
