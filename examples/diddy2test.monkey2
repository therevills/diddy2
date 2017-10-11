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
	End
	
	Method CreateScreens()
		AddScreen(New TitleScreen("TitleScreen"))
		AddScreen(New GameScreen("GameScreen"))
	End
End

Class TitleScreen Extends Screen
	Field mx2Image:Image
	Field diddy2Image:Image
	
	Field player:Sprite
	
	Method New(title:String)
		Super.New(title)
	End
	
	Method Start() Override
		mx2Image = AssetBank.GetImage("monkey2logoSmall-1.png")
		diddy2Image = AssetBank.GetImage("diddy128.png")
		
		player = New Sprite(mx2Image, New Vec2f(Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 2))
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawText(Name, 10, 10)
		canvas.DrawImage(mx2Image, Window.VirtualResolution.X / 4 + Window.VirtualResolution.X / 2, Window.VirtualResolution.Y / 4)
		canvas.DrawImage(diddy2Image, Window.VirtualResolution.X / 4, Window.VirtualResolution.Y / 4)
		player.Render(canvas)
		
		canvas.DrawText("Press Space to move to the GameScreen", Window.VirtualResolution.X / 2, 10, .5)
	End
	
	Method Update(delta:Float) Override
		player.Rotation += 1 * delta
		player.Alpha -= 0.1 * delta
		player.Colour = New Color(Rnd(0,1), Rnd(0,1), Rnd(0,1))
		
		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen("Exit"))
		End
		
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen("GameScreen"))
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
		canvas.DrawText(Name, 10, 10)
	End
	
	Method Update(delta:Float) Override
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen("TitleScreen"))
		End
	End
End
