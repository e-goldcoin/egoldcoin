Name E-Gold

RequestExecutionLevel highest
SetCompressor /SOLID lzma

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 1.6.0
!define COMPANY "E-Gold Developers"
!define URL http://

# MUI Symbol Definitions
!define MUI_ICON "../share/pixmaps/E-Gold.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\share\pixmaps\nsis-wizard.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "..\share\pixmaps\nsis-header.bmp"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER E-Gold
!define MUI_FINISHPAGE_RUN $INSTDIR\E-Gold-qt.exe
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "../share/pixmaps/nsis-wizard.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI2.nsh

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE SimpChinese
!insertmacro MUI_LANGUAGE TradChinese
!insertmacro MUI_LANGUAGE French
!insertmacro MUI_LANGUAGE Japanese
!insertmacro MUI_LANGUAGE Russian
!insertmacro MUI_LANGUAGE Korean


# Installer attributes
OutFile E-Gold-1.6.0-win32-setup.exe
InstallDir $PROGRAMFILES\E-Gold
CRCCheck on
XPStyle on
BrandingText " "
ShowInstDetails show
VIProductVersion 1.6.0.0
VIAddVersionKey ProductName E-Gold
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKCU "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File ..\release\E-Gold-qt.exe
	File ..\release\E-Gold.ico
    File /oname=license.txt ..\COPYING
    File /oname=readme.txt ..\doc\README
    SetOutPath $INSTDIR\daemon
    File ..\src\E-Goldd.exe

    SetOutPath $INSTDIR
    WriteRegStr HKCU "${REGKEY}\Components" Main 1

    # Remove old wxwidgets-based-E-Gold executable and locales:
    Delete /REBOOTOK $INSTDIR\E-Gold.exe
    RMDir /r /REBOOTOK $INSTDIR\locale
SectionEnd

Section -post SEC0001
    WriteRegStr HKCU "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\E-Gold.lnk" $INSTDIR\E-Gold-qt.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall E-Gold.lnk" $INSTDIR\uninstall.exe
	CreateShortcut "$DESKTOP\E-Gold.lnk" $INSTDIR\E-Gold-qt.exe" "" "$INSTDIR\E-Gold.ico"
	
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1

    # E-Gold: URI handling disabled for 0.6.0
        WriteRegStr HKCR "E-Gold" "URL Protocol" ""
        WriteRegStr HKCR "E-Gold" "" "URL:E-Gold"
        WriteRegStr HKCR "E-Gold\DefaultIcon" "" $INSTDIR\E-Gold-qt.exe
        WriteRegStr HKCR "E-Gold\shell\open\command" "" '"$INSTDIR\E-Gold-qt.exe" "$$1"'
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKCU "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    Delete /REBOOTOK $INSTDIR\E-Gold-qt.exe
    Delete /REBOOTOK $INSTDIR\license.txt
    Delete /REBOOTOK $INSTDIR\readme.txt
    Delete /REBOOTOK $INSTDIR\E-Gold.ico
    RMDir /r /REBOOTOK $INSTDIR\daemon

    DeleteRegValue HKCU "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall E-Gold.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\E-Gold.lnk"
    Delete /REBOOTOK "$SMSTARTUP\E-Gold.lnk"
    Delete /REBOOTOK "$DESKTOP\E-Gold.lnk"
	Delete /REBOOTOK $INSTDIR\uninstall.exe
    Delete /REBOOTOK $INSTDIR\debug.log
    Delete /REBOOTOK $INSTDIR\db.log
    DeleteRegValue HKCU "${REGKEY}" StartMenuGroup
    DeleteRegValue HKCU "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKCU "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKCU "${REGKEY}"
    DeleteRegKey HKCR "E-Gold"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKCU "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

