function Search($config, $search, $category)
{   
    $allAgents = Get-FDAllAgents -Config $config

    $output = $allAgents | Select-Object @{
       Name="Id";
       Expression = {
           $_.id
       }
    },
    @{
        Name="Name";
        Expression = {
            $_.contact.name
        }
    }

    $output | Where-Object { $_.Name -like "*$($search)*" }
}

function Validate($config, $search) 
{
    if ($search) {
        $agent = Get-FDAgent -Id $search -Config $config
        $agent | Select-Object @{
           Name="Id";
           Expression = {
               $_.id
           }
        },
        @{
            Name="Name";
            Expression = {
                $_.contact.name
            }
        }
    }
}

function GetCategories($config) 
{

}

function GetDefault($config)
{    
    
}
