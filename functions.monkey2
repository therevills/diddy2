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

Function BoolToString:String(inbool:Bool)
	If inbool
		Return "True"
	Else
		Return "False"
	End
End

'LoadSpriteSheet function by Ethernaut
Function LoadSpriteSheet:Image[] (path:String, numFrames:Int, cellWidth:Int, cellHeight:Int, filter:Bool = True, preScale:Float = 1.0, padding:Int = 0, border:Int = 0, prefix:String = "asset::")
	Local atlasTexture := Texture.Load(prefix + path, Null )
	Assert( atlasTexture, " ~n ~nGameGraphics: Image " + path + " not found.~n ~n" )
 
	Local imgs := New Image[ numFrames ]
	Local atlasImg := New Image( atlasTexture )
 
	Local paddedWidth := cellWidth + ( padding * 2 )
	Local paddedHeight := cellHeight + ( padding * 2 )
	Local columns:Int = ( atlasImg.Width - border - border ) / paddedWidth
 
	For Local i := 0 Until numFrames
		Local col := i Mod columns
		Local x := ( col * paddedWidth ) + padding + border
		Local y := ( ( i / columns ) * paddedHeight ) + padding + border
		imgs[i] = New Image( atlasImg, New Recti( x , y, x + cellWidth, y + cellHeight ) )
		imgs[i].Scale = New Vec2f( preScale, preScale )
	Next
 
	atlasImg = Null
	Return imgs
End

Function DebugPrint(msg:String)
	Print Millisecs() + ": " + msg
End