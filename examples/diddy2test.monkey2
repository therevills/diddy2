Namespace diddy2test

#Import "<diddy2>"
#Import "<mojo>"

Using diddy2..
Using mojo..

Function Main()
	New MyApp("Diddy 2!", 800, 600, False)
End

Class MyApp Extends DiddyApp
	Field titleScreen:TitleScreen
	Field gameScreen:GameScreen
		
	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True)
		Super.New(title, width, height, filterTextures)
		titleScreen = New TitleScreen("Title")
		gameScreen = New GameScreen("Game")
		Start(titleScreen)
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
			Print "Fading to GameScreen"
			FadeToScreen(New GameScreen("GameScreen"))
		End
	End
End

Class GameScreen Extends Screen
	Method New(title:String)
		Super.New(title)
	End
	
	Method Start() Override
		Print "Start " + name
	End
	
	Method Render(canvas:Canvas, tween:Float) Override
		canvas.DrawText(name, 100, 100)
	End
	
	Method Update(delta:Float) Override
		If Keyboard.KeyHit(Key.Space)
			Print "Fading to TitleScreen"
			FadeToScreen(New TitleScreen("TitleScreen"))
		End
	End
End
