Namespace diddy2.screenbank

Class ScreenBank Extends StringMap<Screen>
Private
	Field _diddyApp:DiddyApp
	
Public

	Property DiddyApp:DiddyApp()
		Return _diddyApp
	End
	
	Method New(diddyApp:DiddyApp)
		_diddyApp = diddyApp
	End
		

	Method AddScreen(screen:Screen) 
		Set(screen.Name.ToUpper(), screen)
		screen.ScreenBank = Self
	End
	
	Method GetScreen:Screen(name:String)
		name = name.ToUpper()

		Local s:Screen = Get(name)
		If Not s
			Print("Screen '" + name + "' not found in the ScreenBank")
			Print(ToString())
			App.Terminate()
		End
		
		Return s
	End
	
	Method ToString:String()
		Local rv:String = "The following are in the ScreenBank:~n"
		For Local key:String = EachIn Self.Keys
			rv += key + "~n"
		Next
		Return rv
	End
End