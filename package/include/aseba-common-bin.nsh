/*
	Aseba - an event-based framework for distributed robot control
	Copyright (C) 2007--2011:
		Stephane Magnenat <stephane at magnenat dot net>
		(http://stephane.magnenat.net)
		and other contributors, see authors.txt for details
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation, version 3 of the License.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

SectionGroup /e "!Aseba" GroupAseba
	Section "!Aseba Studio IDE" SecStudio
		SectionIn 1 2 3

		SetOutPath "$INSTDIR"

		# Main files
		File "${ASEBA_BIN_STRIP}\asebastudio.exe"
		File "${ASEBA_BIN}\clients\studio\aseba-doc.qhc"
		File "${ASEBA_BIN}\clients\studio\aseba-doc.qch"
		File "${ASEBA_SRC}\menu\windows\asebastudio.ico"

		${If} $FullInstall == "true"
			; Install the ThymioII stuff here
			File "${ASEBA_SRC}\menu\windows\asebastudiothymio.ico"
			File "${ASEBA_SRC}\menu\windows\thymiovpl.ico"
			File "${ASEBA_SRC}\menu\windows\thymioupgrader.ico"
			File "${ASEBA_SRC}\menu\windows\asebahelp.ico"
			File "${ASEBA_SRC}\menu\windows\thymiownetconfig.ico"
			File "${ASEBA_BIN_STRIP}\thymioupgrader.exe"
			File "${ASEBA_BIN_STRIP}\thymiovpl.exe"
			File "${ASEBA_BIN_STRIP}\thymiownetconfig.exe"
		${EndIf}
		
		# Version file (version.txt)
		Call WriteVersionFile
		
		${If} $Language == '1036'
			; French
			File "README.fr.txt"
		${ElseIf} $Language == '1031'
			; German
			File "README.de.txt"
		${ElseIf} $Language == '1040'
			; Italian
			File "README.it.txt"
		${Else}
			File "README.en.txt"
		${EndIf}

		;Store installation folder
		WriteRegStr HKCU ${REGISTRY_KEY} "" $INSTDIR

		;Create uninstaller
		WriteUninstaller "$INSTDIR\Uninstall.exe"

		; Populate the start menu
		${If} $AlreadyInstalled == "true"
			; Clean old shortcuts
			Call CleanShortcuts
		${EndIf}
		SetShellVarContext current
		SetOutPath "$DOCUMENTS"		; Working directory for the shortcut
		SetShellVarContext all		; current / all. Install program for all users
		!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
			; Application
			CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Uninstall).lnk" "$INSTDIR\Uninstall.exe"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Package_Name).lnk" "$INSTDIR\asebastudio.exe" "" "$INSTDIR\asebastudio.ico"		; Regular Aseba Studio
			; Doc
			CreateDirectory "$SMPROGRAMS\$StartMenuFolder\$(STR_Doc_Dir)"
			;Do not add this anymore
			;CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Doc_Dir)\$(STR_Doc_Browser_Offline).lnk" "$INSTDIR\asebastudio.exe" "-doc" "$INSTDIR\asebahelp.ico"
			${If} $Language == '1036'
				; French
				!insertmacro CreateInternetShortcut "$SMPROGRAMS\$StartMenuFolder\$(STR_Doc_Dir)\$(STR_Doc_Browser_Online)" "https://www.thymio.org/fr:start" "$INSTDIR\asebahelp.ico" "0"
			${ElseIf} $Language == '1031'
				; German
				!insertmacro CreateInternetShortcut "$SMPROGRAMS\$StartMenuFolder\$(STR_Doc_Dir)\$(STR_Doc_Browser_Online)" "https://www.thymio.org/de:start" "$INSTDIR\asebahelp.ico" "0"
			${ElseIf} $Language == '1040'
				; Italian
				!insertmacro CreateInternetShortcut "$SMPROGRAMS\$StartMenuFolder\$(STR_Doc_Dir)\$(STR_Doc_Browser_Online)" "https://www.thymio.org/it:start" "$INSTDIR\asebahelp.ico" "0"
			${Else}
				!insertmacro CreateInternetShortcut "$SMPROGRAMS\$StartMenuFolder\$(STR_Doc_Dir)\$(STR_Doc_Browser_Online)" "https://www.thymio.org/en:start" "$INSTDIR\asebahelp.ico" "0"
			${EndIf}
			; Thymio stuff?
			${If} $FullInstall == "true"
				; Aseba Thymio with auto-refresh
				CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Package_Name_Thymio).lnk" "$INSTDIR\asebastudio.exe" "-ar ser:name=Thymio-II" "$INSTDIR\asebastudiothymio.ico"
				; Thymio VPL
				CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Thymio VPL.lnk" "$INSTDIR\thymiovpl.exe" "-ar ser:name=Thymio-II" "$INSTDIR\thymiovpl.ico"
				; Thymio flasher 
				; CreateDirectory "$SMPROGRAMS\$StartMenuFolder\Thymio Firmware Upgrader"
				CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Thymio Firmware Upgrader.lnk" "$INSTDIR\thymioupgrader.exe" "" "$INSTDIR\thymioupgrader.ico"
				; Thymio wireless configurator
				CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Wireless Thymio Network Configurator.lnk" "$INSTDIR\thymiownetconfig.exe" "" "$INSTDIR\thymiownetconfig.ico"
			${EndIf}
		!insertmacro MUI_STARTMENU_WRITE_END
	SectionEnd

	Section "Qt4" SecQt
		SectionIn 1 2 3

		SetOutPath "$INSTDIR"

		!ifndef FAKE_PACKAGE
		File "${QTDIR}\bin\libgcc_s_dw2-1.dll"
		File "${QTDIR}\bin\libstdc++-6.dll"
		File "${QTDIR}\bin\libwinpthread-1.dll"
		File "${QTDIR}\bin\QtCore4.dll"
		File "${QTDIR}\bin\QtGui4.dll"
		File "${QTDIR}\bin\QtOpenGL4.dll"
		File "${QTDIR}\bin\QtXml4.dll"
		File "${QTDIR}\bin\QtHelp4.dll"
		File "${QTDIR}\bin\QtCLucene4.dll"
		File "${QTDIR}\bin\QtNetwork4.dll"
		File "${QTDIR}\bin\QtSql4.dll"
		File "${QTDIR}\bin\QtSvg4.dll"
		File "${QTDIR}\bin\QtWebKit4.dll"
		File "${ASEBA_DEP}\qwt\lib\qwt5.dll"
		File "${ASEBA_DEP}\SDL.dll"
		File "${ASEBA_DEP}\libeay32.dll"
		File "${ASEBA_DEP}\ssleay32.dll"

		SetOutPath "$INSTDIR\sqldrivers"
		File "${QTDIR}\plugins\sqldrivers\qsqlite4.dll"

		SetOutPath "$INSTDIR\iconengines"
		File "${QTDIR}\plugins\iconengines\qsvgicon4.dll"

		SetOutPath "$INSTDIR\imageformats"
		File "${QTDIR}\plugins\imageformats\qsvg4.dll"
		
		SetOutPath "$INSTDIR"
		File "qt.conf"
		SetOutPath "$INSTDIR\translations"
		File "${QTDIR}\translations\qt_fr.qm"
		File "${QTDIR}\translations\qt_de.qm"
		File "${QTDIR}\translations\qt_es.qm"
		File "${QTDIR}\translations\qt_ja.qm"
		File "qt_it.qm"
		
		!endif ;FAKE_PACKAGE

	SectionEnd
SectionGroupEnd

Section "Simulations" SecSim 
	SectionIn 1 2

	SetOutPath "$INSTDIR"

	!ifndef FAKE_PACKAGE
	File "${ASEBA_BIN_STRIP}\asebachallenge.exe"
	;File "${ASEBA_BIN_STRIP}\asebamarxbot.exe"
	File "${ASEBA_BIN_STRIP}\asebaplayground.exe"
	File "${ASEBA_SRC}\menu\windows\asebachallenge.ico"
	File "${ASEBA_SRC}\menu\windows\asebaplayground.ico"
	File "${ASEBA_SRC}\targets\playground\unifr.playground"	
	;SetOutPath "$INSTDIR\examples"
	;File /r "${ASEBA_SRC}\targets\playground\examples\*"
	!endif ; FAKE_PACKAGE

	; Populate the start menu
	SetShellVarContext all		; current / all. Install program for all users
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
		CreateDirectory "$SMPROGRAMS\$StartMenuFolder\$(STR_Simulations)"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Simulations)\Aseba Challenge.lnk" "$INSTDIR\asebachallenge.exe" "" "$INSTDIR\asebachallenge.ico"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Simulations)\Aseba Playground.lnk" "$INSTDIR\asebaplayground.exe" "" "$INSTDIR\asebaplayground.ico"
		;CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Simulations)\Aseba MarXbot.lnk" "$INSTDIR\asebamarxbot.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

SectionGroup /e $(NAME_GroupCLI) GroupCLI
	Section "Aseba Switch" SecSwitch
		SectionIn 1 2

		SetOutPath "$INSTDIR"

		File "${ASEBA_BIN_STRIP}\asebaswitch.exe"


		SetShellVarContext all		; current / all. Install program for all users
		!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
			CreateDirectory "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)\$(STR_Cmd_Line).lnk" "%windir%\system32\cmd.exe" "$INSTDIR"
		!insertmacro MUI_STARTMENU_WRITE_END
	SectionEnd
	
	Section "Aseba Http" SecHttp
		SectionIn 1 2

		SetOutPath "$INSTDIR"

		File "${ASEBA_BIN_STRIP}\asebahttp.exe"


		SetShellVarContext all		; current / all. Install program for all users
		!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
			CreateDirectory "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)\$(STR_Cmd_Line).lnk" "%windir%\system32\cmd.exe" "$INSTDIR"
		!insertmacro MUI_STARTMENU_WRITE_END
	SectionEnd

	Section /o $(NAME_SecTools) SecTools
		SectionIn 1 

		SetOutPath "$INSTDIR"
		
		!ifndef FAKE_PACKAGE
		File "${ASEBA_BIN_STRIP}\asebacmd.exe"
		File "${ASEBA_BIN_STRIP}\asebadump.exe"
		File "${ASEBA_BIN_STRIP}\asebaeventlogger.exe"
		File "${ASEBA_BIN_STRIP}\asebaplay.exe"
		File "${ASEBA_BIN_STRIP}\asebarec.exe"    
		File "${ASEBA_BIN_STRIP}\asebaexec.exe"
		File "${ASEBA_BIN_STRIP}\asebadummynode.exe"
		File "${ASEBA_BIN_STRIP}\asebashell.exe"
		File "${ASEBA_BIN_STRIP}\asebamassloader.exe"
		!endif ; FAKE_PACKAGE

		SetShellVarContext all		; current / all. Install program for all users
		!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
			CreateDirectory "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)\$(STR_Cmd_Line).lnk" "%windir%\system32\cmd.exe" "$INSTDIR"
		!insertmacro MUI_STARTMENU_WRITE_END
	SectionEnd
SectionGroupEnd

Section "-Install the driver" InstDriver	; Hidden section -> always executed
	${If} $FullInstall == "true"
		; Install the ThymioII driver
		CreateDirectory "$INSTDIR\drivers"
		SetOutPath "$INSTDIR\drivers"
		
		DetailPrint $(STR_Drv_Install)

		${If} ${AtLeastWin8}
			; Windows 8 or above
			DetailPrint "We are on Windows 8 (or above)"
			File "${DRV_INF_WIN8}\mchpcdc.inf"
			File "${DRV_INF_WIN8}\mchpcdcw.inf"
			File "${DRV_INF_WIN8}\mchpcdc.cat"
			File "${DRV_INF_WIN8}\mchpcdcw.cat"
			File "${DRV_INF_WIN8}\certmgr_x86.exe"
			File "${DRV_INF_WIN8}\certmgr_x64.exe"
			File "${DRV_INF_WIN8}\mobsya.cer"

			; We must install the security certificate in we are on Windows 8
			DetailPrint "Installing the security certificate..."
			${If} ${RunningX64}
				ExecWait '"$INSTDIR\drivers\certmgr_x64.exe" -add -c "$INSTDIR\drivers\mobsya.cer" -s -r LocalMachine root' $0
			${Else}
				ExecWait '"$INSTDIR\drivers\certmgr_x86.exe" -add -c "$INSTDIR\drivers\mobsya.cer" -s -r LocalMachine root' $0
			${EndIf}
			DetailPrint "Done."
			IntCmp $0 0x0 cert_ok8 cert_error8 cert_error8
			cert_ok8:
				DetailPrint "Certificate installed"
				Goto cert_done8
			cert_error8:
				DetailPrint "A problem occured"
			cert_done8:
			; Done
		${ElseIf} ${AtLeastWin7}
			; Windows 7 or above
			DetailPrint "We are on Windows 7 (or above)"
			File "${DRV_INF_WIN}\mchpcdc.inf"
			File "${DRV_INF_WIN}\mchpcdcw.inf"
			File "${DRV_INF_WIN}\mchpcdc.cat"
			File "${DRV_INF_WIN}\mchpcdcw.cat"
			File "${DRV_INF_WIN8}\certmgr_x86.exe"
			File "${DRV_INF_WIN8}\certmgr_x64.exe"
			File "${DRV_INF_WIN8}\mobsya.cer"

			; We must install the security certificate in we are on Windows 7
			DetailPrint "Installing the security certificate..."
			${If} ${RunningX64}
				ExecWait '"$INSTDIR\drivers\certmgr_x64.exe" -add -c "$INSTDIR\drivers\mobsya.cer" -s -r LocalMachine root' $0
			${Else}
				ExecWait '"$INSTDIR\drivers\certmgr_x86.exe" -add -c "$INSTDIR\drivers\mobsya.cer" -s -r LocalMachine root' $0
			${EndIf}
			DetailPrint "Done."
			IntCmp $0 0x0 cert_ok7 cert_error7 cert_error7
			cert_ok7:
				DetailPrint "Certificate installed"
				Goto cert_done7
			cert_error7:
				DetailPrint "A problem occured"
			cert_done7:
			; Done
		${Else}
			; Other windows (XP)
			DetailPrint "We are on Windows XP or above"
			File "${DRV_INF_WIN}\mchpcdc.inf"
			File "${DRV_INF_WIN}\mchpcdcw.inf"
			File "${DRV_INF_WIN}\mchpcdc.cat"
			File "${DRV_INF_WIN}\mchpcdcw.cat"
		${EndIf}

		File "${DRV_SRC}\dpinst32.exe"
		File "${DRV_SRC}\dpinst64.exe"

		${If} ${RunningX64}
			DetailPrint $(STR_Drv_64bits)
			ExecWait '"$INSTDIR\drivers\dpinst64.exe" /c /sa /lm /sw /PATH "$INSTDIR\drivers"' $0
		${Else}
			DetailPrint $(STR_Drv_32bits)
			ExecWait '"$INSTDIR\drivers\dpinst32.exe" /c /sa /lm /sw /PATH "$INSTDIR\drivers"' $0
		${EndIf}
		DetailPrint "$(STR_Drv_Return_Code) $0"
		IntCmpU $0 0x80000000 drv_error no_error drv_error
		drv_error:
			DetailPrint $(STR_Drv_Problem)
			Goto done
		no_error:
			DetailPrint $(STR_Done)
		done:
	${EndIf}
SectionEnd

Section "-Install devcon" InstDevcon	; Hidden section -> always executed
	${If} $FullInstall == "true"
		SetOutPath "$INSTDIR"
		
		File "${DEVCON_SRC}\restart.bat"
		File "${DEVCON_SRC}\restartusb.exe"

		SetShellVarContext all		; current / all. Install program for all users
		!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
			CreateDirectory "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(STR_Tools)\$(STR_USB_Restart).lnk" "$INSTDIR\restart.bat" "$INSTDIR"
		!insertmacro MUI_STARTMENU_WRITE_END
	${EndIf}
SectionEnd

Section "-PostInstall"
	DetailPrint "Post install..."

	; Black voodoo to order the menu correctly
	DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu\Programs\Aseba Studio"
	DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs\Aseba Studio"

	DetailPrint "Done."
SectionEnd

; First function to be executed by the installer
Function .onInit
	; Display the "Language Select" menu
	!insertmacro MUI_LANGDLL_DISPLAY

	; Load bitmaps
	InitPluginsDir
	File /oname=$PLUGINSDIR\thymio2.bmp "thymio2.bmp"
	File /oname=$PLUGINSDIR\studio.bmp "studio.bmp"

	; Group Studio as Read-only and Expanded
	SectionGetFlags ${GroupAseba} $0
	IntOp $0 $0 | ${SF_RO}
	IntOp $0 $0 | ${SF_EXPAND}
	SectionSetFlags ${GroupAseba} $0

	; Section Studio IDE as Read-only
	SectionGetFlags ${SecStudio} $0
	IntOp $0 $0 | ${SF_RO}
	SectionSetFlags ${SecStudio} $0

	; Section Qt as Read-only
	SectionGetFlags ${SecQt} $0
	IntOp $0 $0 | ${SF_RO}
	SectionSetFlags ${SecQt} $0

	IfSilent 0 +5
		StrCpy $FullInstall "true" ; for silent install
		SectionGetFlags ${SecTools} $0
		IntOp $0 $0 | ${SF_SELECTED}
		SectionSetFlags ${SecTools} $0

	; Check for a previous installation
	ReadRegStr $0 HKCU ${REGISTRY_KEY} ""	; Read installation folder
	${If} $0 != ""
		DetailPrint "Previous installation detected at $0"
		StrCpy $AlreadyInstalled "true"
		; Check installation type
		${If} ${FileExists} "$INSTDIR\drivers\mchpcdc.inf"
			DetailPrint "Full installation detected"
			StrCpy $FullInstall "true"
		${Else}
			DetailPrint "Aseba-only installation detected"
			StrCpy $FullInstall "false"
		${EndIf}

		MessageBox MB_YESNO $(STR_Previous_Install) /SD IDYES IDNO cancel IDYES ok

		cancel:
			Abort
		ok:
	${Else}
		StrCpy $AlreadyInstalled "false"
	${EndIf}

FunctionEnd

; First function to be executed by the uninstaller
Function un.onInit
  ; Get the language preference from the registry
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

;--------------------------------
;Descriptions

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${GroupAseba} $(DESC_GroupAseba)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStudio} $(DESC_SecStudioIDE)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecQt} $(DESC_SecQt)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSim} $(DESC_SecSim)
    !insertmacro MUI_DESCRIPTION_TEXT ${GroupCLI} $(DESC_GroupCLI)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSwitch} $(DESC_SecSwitch)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecHttp} $(DESC_SecHttp)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecTools} $(DESC_SecTools)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section

Section "Uninstall"
	; Remove the driver
	${If} ${FileExists} "$INSTDIR\drivers\mchpcdc.inf"
		; Driver was installed
		DetailPrint $(STR_Drv_Uninstall)
		${If} ${RunningX64}
			DetailPrint $(STR_Drv_64bits)
			ExecWait '"$INSTDIR\drivers\dpinst64.exe" /c /u "$INSTDIR\drivers\mchpcdc.inf" /d'
			${If} ${FileExists} "$INSTDIR\drivers\mchpcdcw.inf"
				; Driver was installed
				ExecWait '"$INSTDIR\drivers\dpinst64.exe" /c /u "$INSTDIR\drivers\mchpcdcw.inf" /d'
			${EndIf}
		${Else}
			DetailPrint $(STR_Drv_32bits)cer
			ExecWait '"$INSTDIR\drivers\dpinst32.exe" /c /u "$INSTDIR\drivers\mchpcdc.inf" /d'
			${If} ${FileExists} "$INSTDIR\drivers\mchpcdcw.inf"
				; Driver was installed
				ExecWait '"$INSTDIR\drivers\dpinst32.exe" /c /u "$INSTDIR\drivers\mchpcdcw.inf" /d'
			${EndIf}
		${EndIf}

		${If} ${AtLeastWin7}
			; Windows 7 or above
			; We must uninstall our certificate
			DetailPrint "Uninstalling the security certificate..."
			${If} ${RunningX64}
				ExecWait '"$INSTDIR\drivers\certmgr_x64.exe" -del -c -n "Mobsya" -s -r LocalMachine root' $0
			${Else}
				ExecWait '"$INSTDIR\drivers\certmgr_x86.exe" -del -c -n "Mobsya" -s -r LocalMachine root' $0
			${EndIf}
			DetailPrint "Done."
			IntCmp $0 0x0 cert_un_ok cert_un_error cert_un_error
			cert_un_ok:
				DetailPrint "Certificate uninstalled"
				Goto cert_un_done
			cert_un_error:
				DetailPrint "A problem occured"
			cert_un_done:
			; Done
		${EndIf}

		RMDir /r "$INSTDIR\drivers"
		DetailPrint $(STR_Done)
	${EndIf}
	
	; Remove the application
	DetailPrint $(STR_Uninst_Folder)
	RMDir /r "$INSTDIR"
	DetailPrint $(STR_Done)

	Call un.CleanShortcuts

	DeleteRegKey HKCU ${REGISTRY_KEY}
	DetailPrint $(STR_Done)
SectionEnd
