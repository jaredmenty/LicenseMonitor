## Microsoft License Monitor

I created this script to monitor Microsoft license consumption since there was no built in method to do so. You are able to adjust how this notifies people as you see fit. 

I have two custom functions built in here: **Get-LicenseName** and **Get-M365LicenseUsage**.

##### Get-LicenseName
This uses a switch to convert the license id to a readible format. I found thta using the built in name can create confusion as they arent always clear. You can populate this by running Get-MgSubscribedSku and comparing the quantities to your portal or names to [Microsoft's Reference](https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference). Anything not in this list is marked as Unknown and filtered out in the Select part.

##### Get-M365Licensing
This iteraties through the subscribed licenses and creates a table that you can sort, filter, and modify as you see fit. This is converted to an HTML table and sent to recipients. 

### Things you need to change
- The Connect-Graph line will need to be modified to fit your environment. Here is a [Microsoft Authentication Reference](https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands?view=graph-powershell-1.0)
- The list of licenses and names in the Get-LicenseName function
- The recipient, sender, and SMTP server of the Send-MailMessage command

I am working on getting a JSON based threshold and alerting in place.
