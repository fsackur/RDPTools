/*
Sample script for RDPConnect that demos connecting to a remote machine and issuing a command via it's Run menu.
*/
;OutputDebug DBGVIEWCLEAR
#singleinstance force
#include RDPConnect.ahk

address  = %1%
username = %2%
password = %3%

mc := new MyClass()
mc.Connect(address, username, password)
;return


class MyClass {
	__New(){
		; Assign a hotkey to launch the RDP session
		fn := this.Connect.Bind(this)
		hotkey, F1, % fn
	}
	
	Connect(address, username="", password=""){
		; Start the connection attempt with the specified credentials.
		; Also uses the WaitForDesktopColor option to wait for pixel 0, 0 of the session window to be pure white...
		; ... this attempts to detect "Ready" state of the remoote machine (As long as the desktop is white!)
		this.rdp := new RDPConnect(address, username, password, this.SessionEvent.Bind(this)) ;, {WaitForDesktopColor: "0xFFFFFF"})
	}
	
	; SessionEvent will be called when something changes about the session connection
	; e : The event that happened.
	; 	0 is "success", other values are errors (eg bad address, bad credentials)
	;	use GetErrorName to get a human-friendly reason for the failure
	; pid : The Process ID of the RDP session. All RDP windows for one connection will share the same PID
	; hwnd: The Window Handle of the session window.
	;	On connect, hwnd will be the HWND of the session window
	;	On disconnect (User logged off), hwnd will be unset (e will still be 0, as this is a "success")
	SessionEvent(e, pid, hwnd){
		if (e != 0){
			errorname := this.rdp.GetErrorName(e)
			msgbox % "Error : " errorname
			return
		}
		if (hwnd){
			Sleep 2000								; give time to finish logon
			this.rdp.SetMaximizedState(1)			; Maximize the RDP window, so keystrokes get sent
			Sleep 250
			this.rdp.SendKeys("{LWin down}r{LWin up}")				; Open start menu
			Sleep 250
			this.rdp.SendKeys("powershell -NoProfile -Command ""logoff""{enter}")		; Run PS
			return
		} else {
			Tooltip % "Session ended."
			Sleep 2000
			ToolTip
		}
		
		Sleep 500
		this.rdp.CloseSession()
		this.rdp.Close()
		Process, Close, Autohotkey.exe
		Process, Close, Scriptrunner.exe
	}
}
