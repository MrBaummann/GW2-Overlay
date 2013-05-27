#include <Inet.au3>
#include <String.au3>
#include <Array.au3>
#include <WinApi.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <JSMN.au3>
#include <GDIPlus.au3>
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

Global $TIMER_VERSION = "0.3"
Global $serverid = IniRead("WvWWatcherConf.ini", "Match", "id", "1-1")
Global $map = IniRead("WvWWatcherConf.ini", "Match", "map", "0")
Global $servername = ""
Global $matchname = ""
Global $hGUI, $hImage, $hGraphic, $hImage
Global Const $SC_DRAGMOVE = 0xF012

; Create GUI
$map_gui = GUICreate("", 500, 500, -1, -1, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOPMOST)
GUISetBkColor(0x01, $map_gui)
GUISetState()
_WinAPI_SetLayeredWindowAttributes($map_gui, 0x01, 0xFF, 3)

; Load PNG image
_GDIPlus_StartUp()
$hImage   = _GDIPlus_ImageLoadFromFile(@ScriptDir& "\images\eb_map.png")
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($map_gui)
_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)

_GuiCreateLabel($map_gui,"Kodash[DE] vs Seafarer's Rest vs Desolation",120,10,400,20, 0xFFFFFF)
$speldan_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",128,108,$map_gui)
$mendon_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",200,96,$map_gui)
$veloka_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",328,92,$map_gui)
$overlook_icon = writepng(@ScriptDir& "\images\icons\keep_red.png",278,130,$map_gui)
$anza_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",192,190,$map_gui)
$ogrewatch_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",316,166,$map_gui)
$pangloss_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",368,146,$map_gui)
$rogue_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",88,248,$map_gui)
$wildcreek_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",150,276,$map_gui)
$stonemist_icon = writepng(@ScriptDir& "\images\icons\castle_red.png",254,274,$map_gui)
$durios_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",350,262,$map_gui)
$umber_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",412,250,$map_gui)
$bravost_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",446,310,$map_gui)
$aldon_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",56,310,$map_gui)
$lowlands_icon = writepng(@ScriptDir& "\images\icons\keep_red.png",98,360,$map_gui)
$klovan_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",188,354,$map_gui)
$golanta_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",186,416,$map_gui)
$jerrifer_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",128,410,$map_gui)
$quentin_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",286,380,$map_gui)
$danelon_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",320,438,$map_gui)
$langor_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",394,424,$map_gui)
$valley_icon = writepng(@ScriptDir& "\images\icons\keep_red.png",394,360,$map_gui)

GUIRegisterMsg($WM_PAINT, "MY_WM_PAINT")

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
Global $last_mapItems[80][3]
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
	$mapItems[$i - 1][0] = TrayCreateItem($red_name & " Home (" & $match & "|0)", $trayItems[$i - 1], $match & "|" & 0, 1)
	$mapItems[$i - 1][1] = TrayCreateItem($blue_name & " Home (" & $match & "|1)", $trayItems[$i - 1], $match & "|" & 1, 1)
	$mapItems[$i - 1][2] = TrayCreateItem($green_name & " Home (" & $match & "|2)", $trayItems[$i - 1], $match & "|" & 2, 1)
	$mapItems[$i - 1][3] = TrayCreateItem("Eternal Battlegrounds (" & $match & "|3)", $trayItems[$i - 1], $match & "|" & 3, 1)
	If ($match == $serverid) Then
		$matchname = StringFormat("%s vs %s vs %s (%s)", $red_name, $blue_name, $green_name, $match)
		If ($map == 0) Then
			$map_name = "Red(" & $red_name & ") Homelands"
			TrayItemSetState($mapItems[$i - 1][0], 1)
		ElseIf ($map == 1) Then
			$map_name = "Blue(" & $blue_name & ") Homelands"
			TrayItemSetState($mapItems[$i - 1][1], 1)
		ElseIf ($map == 2) Then
			$map_name = "Green(" & $green_name & ") Homelands"
			TrayItemSetState($mapItems[$i - 1][2], 1)
		Else
			$map_name = "Eternal Battlegrounds"
			TrayItemSetState($mapItems[$i - 1][3], 1)
		EndIf
		TrayItemSetState($trayItems[$i - 1], 1)
	EndIf
Next
$matchItem = TrayCreateItem($matchname)
$mapItem = TrayCreateItem("Your Map: " & $map_name)
$options = TrayCreateItem("Options")
$about = TrayCreateItem("About")
$exit = TrayCreateItem("Exit")
$timer = TimerInit()


While 1
    $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $GUI_EVENT_PRIMARYDOWN
                _SendMessage($map_gui, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
    EndSwitch
WEnd

; Clean up resources
_GDIPlus_GraphicsDispose($hGraphic)
_GDIPlus_ImageDispose($hImage)
_GDIPlus_ShutDown()
Exit



Func writepng($img,$top,$left,$hGUI)
; Load PNG image
$hImage   = _GDIPlus_ImageLoadFromFile($img)

; Draw PNG image
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, $top, $left)
EndFunc   ;==>writepng
; Draw PNG image
Func MY_WM_PAINT($hWnd, $msg, $wParam, $lParam)
    #forceref $hWnd, $Msg, $wParam, $lParam
    _WinAPI_RedrawWindow($map_gui, 0, 0, $RDW_UPDATENOW)
    _GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)
    _WinAPI_RedrawWindow($map_gui, 0, 0, $RDW_VALIDATE)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
Func _GuiCreateLabel ($iHwnd, $iText, $iX, $iY, $iW, $iH, $color)
    $iGui = GUICreate ("",$iW, $iH, $iX, $iY,BitOR($WS_POPUP, $WS_VISIBLE), BitOR ($WS_EX_MDICHILD,$WS_EX_LAYERED), $iHwnd)
    GUICtrlCreateLabel ($iText,2,0,$iW,$iH,-1)
    GUICtrlSetColor (-1,$color)
    GUICtrlSetFont (-1,10,400,0,"Arial", 4) ;teste auch mal 5 anstatt 4
    GUISetBkColor(0x010000, $iGui)
    _WinAPI_SetLayeredWindowAttributes($iGui, 0x010000, 255)
EndFunc
