function Set-ITGlueAPIKey {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [AllowEmptyString()]
    [Alias('ApiKey')]
    [string]$Api_Key
  )
  if ($Api_Key) {
    $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

    Set-Variable -Name "ITGlue_API_Key" -Value $x_api_key -Option ReadOnly -Scope script -Force
  }
  else {
    Write-Host "Please enter your API key:"
    $x_api_key = Read-Host -AsSecureString

    Set-Variable -Name "ITGlue_API_Key" -Value $x_api_key -Option ReadOnly -Scope script -Force
  }
}

New-Alias -Name Add-ITGlueAPIKey -Value Set-ITGlueAPIKey