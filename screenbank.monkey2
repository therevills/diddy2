Namespace diddy2.screenbank

Class ScreenBank Extends StringMap<Screen>
	Method AddScreen(screen:Screen) 
		Set(screen.name.ToUpper(), screen)
	End
	
	Method GetScreen:Screen(name:String)
		name = name.ToUpper()

		Local s:Screen = Get(name)
		If s = Null Then Print("Screen '" + name + "' not found in the ScreenBank")
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