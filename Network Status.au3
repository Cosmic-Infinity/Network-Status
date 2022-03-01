#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Cosmic-Infinity

 Script Function:
	Elegantly start wifi status and place it in a convenient spot

#ce ----------------------------------------------------------------------------
#include <MsgBoxConstants.au3>
#include <WinAPISysWin.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <FontConstants.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>

Global $count = 0
Global $wifidiag = ""
Global $left = 1040
Global $right = 565
;Global $active = ControlGetHandle("[ACTIVE]",'','')
main()
move()


Func main()

	Opt("SendKeyDelay", 20)
	;MsgBox($MB_SYSTEMMODAL, "Found OS", @OSVersion)

	Run(@ComSpec & " /c ncpa.cpl")
	WinWaitActive("Network Connections")

	If FileExists(@ScriptDir & "\NetworkCount.cfg") Then
		$count = FileReadLine(@ScriptDir & "\NetworkCount.cfg", 1)
		$wifidiag = FileReadLine(@ScriptDir & "\NetworkCount.cfg", 2)
		$left = FileReadLine(@ScriptDir & "\NetworkCount.cfg", 3)
		$right = FileReadLine(@ScriptDir & "\NetworkCount.cfg", 4)
		If @error Then
		   FileDelete(@ScriptDir & "\NetworkCount.cfg")
		   WinClose("Network Connections")
		   MsgBox($MB_ICONWARNING, "Read Error", "Please relaunch the appliction")
		   Exit
		EndIf

		activate()
	Else
		While True
			Send("{RIGHT}")
			Send("{ENTER}")
			Sleep(1000)
			Local $title = WinGetTitle("[ACTIVE]")
			WinActivate($title)
			If $title == "WiFi Status" Or "Wi-Fi Status" Then
			   ;MsgBox($MB_SYSTEMMODAL, "Found", $title)
				$count += 1
				_FileCreate(@ScriptDir & "\NetworkCount.cfg")
				_FileWriteToLine(@ScriptDir & "\NetworkCount.cfg", 1, $count, True, True)
				_FileWriteToLine(@ScriptDir & "\NetworkCount.cfg", 2, $title, True, True)
				defineposition()
				activate1()
				ExitLoop
			Else
				WinClose($title)
				WinWaitClose($title)
				$count += 1
			EndIf
		WEnd
	EndIf
	Return
EndFunc   ;==>main


Func activate1()

	For $i = 1 To $count
		Send("{RIGHT}")
	Next
	Return

EndFunc   ;==>activate

Func activate()
	For $i = 1 To $count
		Send("{RIGHT}")
	Next
	Send("{ENTER}")
	Return

EndFunc   ;==>activate




Func move()


	WinWaitActive($wifidiag)


    WinClose("Network Connections")
	DllCall("User32.dll", "bool", "SetProcessDPIAware")
	WinMove($wifidiag, "General", $left, $right, Default, Default, 1)
	;WinMove($wifidiag, "General", 1040, 565, Default, Default, 1)
    ;MsgBox($MB_SYSTEMMODAL, "Found", $wifidiag)

	Return
	;Sleep(2000)

	;$wifiwin = WinGetHandle("Wi-Fi Status", "General")

	_;WinAPI_SetWindowPos ($wifiwin, $HWND_TOPMOST, 0,0,0,0,$SWP_NOMOVE)
	;_WinAPI_SetParent($wifiwin, $desktop)

EndFunc   ;==>move


Func defineposition()

	Local $notinstalled = MsgBox(BitOR($MB_YESNO, $MB_SETFOREGROUND, $MB_ICONWARNING), "Window Position", "Place WiFi window in a custom position? " & @CRLF & "(NO? Use the default position)")
	If $notinstalled = $IDYES Then
		DllCall("User32.dll", "bool", "SetProcessDpiAwarenessContext", "HWND", "DPI_AWARENESS_CONTEXT" - 2)
		Global $installgui = GUICreate("Position", @DesktopWidth / 4, @DesktopHeight / 4, -1, -1, BitOR($WS_SYSMENU, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
		GUISetIcon("assets\ns24.ico")
		TraySetIcon("assets\ns48.ico")
		GUISetBkColor(0x00FFFFFF)
		GUISetState()

		Local $size = WinGetPos($installgui)

		Local $installlabel = GUICtrlCreateLabel("Left: ", $size[2]*0.15, $size[3] * 0.15, $size[2]/6.6, $size[3] / 5)
		GUICtrlSetFont(-1, 10, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
		Local $lefttx = GUICtrlCreateInput("", $size[2] * 0.3, $size[3] * 0.14, $size[2] * 0.5, $size[3] * 0.15)
		;GUICtrlSetLimit(-1, 6)
		GUICtrlSetFont(-1, 10, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
		GUICtrlSetTip(-1, "Distance of Wi-Fi window from left end of screen")

		Local $installlabel = GUICtrlCreateLabel("Top: ", $size[2]*0.15, $size[3] * 0.35, $size[2]/6.6, $size[3] / 5)
		GUICtrlSetFont(-1, 10, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
		Local $toptx = GUICtrlCreateInput("", $size[2] * 0.3, $size[3] * 0.34, $size[2] * 0.5, $size[3] * 0.15)
		;GUICtrlSetLimit(-1, 6)
		GUICtrlSetFont(-1, 10, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
		GUICtrlSetTip(-1, "Distance of Wi-Fi window from top of the screen")



		Local $installok = GUICtrlCreateButton("OK", $size[2] * 0.45, $size[3] * 0.55, $size[2] * 0.125, $size[3] * 0.175)
		GUICtrlSetFont(-1, 10, $FW_EXTRALIGHT, 0, "Candara", 2)
		GUICtrlSetTip(-1, "Once done, click here.")

		Do
			Local $n = GUIGetMsg()

			Switch $n
			   Case $installok
				  _FileWriteToLine(@ScriptDir & "\NetworkCount.cfg", 3, GUICtrlRead($lefttx), True, True)
				  _FileWriteToLine(@ScriptDir & "\NetworkCount.cfg", 4, GUICtrlRead($toptx), True, True)
				  MsgBox($MB_OK, "Success", "Changes Svaed!" &@CRLF& "Restart application")
				  Return
			EndSwitch

		Until $n = $GUI_EVENT_CLOSE

	Else
		_FileWriteToLine(@ScriptDir & "\NetworkCount.cfg", 3, 1040, True, True)
		_FileWriteToLine(@ScriptDir & "\NetworkCount.cfg", 4, 565, True, True)
		MsgBox($MB_OK, "Success", "Changes Svaed!" &@CRLF& "Restart application")
		Return
	EndIf


   EndFunc

