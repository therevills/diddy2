Namespace diddy2.screen

Class Screen Abstract
	Field name:String = ""
	Field destinationScreen:Screen
	
	Method New(name:String = "")
		Self.name = name
	End
	
	Method PreStart()
		DiddyWindow.GetWindow().currentScreen = Self
		Load()
		DiddyWindow.GetWindow().screenFade.Start()
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
		DiddyWindow.GetWindow().nextScreen.PreStart()
	End
	
	Method Kill()
	End
	
	Method SetDestinationScreen(screen:Screen)
		destinationScreen = screen
	End
	
	Method MoveToScreen(screen:Screen, fadeTime:Float = 1)
		If DiddyWindow.GetWindow().screenFade.active Then Return
		DiddyWindow.GetWindow().nextScreen = screen
		If fadeTime = 0 
			DiddyWindow.GetWindow().currentScreen.PostFadeOut()
		Else
			DiddyWindow.GetWindow().screenFade.Start(ScreenFade.FADE_OUT, fadeTime)
		End
	End
End

Class EmptyScreen Extends Screen
	Method New(name:String)
		Super.New(name)
	End
	
	Method Start() Override
	End
	
	Method Update(delta:Float) Override
		MoveToScreen(destinationScreen, 0)
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.Clear
	End
End

Class ExitScreen Extends Screen
	Method New(name:String)
		Super.New(name)
	End
	
	Method Start() Override
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
	End
	
	Method Update(delta:Float) Override
	End
End