Namespace diddy2.screen

Class Screen Abstract
	Field name:String = ""
	
	Method New(name:String="")
		Self.name = name
	End
	
	Method Start:Void() Abstract
	
	Method Render:Void(delta:Float) Abstract
	
	Method Update:Void() Abstract
	
	Method Kill:Void()
	End
	
	
End