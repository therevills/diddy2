Namespace diddy2.app

Class DiddyApp
Private
	Global _Instance:DiddyApp = null
	Field _window:DiddyWindow
	Field _assetBank:AssetBank
	Field _channelManager:ChannelManager
	Field _soundVolume:Float = 1
	Field _musicVolume:Float = 1
	Field _filterTextures:Bool
	Field _appInstance:AppInstance
Public
	
	Method New(title:String, width:Int, height:Int, virtualResolutionWidth:Int, virtualResolutionHeight:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable, layout:String = "letterbox", fps:Int = 60, swapInterval:Int = 1)
		_appInstance = New AppInstance
		_Instance = Self
		_window = New DiddyWindow(title, width, height, virtualResolutionWidth, virtualResolutionHeight, filterTextures, flags, layout, fps, swapInterval)
		_assetBank = New AssetBank(filterTextures)
		_filterTextures = filterTextures
		_channelManager = New ChannelManager
		_window.CreateScreenBank(_Instance)
	End

	Function GetInstance:DiddyApp()
		Return _Instance
	End

	Property SoundVolume:Float()
		Return _soundVolume
	Setter(amount:Float)
		amount = Clamp(amount, 0.0, 1.0)
		_soundVolume = amount
		For Local i:Int = 0 Until ChannelManager.MAX_CHANNELS
			ChannelManager.SetChannelVolume(_soundVolume, i)
		Next
	End

	Property MusicVolume:Float()
		Return _musicVolume
	Setter(amount:Float)
		amount = Clamp(amount, 0.0, 1.0)
		_musicVolume = amount
		ChannelManager.SetMusicVolume(_musicVolume)
	End
	
	Property AppInstance:AppInstance()
		Return _appInstance
	End
	
	Property FilterTextures:Bool()
		Return _filterTextures
	End
	
	Property AssetBank:AssetBank()
		Return _assetBank
	End
	
	Function GetAssetBank:AssetBank()
		Return GetInstance()._assetBank
	End
	
	Property ChannelManager:ChannelManager()
		Return _channelManager
	End
	
	Property Window:DiddyWindow()
		Return _window
	End
	
	Function GetWindow:DiddyWindow()
		Return GetInstance()._window
	End
	
	Function GetScreenBank:ScreenBank()
		Return GetInstance()._window.ScreenBank
	End
	
	Function GetScreenFunc:Screen(screen:String)
		Return GetInstance()._window.ScreenBank.GetScreen(screen)
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