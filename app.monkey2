Namespace diddy2.app

Class DiddyApp
	Field window:DiddyWindow
	
	Method New( title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable )
		New AppInstance
		window = New DiddyWindow(title, width, height, filterTextures, flags)
	End
	
	Method Start(screen:Screen)
		window.Start(screen)
		App.Run()
	End
	
	Method AddScreen(screen:Screen)
		window.screenBank.AddScreen(screen)
	End
	
	Method GetScreen:Screen(name:String)
		Return window.screenBank.GetScreen(name)
	End
End