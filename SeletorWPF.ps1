Add-Type -AssemblyName presentationframework
[xml]$xaml = Get-Content .\Downloads\SeletorWPF.xaml
$reader = (New-Object System.Xml.XmlNodeReader $xaml)

#$Form = [Windows.Markup.XamlReader]::Load($reader)
try {
    $Form = [Windows.Markup.XamlReader]::Load($reader)
}
catch {
    Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."
    exit
}

$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

$CancelButton.Add_Click({
    [System.Windows.Window] $Form.Close()  
})

$FilterTextBox.Add_TextChanged({
Get-Service | select-string $FilterTextBox.Text
    $Data = Get-Service | select-string $FilterTextBox.Text
$ProjectsDataGrid.ItemsSource = $Data
})


$Data = Get-Service
$ProjectsDataGrid.ItemsSource = $Data
$Form.ShowDialog()


