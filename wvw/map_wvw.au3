#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#Include <WinAPI.au3>

Global $hGUI, $hImage, $hGraphic, $hImage
Global Const $SC_DRAGMOVE = 0xF012

; Create GUI
$hGUI = GUICreate("", 500, 500, -1, -1, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOPMOST)
_GuiCreateLabel($hGUI,"Kodash[DE] vs Seafarer's Rest vs Desolation",120,10,400,20, 0xFFFFFF)
GUISetBkColor(0x01, $hGUI)
GUISetState()
_WinAPI_SetLayeredWindowAttributes($hGUI, 0x01, 0xFF, 3)

; Load PNG image
_GDIPlus_StartUp()
$hImage   = _GDIPlus_ImageLoadFromFile(@ScriptDir& "\images\eb_map.png")
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)

$speldan_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",128,108,$hGUI)
$mendon_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",200,96,$hGUI)
$veloka_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",328,92,$hGUI)
$overlook_icon = writepng(@ScriptDir& "\images\icons\keep_red.png",278,130,$hGUI)
$anza_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",192,190,$hGUI)
$ogrewatch_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",316,166,$hGUI)
$pangloss_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",368,146,$hGUI)
$rogue_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",88,248,$hGUI)
$wildcreek_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",150,276,$hGUI)
$stonemist_icon = writepng(@ScriptDir& "\images\icons\castle_red.png",254,274,$hGUI)
$durios_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",350,262,$hGUI)
$umber_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",412,250,$hGUI)
$bravost_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",446,310,$hGUI)
$aldon_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",56,310,$hGUI)
$lowlands_icon = writepng(@ScriptDir& "\images\icons\keep_red.png",98,360,$hGUI)
$klovan_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",188,354,$hGUI)
$golanta_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",186,416,$hGUI)
$jerrifer_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",128,410,$hGUI)
$quentin_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",286,380,$hGUI)
$danelon_icon = writepng(@ScriptDir& "\images\icons\camp_red.png",320,438,$hGUI)
$langor_icon = writepng(@ScriptDir& "\images\icons\tower_red.png",394,424,$hGUI)
$valley_icon = writepng(@ScriptDir& "\images\icons\keep_red.png",394,360,$hGUI)

GUIRegisterMsg($WM_PAINT, "MY_WM_PAINT")

While 1
    $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $GUI_EVENT_PRIMARYDOWN
                _SendMessage($hGUI, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
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
    _WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_UPDATENOW)
    _GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)
    _WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_VALIDATE)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
Func _GuiCreateLabel ($iHwnd, $iText, $iX, $iY, $iW, $iH, $color)
    $iGui = GUICreate ("",$iW, $iH, $iX, $iY,BitOR($WS_POPUP, $WS_VISIBLE), BitOR ($WS_EX_MDICHILD,$WS_EX_LAYERED), $iHwnd)
    GUICtrlCreateLabel ($iText,2,0,$iW,$iH,-1,$GUI_WS_EX_PARENTDRAG )
    GUICtrlSetColor (-1,$color)
    GUICtrlSetFont (-1,10,400,0,"Arial", 4) ;teste auch mal 5 anstatt 4
    GUISetBkColor(0x010000, $iGui)
    _WinAPI_SetLayeredWindowAttributes($iGui, 0x010000, 255)
EndFunc