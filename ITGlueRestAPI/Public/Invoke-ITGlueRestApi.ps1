Function Invoke-ITGlueRestAPI {
  [cmdletbinding()]
  param(
    [Parameter(Mandatory = $True)]
    [String]
    $Resource,

    [String]
    $Command,
    
    [ValidateSet('Get', 'Set', 'New', 'Remove')]
    [String]
    $Verb = 'Get',

    [String[]]
    $Body
  )
  Begin {
    $Method = Switch ($Verb) {
      'Get' {'GET'}
      'Set' {'PATCH'}
      'New' {'POST'}
      'Remove' {'DELETE'}
    }

    [String]$Uri = '{0}/{1}' -F $Script:ITGlueApiUri, $Resource
    If ($Command) {
      $Uri += '?{0}' -F $Command
    }

    $Params = @{
      Method      = $Method
      Uri         = $Uri
      ErrorAction = 'Stop'
    }
    If ($Body) {
      $Params['Body'] = $Body
    }

    $Result = @()
  }

  Process {
    Do { 
      Try {
        $Response = Invoke-RestMethod @Params
      }
      Catch {Throw $_}
      $Result += $Response.data
      $Params['Uri'] = $Response.links.next
    }
    While ($Response.links.next)
  }
  
  End {
    Return $Result
  }
}