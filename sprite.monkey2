Namespace diddy2.sprite

Class Sprite
Private
	Field _position:Vec2f
	Field _z:Float
	Field _rotation:Float = Pi / 2
	Field _image:Image
	Field _colour:Color = Color.White
	Field _scale:Vec2f = New Vec2f(1, 1)
	Field _alpha:Float = 1
	
Public
	Method New(image:Image, position:Vec2f)
		_position = position
		Self._image = image
	End
	
	Method Render(canvas:Canvas)
		Local canvasColor := canvas.Color
		Local canvasAlpha := canvas.Alpha
		
		canvas.Color = _colour
		canvas.Alpha = _alpha

		Local r := _rotation - Pi / 2
		canvas.DrawImage(_image, _position, r, _scale)
		
		canvas.Color = canvasColor
		canvas.Alpha = canvasAlpha
	End
	
	Property Position:Vec2f()
		Return _position
	Setter (position:Vec2f)
		_position = position
	End
	
	Property Colour:Color()
		Return _colour
	Setter (color:Color)
		_colour = color
	End
	
	Property Scale:Vec2f()
		Return _scale
	Setter (scale:Vec2f)
		_scale = scale
	End
	
	Property Rotation:Float()
		Return _rotation
	Setter (rotation:Float)
		_rotation = rotation
	End

	Property Alpha:Float()
		Return _alpha
	Setter (alpha:Float)
		If alpha < 0 alpha = 0
		If alpha > 1 alpha = 1
		_alpha = alpha
	End

	
	Property Image:Image()
		Return _image
	Setter (image:Image)
		_image = image
	End
End