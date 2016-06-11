Namespace diddy2.sprite

Class Sprite
	Field x:Float
	Field y:Float
	Field z:Float
	Field angle:Float
	Field image:Image
	
	Method New(image:Image, x:Float, y:Float)
		Self.x = x
		Self.y = y
		Self.image = image
	End
End