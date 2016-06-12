Namespace diddy2.screenfade

Class ScreenFade
	Field width:Int
	Field height:Int
	Field fadeTime:Float
	Field fadeOut:Bool
	Field ratio:Float = 0
	Field active:Bool
	Field counter:Float
	Field fadeMusic:Bool
	Field fadeSound:Bool
	Field allowScreenUpdate:Bool = True
	
	Method New(width:Int, height:Int)
		Self.width = width
		Self.height = height
	End
	
	Method Start(fadeTime:Float, fadeOut:Bool, fadeSound:Bool = False, fadeMusic:Bool = False, allowScreenUpdate:Bool = True)
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

	Method Update(delta:Float)
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
		Print counter + " " + fadeTime
		If counter > fadeTime
'			diddyGame.ResetDelta()
			active = False
			If fadeOut			
				DiddyWindow.GetWindow().currentScreen.PostFadeOut()
			Else
				DiddyWindow.GetWindow().currentScreen.PostFadeIn()
			End
		End
	End
		
	Method CalcRatio()
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
	
	Method Render(canvas:Canvas)
		If Not active Return
		canvas.Color = New Color(0, 0, 0)
		canvas.Alpha = 1 - ratio
		canvas.DrawRect(0, 0, width, height)
		canvas.Alpha = 1
		canvas.Color = New Color(1, 1, 1)
	End
	
End