Namespace diddy2.sprite

Class Sprite
Private
	Field _z:Float
	Field _rotation:Float = Pi / 2
	Field _image:Image
	Field _wrapImageX:Bool = False
	Field _wrapImageY:Bool = False
	Field _colour:Color = Color.White
	Field _alpha:Float = 1
	
	Field _currentAnimation:Image[]
	Field _animationBank:AnimationBank
	Field _frame:Int
	Field _startFrame:Int
	Field _maxFrame:Int
	Field _frameTimer:Int
	Field _frameTimerSpeed:Int
	Field _loopAnimation:Bool = False
	Field _reverseAnimation:Bool = False
	Field _pingPongAnimation:Bool = False
	Field _pingPongAnimationCounter:Int
	Field _maxPingPongAnimationCounter:Int = 1
	
Public

	Field position:Vec2f
	Field originPosition:Vec2f
	Field scale:Vec2f = New Vec2f(1, 1)
	Field speed:Vec2f = New Vec2f(1, 1)
	Field deltaValue:Vec2f = New Vec2f(1, 1)

	Method New(image:Image, position:Vec2f)
		Self.position = position
		Self.originPosition = position
		_image = image
		_animationBank = New AnimationBank
	End
	
	Method Render(canvas:Canvas)
		Local canvasColor := canvas.Color
		Local canvasAlpha := canvas.Alpha
		
		canvas.Color = _colour
		canvas.Alpha = _alpha

		Local r := _rotation - Pi / 2
		
		Local localImage:Image
		
		If _currentAnimation
			localImage = _currentAnimation[_frame]
			
			canvas.DrawImage(localImage, position, r, scale)
			
		Else
			localImage = _image
			
			canvas.DrawImage(localImage, position, r, scale)
		End

		Local vrWidth  := DiddyApp.GetInstance().Window.VirtualResolution.X
		Local vrHeight := DiddyApp.GetInstance().Window.VirtualResolution.Y
		
		If _wrapImageX
			If position.X - localImage.Radius < 0 canvas.DrawImage(localImage, position.X + vrWidth, position.Y, r, scale.X, scale.Y)
			If position.X + localImage.Radius > vrWidth canvas.DrawImage(localImage, position.X - vrWidth, position.Y, r, scale.X, scale.Y)
		End
		
		If _wrapImageY
			If position.Y - localImage.Radius < 0 canvas.DrawImage(localImage, position.X, position.Y + vrHeight, r, scale.X, scale.Y)
			If position.Y + localImage.Radius > vrHeight canvas.DrawImage(localImage, position.X, position.Y - vrHeight, r, scale.X, scale.Y)
		End
		
		canvas.Color = canvasColor
		canvas.Alpha = canvasAlpha
	End
	
	Method RenderDebug(canvas:Canvas)
		Local y:Int = 10
		Local gap:Int = canvas.Font.Height
		canvas.DrawText("Frame: " + Frame, 10, y)
		y += gap
		canvas.DrawText("Start Frame: " + StartFrame, 10, y)
		y += gap
		canvas.DrawText("Max Frame: " + MaxFrame, 10, y)
		y += gap
		canvas.DrawText("_frameTimerSpeed: " + _frameTimerSpeed, 10, y)
		y += gap
		canvas.DrawText("_frameTimer: " + _frameTimer, 10, y)
		y += gap
	End

	Property WrapImageX:Bool()
		Return _wrapImageX
	Setter (wrapImageX:Bool)
		_wrapImageX = wrapImageX
	End
	
	Property WrapImageY:Bool()
		Return _wrapImageY
	Setter (wrapImageY:Bool)
		_wrapImageY = wrapImageY
	End
	
	Property WrapImage:Bool()
		Return _wrapImageX And _wrapImageY
	Setter (wrapImage:Bool)
		_wrapImageX = wrapImage
		_wrapImageY = wrapImage
	End

	Property CurrentAnimation:Image[]()
		Return _currentAnimation
	Setter (frames:Image[])
		_currentAnimation = frames
	End

	Property Frame:Int()
		Return _frame
	Setter (frame:Int)
		_frame = frame
	End
	
	Property StartFrame:Int()
		Return _startFrame
	Setter (startFrame:Int)
		_startFrame = startFrame
	End
	
	Property MaxFrame:Int()
		Return _maxFrame
	Setter (maxFrame:Int)
		_maxFrame = maxFrame
	End

	Property Colour:Color()
		Return _colour
	Setter (color:Color)
		_colour = color
	End

	Property Rotation:Float()
		Return _rotation
	Setter (rotation:Float)
		_rotation = rotation
	End

	Property Alpha:Float()
		Return _alpha
	Setter (alpha:Float)
		alpha = Clamp(alpha, 0.0, 1.0)
		_alpha = alpha
	End

	Property Image:Image()
		Return _image
	Setter (image:Image)
		_image = image
	End
	
	Method CreateAnimation(name:String, noOfFrames:Int)
		_animationBank.CreateAnimation(name, noOfFrames)
	End
	
	Method AddFrame(nameOfAnimation:String, nameOfImage:String, frameIndex:Int)
		_animationBank.AddFrame(nameOfAnimation, nameOfImage, frameIndex)
	End
	
	Method GetAnimation:Image[](nameOfAnimation:String, frameTimerSpeed:Int = 125, loopAnimation:Bool = False, pingPongAnimation:Bool = False, startFrame:Int = 0)
		Local frames := _animationBank.GetAnimation(nameOfAnimation)
		_maxFrame = frames.Length - 1
		_frameTimerSpeed = frameTimerSpeed
		_frameTimer = Millisecs()
		_frame = startFrame
		_startFrame = startFrame
		_pingPongAnimation = pingPongAnimation
		_pingPongAnimationCounter = 0
		_loopAnimation = loopAnimation
		_reverseAnimation = False
		Return frames
	End
	
	Method SetCurrentAnimation(nameOfAnimation:String, frameTimerSpeed:Int = 125, loopAnimation:Bool = False, pingPongAnimation:Bool = False, startFrame:Int = 0)
		_currentAnimation = GetAnimation(nameOfAnimation, frameTimerSpeed, loopAnimation, pingPongAnimation, startFrame)
	End
	
	Method UpdateAnimation:Bool()
		Local rv:Bool = False
		If _frameTimerSpeed > 0
			If Millisecs() > _frameTimer + _frameTimerSpeed
				If Not _reverseAnimation
					_frame += 1
					If _frame > _maxFrame
						rv = ResetAnimation()
					End
				Else
					_frame -= 1
					If _frame < _maxFrame
						rv = ResetAnimation()
					End
				End
				_frameTimer = Millisecs()
			End
		End
		Return rv
	End
	
	Method ResetAnimation:Bool()
		If _loopAnimation
			If _pingPongAnimation
				FlipAnimationFrames()
			Else
				_frame = _startFrame
			End
		Else
			If _pingPongAnimation And _pingPongAnimationCounter < _maxPingPongAnimationCounter
				FlipAnimationFrames()
				_pingPongAnimationCounter += 1
			Else
				_frame = _maxFrame
				Return True
			End
		End
		Return False
	End
	
	Method FlipAnimationFrames()
		_reverseAnimation = Not _reverseAnimation
		_frame = _maxFrame
		Local ts:Int = _startFrame
		_startFrame = _maxFrame
		_maxFrame = ts
	End
End