Namespace diddy2.app

Class DiddyApp
Private
	Global _Instance:DiddyApp = null
	Field _window:DiddyWindow
	Field _assetBank:AssetBank
	
Public
	
	Method New( title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable )
		New AppInstance
		_Instance = Self
		_window = New DiddyWindow(title, width, height, filterTextures, flags)
		_assetBank = New AssetBank
		_window.CreateScreenBank(_Instance)
	End

	Function GetInstance:DiddyApp()
		Return _Instance
	End

	Property AssetBank:AssetBank()
		Return _assetBank
	End
	
	Property Window:DiddyWindow()
		Return _window
	End
	
	Method Start(screen:Screen)
		_window.Start(screen)
		App.Run()
	End
	
	Method AddScreen(screen:Screen)
		_window.ScreenBank.AddScreen(screen)
	End
	
	Method GetScreen:Screen(name:String)
		Return _window.ScreenBank.GetScreen(name)
	End
	
	Method GetCurrentScreen:Screen()
		Return _window.CurrentScreen
	End
	
	Method SetCurrentScreen(screen:Screen)
		_window.CurrentScreen = screen
	End
  
	Method SetDebug(debugOn:Bool)
		_window.DebugOn = debugOn
	End
End