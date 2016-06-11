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
