Namespace diddy2test

#Import "assets/"

#Import "../diddy2"
#Import "<mojo>"
#Import "<std>"

Using diddy2..
Using mojo..
Using std..

Function Main()
	New MyDiddyApp("Diddy 2!", 800, 600, False)
End

Class MyDiddyApp Extends DiddyApp
	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True)
		Super.New(title, width, height, filterTextures)
		SetDebug(True)
		LoadAssets()
		CreateScreens()
		Start(GetScreen("TitleScreen"))
	End
	
	Method LoadAssets()
		AssetBank.LoadImage("monkey2logoSmall-1.png")
		AssetBank.LoadImage("diddy128.png")	
		
		AssetBank.LoadSound("shoot.ogg")
		AssetBank.LoadSound("GraveyardShift.ogg")
	End
	
	Method CreateScreens()
		AddScreen(New TitleScreen("TitleScreen"))
		AddScreen(New GameScreen("GameScreen"))
	End
End

Class TitleScreen Extends Screen
	Field mx2Image:Image
	Field diddy2Image:Image
	Field shootSound:Sound
	Field music:Sound
	
	Field player:Sprite
	
	Field fade:Bool = True
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Load() Override
		mx2Image = AssetBank.GetImage("monkey2logoSmall-1.png")
		diddy2Image = AssetBank.GetImage("diddy128.png")
		shootSound = AssetBank.GetSound("shoot.ogg")
		music = AssetBank.GetSound("GraveyardShift.ogg")
	End
	
	
	Method Start() Override
		ChannelManager.PlayMusic(music)
		
		player = New Sprite(mx2Image, New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 2))
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawImage(mx2Image, Window.VirtualResolution.X / 4 + Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 4)
		canvas.DrawImage(diddy2Image, Window.VirtualResolution.X / 4, Window.VirtualResolution.Y / 4)
		player.Render(canvas)
		
		canvas.DrawText("Press Space to move to the GameScreen", Window.VirtualResolution.X / 2, 10, .5)
	End
	
	Method PostRender(canvas:Canvas, tween:Float) Override
		ChannelManager.OutputDebug(canvas, 10, 300)
	End
	
	Method Update(delta:Float) Override
		SpriteTest(delta)

		SoundTest()

		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen("Exit"))
		End
		
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen("GameScreen"))
			shootSound.Play()
		End
	End
	
	Method SpriteTest(delta:Float)
		player.Rotation += 1 * delta
		Local fadeSpeed:Float = 0.2
		If fade
			player.Alpha -= fadeSpeed * delta
			player.Scale -= fadeSpeed * delta
			If player.Alpha <= 0
				fade = Not fade
			End
		Else
			player.Alpha += fadeSpeed * delta
			player.Scale += fadeSpeed * delta
			If player.Alpha >= 1
				fade = Not fade
			End
		End
		
		player.Colour = New Color(Rnd(0,1), Rnd(0,1), Rnd(0,1))
	End
	
	
	Method SoundTest()
		If Keyboard.KeyHit(Key.PageDown)
			DiddyApp.MusicVolume -= .05
		End
		If Keyboard.KeyHit(Key.PageUp)
			DiddyApp.MusicVolume += .05
		End
		If Keyboard.KeyHit(Key.KeyEnd)
			DiddyApp.SoundVolume -= .05
		End
		If Keyboard.KeyHit(Key.Home)
			DiddyApp.SoundVolume += .05
		End
				
		' Test Pan and Rate
		If Keyboard.KeyHit(Key.Q)
			ChannelManager.PlaySound(shootSound, -1, 2)
		End
		If Keyboard.KeyHit(Key.W)
			ChannelManager.PlaySound(shootSound, 0, 1)
		End
		If Keyboard.KeyHit(Key.E)
			ChannelManager.PlaySound(shootSound, 1, 0.5)
		End
		
		' Test Volume
		If Keyboard.KeyHit(Key.A)
			ChannelManager.PlaySound(shootSound, 0, 1, 0.33)
		End
		If Keyboard.KeyHit(Key.S)
			ChannelManager.PlaySound(shootSound, 0, 1, 0.66)
		End
		If Keyboard.KeyHit(Key.D)
			ChannelManager.PlaySound(shootSound, 0, 1, 1)
		End
		
		' Test Channel set
		If Keyboard.KeyHit(Key.Z)
			ChannelManager.PlaySound(shootSound, 0, 1, 1, False, 31)
		End

		' Test Loop
		If Keyboard.KeyHit(Key.X)
			ChannelManager.PlaySound(shootSound, 0, 1, 1, True)
		End

	End
End

Class GameScreen Extends Screen
	Method New(title:String)
		Super.New(title)
	End
	
	Method Start() Override
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
	End
	
	Method PostRender(canvas:Canvas, tween:Float) Override
		ChannelManager.OutputDebug(canvas, 10, 300)
	End
	
	Method Update(delta:Float) Override
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen("TitleScreen"))
		End
	End
End
