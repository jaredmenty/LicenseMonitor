#Auth Reference - https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands?view=graph-powershell-1.0
#License Refernce - https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference

#Manual Connect
Connect-MgGraph -ClientId "########-####-####-####-############" -TenantId "########-####-####-####-############" -NoWelcome

function Get-LicenseName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$LicenseID
    )

    switch($LicenseID){
        ($LicenseID="########-####-####-####-############_########-####-####-####-############"){$LicenseName="M365 E3"}
        ($LicenseID="########-####-####-####-############_########-####-####-####-############"){$LicenseName="M365 E5"}

        default{
            $LicenseName="Unknown"
        }
    }

    return $LicenseName
}

function Get-M365LicenseUsage {
    [CmdletBinding()]

    [System.Collections.ArrayList]$Licenses = @()

    $SubscribedSKUs = Get-MgSubscribedSku
    foreach($SKU in $SubscribedSKUs){
        $LicenseObject = [PSCustomObject]@{
            Id = $SKU.Id
            SkuPartNumber = $SKU.SkuPartNumber
            ConsumedUnits = $SKU.ConsumedUnits
            PrepaidUnits = $SKU.PrepaidUnits.Enabled
            RemainingUnits = $($SKU.PrepaidUnits.Enabled) - $($SKU.ConsumedUnits)
            LicenseName = Get-LicenseName -LicenseID $SKU.Id
        }
        $Licenses.Add($LicenseObject) | Out-Null
    }

    return $Licenses

}

$CurrentLicense = Get-M365LicenseUsage

$Body = @"
<style>

table, th, td{
    border: 1px solid;
    border-collapse: collapse;
}

table{
    width:100%;
}

h2{
    background-color:#808080;
    color:black;
    text-align:center;
}

</style>
"@

$Body += "<center>Microsoft License Report</center>"
$Body += $CurrentLicense | Sort-Object RemainingUnits | Where-Object {$_.LicenseName -ne "Unknown"} | Select-Object LicenseName,ConsumedUnits,PrepaidUnits,RemainingUnits | ConvertTo-Html
$Body += "<p><center>Generated: $(Get-Date)</center></p>"
Send-MailMessage -From "SenderEmail@domain.com" -To "RecipientEmail@domain.com" -Subject "Microsoft License Report" -Body $Body -SmtpServer "smtp.domain.com" -BodyHtml

Disconnect-MgGraph
