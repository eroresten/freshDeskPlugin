function New-FDTicket
{
    <#
      .Synopsis
         Creates a new ticket in FreshDesk.
    
      .DESCRIPTION
         This activity creates a new ticket in FreshDesk.
    
      .PARAMETER RequesterEmail
        The email of the requester
    
      .PARAMETER Subject
        The subject of the ticket

      .PARAMETER Description
        The description of the ticket

      .PARAMETER Status
        The status of the ticket. Must be an int

      .PARAMETER Priority
        The priority of the ticket. Must be an int

      .PARAMETER Assignee
        The assignee of the ticket. Must be an int
    
      .EXAMPLE
        $config = Get-PFConfig -Path [path to configfile]
        New-FDTicket -RequesterEmail bill@microsoft.com -Subject "Meeting required" -Description "Hi, can you book a meeting?" -Config $config
    
        The example above creates a FreshDesk ticket with the specified subject and description.
        Other default values such as priority and status will be applied.
    
      .NOTES
        The New-FDTicket activity is part of the Activity.FreshDesk module.
    
      .LINK
        http://www.zervicepoint.com
        https://github.com/eroresten/freshDeskPlugin
    #>
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RequesterEmail,
        [parameter(Mandatory = $false)]
        [string]$Subject,
        [parameter(Mandatory = $false)]
        [string]$Description,
        [parameter(Mandatory = $false)]
        [int]$Status,
        [parameter(Mandatory = $false)]
        [int]$Priority,
        [parameter(Mandatory = $false)]
        [string]$Assignee,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Config,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Parameters
    )
    
    if ($Assignee) {
        $Parameters.Add("responder_id", [int64]$Assignee)
    }

    $uri = "https://ekarls20.freshdesk.com/api/v2/tickets"
    $FDHeaders = Get-FDAuthorizationHeader -Config $config  
    
    $params = Get-FDParameters -Parameters $Parameters -ExludedProperties @('Config','Id','Parameters','Assignee')

    $body = ConvertTo-Json -InputObject $params

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
        $res = Invoke-RestMethod -Method Put -Uri $uri -Headers $FDHeaders -ContentType application/json -Body $body
        @{ ZPActivityStatus = $translation.NewFDTicket0 }
    } catch {
        Write-PFError -Message "Failed to create freshdesk ticket" -Config $Config -Parameters $parameters -Exception $_ -ErrorAction Continue
        @{ ZPActivityStatus = $translation.NewFDTicket1 }
    }
    
}

function Set-FDTicket
{
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
        [parameter(Mandatory = $false)]
        [string]$Subject,
        [parameter(Mandatory = $false)]
        [string]$Description,
        [parameter(Mandatory = $false)]
        [int]$Status,
        [parameter(Mandatory = $false)]
        [int]$Priority,
        [parameter(Mandatory = $false)]
        [string]$Assignee,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Config,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Parameters
    )

    if ($Assignee) {
        $Parameters.Add("responder_id", [int64]$Assignee)
    }

    $uri = "https://$($config.TenantName).freshdesk.com/api/v2/tickets/$($Id)"
    $FDHeaders = Get-FDAuthorizationHeader -Config $config  
    
    $params = Get-FDParameters -Parameters $Parameters -ExludedProperties @('Config','Id','Parameters','Assignee')

    $body = ConvertTo-Json -InputObject $params

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Put -Uri $uri -Headers $FDHeaders -ContentType application/json -Body $body

}

function Remove-FDTicket
{
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Config,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Parameters
    )

    $uri = "https://$($config.TenantName).freshdesk.com/api/v2/tickets/$($Id)"
    $FDHeaders = Get-FDAuthorizationHeader -Config $config 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Delete -Uri $uri -Headers $FDHeaders -ContentType application/json

}

function New-FDReply
{
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
        [parameter(Mandatory = $false)]
        [string]$Reply,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Config,
        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Parameters
    )

    $uri = "https://$($config.TenantName).freshdesk.com/api/v2/tickets/$($Id)/reply"
    $FDHeaders = Get-FDAuthorizationHeader -Config $config  

    $body = ConvertTo-Json -InputObject @{"body" = $Reply}

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Post -Uri $uri -Headers $FDHeaders -ContentType application/json -Body $body

}

function Get-FDParameters($Parameters, $ExludedProperties) {
    $newParameters = @{}
    foreach ($key in $Parameters.Keys) {
        if ($key -notin $ExludedProperties) {
            $newParameters.Add($key.ToLower(), $Parameters[$key])
        }
    }
    $newParameters
}