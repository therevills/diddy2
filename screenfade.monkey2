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
	Field _fadeMusic:Bool
	Field _fadeSound:Bool
	Field _startTime:Int
	Field _debug:Bool = False
	
	
Public
	Const FADE_IN:Int = 0
	Const FADE_OUT:Int = 1
	Const EFFECT_FADE:Int = 0
	Const EFFECT_PIXEL_FILL:Int = 1
	Global Effect:Int = EFFECT_FADE
	Global DefaultFadeTimeMs:Float = 500
	Field pixelCount:Int
	Field pixels:Int[,]
	
	Property Active:Bool()
		Return _active
	End		
	
	Method New(width:Int, height:Int)
		Self._width = width
		Self._height = height
		Self.pixels = New Int[Self._width, Self._height]
	End
	
	Method Start(fadeType:Int = FADE_IN, fadeTimeMs:Float = DefaultFadeTimeMs, fadeSound:Bool = True, fadeMusic:Bool = True)
		If _active Then Return
		_active = True
		SetFadeTime(fadeTimeMs)
		_fadeType = fadeType
		_fadeMusic = fadeMusic
		_fadeSound = fadeSound
		
		If _fadeType = FADE_OUT
			For Local y:Int = 0 Until _height
				For Local x:Int = 0 Until _width
					pixels[x, y] = 0 
				Next
			Next
			_ratio = 1
			If Not DiddyApp.GetInstance().Window.NextScreen
				Print "NextScreen is NULL, set NextScreen before calling Start with FADE_OUT"
				App.Terminate()
			End
		Else
			For Local y:Int = 0 Until _height
				For Local x:Int = 0 Until _width
					pixels[x, y] = 1 
				Next
			Next
				
			_ratio = 0	
		End	
		pixelCount = 0
		_counter = 0
		_startTime = Millisecs()
	End
	
	Method SetFadeTime(ms:Float)
		Local gt:Float = DiddyApp.GetInstance().Window.GameTime.CalcFrameTime(ms)
		_fadeTime = gt
	End
	
	Method Update(fixedRate:Float)
		If Not _active Return

		_counter += 1 + fixedRate
		CalcRatio()
		If Effect = EFFECT_PIXEL_FILL
			Local completeRatioAmount:Bool = False

			Local screenPixelCount:Float = _width * _height - 0.1
			While Not completeRatioAmount

				For Local i:Int = 0 To 1200
					Local x:Int = Rnd(0, _width)
					Local y:Int = Rnd(0, _height)
					If _fadeType = FADE_OUT
						If pixels[x, y] = 0
							pixels[x, y] = 1
							pixelCount +=1
						End
					Else
						If pixels[x, y] = 1
							pixels[x, y] = 0
							pixelCount +=1
						End
					End
				End
				If pixelCount > screenPixelCount Then pixelCount = screenPixelCount

				Local r:Float = pixelCount / screenPixelCount
				r = Clamp(r, 0.0, 1.0)
				If _fadeType = FADE_OUT
					r = 1 - r
					If r <= _ratio Or FloatEqual(r, _ratio, 0.01) Then completeRatioAmount = True
				Else
					If r >= _ratio Or FloatEqual(r, _ratio, 0.01) Then completeRatioAmount = True
				End

			End
		End
		
		If _fadeSound
			For Local i:Int = 0 Until ChannelManager.MAX_CHANNELS
				DiddyApp.GetInstance().ChannelManager.SetChannelVolume(_ratio * DiddyApp.GetInstance().SoundVolume, i)
			Next
		End
		If _fadeMusic
			DiddyApp.GetInstance().ChannelManager.SetMusicVolume(_ratio * DiddyApp.GetInstance().MusicVolume)
		End
		
		If _counter > _fadeTime
			_active = False
			If _debug
				Local totalTime := Millisecs() - _startTime
				Print "Screen Fade TotalTime = " + totalTime
			End
			If _fadeType = FADE_OUT		
				DiddyApp.GetInstance().GetCurrentScreen().PostFadeOut()
			Else
				DiddyApp.GetInstance().GetCurrentScreen().PostFadeIn()
			End
		End
	End
		
	Method CalcRatio()
		_ratio = _counter / _fadeTime
		_ratio = Clamp(_ratio, 0.0, 1.0)

		If _fadeType = FADE_OUT
			_ratio = 1 - _ratio
		End
	End
	
	Method Render(canvas:Canvas)
		If Not _active Return
		Select Effect
			Case EFFECT_FADE
				canvas.Color = _fadeColor
				canvas.Alpha = 1 - _ratio
				canvas.DrawRect(0, 0, _width, _height)
				canvas.Alpha = 1
				canvas.Color = _currentColor
			Case EFFECT_PIXEL_FILL
				canvas.Color = _fadeColor
				canvas.Alpha = 1
				
				For Local y:Int = 0 Until _height
					For Local x:Int = 0 Until _width
						If pixels[x, y] = 1 Then
							canvas.DrawRect(x, y, 2, 2)
						End
					Next
				Next
				
				canvas.Color = _currentColor
		End
	End
	
End