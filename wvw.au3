#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=\\tsclient\winwork\GW2_Logo.ico
#AutoIt3Wrapper_Outfile=\\tsclient\winwork\testtimer.exe
#AutoIt3Wrapper_UseUpx=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
Global $option_mini = 0
$connect = _GetNetworkConnect()
If Not $connect Then
	MsgBox(48, "Warning", "You have no Internet Connection!")
	Exit
EndIf
Global $TIMER_VERSION = "0.3"
Global $serverid = IniRead("WvWWatcherConf.ini", "Match", "id", "1-1")
Global $map = IniRead("WvWWatcherConf.ini", "Map", "id", "0")
Global $servername = ""
Global $matchname = ""
#region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Overlay", 180, 500, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor(0x505050, $Form1)
_WinAPI_SetLayeredWindowAttributes($Form1, 0x505050, 250)
$pos = WinGetPos($Form1)
$x = IniRead("WvWWatcherConf.ini", "Position", "x", $pos[0])
$y = IniRead("WvWWatcherConf.ini", "Position", "y", $pos[1])
WinMove($Form1, "", $x, $y, Default, Default)
GUISetState(@SW_SHOW, $Form1)
;$online_version = _INetGetSource("http://timer.felix.vc/wvw/version")
;if $TIMER_VERSION <> $online_version Then
;	MsgBox(0,"New Version Available","A new Version is available! Check out the Reddit Post!")
;EndIf

;Matches
$serverMenu = TrayCreateMenu("Select Match")
$serverMenuEU = TrayCreateMenu("EU", $serverMenu)
$serverMenuNA = TrayCreateMenu("NA", $serverMenu)
$server_src = _INetGetSource("https://api.guildwars2.com/v1/world_names.json")
$serverList = StringSplit($server_src, @CRLF)
Global $server_count = UBound($serverList)
Global $serverarray[3000]
For $i = 1 To $server_count - 1
	$line = $serverList[$i]
	$sid = _StringBetween($line, '"id":"', '",')
	$sname = _StringBetween($line, '"name":"', '"')
	$sid = $sid[0]
	$sname = $sname[0]
	$serverarray[$sid] = $sname
Next
$matches_src = _INetGetSource("https://api.guildwars2.com/v1/wvw/matches.json")
$matchesList = StringSplit($matches_src, @CRLF)
Global $matches_count = UBound($matchesList)
Global $matchlist[$matches_count][4]
Global $trayItems[$matches_count]
Global $mapItems[$matches_count][4]
For $i = 1 To $matches_count - 1
	$line = $matchesList[$i]
	$match = _StringBetween($line, '"wvw_match_id":"', '"')
	$red = _StringBetween($line, '"red_world_id":', ',"')
	$blue = _StringBetween($line, '"blue_world_id":', ',"')
	$green = _StringBetween($line, '"green_world_id":', '}')
	$red = $red[0]
	$blue = $blue[0]
	$green = $green[0]
	$match = $match[0]
	$red_name = $serverarray[$red]
	$blue_name = $serverarray[$blue]
	$green_name = $serverarray[$green]
	$matchlist[$i - 1][0] = $match
	$matchlist[$i - 1][1] = $red_name
	$matchlist[$i - 1][2] = $blue_name
	$matchlist[$i - 1][3] = $green_name
	$ctrlname = StringFormat("%s vs %s vs %s (%s)", $red_name, $blue_name, $green_name, $match)
	If StringMid($match, 1, 1) == "1" Then
		$trayItems[$i - 1] = TrayCreateMenu($ctrlname, $serverMenuNA)
	Else
		$trayItems[$i - 1] = TrayCreateMenu($ctrlname, $serverMenuEU)
	EndIf
	$mapItems[$i - 1][0] = TrayCreateItem($red_name&" Home ("&$match&"|0)",$trayItems[$i - 1],$match&"|"&0,1)
	$mapItems[$i - 1][1] = TrayCreateItem($blue_name&" Home ("&$match&"|1)",$trayItems[$i - 1],$match&"|"&1,1)
	$mapItems[$i - 1][2] = TrayCreateItem($green_name&" Home ("&$match&"|2)",$trayItems[$i - 1],$match&"|"&2,1)
	$mapItems[$i - 1][3] = TrayCreateItem("Eternal Battlegrounds ("&$match&"|3)",$trayItems[$i - 1],$match&"|"&3,1)
	If ($match == $serverid) Then
		$matchname = StringFormat("%s vs %s vs %s (%s)", $red_name, $blue_name, $green_name, $match)
		If($map==0) Then
			$map_name = "Red("&$red_name&") Homelands"
		ElseIf($map==1) Then
			$map_name = "Blue("&$blue_name&") Homelands"
		ElseIf($map==2) Then
			$map_name = "Green("&$green_name&") Homelands"
		Else
			$map_name = "Eternal Battlegrounds"
		Endif
		TrayItemSetState(-1, 1)
	EndIf
