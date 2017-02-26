<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Verb-Noun
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Param1 help description
        [string]
        $Path,
        $FileName,
        $Container,
        $StorageContext
    )
    $blob = Set-AzureStorageBlobContent -File "$Path$FileName" -Container $Container -Blob $FileName -BlobType Block -Context $StorageContext -Force
    
    Return $blob
}
