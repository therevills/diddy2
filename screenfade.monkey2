Namespace diddy2.screenfade

Class ScreenFade
	Field fadeTime:Float
	Field fadeOut:Bool
	Field ratio:Float = 0
	Field active:Bool
	Field counter:Float
	Field fadeMusic:Bool
	Field fadeSound:Bool
	Field allowScreenUpdate:Bool = True
	
	Method Start:Void(fadeTime:Float, fadeOut:Bool, fadeSound:Bool = False, fadeMusic:Bool = False, allowScreenUpdate:Bool = True)
		If active Then Return
'		diddyGame.ResetDelta()
		active = True
		Self.fadeTime = fadeTime 'diddyGame.CalcAnimLength(fadeTime)
		Self.fadeOut = fadeOut
		Self.fadeMusic = fadeMusic
		Self.fadeSound = fadeSound
		Self.allowScreenUpdate = allowScreenUpdate
		
		If fadeOut
			ratio = 1
		Else
			ratio = 0
			' set the music volume to zero if fading in the music
			If Self.fadeMusic
				'diddyGame.SetMojoMusicVolume(0)
			End			
		End
		counter = 0
	End

	Method Update:Void(delta:Float)
		If Not active Return
		counter += 1 * delta
		CalcRatio()
		If fadeSound
'			For Local i:Int = 0 To SoundPlayer.MAX_CHANNELS
				'SetChannelVolume(i, (ratio) * (diddyGame.soundVolume / 100.0))
'			Next
		End
		If fadeMusic
			'diddyGame.SetMojoMusicVolume((ratio) * (diddyGame.musicVolume / 100.0))
		End
		If counter > fadeTime
'			diddyGame.ResetDelta()
			active = False
			If fadeOut			
				'diddyGame.currentScreen.PostFadeOut()
			Else
				'diddyGame.currentScreen.PostFadeIn()
			End
		End
	End
		
	Method CalcRatio:Void()
		ratio = counter/fadeTime
		If ratio < 0
			ratio = 0
			If fadeMusic
				'diddyGame.SetMojoMusicVolume(0)
			End
		End
		If ratio > 1
			ratio = 1
			If fadeMusic
				'diddyGame.SetMojoMusicVolume(diddyGame.musicVolume / 100.0)
			End
		End
		If fadeOut
			ratio = 1 - ratio
		End
	End
	
	Method Render:Void(canvas:Canvas)
		If Not active Return
		'SetAlpha 1 - ratio
		'SetColor 0, 0, 0
		'DrawRect 0, 0, DEVICE_WIDTH, DEVICE_HEIGHT
		'SetAlpha 1
		'SetColor 255, 255, 255
	End
	
End