Next
$matchItem = TrayCreateItem($matchname)
$mapItem = TrayCreateItem("Your Map: " & $map_name)
$options = TrayCreateItem("Options")
$about = TrayCreateItem("About")
$exit = TrayCreateItem("Exit")

$timer = TimerInit()
_getinfo(_INetGetSource("https://api.guildwars2.com/v1/wvw/match_details.json?match_id=" & $serverid))
While 1
	Local $msg = TrayGetMsg()
	Switch $msg
		Case $exit
			Exit
		Case $matchItem
			DoNothing()
		Case $mapItem
			DoNothing()
		Case $about
			AboutEvent()
		Case $options
			GUISetState(@SW_HIDE, $Form1)
			OptionEvent()
			GUISetState(@SW_SHOWNOACTIVATE, $Form1)
		Case 61
			GUISetState(@SW_HIDE, $Form1)
			OptionEvent()
			GUISetState(@SW_SHOWNOACTIVATE, $Form1)
		Case Else
			If $msg > 0 And $msg <> 61 Then
				SelectServer($msg)
			EndIf
	EndSwitch
	Local $state = WinGetState("[CLASS:ArenaNet_Dx_Window_Class]", "")
	Local $fstate = WinGetState($Form1)
	If $option_mini == 1 and Not BitAND($fstate, 8) Then
		If BitAND($state, 8) Then
			GUISetState(@SW_SHOWNOACTIVATE, $Form1)
		Else
			GUISetState(@SW_HIDE, $Form1)
		EndIf
	EndIf
	If TimerDiff($timer) > 10000 Then
		Local $fstate = WinGetState($Form1)
		If $fstate <> 5 And $fstate <> 13 Then
			MsgBox(0,"",$map&"-"&$serverid)
		EndIf
		$timer = TimerInit()
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _getinfo($str)
		$l1 = GUICtrlCreateLabel("test", 15, 44 + (16), 122, 12, -1, $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetColor(-1, 0xFFFFFF)
		MsgBox(0,"",$map&"-"&$serverid)
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

Func OptionEvent()

EndFunc   ;==>OptionEvent
Func AboutEvent()

EndFunc   ;==>AboutEvent
Func MoveEvent()
	$pos = WinGetPos($Form1)
	IniWrite("WvWWatcherConf.ini", "Position", "x", $pos[0])
	IniWrite("WvWWatcherConf.ini", "Position", "y", $pos[1])
EndFunc   ;==>MoveEvent

Func SelectServer($controlID)
	Local $ctrlText = TrayItemGetText($controlID)
	Local $matchid_con = _StringBetween($ctrlText, "(", ")")
	Local $matchid_a = StringSplit($matchid_con[0],"|",2)
	$matchid = $matchid_a[0]
	$map_s = $matchid_a[1]
	For $i = 1 To $matches_count - 1
		TrayItemSetState($trayItems[$i - 1], 4)
	Next
	For $i = 1 To $mapItems - 1
		TrayItemSetState($mapItems[$i - 1][0], 4)
		TrayItemSetState($mapItems[$i - 1][1], 4)
		TrayItemSetState($mapItems[$i - 1][2], 4)
		TrayItemSetState($mapItems[$i - 1][3], 4)
	Next

	For $i = 1 To UBound($matchlist) - 1
		If($matchlist[$i][0]==$matchid) Then
			TrayItemSetText($matchitem, "Your Match: " & $matchlist[$i][1]&" vs "&$matchlist[$i][2]&" vs "&$matchlist[$i][3])
			ExitLoop
		Endif
	Next
	If($map_s==0) Then
		$map_name = "Red("&$matchlist[$i][1]&") Homelands"
	ElseIf($map_s==1) Then
		$map_name = "Blue("&$matchlist[$i][2]&") Homelands"
	ElseIf($map_s==2) Then
		$map_name = "Green("&$matchlist[$i][3]&") Homelands"
	Else
		$map_name = "Eternal Battlegrounds"
	EndIf

	TrayItemSetState($controlID, 1)
	TrayItemSetState(TrayItemGetHandle($controlID), 1)
	TrayItemSetText($mapItem, "Your Map: " & $map_name)
	IniWrite("WvWWatcherConf.ini", "Match", "id", $matchid)
	IniWrite("WvWWatcherConf.ini", "Match", "map", $map_s)
	_getinfo(_INetGetSource("https://api.guildwars2.com/v1/wvw/match_details.json?match_id=" & $serverid))
EndFunc   ;==>SelectServer
Func DoNothing()

EndFunc
Func Sec2Time($nr_sec)
   $sec2time_hour = Int($nr_sec / 3600)
   $sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
   $sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
   Return StringFormat('%02d:%02d', $sec2time_min, $sec2time_sec)
EndFunc   ;==>Sec2Time
