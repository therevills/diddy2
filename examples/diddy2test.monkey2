' set the namespace
Namespace diddy2test

' import all the assets so Monkey2 can access them
#Import "assets/"

' import diddy2
#Import "../diddy2"

' import the mojo module
#Import "<mojo>"

' import the standard module
#Import "<std>"

' use Using to reduce typing
Using diddy2..
Using mojo..
Using std..

' the Main function
Function Main()
	' Create a Diddy2 App with a 800 x 600 window with filtering turned off for images
	New MyDiddyApp("Diddy 2!", 800, 600, False)
End

Class MyDiddyApp Extends DiddyApp
	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True)
		Super.New(title, width, height, filterTextures)
		'SetDebug(True)
		LoadAssets()
		CreateScreens()
		Start(GetScreen("TitleScreen"))
	End
	
	' load the images and sounds into the AssetBank
	Method LoadAssets()
		AssetBank.LoadImage("monkey2logoSmall-1.png")
		AssetBank.LoadImage("diddy128.png")	
		AssetBank.LoadAtlas("gripe.xml", AssetBank.SPARROW_ATLAS)
		
		AssetBank.LoadSound("shoot.ogg")
		AssetBank.LoadSound("GraveyardShift.ogg")
	End
	
	' load the images and sounds into the ScreenBank
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
	
	Field mx2Sprite:Sprite
	
	Field fade:Bool = True
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Load() Override
		' get the assets from the bank
		mx2Image = AssetBank.GetImage("monkey2logoSmall-1.png")
		diddy2Image = AssetBank.GetImage("diddy128.png")
		shootSound = AssetBank.GetSound("shoot.ogg")
		music = AssetBank.GetSound("GraveyardShift.ogg")
	End
	
	
	Method Start() Override
		ChannelManager.PlayMusic(music)
		' create a sprite in the middle of the screen
		mx2Sprite = New Sprite(mx2Image, New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 2))
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawImage(mx2Image, Window.VirtualResolution.X / 4 + Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 4)
		canvas.DrawImage(diddy2Image, Window.VirtualResolution.X / 4, Window.VirtualResolution.Y / 4)
		mx2Sprite.Render(canvas)
		
		canvas.DrawText("Press Space to move to the GameScreen", Window.VirtualResolution.X / 2, 10, .5)
	End
	
	Method PostRender(canvas:Canvas, tween:Float) Override
		'ChannelManager.OutputDebug(canvas, 10, 300)
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
		mx2Sprite.Rotation += 1 * delta
		Local fadeSpeed:Float = 0.2
		If fade
			mx2Sprite.Alpha -= fadeSpeed * delta
			mx2Sprite.Scale -= fadeSpeed * delta
			If mx2Sprite.Alpha <= 0
				fade = Not fade
			End
		Else
			mx2Sprite.Alpha += fadeSpeed * delta
			mx2Sprite.Scale += fadeSpeed * delta
			If mx2Sprite.Alpha >= 1
				fade = Not fade
			End
		End
		
		mx2Sprite.Colour = New Color(Rnd(0,1), Rnd(0,1), Rnd(0,1))
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
	Field player:Player
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Load() Override
		player  = New Player(AssetBank.GetImage("gripe.stand_right"), New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 2))
		player.Scale = New Vec2f(2, 2)
	End
	
	Method Start() Override
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		player.Render(canvas)
	End
	
	Method PostRender(canvas:Canvas, tween:Float) Override
		player.RenderDebug(canvas)
	End
	
	Method Update(delta:Float) Override
		player.Update()
		
		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen("TitleScreen"))
		End
	End
End

Class Player Extends Sprite
	
	Method New(img:Image, position:Vec2f)	
		Super.New(img, position)
		
		' create animation called "run_right" with 8 frames
		CreateAnimation("run_right", 8)		
		
		' Add images from the AssetBank to the "run_right" animation
		For Local i:Int = 1 To 8
			AddFrame("run_right", "gripe.run_right" + i, i - 1)
		Next
		
		' create animation called "gripe.die" with 4 frames
		CreateAnimation("gripe.die", 4)
		
		' Add images from the AssetBank to the "gripe.die" animation
		For Local i:Int = 1 To 4
			AddFrame("gripe.die", "gripe.die" + i, i - 1)
		Next
		
		' Set the current animation to be "run_right" running at 50ms per frame and looping	
		SetCurrentAnimation("run_right", 50, True)
	End
	
	Method Update()
		If Keyboard.KeyDown(Key.Q)
			' Set the current animation to be "gripe.die" running at 125ms per frame and looping	
			SetCurrentAnimation("gripe.die", 125, True)
		End
		If Keyboard.KeyDown(Key.W)
			' Set the current animation to be "run_righte" running at 100ms per frame, not looping and pingpong once
			SetCurrentAnimation("run_right", 100, False, True)
		End
		
		' Update the animation
		UpdateAnimation()	
	End
End