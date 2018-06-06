Namespace diddy2.math

Function Dist:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Return Sqrt(Pow((x1 - x2), 2) + Pow((y1 - y2), 2))
End

Function ToDegrees:Float(rad:Float)
	Return rad * 180.0 / Pi
End

Function ToRadians:Float(degree:Float)
	Return degree * Pi / 180.0
End

Function Cosd:Double(x:Double)
	Return Cos(ToRadians(x))
End

Function Sind:Double(x:Double)
	Return Sin(ToRadians(x))
End

Function CircleOverlap:Bool(pos1:Vec2f, radius1:Float, pos2:Vec2f, radius2:Float)
	Return ((pos2.X - pos1.X) * (pos2.X - pos1.X) + (pos2.Y - pos1.Y) * (pos2.Y - pos1.Y)) < (radius1 + radius2) * (radius1 + radius2)
End

Function RectangleOverlap:Bool(x1:Float, y1:Float, width1:Int, height1:Int, x2:Float, y2:Float, width2:Int, height2:Int, centerRect:Int=False)
	If centerRect
		x1 = x1 - width1 * .5
		y1 = y1 - height1 * .5
		x2 = x2 - width2 * .5
		y2 = y2 - height2 * .5
	Endif

	If x1 + width1 <= x2 Return False
	If y1 + height1 <= y2 Return False

	If x1 >= x2 + width2 Return False
	If y1 >= y2 + height2 Return False

	Return True
End

Function FloatEqual:Bool(f1:Float, f2:Float, epsilon:Float = 0.00001)
	Return (Abs(f1 - f2) < epsilon)
End

Function RoundF:Float(value:Double, places:Int)
	If (places < 0) Then
		Return 0
	Else
		Local factor := Long (Pow(10, places))
			value = value * factor
		Local tmp := Round(value)
		Return Double (tmp / factor)
	End
End

Function GetAngle:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Local angle:Float = ATan2((y2 - y1), (x2 - x1))
	Return angle
End

Function GetAngleInDegrees:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Local angle:Float = GetAngle(x1, y1, x2, y2)
	angle = ToDegrees(angle)
	If (angle < 0)
		angle += 360
	End
	Return angle
End

Function GetAngleInDegreesClockwise:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Local angle:Float = GetAngle(x1, y1, x2, y2)
	angle += Pi / 2.0
	angle = ToDegrees(angle)
	If (angle < 0)
		angle += 360
	End
	Return angle
End

Function LinearTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	Return diff * t / d + b
End

Function QuadTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	t /= d / 2
	If t < 1 Return diff / 2 * t * t + b
	t -= 1
	Return -diff / 2 * (t * (t - 2) - 1) + b
End

Function QuinticTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	t /= d / 2
	If (t < 1) Return diff / 2 * t * t * t * t * t + b
	t -= 2
	Return diff / 2 * (t * t * t * t * t + 2) + b
End

Function TweenCalc:Float(p1:Float, p2:Float, t:Float)
	Return p1 + t * (p2 - p1)
End

Function TweenSmooth:Float(p1:Float, p2:Float, t:Float)
	Local v:Float = SmoothStep(t)
	Return p1 + v * (p2 - p1)
End

Function SmoothStep:Float(x:Float, interpSmooth:Int = 1)
	For Local i:Int = 0 Until interpSmooth
		x *= x * (3 - 2 * x)
	Next

	Return x
End

Function TweenUp:Float(p1:Float, p2:Float, t:Float)
	Local v:Float = SmoothStep(t)
	v = Pow(v, 2) 'power of 2.
	Return p1 + v * (p2 - p1)
End

Function TweenDown:Float(p1:Float, p2:Float, t:Float)
	Local v:Float = SmoothStep(t)
	v = 1 - Pow(1 - v, 2) 'InvSquared
	Return p1 + v * (p2 - p1)
End

Function Bezier:Float(p1:Float, p2:Float, cp1:Float, cp2:Float, t:Float)
	Local v:Float = p1 * Pow( (1 - t), 3) + 3 * cp1 * Pow( (1 - t), 2) * t + 3 * cp2 * (1 - t) * Pow(t, 2) + p2 * Pow(t, 3)
	Return v
End

Function EaseInBounceTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	Return diff - EaseOutBounceTween(d - t, 0, diff, d) + b
End

Function EaseOutBounceTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	t /= d
	If (t < (1 / 2.75))
		Return diff * (7.5625 * t * t) + b
	ElseIf(t < (2 / 2.75))
		t -= (1.5 / 2.75)
		Return diff * (7.5625 * t * t + 0.75) + b
	ElseIf(t < (2.5 / 2.75))
		t -= (2.25 / 2.75)
		Return diff * (7.5625 * t * t + 0.9375) + b
	Else
		t -= (2.625 / 2.75)
		Return diff * (7.5625 * t * t + 0.984375) + b
	End
End

Function EaseInOutBounceTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	If (t < d / 2)
		Return EaseInBounceTween(t * 2, 0, diff, d) * 0.5 + b
	End
	Return EaseOutBounceTween(t * 2 - d, 0, diff, d) * 0.5 + diff * 0.5 + b
End

Function BackEaseInTween:Float(b:Float, c:Float, t:Float, d:Float = 1, s:Float = 2)
	Local diff:Float = c - b
	t /= d
	Return diff * t * t * ( (s + 1) * t - s) + b
End

Function BackEaseOutTween:Float(b:Float, c:Float, t:Float, d:Float = 1, s:Float = 2)
	Local diff:Float = c - b
	t = t / d - 1
	Return diff * (t * t * ( (s + 1) * t + s) + 1) + b
End

Function BackEaseInOutTween:Float(b:Float, c:Float, t:Float, d:Float = 1, s:Float = 2)
	Local diff:Float = c - b
	Local s2:Float = s
	t /= d / 2
	s2 *= 1.525
	If t < 1
		Return diff / 2 * (t * t * ( (s2 + 1) * t - s2)) + b
	End
	t -= 2
	Return diff / 2 * (t * t * ( (s2 + 1) * t + s2) + 2) + b
End