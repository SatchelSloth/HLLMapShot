;***********************************************
;***********************************************
;**				HELL LET LOOSE 				  ** 
;**				  MAPSHOT V6				  **
;**				  9 SEP 2021				  **
;**											  **
;**					  BY					  **
;**		      -TL- Satchel Sloth			  **
;**											  **
;***********************************************
;***********************************************

;__________________________________________________
;
; This is a script that allows players to save 
; screenshots of the in game map in order to later
; process into an animation for after game review.
;
; Known Issues:
;	Spamming M key causes it to freak out and 
;	screenshot everything map open or not.
; Solution:
;	Stop spamming M key
;
; For reporting bugs, quirks, or just general 
; suggestions contact me on discord:
;
;			Sloth With A Glock#6825
;					  OR
;			https://discord.gg/theline
;____________________________________________________

#NoEnv
#SingleInstance,Force

SetWorkingDir,%A_ScriptDir%
CoordMode,Mouse,Window
CoordMode,Pixel,Window

SetBatchLines, -1 ; For speed in general
SetWinDelay, -1   ; For speed of WinMove
BW := 1           ; Border width (and height) in pixels
BC := "Red"       ; Border color
FirstCall := True
CoordMode, Mouse, Screen
Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
Gui, Color, %BC%
Index = 0

!F9:: ;Press ALT+F9 to start the Script

;**********************************************************************
;**********************************************************************
;
; The begining of the setup process.
; Setup starts after clicking YES to the first message box. After first
; setup clicking NO will bypass setup and begin the main script.
; 
; During setup: 
;	First, outline ingame map by holding shift, clicking on
;	the very top left corner of the map (your choice of 
;	weather to include resource numbers) and dragging to the 
;	very bottom right of the map. This box will be the image 
;	that is screenshotted and saved.
;	
;	Second, outline the map key box. The second box you highlight will the
;	area the script will search to verify that the map is currently opened.
;	This function prevents a screenshot from being taken and saved while 
;	the map is not shown. This box can be as big as your whole screen but 
;	will slow down the process as the script will search the entire area.
;	
;	Lastly, outline a small area of the screen that does not change within
;	the area of the previous box. This area will be the reference image the
;	script will look for in the search box. For best results, outline the
;	word key on the ingame map key.
;
;	After highlighting a box you it will be displayed while you are prompted 
;	if you would like to save it. if you chose no the box will be reset and 
;	you will be able to rehighlight it.
;
;************************************************************************
;************************************************************************

MsgBox, 4, Setup, Start Setup?
	IfMsgBox Yes
	{
	Sleep 10
	Return
	}
	Else
	{
	Goto, MapShot
	}

Box:
return
+LButton::
    MouseGetPos, OriginX, OriginY
	WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowX, WindowY
    SetTimer, DrawRectangle, 10
Return
; ______________________________________________________________________________________________________________________
+LButton Up::
   Index++
   SetTimer, DrawRectangle, Off
   FirstCall := True
   Gui, Cancel
   ToolTip
   ;MsgBox, 0, Coordinates, X = %X1%  -  Y = %Y1%  -  W = %W1%  -  H = %H1%
	If (Index = 1)
		goto, SaveMapCoor
	Else If (Index = 2)
		goto, SaveISACoor
	Else If (Index = 3)
		goto, SaveRefIMGCoor
Return
; ______________________________________________________________________________________________________________________
DrawRectangle:
   MouseGetPos, X2, Y2
   ; Has the mouse moved?
   If (XO = X2) And (YO = Y2)
      Return
   Gui, +LastFound
   XO := X2, YO := Y2
   ; Allow dragging to the left of the click point.
   If (X2 < OriginX)
      X1 := X2, X2 := OriginX
   Else
      X1 := OriginX
   ; Allow dragging above the click point.
   If (Y2 < OriginY)
      Y1 := Y2, Y2 := OriginY
   Else
      Y1 := OriginY
   ; Draw the rectangle
   W1 := X2 - X1, H1 := Y2 - Y1
   W2 := W1 - BW, H2 := H1 - BW
   WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %BW%-%BW% %W2%-%BW% %W2%-%H2% %BW%-%H2% %BW%-%BW%
   If (FirstCall) {
      Gui, Show, NA x%X1% y%Y1% w%W1% h%H1%
      FirstCall := False
   }
   WinMove, , , X1, Y1, W1, H1
   ; ToolTip, %X1% - %Y1% - %X2% - %Y2%
