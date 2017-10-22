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
	Const GAME_SCREEN:String = "GameScreen"
	Const TITLE_SCREEN:String = "TitleScreen"
	
	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True)
		Super.New(title, width, height, filterTextures)
		SetDebug(True)
		LoadAssets()
		CreateScreens()
		Start(GetScreen(MyDiddyApp.TITLE_SCREEN))
	End
	
	' load the images and sounds into the AssetBank
	Method LoadAssets()
		AssetBank.LoadImage("monkey2logoSmall-1.png")
		AssetBank.LoadImage("diddy128.png")	
		AssetBank.LoadAtlas("gripe.xml", AssetBank.SPARROW_ATLAS)
		AssetBank.LoadImage("background.png", False)
		
		AssetBank.LoadSound("shoot.ogg")
		AssetBank.LoadSound("GraveyardShift.ogg")
	End
	
	' load the images and sounds into the ScreenBank
	Method CreateScreens()
		AddScreen(New TitleScreen(MyDiddyApp.TITLE_SCREEN))
		AddScreen(New GameScreen(MyDiddyApp.GAME_SCREEN))
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
	
	Method Update(fixedRate:Float) Override
		SpriteTest(fixedRate)

		SoundTest()

		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen(Screen.EXIT_SCREEN))
		End
		
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen(MyDiddyApp.GAME_SCREEN))
			shootSound.Play()
		End
	End
	
	Method SpriteTest(fixedRate:Float)
		mx2Sprite.Rotation += 1 * fixedRate
		Local fadeSpeed:Float = 0.2
		If fade
			mx2Sprite.Alpha -= fadeSpeed * fixedRate
			mx2Sprite.scale -= fadeSpeed * fixedRate
			If mx2Sprite.Alpha <= 0
				fade = Not fade
			End
		Else
			mx2Sprite.Alpha += fadeSpeed * fixedRate
			mx2Sprite.scale += fadeSpeed * fixedRate
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
	Field animationSprite:AnimationSprite
	Field player:Player
	Field scrollingPlayer:ScrollingPlayer
	Field background:Image
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Load() Override
		animationSprite  = New AnimationSprite(AssetBank.GetImage("gripe.stand_right"), New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 4))
		animationSprite.scale = New Vec2f(2, 2)
		
		player  = New Player(AssetBank.GetImage("gripe.stand_right"), New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 2))
		player.scale = New Vec2f(2, 2)
		player.WrapImage = True
		
		scrollingPlayer = New ScrollingPlayer(AssetBank.GetImage("gripe.stand_right"), New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 4 + Window.VirtualResolution.Y / 2 ))
		scrollingPlayer.scale = New Vec2f(2, 2)
		
		background = AssetBank.GetImage("background.png")
		Window.MaxScrollX = background.Width * .5
	End
	
	Method Start() Override
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		TileImage(canvas, background, Window.ScrollX, Window.ScrollY, Window.VirtualResolution.x, Window.VirtualResolution.Y)
		'canvas.DrawImage(background, -Window.ScrollX, Window.ScrollY)
		animationSprite.Render(canvas)
		player.Render(canvas)
		scrollingPlayer.Render(canvas, Window.ScrollX, Window.ScrollY)
	End
	
	Method PostRender(canvas:Canvas, tween:Float) Override
		Local state:String = ""
		Select scrollingPlayer.State
			Case player.STANDING
				state = "STANDING"
			Case player.WALKING
				state = "WALKING"
			Case player.TURNING
				state = "TURNING"
			Case player.DIE
				state = "DIEING"
		End
		If scrollingPlayer.Jumping Then state = "JUMPING"
		canvas.DrawText("State: " + state, 10, 110)
		Local dir:String = ""
		Select scrollingPlayer._direction
			Case player.RIGHT
				dir = "RIGHT"
			Case player.LEFT
				dir = "LEFT"				
		End
		canvas.DrawText("Direction: " + dir, 10, 125)
		canvas.DrawText("Position: " + scrollingPlayer.position, 10, 140)
		
		player.RenderDebug(canvas)
	End
	
	Method Update(fixedRate:Float) Override
		animationSprite.Update(fixedRate)
		player.Update(fixedRate, True)
		scrollingPlayer.Update(fixedRate, False)
		
		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen(MyDiddyApp.TITLE_SCREEN))
		End
	End
End

Class AnimationSprite Extends Sprite
	
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
	
	Method Update(fixedRate:Float)
		If Keyboard.KeyDown(Key.Q)
			' Set the current animation to be "gripe.die" running at 125ms per frame and looping	
			SetCurrentAnimation("gripe.die", 125, True)
		End
		If Keyboard.KeyDown(Key.W)
			' Set the current animation to be "run_right" running at 100ms per frame, not looping and pingpong once
			SetCurrentAnimation("run_right", 100, False, True)
		End
		
		' Update the animation
		UpdateAnimation()	
	End
End

Class ScrollingPlayer Extends Player
	Method New(img:Image, position:Vec2f)	
		Super.New(img, position)
	End
	
	Method Update(fixedRate:Float, wrapImage:Bool) Override
		Super.Update(fixedRate, wrapImage)
		
		Local border:Int = 200
		If position.x - Window.ScrollX < border
			Window.ScrollHorizontal((position.x - Window.ScrollX) - border)
		End
		If position.x - Window.ScrollX > Window.VirtualResolution.X - border
			Window.ScrollHorizontal((position.x - Window.ScrollX) - (Window.VirtualResolution.X - border))
		End
		If position.x - Window.ScrollX > Window.VirtualResolution.X - Image.Width
			position.x = Window.VirtualResolution.X + Window.ScrollX - Image.Width
		End
		If position.x < Image.Width
			position.x = Image.Width
		End
	End
