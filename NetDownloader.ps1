Add-Type -AssemblyName System.Windows.Forms





# Hauptfenster
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Net Downloader"
$Form.Size = New-Object System.Drawing.Size(775, 500)
$Form.StartPosition = "CenterScreen"

# Text im Hauptfenster
$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Location = New-Object System.Drawing.Point(320, 50)
$welcomeLabel.AutoSize = $true # AutoSize auf True setzen
$welcomeLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$welcomeLabel.Text = "Herzlich Willkommen"
$Form.Controls.Add($welcomeLabel)

# Text im Hauptfenster
$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Location = New-Object System.Drawing.Point(310, 100)
$welcomeLabel.AutoSize = $true # AutoSize auf True setzen
$welcomeLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$welcomeLabel.Text = "Was möchtest du machen?"
$Form.Controls.Add($welcomeLabel)


# Button 1 - Öffnet Fenster 1
$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(275, 160)
$button1.Size = New-Object System.Drawing.Size(250, 50)
$button1.Text = "Herunterladen"
$button1.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$button1.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$button1.Add_Click({

        #Erstellt ein neues Dialogfenster
        $Form2 = New-Object System.Windows.Forms.Form
        $Form2.Text = "Herunterladen"
        $Form2.Size = New-Object System.Drawing.Size(700, 400)
        $Form2.StartPosition = "CenterScreen"

         # Label & Textbox für die URL
        $urlLabel = New-Object System.Windows.Forms.Label
        $urlLabel.Location = New-Object System.Drawing.Point(100, 50)
        $urlLabel.AutoSize = $true # AutoSize auf True setzen
        $urlLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $urlLabel.Text = "Gib die URL ein:"
        $Form2.Controls.Add($urlLabel)
        $urlTextBox = New-Object System.Windows.Forms.TextBox
        $urlTextBox.Location = New-Object System.Drawing.Point(230, 50)
        $urlTextBox.Size = New-Object System.Drawing.Size(400, 50)
        $Form2.Controls.Add($urlTextBox)

        # Label & Textbox für den Speicherort
        $pathLabel = New-Object System.Windows.Forms.Label
        $pathLabel.Location = New-Object System.Drawing.Point(100, 90)
        $pathLabel.AutoSize = $true # AutoSize auf True setzen
        $pathLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $pathLabel.Text = "Speicherort:"
        $Form2.Controls.Add($pathLabel)
        $pathTextBox = New-Object System.Windows.Forms.TextBox
        $pathTextBox.Location = New-Object System.Drawing.Point(230, 90)
        $pathTextBox.Size = New-Object System.Drawing.Size(300, 50)
        $Form2.Controls.Add($pathTextBox)

        # Button zum Auswählen des Speicherorts
        $browseButton = New-Object System.Windows.Forms.Button
        $browseButton.Location = New-Object System.Drawing.Point(540, 86)
        $browseButton.Size = New-Object System.Drawing.Size(90, 25)
        $browseButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $browseButton.Text = "Browse"
        $Form2.Controls.Add($browseButton)
        # Ereignisbehandlungsroutine für den Durchsuchen-Button
        $browseButton.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.RootFolder = "MyComputer"
    $result = $dialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $pathTextBox.Text = $dialog.SelectedPath
    }
})

        
        # Fortschrittsanzeige
# Fortschrittsanzeige
$downloadProgressBar = New-Object System.Windows.Forms.ProgressBar
$downloadProgressBar.Location = New-Object System.Drawing.Point(220, 240)
$downloadProgressBar.Size = New-Object System.Drawing.Size(250, 20)
$downloadProgressBar.Style = "Continuous"
$Form2.Controls.Add($downloadProgressBar)

# Label for download progress
$downloadProgressLabel = New-Object System.Windows.Forms.Label
$downloadProgressLabel.Location = New-Object System.Drawing.Point(220, 260)
$downloadProgressLabel.AutoSize = $true
$downloadProgressLabel.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Regular)
$downloadProgressLabel.Text = "Download Progress:"
$Form2.Controls.Add($downloadProgressLabel)

