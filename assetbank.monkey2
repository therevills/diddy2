Namespace diddy2.assetbank

#Import "<tinyxml2>"

Using tinyxml2..

Class AssetBank Extends StringMap<Asset>
Private
	Field _prefix:String = "asset::"
	Field _imagePath:String = "graphics/"
	Field _soundPath:String = "sounds/"
	
Public
	Const SPARROW_ATLAS:Int = 0

	Method LoadImage:Image(fileName:String, setMidHandle:Bool = True)
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
		Return image
	End
	
	Method LoadAtlas:Void(fileName:String, format:Int = SPARROW_ATLAS, setMidHandle:Bool = True)
		If format = SPARROW_ATLAS
			LoadSparrowAtlas(fileName, setMidHandle)
		Else
			Print "Invalid atlas format!"
		End
	End
	
	Method LoadSparrowAtlas:Void(fileName:String, midHandle:Bool=True)
		Local xml := LoadString(_prefix + _imagePath + fileName)
		' parse the xml
		Local doc:XMLDocument = New XMLDocument()
		
		If doc.Parse(xml) <> XMLError.XML_SUCCESS
			Print "Failed to parse XML: " + fileName
			App.Terminate()
		End
		
		Local xmlNode:XMLNode = doc
		Local xmlElement := xmlNode.ToElement()
		Local xmlChild := xmlNode.FirstChild()
		
		Local spriteFileName:String
	
		While xmlChild
			' Print xmlChild.Value() 
			If xmlChild.Value() = "TextureAtlas"

				Local xmlElement := xmlChild.ToElement()
				
				Local attrib := xmlElement.FirstAttribute()
				While attrib
					If attrib.Name() = "imagePath"
						spriteFileName = attrib.Value()
					End
					attrib = attrib.NextAttribute()
				End
	
				If Not xmlChild.NoChildren()
					
					Local xmlChildren := xmlChild.FirstChild()
					While xmlChildren
	
						If xmlChildren.Value() = "SubTexture"
							Local xmlElementChildren := xmlChildren.ToElement()
							Local attribChildren := xmlElementChildren.FirstAttribute()
							Local name:String
							Local x:Int
							Local y:Int
							Local width:Int
							Local height:Int

							While attribChildren
								' Print attribChildren.Name() + " "  + attribChildren.Value()
								
								If attribChildren.Name() = "name"
									name = attribChildren.Value()
								End
								If attribChildren.Name() = "x"
									x = Cast<Int> (attribChildren.Value().Trim())
								End
								If attribChildren.Name() = "y"
									y = Cast<Int> (attribChildren.Value().Trim())
								End
								If attribChildren.Name() = "width"
									width = Cast<Int> (attribChildren.Value().Trim())
								End
								If attribChildren.Name() = "height"
									height = Cast<Int> (attribChildren.Value().Trim())
								End
								
								attribChildren = attribChildren.NextAttribute()
							End
							
							' Print name + " x = " + x + " y = " + y + " width = " + width + " height = " + height
							
							Local pointer:Image = LoadImage(spriteFileName, False)
							
							local rect := New Recti(x, y, x + width, y + height)
							Local image:Image = New Image(pointer, rect)
							
							If midHandle
								image.Handle = New Vec2f(.5)
							End
							
							Local imageAsset:ImageAsset = New ImageAsset(name.ToUpper(), image)
							
							Set(name.ToUpper(), imageAsset)
						End

						xmlChildren = xmlChildren.NextSibling()
					End
				End
			End
		
			xmlChild = xmlChild.NextSibling()
		End
	End
	
	Method LoadSound(fileName:String)
		Local path:String = _prefix + _soundPath + fileName
		Local sound:Sound = Sound.Load(path)
		If Not sound
			Print("Error: Can not load sound: " + path)
			App.Terminate()
		End
		Local soundAsset := New SoundAsset(fileName.ToUpper(), sound)
		Set(fileName.ToUpper(), soundAsset)
	End
	
	Method GetImage:Image(name:String)
		name = name.ToUpper()
		Local asset:Asset = Get(name)
		
		Local imageAsset:ImageAsset = Cast<ImageAsset>(asset)
		If imageAsset = Null Then Print("Image '" + name + "' not found in the AssetBank")
		Return imageAsset.RawImage
	End
	
	Method GetSound:Sound(name:String)
		name = name.ToUpper()
		Local asset:Asset = Get(name)
		
		Local soundAsset:SoundAsset = Cast<SoundAsset>(asset)
		If soundAsset = Null Then Print("Sound '" + name + "' not found in the AssetBank")
		Return soundAsset.RawSound
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

Class SoundAsset Extends Asset
Private
	Field _rawSound:Sound
		
Public
	Property RawSound:Sound()
		Return Self._rawSound
	End
	
	Method New(name:String, sound:Sound)
		Super.New(name)
		Self._rawSound = sound
	End
End
