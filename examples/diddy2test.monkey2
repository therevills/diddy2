Namespace diddy2test

#Import "<diddy2>"
#Import "<mojo>"
#Import "<std>"

Using diddy2..
Using mojo..
Using std..

Function Main()
	New MyApp("Diddy 2!", 800, 600, False)
End

Class MyApp Extends DiddyApp
	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True)
		Super.New(title, width, height, filterTextures)
		CreateScreens()
		Start(GetScreen("Title"))
	End
	
	Method CreateScreens()
		AddScreen(New TitleScreen("Title"))
		AddScreen(New GameScreen("Game"))
	End
End

Class TitleScreen Extends Screen
	Method New(title:String)
		Super.New(title)
	End
	
	Method Start() Override
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawText(name, 10, 10)
	End
	
	Method Update(delta:Float) Override
		If Keyboard.KeyHit(Key.Space)
			MoveToScreen(DiddyWindow.GetWindow().screenBank.GetScreen("Game"))
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
		canvas.DrawText(name, 10, 10)
	End
	
	Method Update(delta:Float) Override
		If Keyboard.KeyHit(Key.Space)
			MoveToScreen(DiddyWindow.GetWindow().screenBank.GetScreen("Title"))
		End
	End
End
