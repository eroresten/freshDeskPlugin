function Search($config, $search, $category)
{   
    $result = @()
	$query = @()    
    $output = @()
    $pair = "$($config.APIKey):$($config.APIKey)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $FDHeaders = @{ Authorization = $basicAuthValue }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $config | Export-Clixml C:\Temp\config.xml
    # START - Code for getting output properties
    if ($dropdown.output.add) {
        $outputObject = $dropdown.output.add
        if ($outputObject | Where-Object { $_.key -eq 'Id' }) {
            $id = ($outputObject | Where-Object { $_.key -eq 'Id' }).value
        }
        else {
            $id = 'id'
        }
        if ($outputObject | Where-Object { $_.key -eq 'Name' }) {
            [array]$name = (($outputObject | Where-Object { $_.key -eq 'Name' }).value).Split(",").Trim()
            [array]$properties = (($outputObject | Where-Object { $_.key -eq 'Name' }).value).Split(",").Trim() -replace "\W"
        }
        else {
            [array]$name = @('displayName','(userPrincipalName)')
            [array]$properties = @('displayName')
        }
    }
    else {
        $id = 'id'
        [array]$name = @('displayName','(userPrincipalName)')
        [array]$properties = @('displayName')
    }
    # END - Code for getting output properties

    $query = New-Object PSObject
    foreach ($role in $config.roles) {        
        foreach ($parameter in $dropDown.parameter) {
            foreach ($item in $parameter.add) {
                $value = $item.value -replace '\$search', $search -replace '\$role', $role -replace "'\*\*'","'*'"
                if($item.key -eq $role) {
                    $query | Add-Member -MemberType NoteProperty -Name $([string]$parameter.name) -Value $([string]$value)
                }
            }
        }
    }
    
    if ([string]$query[0]) {
        $res = @()
        foreach($q in $query) {
            foreach ($entity in $q.EntityName.Trim()) {
                $uri = "https://ekarls20.freshdesk.com/api/v2/$entity"
                $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

                if($res) {
                    $result += $res
                }
            }
        }

        $result | Select-Object -Unique @{
            Name="Id";
            Expression = {
                $_."$id"
            }
        }, 
        @{
            Name="Name";
            Expression = {
                $returnObject = @()
                foreach ($item in $name) {
                    $attribute = $item -replace "\W"
                    $result = $_."$attribute"
                    $returnObject += $item -replace $attribute, $result
                }
                [string]::Join(" ",$returnObject)
            }
        }
    }
}

function Validate($config, $search) 
{
    $result = @()
	$query = @()    
    $output = @()

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12

    # START - Code for getting output properties
    if ($dropdown.output.add) {
        $outputObject = $dropdown.output.add
        if ($outputObject | Where-Object { $_.key -eq 'Id' }) {
            $id = ($outputObject | Where-Object { $_.key -eq 'Id' }).value
        }
        else {
            $id = 'id'
        }
        if ($outputObject | Where-Object { $_.key -eq 'Name' }) {
            [array]$name = (($outputObject | Where-Object { $_.key -eq 'Name' }).value).Split(",").Trim()
            [array]$properties = (($outputObject | Where-Object { $_.key -eq 'Name' }).value).Split(",").Trim() -replace "\W"
        }
        else {
            [array]$name = @('displayName','(userPrincipalName)')
            [array]$properties = @('displayName')
        }
    }
    else {
        $id = 'id'
        [array]$name = @('displayName','(userPrincipalName)')
        [array]$properties = @('displayName')
    }
    # END - Code for getting output properties

    foreach ($role in $config.roles) {
        $query = New-Object PSObject
        foreach ($parameter in $dropDown.parameter) {
            foreach ($item in $parameter.add) {
                $value = $item.value -replace '\$search', $search -replace '\$role', $role -replace "'\*\*'","'*'"
                if($item.key -eq $role) {
                    $query | Add-Member -MemberType NoteProperty -Name $([string]$parameter.name) -Value $([string]$value)
                }
            }
        }
    }
    
    if ([string]$query[0]) {
        $res = @()
        foreach($q in $query) {
            foreach ($entity in $q.EntityName.Trim()) {
                $uri = "https://ekarls20.freshdesk.com/api/v2/$entity/$search"
                $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

                if($res) {
                    $result += $res
                }
            }
        }

        $result | Select-Object -Unique @{
            Name="Id";
            Expression = {
                $_."$id"
            }
        }, 
        @{
            Name="Name";
            Expression = {
                $returnObject = @()
                foreach ($item in $name) {
                    $attribute = $item -replace "\W"
                    $result = $_."$attribute"
                    $returnObject += $item -replace $attribute, $result
                }
                [string]::Join(" ",$returnObject)
            }
        }
    }
}

function GetCategories($config) 
{

}

function GetDefault($config)
{    
    $result = @()
	$query = @()    
    $output = @()
    $pair = "$($config.APIKey):$($config.APIKey)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $FDHeaders = @{ Authorization = $basicAuthValue }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $config | Export-Clixml C:\Temp\config.xml
    # START - Code for getting output properties
    if ($dropdown.output.add) {
        $outputObject = $dropdown.output.add
        if ($outputObject | Where-Object { $_.key -eq 'Id' }) {
            $id = ($outputObject | Where-Object { $_.key -eq 'Id' }).value
        }
        else {
            $id = 'id'
        }
        if ($outputObject | Where-Object { $_.key -eq 'Name' }) {
            [array]$name = (($outputObject | Where-Object { $_.key -eq 'Name' }).value).Split(",").Trim()
            [array]$properties = (($outputObject | Where-Object { $_.key -eq 'Name' }).value).Split(",").Trim() -replace "\W"
        }
        else {
            [array]$name = @('displayName','(userPrincipalName)')
            [array]$properties = @('displayName')
        }
    }
    else {
        $id = 'id'
        [array]$name = @('displayName','(userPrincipalName)')
        [array]$properties = @('displayName')
    }
    # END - Code for getting output properties

    $query = New-Object PSObject
    foreach ($role in $config.roles) {        
        foreach ($parameter in $dropDown.parameter) {
            foreach ($item in $parameter.add) {
                $value = $item.value -replace '\$search', $search -replace '\$role', $role -replace "'\*\*'","'*'"
                if($item.key -eq $role) {
                    $query | Add-Member -MemberType NoteProperty -Name $([string]$parameter.name) -Value $([string]$value)
                }
            }
        }
    }
    
    if ([string]$query[0]) {
        $res = @()
        foreach($q in $query) {
            foreach ($entity in $q.EntityName.Trim()) {
                $uri = "https://ekarls20.freshdesk.com/api/v2/$entity"
                $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $FDHeaders -ContentType application/json

                if($res) {
                    $result += $res
                }
            }
        }

        $result | Select-Object -Unique @{
            Name="Id";
            Expression = {
                $_."$id"
            }
        }, 
        @{
            Name="Name";
            Expression = {
                $returnObject = @()
                foreach ($item in $name) {
                    $attribute = $item -replace "\W"
                    $result = $_."$attribute"
                    $returnObject += $item -replace $attribute, $result
                }
                [string]::Join(" ",$returnObject)
            }
        }
    }
}