Return

SaveMapCoor:
	MapSquareX1 = %X1%
	MapSquareY1 = %Y1%
	MapSquareW1 = %W1%
	MapSquareH1 = %H1%
	
	Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
	Gui, Color, %BC%
	W2 := W1 - BW, H2 := H1 - BW
	WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %BW%-%BW% %W2%-%BW% %W2%-%H2% %BW%-%H2% %BW%-%BW%
	Gui, Show, NA x%X1% y%Y1% w%W1% h%H1%
	
	MapSquare = X1=%MapSquareX1% Y1=%MapSquareY1% Width=%MapSquareW1% Hieght=%MapSquareH1%
	MsgBox, 4, Map Window Coords Saved, MapSquare Coordinates saved as "%MapSquare%". Accept Setting?
	IfMsgBox Yes
	{
		Gui, Cancel
		Goto, Box
	}
	Else
	{
	Index--
	Gui, Cancel
	Goto, Box
	}
	
SaveISACoor:
	ISAX1 = %X1%
	ISAY1 = %Y1%
	ISAW1 = %W1%
	ISAH1 = %H1%
	ISAX2 = %X2%
	ISAY2 = %Y2% 
	
	Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
	Gui, Color, %BC%
	W2 := W1 - BW, H2 := H1 - BW
	WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %BW%-%BW% %W2%-%BW% %W2%-%H2% %BW%-%H2% %BW%-%BW%
	Gui, Show, NA x%X1% y%Y1% w%W1% h%H1%
	
	ISA = X1=%ISAX1% Y1=%ISAY1% Width=%ISAW1% Hieght=%ISAH1%
	MsgBox, 4, ImageSearchArea Coords Saved, ImageSearchArea Coordinates Saved as "%ISA%". Accept Setting?
	IfMsgBox Yes
	{
		Gui, Cancel
		Goto, Box
	}
	Else
	{
	Index--
	Gui, Cancel
	Goto, Box
	}

SaveRefIMGCoor:
	RefIMGX1 = %X1%
	RefIMGY1 = %Y1%
	RefIMGW1 = %W1%
	RefIMGH1 = %H1%
	
	Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
	Gui, Color, %BC%
	W2 := W1 - BW, H2 := H1 - BW
	WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %BW%-%BW% %W2%-%BW% %W2%-%H2% %BW%-%H2% %BW%-%BW%
	Gui, Show, NA x%X1% y%Y1% w%W1% h%H1%
	
	RefIMG = X1=%RefIMGX1% Y1=%RefIMGY1% Width=%RefIMGW1% Hieght=%RefIMGH1%
	MsgBox, 4, RefIMG Coords Saved, ImageSearchArea Coordinates Saved as "%RefIMG%". Accept Setting?
	IfMsgBox Yes
	{
		Gui, Cancel
	}
	Else
	{
	Index--
	Gui, Cancel
	Goto, Box
	}
	
filename = %A_ScriptDir%\RefIMG.png
sleep 1000
pToken:=Gdip_Startup()
pBitmap:=Gdip_BitmapFromScreen(RefIMGX1 "|" RefIMGY1 "|" RefIMGW1 "|" RefIMGH1, raster)
;pBitmap:=Gdip_BitmapFromScreen("RefIMG", raster)
Gdip_SaveBitmapToFile(pBitmap, filename)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
MsgBox,,, Saved Reference Image. Press F9 to validate.

