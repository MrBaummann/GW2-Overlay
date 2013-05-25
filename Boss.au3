#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=a.ico
#AutoIt3Wrapper_Outfile=..\Desktop\GW2_Timer.exe
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Written by Dauni.8290
;(c) 2013
#include <Inet.au3>
#include <String.au3>
#include <Array.au3>
#include <WinApi.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

$connect = _GetNetworkConnect()
If Not $connect Then
	MsgBox(48, "Warning", "You have no Internet Connection!")
	Exit
EndIf
Global $TIMER_VERSION = "0.5"
$serverid = IniRead("TimerConf.ini", "Server", "id", 2201)
$servername = ""
#region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Overlay", 180, 500, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor(0x505050, $Form1)
_WinAPI_SetLayeredWindowAttributes($Form1, 0x505050, 250)
#endregion ### END Koda GUI section ###
Global $option_mini = IniRead("TimerConf.ini", "Options", "minimize", 0)
Global $option_blackbg = IniRead("TimerConf.ini", "Options", "blackbg", 0)
Global $option_timer = IniRead("TimerConf.ini", "Options", "timer", 0)
Global $alllbl[1]
Global $statlbl[1]
Global $msgevents[1]
Global $name[1]
Global $status[1]
Global $wplbls[1]
; TESTING
Global $fireeletimer = ""
Global $Secs, $Mins, $Hour, $Time
; TESTING

; BOSSES
Global $option_boss_behemoth = IniRead("TimerConf.ini", "Bosses", "behemoth", 1)
Global $option_boss_felemental = IniRead("TimerConf.ini", "Bosses", "felemental", 1)
Global $option_boss_worm = IniRead("TimerConf.ini", "Bosses", "worm", 1)
Global $option_boss_golem = IniRead("TimerConf.ini", "Bosses", "golem", 1)
Global $option_boss_shatterer = IniRead("TimerConf.ini", "Bosses", "shatterer", 1)
Global $option_boss_quatl = IniRead("TimerConf.ini", "Bosses", "quatl", 1)
Global $option_boss_jormag = IniRead("TimerConf.ini", "Bosses", "jormag", 1)
Global $option_boss_meldanru = IniRead("TimerConf.ini", "Bosses", "meldanru", 1)
Global $option_boss_grenth = IniRead("TimerConf.ini", "Bosses", "grenth", 1)
Global $option_boss_dwayna = IniRead("TimerConf.ini", "Bosses", "dwayna", 1)
Global $option_boss_lyssa = IniRead("TimerConf.ini", "Bosses", "lyssa", 1)
Global $option_boss_balti = IniRead("TimerConf.ini", "Bosses", "balti", 1)
Global $option_boss_maw = IniRead("TimerConf.ini", "Bosses", "maw", 1)
Global $option_boss_kral = IniRead("TimerConf.ini", "Bosses", "kral", 1)
Global $option_boss_ulgoth = IniRead("TimerConf.ini", "Bosses", "ulgoth", 1)
Global $option_boss_dredge = IniRead("TimerConf.ini", "Bosses", "dredge", 1)
Global $option_boss_taidha = IniRead("TimerConf.ini", "Bosses", "taidha", 1)
Global $option_boss_shaman = IniRead("TimerConf.ini", "Bosses", "shaman", 1)
Global $option_boss_eye = IniRead("TimerConf.ini", "Bosses", "eye", 1)
; BOSSES

$pos = WinGetPos($Form1)
$x = IniRead("TimerConf.ini", "Position", "x", $pos[0])
$y = IniRead("TimerConf.ini", "Position", "y", $pos[1])
WinMove($Form1, "", $x, $y, Default, Default)
GUISetState(@SW_SHOW, $Form1)

