Namespace diddy2.screen

Class Screen Abstract
Private
	Field _name:String
	Field _destinationScreen:Screen
	Field _screenBank:ScreenBank
	Field _allowUpdatesInFade:Bool = False
	
Public
	Const EMPTY_SCREEN:String = "EmptyScreen"
	Const EXIT_SCREEN:String = "ExitScreen"
	Const GAME_SCREEN:String = "GameScreen"
	Const TITLE_SCREEN:String = "TitleScreen"
	Const OPTIONS_SCREEN:String = "OptionsScreen"
	Const GAME_OVER_SCREEN:String = "GameOverScreen"
	Const LEVEL_SELECT_SCREEN:String = "LevelSelectScreen"

	Property ScreenBank:ScreenBank()
		Return _screenBank
	Setter(screenBank:ScreenBank)
		_screenBank = screenBank
	End
	
	Property DiddyApp:DiddyApp()
		Return _screenBank.DiddyApp
	End
	
	Property Window:DiddyWindow()
		Return _screenBank.DiddyApp.Window
	End
	
	Property VirtualResolution:Vec2i()
		Return _screenBank.DiddyApp.Window.VirtualResolution
	End
	
	Property AssetBank:AssetBank()
		Return _screenBank.DiddyApp.AssetBank
	End
	
	Property ChannelManager:ChannelManager()
		Return _screenBank.DiddyApp.ChannelManager
	End
	
	Property Name:String()
		Return _name
	Setter(name:String)
		_name = name
	End
  
	Property AllowUpdatesInFade:Bool()
		Return _allowUpdatesInFade
	Setter(b:Bool)
		_allowUpdatesInFade = b
	End
  
	Method New(name:String = "")
		Self._name = name
	End
	
	Method PreStart(fadeType:Int = ScreenFade.FADE_IN, fadeTimeMs:Float = ScreenFade.DefaultFadeTimeMs)
		DiddyApp.SetCurrentScreen(Self)
		Load()
		Window.ScreenFade.Start(fadeType, fadeTimeMs)
		DiddyApp.AppInstance.ResetPolledInput()
		Start()
	End
	
	Method PostFadeIn() Virtual
	End
	
	Method Load() Virtual
	End
	
	Method Start() Abstract
	
	Method Render(canvas:Canvas, tween:Float) Abstract
	
	Method PostRender(canvas:Canvas, tween:Float) Virtual
	End
	
	Method Update(fixedRate:Float) Abstract
	
	Method PostFadeOut()
		Kill()
		Window.NextScreen.PreStart()
	End
	
	Method Kill() Virtual
	End
	
	Method SetDestinationScreen(screen:Screen)
		_destinationScreen = screen
	End
	
	Method MoveToScreen(screen:Screen, fadeTimeMs:Float = ScreenFade.DefaultFadeTimeMs)
		If Window.ScreenFade.Active Then Return
		Window.NextScreen = screen
		If fadeTimeMs <= 0 
			DiddyApp.GetCurrentScreen().PostFadeOut()
		Else
			Window.ScreenFade.Start(ScreenFade.FADE_OUT, fadeTimeMs)
		End
	End
End

Class EmptyScreen Extends Screen
	Field cleared:Bool = False
	
	Method New(name:String)
		Super.New(name)
	End
	
	Method Start() Override
	End
	
	Method Update(fixedRate:Float) Override
		MoveToScreen(_destinationScreen, 0)
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		If Not cleared
			canvas.Clear(Color.Black)
			cleared = True
		End
	End
End

Class ExitScreen Extends Screen
	Method New(name:String)
		Super.New(name)
	End
	
	Method Start() Override
		AllowUpdatesInFade = True
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
	End
	
	Method Update(fixedRate:Float) Override
		App.Terminate()
	End
End