# Button zum Starten des Downloads
$downloadButton = New-Object System.Windows.Forms.Button
$downloadButton.Location = New-Object System.Drawing.Point(220, 180)
$downloadButton.Size = New-Object System.Drawing.Size(250, 50)
$downloadButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$downloadButton.Text = "Starte Download"
$Form2.Controls.Add($downloadButton)
$downloadButton.Add_Click({
    $webClient = New-Object System.Net.WebClient
    
    # URL and path from text boxes
    $url = $urlTextBox.Text
    $path = $pathTextBox.Text
    
    # Check if URL and path are provided
    if ([string]::IsNullOrWhiteSpace($url) -or [string]::IsNullOrWhiteSpace($path)) {
        [System.Windows.Forms.MessageBox]::Show("Please provide a valid URL and path.")
        return
    }
    
    # Confirm download
    $confirmResult = [System.Windows.Forms.MessageBox]::Show("Do you really want to start the download?", "Confirm download", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($confirmResult -eq [System.Windows.Forms.DialogResult]::No) {
        return
    }
            
    # Download file
    try {
        $webClient.DownloadFileAsync($url, $pathTextBox.Text + "/" + [System.IO.Path]::GetFileName($urlTextBox.Text))
        $webClient.DownloadProgressChanged.add({
            $downloadProgressBar.Value = $args[1]
            $downloadProgressLabel.Text = "Download Progress: $($args[1])%"
        })
        $webClient.DownloadFileCompleted.add({
            [System.Windows.Forms.MessageBox]::Show("Download completed!")
        })
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)")
    }
    finally {
        $webClient.Dispose()
    }
})


    
        $Form2.Controls.Add($downloadButton)

        # Zurück Button
        $button3 = New-Object System.Windows.Forms.Button
        $button3.Location = New-Object System.Drawing.Point(220, 230)
        $button3.Size = New-Object System.Drawing.Size(250, 50)
        $button3.Text = "Zurück"
        $button3.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $button3.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $button3.Add_Click({
                $Form2.Close()
            })
        $Form2.Controls.Add($button3)

        $Form2.ShowDialog()
    })
$Form.Controls.Add($button1)


# Button 2 - Öffnet Fenster 2
$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(275, 220)
$button2.Size = New-Object System.Drawing.Size(250, 50)
$button2.Text = "Verfügbarer Speicherplatz"
$button2.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$button2.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$button2.Add_Click({

        #Erstellt ein neues Dialogfenster
        $Form3 = New-Object System.Windows.Forms.Form
        $Form3.Text = "Speicherplatz"
        $Form3.Size = New-Object System.Drawing.Size(700, 400)
        $Form3.StartPosition = "CenterScreen"

        # Label-Steuerelement erstellen
        $speicherlabel = New-Object System.Windows.Forms.Label
        $speicherlabel.Location = New-Object System.Drawing.Point(130, 100)
        $speicherlabel.Size = New-Object System.Drawing.Size(300, 500)
        $speicherlabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $speicherlabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $speicherLabel.AutoSize = $true # AutoSize auf True setzen

        # Cmdlet ausführen und Ergebnis im Label anzeigen
        $volume = Get-Volume -DriveLetter 'C'
        $totalSpace = $volume | Select-Object -ExpandProperty Size
        $freeSpace = $volume | Select-Object -ExpandProperty SizeRemaining
        $totalSpaceGB = [math]::Round($totalSpace / 1GB, 2)
        $freeSpaceGB = [math]::Round($freeSpace / 1GB, 2)
        $speicherlabel.Text = "Gesamtspeicherplatz auf Laufwerk C: $totalSpaceGB GB`nVerfügbarer Speicherplatz auf Laufwerk C: $freeSpaceGB GB"

        $Form3.Controls.Add($speicherlabel)


        # Button-Steuerelement erstellen
        $aktualisierenButton = New-Object System.Windows.Forms.Button
        $aktualisierenButton.Location = New-Object System.Drawing.Point(220, 180)
        $aktualisierenButton.Size = New-Object System.Drawing.Size(250, 50)
        $aktualisierenButton.Text = "Aktualisieren"
        $aktualisierenButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $aktualisierenButton.Add_Click({
                # Cmdlet ausführen und Ergebnis im Label anzeigen
                $volume = Get-Volume -DriveLetter 'C'
                $totalSpace = $volume | Select-Object -ExpandProperty Size
                $freeSpace = $volume | Select-Object -ExpandProperty SizeRemaining
                $totalSpaceGB = [math]::Round($totalSpace / 1GB, 2)
                $freeSpaceGB = [math]::Round($freeSpace / 1GB, 2)
                $speicherlabel.Text = "Gesamtspeicherplatz auf Laufwerk C: $totalSpaceGB GB`nVerfügbarer Speicherplatz auf Laufwerk C: $freeSpaceGB GB"
            })

        $form3.Controls.Add($aktualisierenButton)

        # Zurück Button
        $button3 = New-Object System.Windows.Forms.Button
        $button3.Location = New-Object System.Drawing.Point(220, 230)
        $button3.Size = New-Object System.Drawing.Size(250, 50)
        $button3.Text = "Zurück"
        $button3.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $button3.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $button3.Add_Click({
                $Form3.Close()
            })
        $Form3.Controls.Add($button3)


        $Form3.ShowDialog()
    })
$Form.Controls.Add($button2)

# beendenButton
$button3 = New-Object System.Windows.Forms.Button
$button3.Location = New-Object System.Drawing.Point(275, 280)
$button3.Size = New-Object System.Drawing.Size(250, 50)
$button3.Text = "Beenden"
$button3.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$button3.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$button3.Add_Click({
        $Form.Close()
    })
$Form.Controls.Add($button3)

$Form.ShowDialog() | Out-Null