;*********************************************************************************************************************
;*********************************************************************************************************************
;
; Settings have been saved and the reference image has also been saved.
; The following work to validate and make sure required settings work as intended.
; To start make sure the in game map is opened and press F9
;	If successful a message box will appear stating YAY found it @ (screen coordinates of the referance image)
;	You will be prompted if you would like to save your settings.
;	Selecting yes will write your settings to an .INI file allowing you to bypass setup the next time the script is ran.
;
;	If unsuccessful a message box will state Image Not Found. 
;	On rare occasions it wont be found on the first attempt. try again. this is also most likely cause by the search 
;	area not correctly define and the referance image is not in the search area or Hell Let Loose is not the active 
;	window. Click back in HLL to make it the active window.
;
;	If super unsuccessful a message box will state It Broke. Does Ref Image Exist? and will restart setup.
;	make sure a referance image is saved in the same directory as the script titled "RefImg.png"
;
;*********************************************************************************************************************
;*********************************************************************************************************************

;---------- validate above settings
Loop,
{
KeyWait, F9, D
KeyWait, F9,
Sleep 100
ImageSearch, OutputVarX, OutputVarY, %ISAX1%, %ISAY1%, %ISAX2%, %ISAY2%, *TransBlack RefImg.png
if(ErrorLevel=2)
{
msgbox, 0, Error, It Broke. Does Ref Image Exist? Resetting Setup.
Index = 0
goto, Box
}
else if(ErrorLevel=1)
{
msgbox, 0, Error, Image Not Found
}

else if(ErrorLevel=0)
{
msgbox, 0, YAY!, Found It @ %OutputVarX%, %OutputVarY%
Sleep 1000
SN++
filename = %A_ScriptDir%\Screenshot_%A_Now%_%SN%.png
pToken:=Gdip_Startup()
pBitmap:=Gdip_BitmapFromScreen(MapSquareX1 "|" MapSquareY1 "|" MapSquareW1 "|" MapSquareH1, raster)
Gdip_SaveBitmapToFile(pBitmap, filename)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)

MsgBox, 4, Setup Complete, Save Settings and Exit Setup?
IfMsgBox Yes
	{
		IniWrite, %MapSquareX1%, FileIndex.ini, MapSquare, MapSquareX1
		IniWrite, %MapSquareY1%, FileIndex.ini, MapSquare, MapSquareY1
		IniWrite, %MapSquareW1%, FileIndex.ini, MapSquare, MapSquareW1
		IniWrite, %MapSquareH1%, FileIndex.ini, MapSquare, MapSquareH1
		IniWrite, %ISAX1%, FileIndex.ini, ISA, ISAX1
		IniWrite, %ISAY1%, FileIndex.ini, ISA, ISAY1
		IniWrite, %ISAX2%, FileIndex.ini, ISA, ISAX2
		IniWrite, %ISAY2%, FileIndex.ini, ISA, ISAY2
		IniWrite, %RefIMGX1%, FileIndex.ini, RefIMG, RefIMGX1
		IniWrite, %RefIMGY1%, FileIndex.ini, RefIMG, RefIMGY1
		IniWrite, %RefIMGW1%, FileIndex.ini, RefIMG, RefIMGW1
		IniWrite, %RefIMGH1%, FileIndex.ini, RefIMG, RefIMGH1
		ImageSearch, OutputVarX, OutputVarY, %ISAX1%, %ISAY1%, %ISAX2%, %ISAY2%, *TransBlack RefImg.png
		Sleep 1000
		Send M
		Goto, MapShot
	}
	Else
	{
	Index = 0
	Gui, Cancel
	Goto, Box
	}
}
}

