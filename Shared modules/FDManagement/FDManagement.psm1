function Get-FDAuthorizationHeader($Config) {
    $pair = "$($config.APIKey):$($config.APIKey)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $FDHeaders = @{ Authorization = $basicAuthValue }
    $FDHeaders
}

function Get-FDAgent($Id, $Config) {
    $uri = "https://ekarls20.freshdesk.com/api/v2/agents/$($Id)"
    $FDHeaders = Get-FDAuthorizationHeader -Config $config    

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

    $res
}

function Get-FDAllAgents($Config) {
    $uri = "https://ekarls20.freshdesk.com/api/v2/agents"
    $FDHeaders = Get-FDAuthorizationHeader -Config $config

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

    $res
}

function Get-FDStatusAsString($Id) {
    $statusTranslation = @{2="Open";3="Pending";4="Resolved";5="Closed";6="Waiting for Customer"}
    $statusTranslation[$Id]
}

function Get-FDPriorityAsString($Id) {
    $priorityTranslation = @{1="1 - Low";2="2 - Medium";3="3 - High";4="4 - Urgent"}
    $priorityTranslation[$Id]
}

function Get-FDSourceAsString($Id) {
    $sourceTranslation = @{1="Email";2="Portal";3="Phone";7="Chat";8="Mobihelp";9="Feedback Widget";10="Outbound email"}
    $sourceTranslation[$Id]
}

function Get-FSCommentStyling() {    
    "border: lightgray;border-style: solid;border-radius: 3px;border-width: 1px;box-shadow: 3px 2px 2px lightgrey;padding: 3px;margin-bottom: 10px;margin-right: 16px;font-size: 12px;display: flex;justify-content: space-between;"
}

Export-ModuleMember *-*