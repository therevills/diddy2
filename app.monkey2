Namespace diddy2.app

Class DiddyApp
	Method New( title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable )
		New AppInstance
		New DiddyWindow(title, width, height, filterTextures, flags)
		App.Run()
	End
End