End

Class Player Extends Sprite
	Field _state:Int = STANDING
	Field _jumping:Bool
	Field _direction:Int = RIGHT
	
	Const RIGHT:Int = 0
	Const LEFT:Int = 1
	
	Const STANDING:Int = 0
	Const WALKING:Int = 1
	Const DIE:Int = 2
	Const TURNING:Int = 3

	Const GRAVITY:Float = 650
	
	Method New(img:Image, position:Vec2f)	
		Super.New(img, position)
		
		speed = New Vec2f(160, 410)
		deltaValue = New Vec2f(0, 0)
		
		' standing still
		CreateAnimation("gripe.stand_right", 1)
		AddFrame("gripe.stand_right", "gripe.stand_right", 0)

		' jumping
		CreateAnimation("gripe.jump_right", 1)
		AddFrame("gripe.jump_right", "gripe.jump_right", 0)

		' turning
		CreateAnimation("gripe.turn_right_to_left", 4)		
		For Local i:Int = 1 To 4
			AddFrame("gripe.turn_right_to_left", "gripe.turn_right_to_left" + i, i - 1)
		Next
		
		' running
		CreateAnimation("gripe.run_right", 8)		
		For Local i:Int = 1 To 8
			AddFrame("gripe.run_right", "gripe.run_right" + i, i - 1)
		Next
		
		' dying
		CreateAnimation("gripe.die", 4)
		For Local i:Int = 1 To 4
			AddFrame("gripe.die", "gripe.die" + i, i - 1)
		Next
		
		SetCurrentAnimation("gripe.stand_right", 50, False)
		_state = STANDING
	End
	
	Method SetupWalkAnimation()
		If _direction = RIGHT
			scale.x = Abs(scale.x)
		Elseif _direction = LEFT
			If scale.x > 0
				scale.x = -scale.x
			End
		End
		If _state <> WALKING SetCurrentAnimation("gripe.run_right", 80, True)
	End
		
	Method SetupStandAnimation()
		If _state <> STANDING
			SetCurrentAnimation("gripe.stand_right", 50, True)
		End
		_state = STANDING
	End
	
	Method SetupJumpAnimation()
		SetCurrentAnimation("gripe.jump_right", 50, True)
	End
	
	Method SetupDieAnimation()
		_state = DIE
		SetCurrentAnimation("gripe.die", 125, True)
	End
	
	Method SetUpTurningAnimation()
		If _state <> TURNING
			SetCurrentAnimation("gripe.turn_right_to_left", 40)
		End
		_state = TURNING
	End
	
	Method Update(fixedRate:Float, wrapImage:Bool) Virtual
		local hasAnimimationFinished:Bool = UpdateAnimation()
		Local leftKey := Keyboard.KeyDown(Key.Left) Or Keyboard.KeyDown(Key.A)
		Local rightKey := Keyboard.KeyDown(Key.Right) Or Keyboard.KeyDown(Key.D)
		Local fireKey := Keyboard.KeyDown(Key.Space)
		
		if _state = TURNING
			if hasAnimimationFinished
				if _direction = RIGHT
					_direction = LEFT
					If scale.x > 0
						scale.x = -scale.x
					End
				Elseif _direction = LEFT
					_direction = RIGHT
					scale.x = Abs(scale.x)
				End
				SetupStandAnimation()
			End
		End
		If _state <> DIE
			If leftKey
				If _direction = RIGHT
					If _jumping
						_direction = LEFT
					Else
						If _state <> TURNING Then SetUpTurningAnimation()
					End
				Else
					_direction = LEFT
					SetupWalkAnimation()
					_state = WALKING
					position.x -= speed.x * fixedRate
				End
			Else If rightKey
				If _direction = LEFT
					If _jumping
						_direction = RIGHT
					Else
						If _state <> TURNING Then SetUpTurningAnimation()
					End
				Else
					_direction = RIGHT
					SetupWalkAnimation()
					_state = WALKING
					position.x += speed.x * fixedRate
				End
			Else
				If _state <> TURNING And Not _jumping Then SetupStandAnimation()
			End
			If fireKey And Not _jumping Then
				deltaValue.y =- speed.y
				_jumping = True
			End
			
			If _jumping
				SetupJumpAnimation()
				deltaValue.y += GRAVITY * fixedRate
				Local tmpY := position.y + (deltaValue.y * fixedRate)
				If deltaValue.y <> 0
					If deltaValue.y > 0
						If position.y > originPosition.y
							deltaValue.y = 0
							_jumping = False
							SetupStandAnimation()
							position.y = originPosition.y
						Else
							position.y = tmpY
						End
					Else
						position.y = tmpY
					End
				End
					
			End
		End
		If wrapImage
			position.x = (position.x + Window.VirtualResolution.x) Mod Window.VirtualResolution.x
		End
	End
	
	Property State:Int()
		Return _state
	Setter(state:Int)
		_state = state
	End
	
	Property Jumping:Bool()
		Return _jumping
	Setter(jumping:Int)
		_jumping = jumping
	End
End
