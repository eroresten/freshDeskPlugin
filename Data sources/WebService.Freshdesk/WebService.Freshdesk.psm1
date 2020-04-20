function Get-FDTickets
{
    param (
        [parameter(mandatory=$false)]
        [string]$Id,

        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Parameters,

        [parameter(Mandatory = $false, ParameterSetName = "Hidden")]
        [hashtable]$Config
    )

    if ($Id) {
        $uri = "https://$($config.TenantName).freshdesk.com/api/v2/tickets/$($Id)?include=requester"
    } else {
        $uri = "https://$($config.TenantName).freshdesk.com/api/v2/tickets?include=requester"
    }

    $FDHeaders = Get-FDAuthorizationHeader -Config $config  

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

    if ($Id) {
        $uri = "https://$($config.TenantName).freshdesk.com/api/v2/tickets/$($Id)/conversations"
        $conversations = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json
    }

    $out = @()

    foreach ($r in $res) {
        $row = @{}
        $row.Add("Id",$r.id)
        $row.Add("Type",$r.type)
        $row.Add("Created date", (Get-Date $r.created_at -Format "yyyy-MM-dd HH:mm"))
        $row.Add("Source", (Get-FDSourceAsString -Id $r.source))
        $row.Add("Requester", $r.requester.name)
        $row.Add("Priority", (Get-FDPriorityAsString -Id $r.priority))
        $row.Add("PriorityId", $r.priority)
        $row.Add("Status", (Get-FDStatusAsString -Id $r.status))
        $row.Add("StatusId", $r.status)
        $row.Add("Subject", $r.subject)
        $row.Add("Due by", (Get-Date $r.due_by -Format "yyyy-MM-dd HH:mm"))
        $row.Add("Description", $r.description_text)
        $row.Add("ResponderId", $r.responder_id)

        if ($Id) {
            $convList = ""
            foreach($co in $conversations) {
                 $convList += "<div style='" + (Get-FSCommentStyling) + "'><div>" + $co.body_text + "</div><div style='min-width: 100px;'>" + (Get-Date $co.created_at  -Format "yyyy-MM-dd HH:mm") + "</div></div>"           
            }
            $row.Add("Conversations", $convList)
        }
        
        $out += $row
    }
    $out
}