;*************************************************************************************************************************
;*************************************************************************************************************************
;
; The begining. The meat and potatoes.
; Starts off with loading required settings from INI file saved in script directory.
; Prompts for a folder location to save screenshots taken.
; Script is able to run in two different modes. AUTO and MANUAL.
;
;	In Auto Mode: the ingame map will be opened, zoomed out, then screenshotted and finally closed every 30 
;	seconds by default. The inverval by which this occurs can be changed by editing line 358 variable labeled INTERVAL. 
;	Value must be in miliseconds
;
;	In Manual Mode, the map will be opened and fully zoomed out then a screenshot is taken everytime the M key is pressed
;	to open the map. A screenshot will not be taken on map close. 
;	it will also zoom the map out and take a screenshot every 15 seconds while the map is open.
;
;***************************************************************************************************************************
;***************************************************************************************************************************
	
MapShot: ;------ MapShot Start

Hotkey, +LButton, Off
Hotkey, +LButton Up, Off

IniRead, ISAX1, FileIndex.ini, ISA, ISAX1
IniRead, ISAY1, FileIndex.ini, ISA, ISAY1
IniRead, ISAX2, FileIndex.ini, ISA, ISAX2
IniRead, ISAY2, FileIndex.ini, ISA, ISAY2
IniRead, MapSquareX1, FileIndex.ini, MapSquare, MapSquareX1, 0
IniRead, MapSquareY1, FileIndex.ini, MapSquare, MapSquareY1, 0
IniRead, MapSquareW1, FileIndex.ini, MapSquare, MapSquareW1, 0
IniRead, MapSquareH1, FileIndex.ini, MapSquare, MapSquareH1, 0

ISAXA = %ISAX1%
ISAYA = %ISAY1%
ISAXB = %ISAX2%
ISAYB = %ISAY2%

FileSelectFolder, ShotDir ;------- GUI to select screenshot save DIR
;ShotDir = D:\Documents\AHK\hll\IMAGE\TestShots

SN = 0
INTERVAL = 30000
ZoomStep = 15
msgbox, 4 ,MODE SELECT, Turn on AUTO MODE?
;Goto, MANUAL
IfMsgBox Yes
	{
	sleep 1000
	Goto, AUTO
	}
else
	Goto, MANUAL

AUTO:
SN++
Send M
Sleep 125
Map_ScreenShot(ISAX1,ISAY1,ISAX2,ISAY2,MapSquareX1,MapSquareY1,MapSquareW1,MapSquareH1,ShotDir,SN)
Send M
Loop,
{
Sleep %INTERVAL%
ImageSearch, OutputVarX, OutputVarY, %ISAX1%, %ISAY1%, %ISAX2%, %ISAY2%, *TransBlack RefImg.png
if(ErrorLevel=1)
{
SN++
Send M
Sleep 125
Map_ScreenShot(ISAX1,ISAY1,ISAX2,ISAY2,MapSquareX1,MapSquareY1,MapSquareW1,MapSquareH1,ShotDir,SN)
Send M
}
else if(ErrorLevel=0)
{
SN++
Map_ScreenShot(ISAX1,ISAY1,ISAX2,ISAY2,MapSquareX1,MapSquareY1,MapSquareW1,MapSquareH1,ShotDir,SN)
}
}

MANUAL:
loop,
{
Map_close:
KeyWait, M, D, L
KeyWait, M,, L
sleep 100

Active_map:
SN++
Map_ScreenShot(ISAX1,ISAY1,ISAX2,ISAY2,MapSquareX1,MapSquareY1,MapSquareW1,MapSquareH1,ShotDir,SN)

Loop, 1000
{ ;---- check active map loop open
KeyIsDown := GetKeyState( "M", "P")
if (KeyIsDown = 1)
{
	KeyWait, M,, L
	sleep 100
	Goto, Map_close
}
else 
	{
	ImageSearch, OutputVarX, OutputVarY, %ISAX1%, %ISAY1%, %ISAX2%, %ISAY2%, *TransBlack RefImg.png
	if(ErrorLevel=1)
		goto, Map_close
	}
	sleep 2
}
Goto, Active_map
}

