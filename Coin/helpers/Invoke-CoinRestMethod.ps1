function Invoke-CoinRestMethod
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateSet("original", "min-api")]
        $Api,

        [string]
        $Endpoint,

        [hashtable]
        $Body
    )

    try
    {
        $ApiBase = $CoinApis.$Api
        $Splat = @{
            Uri = "{0}/{1}" -f $ApiBase, $Endpoint
        }

        if ($Body)
        {
            $Splat["Body"] = $Body
        }

        # test that the response type value is greater than 100, if not, throw an error

        $Response = Invoke-RestMethod @Splat
        if ($Response.Response -eq "Error")
        {

            throw $Response.Message
        }
        else
        {
            $Response
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
