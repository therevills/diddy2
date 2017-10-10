Namespace diddy2.screen

Class Screen Abstract
Private
	Field _name:String
	Field _destinationScreen:Screen
	Field _screenBank:ScreenBank
	Field _allowUpdatesInFade:Bool = False
	
Public

	Property ScreenBank:ScreenBank()
		Return _screenBank
	Setter(screenBank:ScreenBank)
		_screenBank = screenBank
	End
	
	Property DiddyApp:DiddyApp()
		Return _screenBank.DiddyApp
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
	
	Method PreStart()
		DiddyApp.SetCurrentScreen(Self)
		Load()
		DiddyApp.Window.ScreenFade.Start()
		Start()
	End
	
	Method PostFadeIn()
	End
	
	Method Load()
	End
	
	Method Start() Abstract
	
	Method Render(canvas:Canvas, tween:Float) Abstract
	
	Method Update(delta:Float) Abstract
	
	Method PostFadeOut()
		Kill()
		_screenBank.DiddyApp.Window.NextScreen.PreStart()
	End
	
	Method Kill()
	End
	
	Method SetDestinationScreen(screen:Screen)
		_destinationScreen = screen
	End
	
	Method MoveToScreen(screen:Screen, fadeTime:Float = 1)
		If DiddyApp.Window.ScreenFade.Active Then Return
		DiddyApp.Window.NextScreen = screen
		If fadeTime = 0 
			DiddyApp.GetCurrentScreen().PostFadeOut()
		Else
			DiddyApp.Window.ScreenFade.Start(ScreenFade.FADE_OUT, fadeTime)
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
	
	Method Update(delta:Float) Override
		MoveToScreen(_destinationScreen, 1)
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
	
	Method Update(delta:Float) Override
		App.Terminate()
	End
End