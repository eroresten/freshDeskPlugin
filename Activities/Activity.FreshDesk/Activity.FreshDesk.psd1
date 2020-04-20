@{
    RootModule = 'Activity.FreshDesk.psm1'
    ModuleVersion = '1.0.0.0'
    GUID = '6a5d2971-4be2-4e97-9a53-5dd4bd1b2114'
    Author = 'Erik Oresten (Zervicepoint)'
    CompanyName = 'Zervicepoint'
    Copyright = '(c) 2020 Enfo. All rights reserved.'
    Description = 'Activity Module for FreshDesk.'
    PowerShellVersion = '4.0'
    ScriptsToProcess = @("Translations.ps1")
    NestedModules = @("..\..\Shared modules\FDManagement\FDManagement.psm1")
    FunctionsToExport = @(
       'Set-FDTicket',
       'New-FDReply',
       'Remove-FDTicket',
       'New-FDTicket'
    )
    ModuleList = @('Activity.FreshDesk.psm1')
    FileList = @(
        'Activity.FreshDesk.psm1',
        'en-US\Activity.FreshDesk.psd1',
        'sv-SE\Activity.FreshDesk.psd1'
    )
    HelpInfoURI = 'http://www.zervicepoint.com'
}