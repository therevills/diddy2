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
End