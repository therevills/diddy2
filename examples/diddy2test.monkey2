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
		Start(GetScreen("Title"))
	End
	
	Method LoadAssets()
		AssetBank.LoadImage("monkey2logoSmall-1.png")
		AssetBank.LoadImage("diddy128.png")	
	End
	
	Method CreateScreens()
		AddScreen(New TitleScreen("Title"))
		AddScreen(New GameScreen("Game"))
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
		mx2Image = DiddyApp.AssetBank.GetImage("monkey2logoSmall-1.png")
		diddy2Image = DiddyApp.AssetBank.GetImage("diddy128.png")
		
		player = New Sprite(mx2Image, New Vec2f(100, 100))
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawText(Name, 10, 10)
		canvas.DrawImage(mx2Image, DiddyApp.Window.VirtualResolution.X / 4 + DiddyApp.Window.VirtualResolution.X / 2, DiddyApp.Window.VirtualResolution.Y / 2)
		canvas.DrawImage(diddy2Image, DiddyApp.Window.VirtualResolution.X / 4, DiddyApp.Window.VirtualResolution.Y / 2)
		player.Render(canvas)
	End
	
	Method Update(delta:Float) Override
		If Keyboard.KeyDown(Key.Escape)
			MoveToScreen(ScreenBank.GetScreen("Exit"))
		End
		
		player.Rotation += 1 * delta
		
		If Keyboard.KeyDown(Key.Space)
			MoveToScreen(ScreenBank.GetScreen("Game"))
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
			MoveToScreen(ScreenBank.GetScreen("Title"))
		End
	End
End
