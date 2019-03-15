function Get-ITGlueAPIKey {
    if($ITGlue_API_Key -eq $null) {
        Write-Error "No API key exists. Please run Add-ITGlueAPIKey to add one."
    }
    else {
        $ITGlue_API_Key
    }
}