F6::Reload ;---- F5 key reloads script
Pause::Pause

;-------------------------------------------------------------------
; MapScreensShot Function
;				
;				X1,Y1 = x,y value of first imagesearch point
;				X2,Y2 = x,y value of second imagesearch point
;				
;				GdipX1,GdipY1	= x,y,w,h value of area 
;				GdipW1,GdipH1 		to be screenshotted
;				
;				ShotDir =	File directory of screenshot
;--------------------------------------------------------------------

Map_ScreenShot(X1,Y1,X2,Y2,GdipX1,GdipY1,GdipW1,GdipH1,ShotDir,SN)
	{
		;msgbox %X1%, %Y1%, %X2%, %Y2%
		ImageSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, *TransBlack %A_ScriptDir%\RefIMG.png
		if(ErrorLevel=2)
		{
		msgbox, 0, Error, It Broke. Does Ref Image Exist?
		}
		else if(ErrorLevel=1)
		{
		Return
		}
		else if(ErrorLevel=0)
		{
		;msgbox, 0, YAY!, Found It @ %OutputVarX%, %OutputVarY%
		;Sleep 1000
		Sleep 1
		loop, 15
		{ ;----- zoom out loop open
		MouseClick, WheelDown
		Sleep 1
		} ;----- zoom out loop close

		;----- Gdip Snap
		filename = %ShotDir%\Screenshot_%A_Now%_%SN%.png
		pToken:=Gdip_Startup()
		;msgbox pBitmap:=Gdip_BitmapFromScreen(%GdipX1%|%GdipY1%|%GdipW1%|%GdipH1%, raster)
		pBitmap:=Gdip_BitmapFromScreen(GdipX1 "|" GdipY1 "|" GdipW1 "|" GdipH1, raster)
		;msgbox filename = %ShotDir%\Screenshot_%A_Now%_%SN%.png
		Gdip_SaveBitmapToFile(pBitmap, filename)
		Gdip_DisposeImage(pBitmap)
		Gdip_Shutdown(pToken)
		}
		return
	}
	
; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
; Modifed by Rseding91 using fincs 64 bit compatible Gdip library 5/1/2013
; Supports: Basic, _L ANSi, _L Unicode x86 and _L Unicode x64
;
; Updated 2/20/2014 - fixed Gdip_CreateRegion() and Gdip_GetClipRegion() on AHK Unicode x86
; Updated 5/13/2013 - fixed Gdip_SetBitmapToClipboard() on AHK Unicode x64
; Extracted Required functions - [BR1] Satchel Sloth

;#####################################################################################

; Function				Gdip_BitmapFromScreen
; Description			Gets a gdi+ bitmap from the screen
;
; Screen				0 = All screens
;						Any numerical value = Just that screen
;						x|y|w|h = Take specific coordinates with a width and height
; Raster				raster operation code
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1:		one or more of x,y,w,h not passed properly
;
; notes					If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	if (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}

	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1

	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}

;#####################################################################################

; Function				CreateDIBSection
; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w						width of the bitmap to create
; h						height of the bitmap to create
; hdc					a handle to the device context to use the palette from
; bpp					bits per pixel (32 = ARGB)
; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return				returns a DIB. A gdi bitmap
;
; notes					ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	
	NumPut(w, bi, 4, "uint")
	, NumPut(h, bi, 8, "uint")
	, NumPut(40, bi, 0, "uint")
	, NumPut(1, bi, 12, "ushort")
	, NumPut(0, bi, 16, "uInt")
	, NumPut(bpp, bi, 14, "ushort")
	
	hbm := DllCall("CreateDIBSection"
					, Ptr, hdc2
					, Ptr, &bi
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "uint*", ppvBits
					, Ptr, 0
					, "uint", 0, Ptr)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}


;#####################################################################################