$load = GUICtrlCreateLabel("Check Version..", 8, 44 + 16, 122, 24, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetColor(-1, 0xFFFFFF)
_ArrayAdd($alllbl, $load)
$online_version = _INetGetSource("http://timer.felix.vc/version")
If $TIMER_VERSION <> $online_version Then
	MsgBox(0, "New Version Available", "A new Version is available! Check out the Reddit Post!( http://tinyurl.com/gw2overredd )")
EndIf

For $i = 1 To UBound($alllbl) - 1
	GUICtrlDelete($alllbl[$i])
Next
$load = GUICtrlCreateLabel("Fetching...", 8, 44 + 16, 122, 24, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetColor(-1, 0xFFFFFF)
_ArrayAdd($alllbl, $load)


$front = TrayCreateItem("Show")
$serverMenu = TrayCreateMenu("Select Server")
$serverMenuEU = TrayCreateMenu("EU", $serverMenu)
$serverMenuNA = TrayCreateMenu("NA", $serverMenu)
$server_src = _INetGetSource("https://api.guildwars2.com/v1/world_names.json")
$serverList = StringSplit($server_src, @CRLF)
Global $server_count = UBound($serverList) - 1
Global $trayItems[$server_count]
For $i = 1 To $server_count - 1
	$line = $serverList[$i]
	$sid = _StringBetween($line, '"id":"', '",')
	$sname = _StringBetween($line, '"name":"', '"')
	$sid = $sid[0]
	$sname = $sname[0]
	$ctrlname = StringFormat("%s (%s)", $sname, $sid)
	If StringMid($sid, 1, 1) == "1" Then
		$trayItems[$i - 1] = TrayCreateItem($ctrlname, $serverMenuNA, $sid, 1)
	Else

		$trayItems[$i - 1] = TrayCreateItem($ctrlname, $serverMenuEU, $sid, 1)
	EndIf
	If ($sid == $serverid) Then
		$servername = $sname
		TrayItemSetState(-1, 1)
	EndIf
Next
$serverItem = TrayCreateItem(StringFormat("Your Server: %s (%s)", $servername, $serverid))
$options = TrayCreateItem("Options")
$reset = TrayCreateItem("Reset Completed Bosses")
$about = TrayCreateItem("About")
$exit = TrayCreateItem("Exit")
TraySetState()

$timer = TimerInit()

_getinfo(_INetGetSource("https://api.guildwars2.com/v1/events.json?world_id=" & $serverid))
AdlibRegister("updatetimer", 1000)
While 1
	Local $msg = TrayGetMsg()
	Switch $msg
		Case $exit
			Exit
		Case $front
			TrayItemSetState($front, 4)
			ShowWin()
		Case $about
			TrayItemSetState($about, 4)
			AboutEvent()
		Case $reset
			TrayItemSetState($reset, 4)
			ResetEvent()
		Case $options
			TrayItemSetState($options, 4)
			GUISetState(@SW_HIDE, $Form1)
			OptionEvent()
			GUISetState(@SW_SHOWNOACTIVATE, $Form1)
		Case 62
			TrayItemSetState($options, 4)
			GUISetState(@SW_HIDE, $Form1)
			OptionEvent()
			GUISetState(@SW_SHOWNOACTIVATE, $Form1)
		Case Else
			If $msg > 0 And $msg <> 62 Then
				SelectServer($msg)
			EndIf
	EndSwitch
	Local $state = WinGetState("[CLASS:ArenaNet_Dx_Window_Class]", "")
	Local $fstate = WinGetState($Form1)
	If $option_mini == 1 And Not BitAND($fstate, 8) Then
		If BitAND($state, 8) Then
			GUISetState(@SW_SHOWNOACTIVATE, $Form1)
		Else
			GUISetState(@SW_HIDE, $Form1)
		EndIf
	EndIf
	If TimerDiff($timer) > 10000 Then
		Local $fstate = WinGetState($Form1)
		If $fstate <> 5 And $fstate <> 13 Then
			_getinfo(_INetGetSource("https://api.guildwars2.com/v1/events.json?world_id=" & $serverid))
		EndIf
		$timer = TimerInit()
	EndIf

	$nMsg = GUIGetMsg()
	For $iID = 1 To UBound($msgevents) - 1
		If $nMsg = $msgevents[$iID] Then
			If (GUICtrlRead($msgevents[$iID]) == $GUI_CHECKED) Then
				IniWrite("TimerConf.ini", "Complete", $name[$iID], 1)
			Else
				IniWrite("TimerConf.ini", "Complete", $name[$iID], 0)
			EndIf
		EndIf
	Next
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _getinfo($str)
	AdlibUnRegister("updatetimer")
	For $i = 1 To UBound($status) - 1
		_ArrayDelete($status, $i)
	Next
	For $i = 1 To UBound($name) - 1
		_ArrayDelete($name, $i)
	Next
	If (IniRead("TimerConf.ini", "Complete", "Behemoth", 0) == 0 And $option_boss_behemoth == 1) Then
		$a1_1 = _StringBetween($str, '"event_id":"CFBC4A8C-2917-478A-9063-1A8B43CC8C38","state":"', '"},')
		$a1_2 = _StringBetween($str, '"event_id":"36330140-7A61-4708-99EB-010B10420E39","state":"', '"},')
		$a1_3 = _StringBetween($str, '"event_id":"AFCF031A-F71D-4CEA-85E1-957179414B25","state":"', '"},')
		$a1_4 = _StringBetween($str, '"event_id":"E539A5E3-A33B-4D5F-AEED-197D2716F79B","state":"', '"},')
		$a1_5 = _StringBetween($str, '"event_id":"31CEBA08-E44D-472F-81B0-7143D73797F5","state":"', '"},')
		If ($a1_1 <> "" And $a1_2 <> "" And $a1_3 <> "" And $a1_4 <> "" And $a1_5 <> "") Then
			If ($a1_1[0] == "Active" Or $a1_2[0] == "Active" Or $a1_3[0] == "Active" Or $a1_4[0] == "Active" Or $a1_5[0] == "Active") Then
				_ArrayAdd($name, "Behemoth")
				If ($a1_5[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Fire Elemental", 0) == 0 And $option_boss_felemental == 1) Then
		$a2_1 = _StringBetween($str, '"event_id":"2C833C11-5CD5-4D96-A4CE-A74C04C9A278","state":"', '"},')
		$a2_2 = _StringBetween($str, '"event_id":"33F76E9E-0BB6-46D0-A3A9-BE4CDFC4A3A4","state":"', '"},')
		$a2_3 = _StringBetween($str, '"event_id":"5E4E9CD9-DD7C-49DB-8392-C99E1EF4E7DF","state":"', '"},')
		If ($a2_1 <> "" And $a2_2 <> "" And $a2_3 <> "") Then
			If ($a2_1[0] == "Active" Or $a2_2[0] == "Active" Or $a2_3[0] == "Active") Then
				_ArrayAdd($name, "Fire Elemental")
				If ($option_timer == 1) Then
					If ($a2_2[0] == "Active") Then
						$fireeletimer = ""
						_ArrayAdd($status, "Active")
					ElseIf ($a2_1[0] == "Active" And $fireeletimer == "") Then
						$fireeletimer = TimerInit()
						_ArrayAdd($status, Sec2Time(300 - (Round(TimerDiff($fireeletimer) / 1000))))
					ElseIf ($a2_1[0] == "Active" And (300 - (Round(TimerDiff($fireeletimer) / 1000))) <= 0) Then
						$fireeletimer = ""
						_ArrayAdd($status, "Waiting")
					ElseIf ($a2_1[0] == "Active") Then
						_ArrayAdd($status, Sec2Time(300 - (Round(TimerDiff($fireeletimer) / 1000))))
					Else
						_ArrayAdd($status, "Pre")
					EndIf
				Else
					If ($a2_2[0] == "Active") Then
						_ArrayAdd($status, "Active")
					Else
						_ArrayAdd($status, "Pre")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Jungle Worm", 0) == 0 And $option_boss_worm == 1) Then
		$a3_1 = _StringBetween($str, '"event_id":"613A7660-8F3A-4897-8FAC-8747C12E42F8","state":"', '"},')
		$a3_2 = _StringBetween($str, '"event_id":"1DCFE4AA-A2BD-44AC-8655-BBD508C505D1","state":"', '"},')
		$a3_3 = _StringBetween($str, '"event_id":"456DD563-9FDA-4411-B8C7-4525F0AC4A6F","state":"', '"},')
		$a3_4 = _StringBetween($str, '"event_id":"61BA7299-6213-4569-948B-864100F35E16","state":"', '"},')
		$a3_5 = _StringBetween($str, '"event_id":"C5972F64-B894-45B4-BC31-2DEEA6B7C033","state":"', '"},')
		If ($a3_1 <> "" And $a3_2 <> "" And $a3_3 <> "" And $a3_4 <> "" And $a3_5 <> "") Then
			If ($a3_1[0] == "Active" Or $a3_2[0] == "Active" Or $a3_3[0] == "Active" Or $a3_4[0] == "Active" Or $a3_5[0] == "Active") Then
				_ArrayAdd($name, "Jungle Worm")
				If ($a3_5[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Shatterer", 0) == 0 And $option_boss_shatterer == 1) Then
		$a4_1 = _StringBetween($str, '"event_id":"580A44EE-BAED-429A-B8BE-907A18E36189","state":"', '"},')
		$a4_2 = _StringBetween($str, '"event_id":"8E064416-64B5-4749-B9E2-31971AB41783","state":"', '"},')
		$a4_3 = _StringBetween($str, '"event_id":"03BF176A-D59F-49CA-A311-39FC6F533F2F","state":"', '"},')
		If ($a4_1 <> "" And $a4_2 <> "" And $a4_3 <> "") Then
			If ($a4_1[0] == "Active" Or $a4_2[0] == "Active" Or $a4_3[0] == "Active") Then
				_ArrayAdd($name, "Shatterer")
				If ($a4_3[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Tequatl", 0) == 0 And $option_boss_quatl == 1) Then
		$a5 = _StringBetween($str, '"event_id":"568A30CF-8512-462F-9D67-647D69BEFAED","state":"', '"},')
		If ($a5 <> "") Then
			If ($a5[0] == "Active") Then
				_ArrayAdd($name, "Tequatl")
				_ArrayAdd($status, "Active")
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Golem Mark II", 0) == 0 And $option_boss_golem == 1) Then
		$a6_1 = _StringBetween($str, '"event_id":"3ED4FEB4-A976-4597-94E8-8BFD9053522F","state":"', '"},')
		$a6_2 = _StringBetween($str, '"event_id":"9AA133DC-F630-4A0E-BB5D-EE34A2B306C2","state":"', '"},')
		If ($a6_1 <> "" And $a6_2 <> "") Then
			If ($a6_1[0] == "Active" Or $a6_2[0] == "Active") Then
				_ArrayAdd($name, "Golem Mark II")
				If ($a6_2[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Jormag", 0) == 0 And $option_boss_jormag == 1) Then
		$a7_3 = _StringBetween($str, '"event_id":"0CA3A7E3-5F66-4651-B0CB-C45D3F0CAD95","state":"', '"},')
		$a7_2 = _StringBetween($str, '"event_id":"BFD87D5B-6419-4637-AFC5-35357932AD2C","state":"', '"},')
		$a7_1 = _StringBetween($str, '"event_id":"0464CB9E-1848-4AAA-BA31-4779A959DD71","state":"', '"},')
		If ($a7_3 <> "" And $a7_2 <> "" And $a7_1 <> "") Then
			If ($a7_1[0] == "Active" Or $a7_2[0] == "Active" Or $a7_3[0] == "Active") Then
				_ArrayAdd($name, "Jormag")
				If ($a7_1[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Melandru", 0) == 0 And $option_boss_meldanru == 1) Then
		$a8_1 = _StringBetween($str, '"event_id":"A5B5C2AF-22B1-4619-884D-F231A0EE0877","state":"', '"},')
		$a8_2 = _StringBetween($str, '"event_id":"7E24F244-52AF-49D8-A1D7-8A1EE18265E0","state":"', '"},')
		If ($a8_1 <> "" And $a8_2 <> "") Then
			If ($a8_1[0] == "Active" Or $a8_2[0] == "Active") Then
				_ArrayAdd($name, "Melandru")
				If ($a8_2[0] == "Active") Then
					_ArrayAdd($status, "Pre")
				Else
					_ArrayAdd($status, "Active")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Grenth", 0) == 0 And $option_boss_grenth == 1) Then
		$a9_1 = _StringBetween($str, '"event_id":"99254BA6-F5AE-4B07-91F1-61A9E7C51A51","state":"', '"},')
		$a9_2 = _StringBetween($str, '"event_id":"E16113B1-CE68-45BB-9C24-91523A663BCB","state":"', '"},')
		If ($a9_1 <> "" And $a9_2 <> "") Then
			If ($a9_1[0] == "Active" Or $a9_2[0] == "Active") Then
				_ArrayAdd($name, "Grenth")
				If ($a9_2[0] == "Active") Then
					_ArrayAdd($status, "Pre")
				Else
					_ArrayAdd($status, "Active")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Dwayna", 0) == 0 And $option_boss_dwayna == 1) Then
		$a10_1 = _StringBetween($str, '"event_id":"6A6FD312-E75C-4ABF-8EA1-7AE31E469ABA","state":"', '"},')
		$a10_2 = _StringBetween($str, '"event_id":"526732A0-E7F2-4E7E-84C9-7CDED1962000","state":"', '"},')
		If ($a10_1 <> "" And $a10_2 <> "") Then
			If ($a10_1[0] == "Active" Or $a10_2[0] == "Active") Then
				_ArrayAdd($name, "Dwayna")
				If ($a10_2[0] == "Active") Then
					_ArrayAdd($status, "Pre")
				Else
					_ArrayAdd($status, "Active")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Lyssa", 0) == 0 And $option_boss_lyssa == 1) Then
		$a11_1 = _StringBetween($str, '"event_id":"0372874E-59B7-4A8F-B535-2CF57B8E67E4","state":"', '"},')
		$a11_2 = _StringBetween($str, '"event_id":"F66922B5-B4BD-461F-8EC5-03327BD2B558","state":"', '"},')
		$a11_3 = _StringBetween($str, '"event_id":"590364E0-0053-4933-945E-21D396B10B20","state":"', '"},')
		If ($a11_1 <> "" And $a11_2 <> "" And $a11_3 <> "") Then
			If ($a11_1[0] == "Active" Or $a11_2[0] == "Active" Or $a11_3[0] == "Active") Then
				_ArrayAdd($name, "Lyssa")
				If ($a11_2[0] == "Active" Or $a11_3[0] == "Active") Then
					_ArrayAdd($status, "Pre")
				Else
					_ArrayAdd($status, "Active")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Balthazar", 0) == 0 And $option_boss_balti == 1) Then
		$a12_1 = _StringBetween($str, '"event_id":"2555EFCB-2927-4589-AB61-1957D9CC70C8","state":"', '"},')
		$a12_2 = _StringBetween($str, '"event_id":"D0ECDACE-41F8-46BD-BB17-8762EF29868C","state":"', '"},')
		If ($a12_1 <> "" And $a12_2 <> "") Then
			If ($a12_1[0] == "Active" Or $a12_2[0] == "Active") Then
				_ArrayAdd($name, "Balthazar")
				If ($a12_2[0] == "Active") Then
					_ArrayAdd($status, "Pre")
				Else
					_ArrayAdd($status, "Active")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Frozen Maw", 0) == 0 And $option_boss_maw == 1) Then
		$a13_1 = _StringBetween($str, '"event_id":"F7D9D427-5E54-4F12-977A-9809B23FBA99","state":"', '"},')
		$a13_2 = _StringBetween($str, '"event_id":"374FC8CB-7AB7-4381-AC71-14BFB30D3019","state":"', '"},')
		$a13_3 = _StringBetween($str, '"event_id":"DB83ABB7-E5FE-4ACB-8916-9876B87D300D","state":"', '"},')
		$a13_4 = _StringBetween($str, '"event_id":"90B241F5-9E59-46E8-B608-2507F8810E00","state":"', '"},')
		$a13_5 = _StringBetween($str, '"event_id":"6565EFD4-6E37-4C26-A3EA-F47B368C866D","state":"', '"},')
		$a13_6 = _StringBetween($str, '"event_id":"D5F31E0B-E0E3-42E3-87EC-337B3037F437","state":"', '"},')
		$a13_7 = _StringBetween($str, '"event_id":"6F516B2C-BD87-41A9-9197-A209538BB9DF","state":"', '"},')
		If ($a13_1 <> "" And $a13_2 <> "" And $a13_3 <> "" And $a13_4 <> "" And $a13_5 <> "" And $a13_6 <> "" And $a13_7 <> "") Then
			If ($a13_1[0] == "Active" Or $a13_2[0] == "Active" Or $a13_3[0] == "Active" Or $a13_4[0] == "Active" Or $a13_5[0] == "Active" Or $a13_6[0] == "Active" Or $a13_7[0] == "Active") Then
				_ArrayAdd($name, "Frozen Maw")
				If ($a13_1[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Foulbear Kral", 0) == 0 And $option_boss_kral == 1) Then
		$a14_1 = _StringBetween($str, '"event_id":"4B478454-8CD2-4B44-808C-A35918FA86AA","state":"', '"},')
		$a14_2 = _StringBetween($str, '"event_id":"8D45B410-B614-4008-8A5C-E8D8230CEB40","state":"', '"},')
		If ($a14_1 <> "" And $a14_2 <> "") Then
			If ($a14_1[0] == "Active" Or $a14_2[0] == "Active") Then
				If ($a14_1[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
				_ArrayAdd($name, "Foulbear Kral")
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Ulgoth the Mondniir", 0) == 0 And $option_boss_ulgoth == 1) Then
		$a15_1 = _StringBetween($str, '"event_id":"4A1DECF3-C1AD-42EC-9905-976B281CFA49","state":"', '"},')
		$a15_2 = _StringBetween($str, '"event_id":"AE7AAA0C-5619-4C94-918B-6022DB9AA481","state":"', '"},')
		$a15_3 = _StringBetween($str, '"event_id":"C3A1BAE2-E7F2-4929-A3AA-92D39283722C","state":"', '"},')
		$a15_4 = _StringBetween($str, '"event_id":"DDC0A526-A239-4791-8984-E7396525B648","state":"', '"},')
		$a15_5 = _StringBetween($str, '"event_id":"A3101CDC-A4A0-4726-85C0-147EF8463A50","state":"', '"},')
		$a15_6 = _StringBetween($str, '"event_id":"DA465AE1-4D89-4972-AD66-A9BE3C5A1823","state":"', '"},')
		$a15_7 = _StringBetween($str, '"event_id":"E6872A86-E434-4FC1-B803-89921FF0F6D6","state":"', '"},')
		If ($a15_1 <> "" And $a15_2 <> "" And $a15_3 <> "" And $a15_4 <> "" And $a15_5 <> "" And $a15_6 <> "" And $a15_7 <> "") Then
			If ($a15_1[0] == "Active" Or $a15_2[0] == "Active" Or $a15_3[0] == "Active" Or $a15_4[0] == "Active" Or $a15_5[0] == "Active" Or $a15_6[0] == "Active" Or $a15_7[0] == "Active") Then
				If ($a15_7[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
				_ArrayAdd($name, "Ulgoth the Mondniir")
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Dredge Commissar", 0) == 0 And $option_boss_dredge == 1) Then
		$a16_1 = _StringBetween($str, '"event_id":"F1F99810-D6A9-4263-A5BC-4257C5B7AD0D","state":"', '"},')
		$a16_2 = _StringBetween($str, '"event_id":"07536BE1-9796-4D40-A203-29B4FE270E64","state":"', '"},')
		$a16_3 = _StringBetween($str, '"event_id":"95CA969B-0CC6-4604-B166-DBCCE125864F","state":"', '"},')
		If ($a16_1 <> "" And $a16_2 <> "" And $a16_3 <> "") Then
			If ($a16_1[0] == "Active" Or $a16_2[0] == "Active" Or $a16_3[0] == "Active") Then
				If ($a16_3[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
				_ArrayAdd($name, "Dredge Commissar")
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Taidha", 0) == 0 And $option_boss_taidha == 1) Then
		$a17_1 = _StringBetween($str, '"event_id":"D682ABC2-6B73-4C8E-A246-E9C23ED99153","state":"', '"},')
		$a17_2 = _StringBetween($str, '"event_id":"B6B7EE2A-AD6E-451B-9FE5-D5B0AD125BB2","state":"', '"},')
		$a17_3 = _StringBetween($str, '"event_id":"189E7ABE-1413-4F47-858E-4612D40BF711","state":"', '"},')
		$a17_4 = _StringBetween($str, '"event_id":"0E0801AF-28CF-4FF7-8064-BB2F4A816D23","state":"', '"},')
		$a17_5 = _StringBetween($str, '"event_id":"242BD241-E360-48F1-A8D9-57180E146789","state":"', '"},')
		If ($a17_1 <> "" And $a17_2 <> "" And $a17_3 <> "" And $a17_4 <> "" And $a17_5 <> "") Then
			If ($a17_1[0] == "Active" Or $a17_2[0] == "Active" Or $a17_3[0] == "Active" Or $a17_4[0] == "Active" Or $a17_5[0] == "Active") Then
				If ($a17_5[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
				_ArrayAdd($name, "Taidha")
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Fire Shaman", 0) == 0 And $option_boss_shaman == 1) Then
		$a18 = _StringBetween($str, '"event_id":"295E8D3B-8823-4960-A627-23E07575ED96","state":"', '"},')
		If ($a18 <> "") Then
			If ($a18[0] == "Active") Then
				_ArrayAdd($name, "Fire Shaman")
				_ArrayAdd($status, "Active")
			EndIf
		EndIf
	EndIf
	If (IniRead("TimerConf.ini", "Complete", "Eye of Zaithan", 0) == 0 And $option_boss_eye == 1) Then
		$a19_1 = _StringBetween($str, '"event_id":"42884028-C274-4DFA-A493-E750B8E1B353","state":"', '"},')
		$a19_2 = _StringBetween($str, '"event_id":"A0796EC5-191D-4389-9C09-E48829D1FDB2","state":"', '"},')
		If ($a19_1 <> "" And $a19_2 <> "") Then
			If ($a19_1[0] == "Active" Or $a19_2[0]) Then
				If ($a19_2[0] == "Active") Then
					_ArrayAdd($status, "Active")
				Else
					_ArrayAdd($status, "Pre")
				EndIf
				_ArrayAdd($name, "Eye of Zaithan")
			EndIf
		EndIf
	EndIf
	GUIRegisterMsg($WM_MOVE, "MoveEvent")
	$pos = WinGetPos($Form1)
	$x = IniRead("TimerConf.ini", "Position", "x", $pos[0])
	$y = IniRead("TimerConf.ini", "Position", "y", $pos[1])
	WinMove($Form1, "", $x, $y, Default, 88 + ((UBound($name) - 1) * 16))
	For $i = 1 To UBound($alllbl) - 1
		GUICtrlDelete($alllbl[$i])
	Next
	For $i = 1 To UBound($msgevents) - 1
		_ArrayDelete($msgevents, $i)
	Next
	For $i = 1 To UBound($wplbls) - 1
		_ArrayDelete($wplbls, $i)
	Next
	For $i = 1 To UBound($name) - 1
		$cb = GUICtrlCreateCheckbox($name[$i], 2, 46 + (($i - 1) * 16), 10, 10)
		$l1 = GUICtrlCreateLabel($name[$i], 15, 44 + (($i - 1) * 16), 122, 12, -1, $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetColor(-1, 0xFFFFFF)

		If ($status[$i] == "Active") Then
			$l2 = GUICtrlCreateLabel("Active", 141, 44 + (($i - 1) * 16), 122, 24, -1, $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
			GUICtrlSetColor(-1, 0x008000)
		Else
			$l2 = GUICtrlCreateLabel($status[$i], 141, 44 + (($i - 1) * 16), 122, 24, -1, $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetColor(-1, 0xFFFFFF)
		EndIf
		_ArrayAdd($alllbl, $cb)
		_ArrayAdd($msgevents, $cb)
		_ArrayAdd($wplbls, $l1)
		_ArrayAdd($alllbl, $l1)
		_ArrayAdd($alllbl, $l2)
	Next
	AdlibRegister("updatetimer", 1000)
EndFunc   ;==>_getinfo

Func _GetNetworkConnect()
	Local Const $NETWORK_ALIVE_LAN = 0x1 ;net card connection
	Local Const $NETWORK_ALIVE_WAN = 0x2 ;RAS (internet) connection
	Local Const $NETWORK_ALIVE_AOL = 0x4 ;AOL

	Local $aRet, $iResult

	$aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)

	If BitAND($aRet[1], $NETWORK_ALIVE_LAN) Then $iResult &= "LAN connected" & @LF
	If BitAND($aRet[1], $NETWORK_ALIVE_WAN) Then $iResult &= "WAN connected" & @LF
	If BitAND($aRet[1], $NETWORK_ALIVE_AOL) Then $iResult &= "AOL connected" & @LF

	Return $iResult
EndFunc   ;==>_GetNetworkConnect

Func ServEvent()

EndFunc   ;==>ServEvent
Func OptionEvent()
	#region ### START Koda GUI section ### Form=
	$options = GUICreate("Options", 804, 177, 2417, 330)
	$minimize = GUICtrlCreateCheckbox("", 16, 15, 17, 17)
	If ($option_mini == 1) Then
		GUICtrlSetState($minimize, $GUI_CHECKED)
	EndIf
	$Label1 = GUICtrlCreateLabel("Minimize if Guild Wars 2 is inactive", 40, 17, 166, 17)
	$option_timer_box = GUICtrlCreateCheckbox("", 16, 61, 17, 17)

	$Label823 = GUICtrlCreateLabel("Display Timers(beta)", 40, 63, 170, 17)
	If ($option_timer == 1) Then
		GUICtrlSetState($option_timer_box, $GUI_CHECKED)
	EndIf
	;$blackbg = GUICtrlCreateCheckbox("", 15, 61, 17, 17)
	;$Label23 = GUICtrlCreateLabel("10% Trans. Background", 39, 63, 170, 17)
	;If ($option_blackbg == 1) Then
	;	GUICtrlSetState($blackbg, $GUI_CHECKED)
	;EndIf
	$Button1 = GUICtrlCreateButton("Save", 16, 128, 193, 33)
	$Group1 = GUICtrlCreateGroup("Boss selection", 216, 16, 569, 145)
	$option_boss_behemoth_box = GUICtrlCreateCheckbox("", 224, 40, 13, 17)
	If ($option_boss_behemoth == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label4 = GUICtrlCreateLabel("Shadow Behemoth", 240, 42, 94, 17)
	$option_boss_felemental_box = GUICtrlCreateCheckbox("", 224, 70, 13, 17)
	If ($option_boss_felemental == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label5 = GUICtrlCreateLabel("Fire Elemental", 240, 72, 70, 17)
	$option_boss_worm_box = GUICtrlCreateCheckbox("", 224, 100, 13, 17)
	If ($option_boss_worm == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label6 = GUICtrlCreateLabel("Jungle Worm", 240, 102, 66, 17)
	$option_boss_golem_box = GUICtrlCreateCheckbox("", 224, 130, 13, 17)
	If ($option_boss_golem == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label7 = GUICtrlCreateLabel("Golem Mark II", 240, 132, 70, 17)
	$option_boss_shatterer_box = GUICtrlCreateCheckbox("", 350, 40, 13, 17)
	If ($option_boss_shatterer == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label8 = GUICtrlCreateLabel("The Shatterer", 366, 42, 69, 17)
	$option_boss_quatl_box = GUICtrlCreateCheckbox("", 350, 70, 13, 17)
	If ($option_boss_quatl == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label9 = GUICtrlCreateLabel("Tequatl", 366, 72, 40, 17)
	$option_boss_jormag_box = GUICtrlCreateCheckbox("", 350, 100, 13, 17)
	If ($option_boss_jormag == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label10 = GUICtrlCreateLabel("Jormag", 366, 102, 38, 17)
	$option_boss_meldanru_box = GUICtrlCreateCheckbox("", 350, 130, 13, 17)
	If ($option_boss_meldanru == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label11 = GUICtrlCreateLabel("Melandru", 366, 132, 48, 17)
	$option_boss_grenth_box = GUICtrlCreateCheckbox("", 451, 40, 13, 17)
	If ($option_boss_grenth == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label12 = GUICtrlCreateLabel("Grenth", 467, 42, 36, 17)
	$option_boss_dwayna_box = GUICtrlCreateCheckbox("", 451, 70, 13, 17)
	If ($option_boss_dwayna == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label13 = GUICtrlCreateLabel("Dwayna", 467, 72, 43, 17)
	$option_boss_lyssa_box = GUICtrlCreateCheckbox("", 451, 100, 13, 17)
	If ($option_boss_lyssa == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label14 = GUICtrlCreateLabel("Lyssa", 467, 102, 31, 17)
	$option_boss_balti_box = GUICtrlCreateCheckbox("", 451, 130, 13, 17)
	If ($option_boss_balti == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label15 = GUICtrlCreateLabel("Balthazar", 467, 132, 48, 17)
	$option_boss_maw_box = GUICtrlCreateCheckbox("", 524, 40, 13, 17)
	If ($option_boss_maw == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label16 = GUICtrlCreateLabel("Frozen Maw", 540, 42, 62, 17)
	$option_boss_kral_box = GUICtrlCreateCheckbox("", 524, 70, 13, 17)
	If ($option_boss_kral == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label17 = GUICtrlCreateLabel("Foulbear Kral", 540, 72, 66, 17)
	$option_boss_ulgoth_box = GUICtrlCreateCheckbox("", 524, 100, 13, 17)
	If ($option_boss_ulgoth == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label18 = GUICtrlCreateLabel("Ulgoth the Mondniir", 540, 102, 96, 17)
	$option_boss_dredge_box = GUICtrlCreateCheckbox("", 524, 130, 13, 17)
	If ($option_boss_dredge == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label19 = GUICtrlCreateLabel("Dredge Commissar", 540, 132, 92, 17)
	$option_boss_taidha_box = GUICtrlCreateCheckbox("", 653, 40, 13, 17)
	If ($option_boss_taidha == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label20 = GUICtrlCreateLabel("Taidha Covington", 669, 42, 88, 17)
	$option_boss_shaman_box = GUICtrlCreateCheckbox("", 653, 70, 13, 17)
	If ($option_boss_shaman == 1) Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label21 = GUICtrlCreateLabel("Fire Shaman", 669, 72, 63, 17)
	$option_boss_eye_box = GUICtrlCreateCheckbox("", 653, 100, 13, 17)
	If ($option_boss_eye == 1) Then
		GUICtrlSetState($option_boss_eye_box, $GUI_CHECKED)
	EndIf
	$Label22 = GUICtrlCreateLabel("Eye of Zaithan", 669, 102, 73, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#endregion ### END Koda GUI section ###
	GUISetState(@SW_SHOW, $options)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($options)
				$msg = 0
				ExitLoop
			Case $Button1
				If (GUICtrlRead($minimize) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Options", "minimize", 0)
					Global $option_mini = 0
				Else
					IniWrite("TimerConf.ini", "Options", "minimize", 1)
					Global $option_mini = 1
				EndIf
				If (GUICtrlRead($option_boss_behemoth_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "behemoth", 0)
					Global $option_boss_behemoth = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "behemoth", 1)
					Global $option_boss_behemoth = 1
				EndIf

				If (GUICtrlRead($option_boss_felemental_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "felemental", 0)
					Global $option_boss_felemental = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "felemental", 1)
					Global $option_boss_felemental = 1
				EndIf

				If (GUICtrlRead($option_boss_worm_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "worm", 0)
					Global $option_boss_worm = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "worm", 1)
					Global $option_boss_worm = 1
				EndIf

				If (GUICtrlRead($option_boss_golem_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "golem", 0)
					Global $option_boss_golem = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "golem", 1)
					Global $option_boss_golem = 1
				EndIf

				If (GUICtrlRead($option_boss_shatterer_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "shatterer", 0)
					Global $option_boss_shatterer = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "shatterer", 1)
					Global $option_boss_shatterer = 1
				EndIf

				If (GUICtrlRead($option_boss_quatl_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "quatl", 0)
					Global $option_boss_quatl = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "quatl", 1)
					Global $option_boss_quatl = 1
				EndIf

				If (GUICtrlRead($option_boss_jormag_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "jormag", 0)
					Global $option_boss_jormag = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "jormag", 1)
					Global $option_boss_jormag = 1
				EndIf

				If (GUICtrlRead($option_boss_meldanru_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "meldanru", 0)
					Global $option_boss_meldanru = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "meldanru", 1)
					Global $option_boss_meldanru = 1
				EndIf

				If (GUICtrlRead($option_boss_grenth_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "grenth", 0)
					Global $option_boss_grenth = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "grenth", 1)
					Global $option_boss_grenth = 1
				EndIf

				If (GUICtrlRead($option_boss_dwayna_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "dwayna", 0)
					Global $option_boss_dwayna = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "dwayna", 1)
					Global $option_boss_dwayna = 1
				EndIf

				If (GUICtrlRead($option_boss_lyssa_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "lyssa", 0)
					Global $option_boss_lyssa = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "lyssa", 1)
					Global $option_boss_lyssa = 1
				EndIf

				If (GUICtrlRead($option_boss_balti_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "balti", 0)
					Global $option_boss_balti = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "balti", 1)
					Global $option_boss_balti = 1
				EndIf

				If (GUICtrlRead($option_boss_maw_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "maw", 0)
					Global $option_boss_maw = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "maw", 1)
					Global $option_boss_maw = 1
				EndIf
				If (GUICtrlRead($option_boss_kral_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "kral", 0)
					Global $option_boss_kral = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "kral", 1)
					Global $option_boss_kral = 1
				EndIf
				If (GUICtrlRead($option_boss_ulgoth_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "ulgoth", 0)
					Global $option_boss_ulgoth = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "ulgoth", 1)
					Global $option_boss_ulgoth = 1
				EndIf
				If (GUICtrlRead($option_boss_dredge_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "dredge", 0)
					Global $option_boss_dredge = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "dredge", 1)
					Global $option_boss_dredge = 1
				EndIf
				If (GUICtrlRead($option_boss_taidha_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "taidha", 0)
					Global $option_boss_taidha = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "taidha", 1)
					Global $option_boss_taidha = 1
				EndIf
				If (GUICtrlRead($option_boss_shaman_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "shaman", 0)
					Global $option_boss_shaman = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "shaman", 1)
					Global $option_boss_shaman = 1
				EndIf
				If (GUICtrlRead($option_boss_eye_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Bosses", "eye", 0)
					Global $option_boss_eye = 0
				Else
					IniWrite("TimerConf.ini", "Bosses", "eye", 1)
					Global $option_boss_eye = 1
				EndIf
				;If (GUICtrlRead($blackbg) == $GUI_UNCHECKED) Then
				;	IniWrite("TimerConf.ini", "Options", "blackbg", 0)
				;	Global $option_blackbg = 0
				;Else
				;	IniWrite("TimerConf.ini", "Options", "blackbg", 1)
				;	Global $option_blackbg = 1
				;EndIf
				If (GUICtrlRead($option_timer_box) == $GUI_UNCHECKED) Then
					IniWrite("TimerConf.ini", "Options", "timer", 0)
					Global $option_timer = 0
				Else
					IniWrite("TimerConf.ini", "Options", "timer", 1)
					Global $option_timer = 1
				EndIf

				GUIDelete($options)
				$msg = 0
				ExitLoop
		EndSwitch
	WEnd
	_getinfo(_INetGetSource("https://api.guildwars2.com/v1/events.json?world_id=" & $serverid))
EndFunc   ;==>OptionEvent
Func ResetEvent()
	IniDelete("TimerConf.ini", "Complete")
	For $i = 1 To UBound($alllbl) - 1
		GUICtrlDelete($alllbl[$i])
	Next
	$load = GUICtrlCreateLabel("Fetching...", 8, 44 + 16, 122, 24, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0xFFFFFF)
	_ArrayAdd($alllbl, $load)
	_getinfo(_INetGetSource("https://api.guildwars2.com/v1/events.json?world_id=" & $serverid))
EndFunc   ;==>ResetEvent
Func AboutEvent()
	MsgBox(0, "About", "Written by Dauni.8290" & @CRLF & "Thanks to the Redditors: slashy1302" & @CRLF & @CRLF & "Also thanks to Anet for this great API! :)")
EndFunc   ;==>AboutEvent

Func SelectServer($controlID)
	Local $ctrlText = TrayItemGetText($controlID)
	Local $sid = _StringBetween($ctrlText, "(", ")");
	For $i = 1 To $server_count - 1
		TrayItemSetState($trayItems[$i - 1], 4)
	Next
	TrayItemSetState($controlID, 1)
	TrayItemSetText($serverItem, "Your Server: " & $ctrlText)
	$serverid = $sid[0]
	IniWrite("TimerConf.ini", "Server", "id", $serverid)
	For $i = 1 To UBound($alllbl) - 1
		GUICtrlDelete($alllbl[$i])
	Next
	$load = GUICtrlCreateLabel("Fetching...", 8, 44 + 16, 122, 24, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0xFFFFFF)
	_ArrayAdd($alllbl, $load)
	_getinfo(_INetGetSource("https://api.guildwars2.com/v1/events.json?world_id=" & $serverid))
EndFunc   ;==>SelectServer

Func MoveEvent()
	$pos = WinGetPos($Form1)
	IniWrite("TimerConf.ini", "Position", "x", $pos[0])
	IniWrite("TimerConf.ini", "Position", "y", $pos[1])
EndFunc   ;==>MoveEvent

Func Sec2Time($nr_sec)
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d', $sec2time_min, $sec2time_sec)
EndFunc   ;==>Sec2Time
Func updatetimer()
	For $i = 1 To UBound($name) - 1
		If ($name[$i] == "Fire Elemental" And $fireeletimer <> "") Then
			_ArrayDelete($status, $i)
			If (300 - (Round(TimerDiff($fireeletimer) / 1000)) <= 1) Then
				$l2 = GUICtrlCreateLabel("Waiting", 141, 44 + (($i - 1) * 16), 122, 12, -1, $GUI_WS_EX_PARENTDRAG)
			Else
				$l2 = GUICtrlCreateLabel(Sec2Time(300 - (Round(TimerDiff($fireeletimer) / 1000))), 141, 44 + (($i - 1) * 16), 122, 12, -1, $GUI_WS_EX_PARENTDRAG)
			EndIf
			GUICtrlSetColor(-1, 0xFFFFFF)
			_ArrayAdd($status, "Pre")
			_ArrayAdd($alllbl, $l2)
		EndIf
	Next
EndFunc   ;==>updatetimer
Func ShowWin()
	WinMove($Form1, "", $x, $y, Default, Default)
	GUISetState(@SW_RESTORE, $Form1)
EndFunc   ;==>ShowWin