$accessGroups = @()
$accessGroups += @{id="1"; name='PlatinaX'}
$accessGroups += @{id="2"; name='PlatinaAdmin'}
$accessGroups += @{id="3"; name='Secret1'}
$accessGroups += @{id="4"; name='Secret2'}
$accessGroups += @{id="5"; name='Secret3'}
$accessGroups += @{id="6"; name='MegaAdmins'}
$accessGroups += @{id="7"; name='FullLicense'}
$accessGroups += @{id="8"; name='wpo-obscure-group'}
$accessGroups += @{id="9"; name='wpo-common-file-group'}

function Search($config, $search, $category)
{   
    if ($search) {
        $results = @()
        foreach ($row in $search) {
            $results += $accessGroups | Where-Object { $_.name -like "$($row)*" } | Select-Object @{
               Name="Id";
               Expression = {
                   $_.id
               }
            },
            @{
                Name="Name";
                Expression = {
                    $_.name
                }
            }
        }
        $results
    }
}

function Validate($config, $search) 
{
    if ($search) {
        $results = @()
        foreach ($row in $search) {
            $results += $accessGroups | Where-Object { $_.id -eq $row } | Select-Object @{
               Name="Id";
               Expression = {
                   $_.id
               }
            },
            @{
                Name="Name";
                Expression = {
                    $_.name
                }
            }
        }
        $results
    }
}

function GetCategories($config) 
{

}

function GetDefault($config)
{    
    $accessGroups | Select-Object @{
        Name="Id";
        Expression = {
            $_.id
        }
    },
    @{
        Name="Name";
        Expression = {
            $_.name
        }
    }
}
