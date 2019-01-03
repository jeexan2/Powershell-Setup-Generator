Param
(
    [Parameter(Mandatory = $true)]
    [String] $RootPathValue
)

New-Item path.txt -itemType File
Set-Content path.txt $RootPathValue