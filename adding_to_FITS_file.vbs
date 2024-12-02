Sub AddHeaderInfoToFITS()
    ' Define the path to the external Python script
    Dim pythonScriptPath
    pythonScriptPath = "C:\Users\astronomer\Python_Scripts\webpage_header_info.py"

    ' Call the Python script and capture the output
    Dim objShell, pythonOutput
    Set objShell = CreateObject("WScript.Shell")
    pythonOutput = objShell.Exec("python """ & pythonScriptPath & """").StdOut.ReadAll()

    ' Extract values from the JSON response
    Dim RA, DEC, EPOCH, SIDTRACK, ALTITUDE, AZIMUTH, LST, HA, AIRMASS, FLAGS, TELLIMIT, UTTIME
	
	RA = GetValueFromOutput("RA", pythonOutput)
	DEC = GetValueFromOutput("DEC", pythonOutput)
	EPOCH = GetValueFromOutput("EPOCH", pythonOutput)
	SIDTRACK = GetValueFromOutput("SIDTRACK", pythonOutput)
	ALTITUDE = GetValueFromOutput("ALTITUDE", pythonOutput)
	AZIMUTH = GetValueFromOutput("AZIMUTH", pythonOutput)
	LST = GetValueFromOutput("LST", pythonOutput)
	HA = GetValueFromOutput("HA", pythonOutput)
	AIRMASS = GetValueFromOutput("AIRMASS", pythonOutput)
	FLAGS = GetValueFromOutput("FLAGS", pythonOutput)
	TELLIMIT = GetValueFromOutput("TELLIMIT", pythonOutput)
	UTTIME = GetValueFromOutput("UTTIME", pythonOutput)
	
	Dim cam
	Set cam = CreateObject("MaxIM.CCDCamera")
	
	cam.SetFITSKey  "RA", RA
	cam.SetFITSKey  "DEC", DEC
	cam.SetFITSKey  "EPOCH", EPOCH
	cam.SetFITSKey  "SIDTRACK", SIDTRACK
	cam.SetFITSKey  "SIDTRACK", SIDTRACK
	cam.SetFITSKey  "ALTITUDE", ALTITUDE
	cam.SetFITSKey  "AZIMUTH", AZIMUTH
	cam.SetFITSKey  "LST", LST
	cam.SetFITSKey  "HA", HA
	cam.SetFITSKey  "AIRMSS", AIRMASS
	cam.SetFITSKey  "FLAGS", FLAGS
	cam.SetFITSKey  "TELLIMIT", TELLIMIT
	cam.SetFITSKey  "UTTIME", UTTIME
	

End Sub

Function GetValueFromOutput(keys, output)
	Dim regex, matches
	Set regex = New RegExp
	regex.IgnoreCase = True
	regex.Global = True
	regex.Pattern = keys & "=(.*)"
	Set matches = regex.Execute(output)
	
	If matches.Count > 0 Then
		GetValueFromOutput = Trim(matches(0).SubMatches(0))
	Else
		GetValueFromOutput = ""
	End If
End Function

Sub OnSaveFITS()
    ' Call the function to add custom header information
    AddHeaderInfoToFITS()

    ' Save the image with the modified header information
    cam.SaveAs cam.FileName
End Sub

' Trigger the save process when you save the image
OnSaveFITS()

