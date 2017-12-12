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