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