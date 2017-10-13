Namespace diddy2.screenfade

Class ScreenFade

Private
	Field _fadeColor:Color = New Color(0, 0, 0)
	Field _currentColor:Color = New Color(1, 1, 1)
	Field _width:Int
	Field _height:Int
	Field _active:Bool
	Field _ratio:Float = 0
	Field _fadeType:Int
	Field _fadeTime:Float = 1
	Field _counter:Float
	
Public
	Const FADE_IN:Int = 0
	Const FADE_OUT:Int = 1
	Global DefaultFadeTimeMs:Float = 300
	Field startMs:Int 
	
	Property Active:Bool()
		Return _active
	End		
	
	Method New(width:Int, height:Int)
		Self._width = width
		Self._height = height
	End
	
	Method Start(fadeType:Int = FADE_IN, fadeTimeMs:Float = DefaultFadeTimeMs)
		If _active Then Return
		_active = True
		SetFadeTime(fadeTimeMs)
		_fadeType = fadeType
		startMs = Millisecs()
		
		If _fadeType = FADE_OUT
			_ratio = 1
			If Not DiddyApp.GetInstance().Window.NextScreen
				Print "NextScreen is NULL, set NextScreen before calling Start with FADE_OUT"
				App.Terminate()
			End
		Else
			_ratio = 0	
		End
		_counter = 0
	End
	
	Method SetFadeTime(ms:Float)
		Local gt:Float = DiddyApp.GetInstance().Window.GameTime.CalcFrameTime(ms)
		_fadeTime = gt
	End
	
	Method Update(delta:Float)
		If Not _active Return

		_counter += 1 + delta
		CalcRatio()
		If _counter > _fadeTime
			Local endMs:Int = Millisecs()
			Print "FT: " + (endMs - startMs)
			_active = False
			If _fadeType = FADE_OUT		
				DiddyApp.GetInstance().GetCurrentScreen().PostFadeOut()
			Else
				DiddyApp.GetInstance().GetCurrentScreen().PostFadeIn()
			End
		End
	End
		
	Method CalcRatio()
		_ratio = _counter / _fadeTime
		If _ratio < 0
			_ratio = 0
		End
		If _ratio > 1
			_ratio = 1
		End
		If _fadeType = FADE_OUT
			_ratio = 1 - _ratio
		End
	End
	
	Method Render(canvas:Canvas)
		If Not _active Return
		canvas.Color = _fadeColor
		canvas.Alpha = 1 - _ratio
		canvas.DrawRect(0, 0, _width, _height)
		canvas.Alpha = 1
		canvas.Color = _currentColor
	End
	
End