; Function:     		Gdip_SaveBitmapToFile
; Description:  		Saves a bitmap to a file in any supported format onto disk
;   
; pBitmap				Pointer to a bitmap
; sOutput      			The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality      			If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return      			If the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	if !(nCount && nSize)
		return -2
	
	If (A_IsUnicode){
		StrGet_Name := "StrGet"
		Loop, %nCount%
		{
			sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+idx
			break
		}
	} else {
		Loop, %nCount%
		{
			Location := NumGet(ci, 76*(A_Index-1)+44)
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+76*(A_Index-1)
			break
		}
	}
	
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			Loop, % NumGet(EncoderParameters, "UInt")      ;%
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					p := elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
					break
				}
			}      
		}
	}

	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &wOutput, Ptr, pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &sOutput, Ptr, pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}

;#####################################################################################

Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}


;#####################################################################################
; Extra functions
;#####################################################################################

Gdip_Startup()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}

Gdip_Shutdown(pToken)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}

;#####################################################################################

; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags=0, hrgnClip=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
    return DllCall("GetDCEx", Ptr, hwnd, Ptr, hrgnClip, "int", flags)
}

;#####################################################################################

; Function				CreateCompatibleDC
; Description			This function creates a memory device context (DC) compatible with the specified device
;
; hdc					Handle to an existing device context					
;
; return				returns the handle to a device context or 0 on failure
;
; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}

;#####################################################################################

; Function				SelectObject
; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc					Handle to a DC
; hgdiobj				A handle to the object to be selected into the DC
;
; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes					The specified object must have been created by using one of the following functions
;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;						Font - CreateFont, CreateFontIndirect
;						Pen - CreatePen, CreatePenIndirect
;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION			= 2 Region consists of a single rectangle
; COMPLEXREGION			= 3 Region consists of more than one rectangle
; NULLREGION			= 1 Region is empty

SelectObject(hdc, hgdiobj)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}

;#####################################################################################

; Function				Gdip_GetDC
; Description			This function gets the device context of the passed Graphics
;
; hdc					This is the handle to the device context
;
; return				returns the device context for the graphics of a bitmap

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", hdc)
	return hdc
}

; Function				GetDC
; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window. 
;
; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen					
;
; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd=0)
{
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}

;#####################################################################################

; Function				BitBlt
; Description			The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle 
;						of pixels from the specified source device context into a destination device context.
;
; dDC					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of the area to copy
; dh					height of the area to copy
; sDC					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; BLACKNESS				= 0x00000042
; NOTSRCERASE			= 0x001100A6
; NOTSRCCOPY			= 0x00330008
; SRCERASE				= 0x00440328
; DSTINVERT				= 0x00550009
; PATINVERT				= 0x005A0049
; SRCINVERT				= 0x00660046
; SRCAND				= 0x008800C6
; MERGEPAINT			= 0x00BB0226
; MERGECOPY				= 0x00C000CA
; SRCCOPY				= 0x00CC0020
; SRCPAINT				= 0x00EE0086
; PATCOPY				= 0x00F00021
; PATPAINT				= 0x00FB0A09
; WHITENESS				= 0x00FF0062
; CAPTUREBLT			= 0x40000000
; NOMIRRORBITMAP		= 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdi32\BitBlt"
					, Ptr, dDC
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sDC
					, "int", sx
					, "int", sy
					, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				ReleaseDC
; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc					Handle to the device context to be released
; hwnd					Handle to the window whose device context is to be released
;
; return				1 = released
;						0 = not released
;
; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function. 

ReleaseDC(hdc, hwnd=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBitmap, Ptr, Palette, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

; Function				DeleteObject
; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;						After the object is deleted, the specified handle is no longer valid
;
; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject)
{
   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}

;#####################################################################################

; Function				DeleteDC
; Description			The DeleteDC function deletes the specified device context (DC)
;
; hdc					A handle to the device context
;
; return				If the function succeeds, the return value is nonzero
;
; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc)
{
   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}