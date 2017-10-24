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
	' Create a Diddy2 App with a 800 x 600 window with a virtual resolution of 640 x 480 and filtering turned off for images
	New MyDiddyApp("Diddy 2 - Platformer Example!", 800, 600, 640, 480, False)
End

Class MyDiddyApp Extends DiddyApp
	Method New(title:String, width:Int, height:Int, virtualResolutionWidth:Int, virtualResolutionHeight:Int, filterTextures:Bool = True)
		Super.New(title, width, height, virtualResolutionWidth, virtualResolutionHeight, filterTextures)
		SetDebug(True)
		LoadAssets()
		CreateScreens()
		Start(GetScreen(Screen.TITLE_SCREEN))
	End
	
	' load the images and sounds into the AssetBank
	Method LoadAssets()
		AssetBank.LoadAtlas("gripe.xml", AssetBank.SPARROW_ATLAS)
	End
	
	' create the screens and add them to the ScreenBank
	Method CreateScreens()
		AddScreen(New TitleScreen(Screen.TITLE_SCREEN))
		AddScreen(New GameScreen(Screen.GAME_SCREEN))
	End
End

Class TitleScreen Extends Screen
	Field background:Image
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Load() Override
		background = AssetBank.LoadImage("title_screen.jpg", False, False)
	End
	
	Method Start() Override
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawImage(background, 0, 0)
		canvas.DrawText("PRESS SPACE TO START", Window.VirtualResolution.x / 2, Window.VirtualResolution.y - canvas.Font.Height * 2, .5, .5)
	End
	
	Method Update(fixedRate:Float) Override

		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen(Screen.EXIT_SCREEN))
		End
		
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen(Screen.GAME_SCREEN))
		End
	End
	
	Method Kill() Override
		background.Discard()
	End
End

Class GameScreen Extends Screen
	Field background0:Image
	Field background1:Image
	Field player:Player
	Field level:Level
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Load() Override
		background0 = AssetBank.LoadImage("area01_bkg0.png", False, False)
		background1 = AssetBank.LoadImage("area01_bkg1.png", False, False)
	End
	
	Method Start() Override
		level = New Level(1)
		Window.MaxScrollX = (level.Width * level.TileSize) - Window.VirtualResolution.x
		Window.MaxScrollY = (level.Height * level.TileSize) - Window.VirtualResolution.y
		player  = New Player(AssetBank.GetImage("gripe.stand_right"), level.PlayerStart, level)
		player.Scroll()
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawImage(background0, 0, 0)
		TileImage(canvas, background1, Window.ScrollX / 2, Window.ScrollY / 2, Window.VirtualResolution.x, Window.VirtualResolution.y)
		level.Render(canvas, Window.ScrollX, Window.ScrollY)
		player.Render(canvas, Window.ScrollX, Window.ScrollY)
	End
	
	Method Update(fixedRate:Float) Override
		player.Update(fixedRate)
		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen(Screen.TITLE_SCREEN))
		End
	End
	
	Method Kill() Override
		background0.Discard()
		background1.Discard()
	End
End

Class Level
Private
	Field _level:Int
	Field _levelName:String
	Field _width:Int
	Field _height:Int
	Field _tileSize:Int
	Field _playerStart:Vec2i
	Field _map:Int[,]	
	Field _mapAtlas:Image[]
