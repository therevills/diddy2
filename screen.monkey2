Namespace diddy2.screen

Class Screen Abstract
	Field name:String = ""
	Field autoFadeIn:Bool
	
	Method New(name:String="")
		Self.name = name
	End
	
	Method PostFadeIn()
	End
	
	Method PreStart()
		Print "PreStart " + name
		DiddyWindow.GetWindow().currentScreen = Self
		Load()
		Start()
	End
	
	Method Load()
	End
	
	Method Start() Abstract
	
	Method Render(canvas:Canvas, tween:Float) Abstract
	
	Method Update(delta:Float) Abstract
	
	Method PostFadeOut:Void()
		Kill()
		DiddyWindow.GetWindow().nextScreen.PreStart()
	End
	
	Method Kill()
	End
	
	Method FadeToScreen:Void(screen:Screen)
		' don't try to fade twice
		If DiddyWindow.GetWindow().screenFade.active Then Return
				
		' trigger the fade out
		DiddyWindow.GetWindow().nextScreen = screen
		DiddyWindow.GetWindow().screenFade.Start(1, True, True, True, True)
	End
	
End