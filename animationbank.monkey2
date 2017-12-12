Namespace diddy2.animationbank

Class AnimationBank
Private
	Field _bank:StringMap<Image[]>

Public	
	Method New()
		_bank = New StringMap<Image[]>
	End

	Method CreateAnimation(name:String, noOfFrames:Int)
		_bank.Set(name.ToUpper(), New Image[noOfFrames])
	End
		
	Method CheckAnimationExists(nameOfAnimation:String, frames:Image[])
		If frames.Length = 0 Then
			Print "Cannot find animation " + nameOfAnimation.ToUpper() + " or lenght is zero"
			Print(ToString())
			App.Terminate()
		End
	End
	
	Method GetAnimation:Image[](nameOfAnimation:String)
		Local frames := _bank.Get(nameOfAnimation.ToUpper())
		CheckAnimationExists(nameOfAnimation, frames)
		Return frames
	End
	
	Method AddFrame(nameOfAnimation:String, nameOfImage:String, frameIndex:Int)
		nameOfAnimation = nameOfAnimation.ToUpper()
		nameOfImage = nameOfImage.ToUpper()
		
		Local image:Image = DiddyApp.GetInstance().AssetBank.GetImage(nameOfImage)
		Local frames := _bank.Get(nameOfAnimation)
		CheckAnimationExists(nameOfAnimation, frames)
		frames[frameIndex] = image
	End
	
	Method ToString:String()
		Local rv:String = "The following are in the AnimationBank:~n"
		For Local key:String = Eachin _bank.Keys
			rv += key + "~n"
		Next
		Return rv
	End
End