Public
	Method New(level:Int)
		_level = level	
		LoadLevel(_level)
	End
	
	Property PlayerStart:Vec2i()
		Return _playerStart
	End
	
	Property Width:Int()
		Return _width
	End

	Property Height:Int()
		Return _height
	End

	Property TileSize:Int()
		Return _tileSize
	End

	Method LoadLevel(level:Int)
		Local jsonData := LoadString("asset::levels/level" + level + ".json")
		Local json:JsonObject = JsonObject.Parse(jsonData)
		If json
			Local jsonLevel:JsonObject = json.GetObject("level")
			_levelName = jsonLevel.GetString("name")
			_width = jsonLevel.GetNumber("width")
			_height = jsonLevel.GetNumber("height")
			_tileSize = jsonLevel.GetNumber("tilesize")
			Local playerStartX:Int = jsonLevel.GetNumber("playerStartX")
			Local playerStartY:Int = jsonLevel.GetNumber("playerStartY")
			
			_playerStart = New Vec2i(playerStartX, playerStartY)

			Local imagePath:String = jsonLevel.GetString("imagePath")
			Local tileCount:Int = jsonLevel.GetNumber("tileCount")
			
			_mapAtlas = LoadSpriteSheet(imagePath, tileCount, _tileSize, _tileSize)

			Local data:Int[] = New Int[_width * _height]
			For Local i:Int = 0 Until data.Length
				data[i] = jsonLevel.GetArray("data").GetNumber(i)
			Next

			_map = New Int[_width, _height]
			Local count:Int = 0
			For Local y:Int = 0 Until _height
				For Local x:Int = 0 Until _width
					_map[x, y] = data[count]
					count += 1
				Next
			Next
		End
	End
	
	Method Render(canvas:Canvas, offsetX:Float, offsetY:Float)
		For Local y:Int = 0 Until _height
			For Local x:Int = 0 Until _width
				If _map[x, y] > 0
					canvas.DrawImage(_mapAtlas[_map[x, y] - 1], x * _tileSize - offsetX, y * _tileSize - offsetY)
				End
			Next
		Next
	End
	
	Method GetCollisionTile:Int(x:Float, y:Float)
		If x < 0 Or x >= _width * _tileSize Or y < 0 Or y >= _height * _tileSize Then Return 0
		local xx:Int = (Floor(x / _tileSize)) 
		local yy:Int = (Floor(y / _tileSize))
		Return _map[xx, yy]
	End Method
	
End

