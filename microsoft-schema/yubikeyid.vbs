'VBScript to add a semi-colon list of yubiKeyIds to a user via
'  the right click menu (adminContextMenu) in ADUC.
'
'Please save this file in C:\yubikeyid.vbs
'and make sure you have updated the Schema Configuration with updateAdminContextMenu.ldif
'
'Author: David Latham <david-latham.blogspot.com>
'
'Credits:
'    Stack Overflow User: http://stackoverflow.com/users/107929/sh-beta
'    <http://stackoverflow.com/questions/1029288/vbs-script-for-modifying-multi-value-active-directory-display-specifier>
'
Dim objYubikey
Dim objUser
Dim temp1, title, message, default
Dim yubikeys
title = "YubiKeys"

Set objYubiKey = Wscript.Arguments
Set objUser = GetObject(objYubiKey(0))

'Find our current yubikeys
yubikeys = objUser.yubiKeyId
If Not isArray(yubikeys) Then
    yubikeys = Array(yubikeys)
End If

'Setup our message box
default = arrayToStr(yubikeys)
message = "Semicolon-delimited list of YubiKeyIds" & vbCRLF & vbCRLF & default
temp1 = InputBox(message, title, default)

'catch cancels
if IsEmpty(temp1) Then
    WScript.Quit
End If

' update our data
yubikeys = strToArray(temp1)
objUser.Put "yubiKeyId",yubikeys
objUser.SetInfo

'Clean up and quit
Set yubikeys = Nothing
Set objUser = Nothing
Set objProject = Nothing
Set temp1 = Nothing
Set title = Nothing
Set message = Nothing
Set default = Nothing
WScript.Quit

'Functions
Function strToArray(s)
    Dim a
    Dim token

    ' discard blank entries
    For Each token in split(s, ";")
    	token = trim(token)
    	If token <> "" Then
    		If isEmpty(a) Then
    			a = token
    		Else
    			a = a & ";" & token
    		End If
    	End If
    Next

    ' return array
    strToArray = split(a, ";")
End Function
Function arrayToStr(a)
    Dim s
    Dim token

    For Each token in a
    	If isEmpty(s) Then
    		s = token
    	Else
    		s = s & ";" & token
    	End If
    Next

    ' return string
    arrayToStr = s
End Function
