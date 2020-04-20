function Search($config, $search, $category)
{   
    $uri = "https://ekarls20.freshdesk.com/api/v2/tickets?filter=new_and_my_open"

    $pair = "$($config.APIKey):$($config.APIKey)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $FDHeaders = @{ Authorization = $basicAuthValue }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

    $output = $res | Select-Object @{
       Name="Id";
       Expression = {
           $_.id
       }
    },
    @{
        Name="Name";
        Expression = {
            "$($_.id): $($_.subject)"
        }
    }

    $output# | Where-Object { $_.Name -like "*$($search)*" }
}

function Validate($config, $search) 
{
    $uri = "https://ekarls20.freshdesk.com/api/v2/tickets/$search"

    $pair = "$($config.APIKey):$($config.APIKey)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $FDHeaders = @{ Authorization = $basicAuthValue }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

    $output = $res | Select-Object @{
       Name="Id";
       Expression = {
           $_.id
       }
    },
    @{
        Name="Name";
        Expression = {
            "$($_.id): $($_.subject)"
        }
    }

    $output# | Where-Object { $_.Name -like "*$($search)*" }
}

function GetCategories($config) 
{

}

function GetDefault($config)
{    
    $uri = "https://ekarls20.freshdesk.com/api/v2/tickets?filter=new_and_my_open"

    $pair = "$($config.APIKey):$($config.APIKey)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $FDHeaders = @{ Authorization = $basicAuthValue }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

    $output = $res | Select-Object @{
       Name="Id";
       Expression = {
           $_.id
       }
    },
    @{
        Name="Name";
        Expression = {
            "$($_.id): $($_.subject)"
        }
    }

    $output# | Where-Object { $_.Name -like "*$($search)*" }
}
