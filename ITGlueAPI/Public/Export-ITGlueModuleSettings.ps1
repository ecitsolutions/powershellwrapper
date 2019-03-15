
function Export-ITGlueModuleSettings {
  # Locations of settings path and file
  If ($env:USERPROFILE) {
    $ITGlueAPIConfPath = "$($env:USERPROFILE)\ITGlueAPI"      
  }
  ElseIf ($env:HOME) {
    $ITGlueAPIConfPath = "$($env:HOME)\ITGlueAPI"  
  }
  else {
      Write-Error 'Do not recognise this platform. No userprofile found in environment.'
      Exit
  }
  $ITGlueAPIConfFile = "config.psd1"

  # Confirm variables exist and are not null before exporting
  if ($ITGlue_Base_URI -and $ITGlue_API_Key -and $ITGlue_JSON_Conversion_Depth) {
    $secureString = $ITGlue_API_KEY | ConvertFrom-SecureString
    New-Item -ItemType Directory -Force -Path $ITGlueAPIConfPath | ForEach-Object {$_.Attributes = "hidden"}
    @"
@{
    ITGlue_Base_URI = '$ITGlue_Base_URI'
    ITGlue_API_Key = '$secureString'
    ITGlue_JSON_Conversion_Depth = '$ITGlue_JSON_Conversion_Depth'
}
"@ | Out-File -FilePath ($ITGlueAPIConfPath + "\" + $ITGlueAPIConfFile) -Force
  }
  else {
    Write-Host "Failed export ITGlue Module settings to $ITGlueAPIConfPath\$ITGlueAPIConfFile"
  }
}