Class Player Extends Sprite
	Field _state:Int = STANDING
	Field _jumping:Bool
	Field _direction:Int = RIGHT
	Field _level:Level
		
	Const RIGHT:Int = 0
	Const LEFT:Int = 1
	
	Const STANDING:Int = 0
	Const WALKING:Int = 1
	Const DIE:Int = 2
	Const TURNING:Int = 3

	Field gravity:Float
	
	Method New(img:Image, position:Vec2f, level:Level)	
		Super.New(img, position)
		_level = level
		
		Select Window.UpdateMode
			Case Window.UpdateModeFlag.FRL
				speed = New Vec2f(160, 450)
				gravity = 650
			Case Window.UpdateModeFlag.TIMER
				speed = New Vec2f(2, 10)
				gravity = 0.3
			Case Window.UpdateModeFlag.DELTA
				speed = New Vec2f(2, 10)
				gravity = 0.3
		End
		
		
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
	
	Method Update(fixedRate:Float) Virtual
		local hasAnimimationFinished:Bool = UpdateAnimation()
		Local leftKey := Keyboard.KeyDown(Key.Left) Or Keyboard.KeyDown(Key.A)
		Local rightKey := Keyboard.KeyDown(Key.Right) Or Keyboard.KeyDown(Key.D)
		Local fireKey := Keyboard.KeyDown(Key.Space)
		Local w2:Float = Image.Width / 2
		Local h2:Float = Image.Height / 2
			
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
			Local tempX:Float
			
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
					tempX = position.x - speed.x * fixedRate
					
					If _level.GetCollisionTile(tempX - w2 , position.y + h2 - 1 ) = 0 And _level.GetCollisionTile(tempX - w2 , position.y - h2) = 0 And _level.GetCollisionTile(tempX - w2 , position.y) = 0
						position.x = tempX
					Else
						position.x = Round((position.x - w2) / _level.TileSize) * _level.TileSize + w2
					End
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
				
					tempX = position.x + speed.x * fixedRate
					
					If _level.GetCollisionTile(tempX + w2 , position.y + h2 - 1 ) = 0 And _level.GetCollisionTile(tempX + w2 , position.y - h2) = 0 And _level.GetCollisionTile(tempX + w2 , position.y) = 0
						position.x = tempX
					Else
						position.x = Round((position.x + w2) / _level.TileSize) * _level.TileSize -  w2
					End
					
				End
			Else
				If _state <> TURNING And Not _jumping Then SetupStandAnimation()
			End
			If fireKey And Not _jumping Then
				deltaValue.y =- speed.y
				_jumping = True
			End
			
			Local amount:Int = 1
			Local amountY:int = 1
		
			If Not _jumping
				if _level.GetCollisionTile(position.x - w2 + amount, position.y + h2) = 0 And _level.GetCollisionTile(position.x + w2 - amount, position.y + h2) = 0 And _level.GetCollisionTile(position.x, position.y + h2) = 0
					_jumping = true
				End
			End
		
			If _jumping
				SetupJumpAnimation()
				deltaValue.y += gravity * fixedRate
				Local tempY := position.y + (deltaValue.y * fixedRate)
				If deltaValue.y <> 0
					If deltaValue.y > 0
						Local tileData:Int[] = New Int[3]
						
						tileData[0] = _level.GetCollisionTile(position.x - w2 + amount, tempY + h2 - amountY)
						tileData[1] = _level.GetCollisionTile(position.x + w2 - amount, tempY + h2 - amountY)
						tileData[2] = _level.GetCollisionTile(position.x, tempY + h2 - amountY)
						
						If tileData[0] > 0 Or tileData[1] > 0 Or tileData[2] > 0
						
							deltaValue.y = 0
							_jumping = false
							position.y = Round((tempY + h2) / _level.TileSize) * _level.TileSize - h2
							SetupStandAnimation()
							
							If tileData[0] = 92 Or tileData[0] = 93 Or tileData[1] = 92 Or tileData[1] = 93 Or tileData[2] = 92 Or tileData[2] = 93
								SetupDieAnimation()
								deltaValue.y = -speed.y * 1.1
							End
							
						Else
							position.y = tempY
						End
					Else
						If _level.GetCollisionTile(position.x - w2 + amount, tempY - h2 - amountY) > 0 Or _level.GetCollisionTile(position.x + w2 - amount, tempY - h2 - amountY) > 0 Or _level.GetCollisionTile(position.x, tempY - h2 - amountY) > 0
							deltaValue.y = 0
							position.y = Round((tempY - h2) / _level.TileSize) * _level.TileSize + h2
							
						Else
							position.y = tempY
						End
					End
				End
					
			End
		Else
			deltaValue.y += gravity * fixedRate
			position.y += (deltaValue.y * fixedRate)
			If _direction = RIGHT
				position.x += (speed.x / 2) * fixedRate
			Else
				position.x -= (speed.x / 2) * fixedRate
			End
			If position.y - Window.ScrollY > Window.VirtualResolution.y  + 200
				DiddyApp.GetInstance().Window.CurrentScreen.MoveToScreen(DiddyApp.GetInstance().Window.ScreenBank.GetScreen(Screen.TITLE_SCREEN))
			End
		End
		Scroll()
	End
	
	Method Scroll()
		Local borderX:Int = 200, borderY:Int = 200
		
		If position.x - Window.ScrollX < borderX
			Window.Scroll((position.x - Window.ScrollX) - borderX)
		End
		If position.x - Window.ScrollX > Window.VirtualResolution.x - borderX
			Window.Scroll((position.x - Window.ScrollX) - (Window.VirtualResolution.x - borderX))
		End
		If position.y - Window.ScrollY < borderY
			Window.Scroll(0, (position.y - Window.ScrollY) - borderY)
		End
		If position.y - Window.ScrollY > Window.VirtualResolution.y - borderY
			Window.Scroll(0, (position.y - Window.ScrollY) - (Window.VirtualResolution.y - borderY))
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
