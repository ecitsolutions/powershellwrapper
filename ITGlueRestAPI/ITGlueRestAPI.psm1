<#
    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.
#>

[CmdletBinding()]
Param(
  [Parameter(
    Mandatory = $True,
    Position = 0
  )]
  [String]
  $ApiKey,

  [Parameter(
    Position = 1
  )]
  [ValidateSet( 'US', 'EU')]
  [String]
  $Region = 'EU'
)

# Special consideration for -Verbose, as there is no $PSCmdLet context to check if Import-Module was called using -Verbose
# and $VerbosePreference is not inherited from Import-Module for some reason.

# Remove comments from calling command - if any
$ParentCommand = ($MyInvocation.Line -split '#')[0]

# Store Previous preference
$OldPreference = $VerbosePreference
If ($ParentCommand -like '*-Verbose*') {
  $VerbosePreference = 'Continue'
}

$ITGlueApiUri = switch ($Region) {
  'US' {'https://api.itglue.com'}
  'EU' {'https://api.eu.itglue.com'}
}

# Create necessary headers and commit them as a default parameter to 
# Invoke-RestMethod. Makes subsequent calls to API so much easier.
# Must be written to Script context or it will not work.
$PSDefaultParameterValues = @{
  'Invoke-RestMethod:Headers' = @{
    'x-api-key'    = $ApiKey
    'Content-Type' = 'application/vnd.api+json'
  }
}

# Get all function files as file objects
# Private functions can only be called internally in other functions in the module 
$PrivateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) 

# Public functions will be exported with Prefix prepended to the Noun of the function name
$PublicFunction = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) 

# Loop through all script files and source them
foreach ($Import in @($PrivateFunction + $PublicFunction)) {
  Write-Verbose "Importing $Import"
  try {
    . $Import.fullname
  }
  catch {
    throw "Could not import function $($Import.fullname): $_"
  }
}

# Explicitly export public functions
Export-ModuleMember -Function $PublicFunction.Basename

# Restore Previous preference
If ($OldPreference -ne $VerbosePreference) {
  $VerbosePreference = $OldPreference
}