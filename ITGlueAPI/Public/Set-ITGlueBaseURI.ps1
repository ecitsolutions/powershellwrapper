function Set-ITGlueBaseURI {
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = 'https://api.eu.itglue.com',

        [Alias('locale','dc')]
        [ValidateSet( 'US', 'EU')]
        [String]$data_center = ''
    )

    # Trim superflous forward slash from address (if applicable)
    if($base_uri[$base_uri.Length-1] -eq "/") {
        $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
    }

    switch ($data_center) {
        'US' {$base_uri = 'https://api.itglue.com'}
        'EU' {$base_uri = 'https://api.eu.itglue.com'}
        Default {}
    }

    Set-Variable -Name "ITGlue_Base_URI" -Value $base_uri -Option ReadOnly -Scope script -Force
}

New-Alias -Name Add-ITGlueBaseURI -Value Set-ITGlueBaseURI