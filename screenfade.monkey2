Namespace diddy2.screenfade

Class ScreenFade
	Const FADE_IN:Int = 0
	Const FADE_OUT:Int = 1
	
	Field active:Bool
	Field ratio:Float = 0
	Field fadeType:Int
	Field fadeTime:Float = 1
	Field counter:Float
	
	Field width:Int
	Field height:Int
	
	Method New(width:Int, height:Int)
		Self.width = width
		Self.height = height
	End
	
	Method Start(fadeType:Int = FADE_IN, fadeTime:Float = 1)
		If active Then Return
		SetFadeTime(fadeTime)
		active = True
		
		Self.fadeType = fadeType
		
		If fadeType = FADE_OUT
			ratio = 1
		Else
			ratio = 0	
		End
		counter = 0
	End
	
	Method SetFadeTime(ms:Float)
		Self.fadeTime = ms
	End
	
	Method Update(delta:Float)
		If Not active Return
		
		counter += 1 * delta
		CalcRatio()

		If counter > fadeTime
			active = False
			If fadeType = FADE_OUT		
				DiddyWindow.GetWindow().currentScreen.PostFadeOut()
			Else
				DiddyWindow.GetWindow().currentScreen.PostFadeIn()
			End
		End
	End
		
	Method CalcRatio()
		ratio = counter / fadeTime
		If ratio < 0
			ratio = 0
		End
		If ratio > 1
			ratio = 1
		End
		If fadeType = FADE_OUT
			ratio = 1 - ratio
		End
	End
	
	Method Render(canvas:Canvas)
		If Not active Return
		canvas.Color = New Color(0, 0, 0)
		canvas.Alpha = 1 - ratio
		canvas.DrawRect(0, 0, width, height)
		canvas.Alpha = 1
		canvas.Color = New Color(1, 1, 1)
	End
	
End