Namespace diddy2.functions

Function TileImage(canvas:Canvas, image:Image, cameraX:Float, cameraY:Float, width:Int, height:Int)
	Local tileWidth:Int = image.Width
	Local tileHeight:Int = image.Height

	Local x := Int(cameraX) / tileWidth * tileWidth
	Local y := Int(cameraY) / tileHeight * tileHeight

	x += Int(cameraX) / tileWidth
	y += Int(cameraY) / tileHeight

	canvas.PushMatrix()

	canvas.Translate(-cameraX, -cameraY)

	For Local h := -2 Until width / tileWidth + 4
		For Local v := -2 Until height / tileHeight + 4
			canvas.DrawImage(image, x + h * tileWidth, y + v * tileHeight)
		Next
	Next
	canvas.PopMatrix()
End