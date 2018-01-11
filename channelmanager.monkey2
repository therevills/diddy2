Namespace diddy2.channelmanager

Class ChannelManager
	Private
	Global _prefix:String = "asset::"
	Global _musicPath:String = "music/"
	
	Public
	Global MusicChannel:Channel
	Global MusicFileName:String
	Global MusicVolume:Float
	Global MaxVolume:Float = 1
	
	Global LoopMusic:Bool
	Global ForceStop:Bool
	
	Const MAX_CHANNELS:Int = 32
	Const MUSIC_CHANNEL:Int = 32
	Global ChannelIndex:Int
	Global ChannelArray:Channel[] = New Channel[MAX_CHANNELS + 1]
	Global ChannelState:Int[] = New Int[] ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ) ' 32 indexes + 1 for music
	
	Method New()
		For Local i:Int = 0 Until MAX_CHANNELS
			ChannelArray[i] = New Channel
		Next
		ChannelArray[MUSIC_CHANNEL] = New Channel
	End
	
	Function StopChannels:Void()
		For Local i:Int = 0 Until MAX_CHANNELS
			ChannelArray[i].Stop()
			ChannelState[i] = 0
		Next
	End
	
	Function StopChannel:Void(channel:Int)
		ChannelArray[channel].Stop()
		ChannelState[channel] = 0
	End
	
	Function SetChannelVolume(volume:Float, index:Int)
		ChannelArray[index].Volume = volume * MaxVolume
	End
	
	Function SetChannelPan(pan:Float, index:Int)
		ChannelArray[index].Pan = pan
	End

	Function SetChannelRate(rate:Float, index:Int)
		ChannelArray[index].Rate = rate
	End
	
	Function SetMusicVolume(volume:Float)
		If MusicChannel
			MusicChannel.Volume = volume
			MusicVolume = volume
		End
		
	End
	
	Function PlayMusic(s:Sound, pan:Float=0, rate:Float=1, volume:Float=1, loop:Bool = True)
		ChannelArray[MUSIC_CHANNEL].Stop()
		ChannelArray[MUSIC_CHANNEL].Play(s, loop)
		ChannelArray[MUSIC_CHANNEL].Pan = pan
		ChannelArray[MUSIC_CHANNEL].Rate = rate
		ChannelArray[MUSIC_CHANNEL].Volume = volume
		
		If loop Then ChannelState[MUSIC_CHANNEL] = 1
	End
	
	Function PlayMusic(filename:String, loop:Bool, volume:Float)
		ForceStop = False
		
		If MusicChannel
			If MusicChannel.Playing
				ForceStop = True
				MusicChannel.Stop()
			End
		End
		
		MusicChannel = Audio.PlayMusic(_prefix + _musicPath + filename, MusicFinished)
		If MusicChannel
			LoopMusic = loop
			MusicFileName = filename
			SetMusicVolume(volume)
		Else
			Print "MusicChannel is null - check file " + (_prefix + _musicPath + filename)
		End
	End
	
	Function MusicFinished()
		If LoopMusic And Not ForceStop
			PlayMusic(MusicFileName, LoopMusic, MusicVolume)
		End
	End
	
	Function PlaySound:Int(s:Sound, pan:Float=0, rate:Float=1, volume:Float=-1, loop:Bool = False, channel:Int = -1)
		If channel = -1
			Local cnt:Int = 0
			ChannelIndex += 1
			If (ChannelIndex >= MAX_CHANNELS) Then ChannelIndex = 0
			While ChannelState[ChannelIndex] = 1
				ChannelIndex += 1
				If (ChannelIndex >= MAX_CHANNELS) Then ChannelIndex = 0
				cnt += 1
				If cnt > MAX_CHANNELS * 2 Then Exit ' stop infinite loop if case all channels are playing
			End
		Else
			If channel < 0 or channel >= MAX_CHANNELS
				Print "Invalid Channel Index (" + channel + ") must be between 0 and " + (MAX_CHANNELS - 1)
				App.Terminate()
			End
			ChannelIndex = channel
			ChannelState[channel] = 0
		End
		
		pan = Clamp(pan, -1.0, 1.0)
		If volume = -1
			volume = DiddyApp.GetInstance().SoundVolume
		End
		volume = Clamp(volume, 0.0, 1.0)

		ChannelArray[ChannelIndex].Stop()
		ChannelArray[ChannelIndex].Play(s, loop)
		ChannelArray[ChannelIndex].Pan = pan
		ChannelArray[ChannelIndex].Rate = rate
		ChannelArray[ChannelIndex].Volume = volume
		
		If loop Then ChannelState[ChannelIndex] = 1		
		Return ChannelIndex
	End
	
	Method OutputDebug(canvas:Canvas, x:Int, y:Int)
		
		Local ofx:Int = 24
		For Local i:Int = 0 Until MAX_CHANNELS
			Local ys:Int = y
			
			canvas.DrawText("C", x + (i * ofx), ys)
			ys += canvas.Font.Height
			
			canvas.DrawText(i, x + (i * ofx), ys)
			ys += canvas.Font.Height
			
			Local playing:Int = 0
			If ChannelArray[i].Playing Then playing = 1
			canvas.DrawText(playing, x + (i * ofx), ys)
			ys += canvas.Font.Height
			
			canvas.DrawText(ChannelState[i], x + (i * ofx), ys)
			ys += canvas.Font.Height
			Local v:String = ChannelArray[i].Volume
			If v = "1" Then v = "1.0"
			v = v.Left(3)
			canvas.DrawText(v, x + (i * ofx), ys)
		Next
		Local ys:Int = y
		canvas.DrawText("M", x + (MAX_CHANNELS * ofx), ys)
		ys += canvas.Font.Height
		canvas.DrawText(MUSIC_CHANNEL, x + (MAX_CHANNELS * ofx), ys)
		ys += canvas.Font.Height
		Local playing:Int = 0
		If ChannelArray[MUSIC_CHANNEL].Playing Then playing = 1
		canvas.DrawText(playing, x + (MAX_CHANNELS * ofx), ys)
		ys += canvas.Font.Height
		
		canvas.DrawText(ChannelState[MUSIC_CHANNEL], x + (MAX_CHANNELS * ofx), ys)
		ys += canvas.Font.Height
		Local v:String = ChannelArray[MUSIC_CHANNEL].Volume
		If v = "1" Then v = "1.0"
		v = v.Left(3)
		canvas.DrawText(v, x + (MAX_CHANNELS * ofx), ys)
	End
	
End