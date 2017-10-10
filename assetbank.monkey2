Namespace diddy2.assetbank

Class AssetBank Extends StringMap<Asset>
Private
	Field _prefix:String = "asset::"
	Field _imagePath:String = "graphics/"
	Field _soundPath:String = "sounds/"
	
Public
	Method LoadImage(fileName:String, setMidHandle:Bool = True)
		Local path:String = _prefix + _imagePath + fileName
		Local image:Image = Image.Load(path)
		If Not image
			Print("Error: Can not load image: " + path)
			App.Terminate()
		End
		If setMidHandle
			image.Handle = New Vec2f(.5)
		End
		Local imageAsset := New ImageAsset(fileName.ToUpper(), image)
		Set(fileName.ToUpper(), imageAsset)
	End
	
	Method GetImage:Image(name:String)
		name = name.ToUpper()
		Local asset:Asset = Get(name)
		
		Local imageAsset:ImageAsset = Cast<ImageAsset>(asset)
		If imageAsset = Null Then Print("Image '" + name + "' not found in the AssetBank")
		Return imageAsset.RawImage
	End
	
	Method ToString:String()
		Local rv:String = "The following are in the AssetBank:~n"
		For Local key:String = EachIn Self.Keys
			rv += key + "~n"
		Next
		Return rv
	End
End

Class Asset
Private
	Field _name:String
		
Public
	Property Name:String()
		Return _name
	End
	
	Method New(name:String)
		Self._name = name
	End
End

Class ImageAsset Extends Asset
Private
	Field _rawImage:Image
		
Public
	Property RawImage:Image()
		Return Self._rawImage
	End
	
	Method New(name:String, image:Image)
		Super.New(name)
		Self._rawImage = image
	End
End
