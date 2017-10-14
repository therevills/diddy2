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
Public
	Const FADE_IN:Int = 0
	Const FADE_OUT:Int = 1
	Global DefaultFadeTimeMs:Float = 500

	Property Active:Bool()
		Return _active
	End		
	
	Method New(width:Int, height:Int)
		Self._width = width
		Self._height = height
	End
	
	Method Start(fadeType:Int = FADE_IN, fadeTimeMs:Float = DefaultFadeTimeMs, fadeSound:Bool = True, fadeMusic:Bool = True)
		If _active Then Return
		_active = True
		SetFadeTime(fadeTimeMs)
		_fadeType = fadeType
		_fadeMusic = fadeMusic
		_fadeSound = fadeSound
		
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
		canvas.Color = _fadeColor
		canvas.Alpha = 1 - _ratio
		canvas.DrawRect(0, 0, _width, _height)
		canvas.Alpha = 1
		canvas.Color = _currentColor
	End
	
End