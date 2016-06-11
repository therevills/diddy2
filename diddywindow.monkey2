Namespace diddy2.window

Class DiddyApp
	Method New( title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable )
		New AppInstance
		New DiddyWindow(title, width, height, filterTextures, flags)
		App.Run()
	End
End

Class DiddyWindow Extends Window
	Const UPDATE_FREQUENCY:Float = 100.0
	Const SPIKE_SUPPRESSION:Int = 20
	
	Field virtualResolution := New Vec2i
	Field dt:DeltaTimer
	Field FPS:Int = 60
	Global GameTime:FixedRateLogicTimer = New FixedRateLogicTimer(UPDATE_FREQUENCY, SPIKE_SUPPRESSION)
	
	Method New( title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable )
		Super.New( title, width, height, flags )
		Layout = "letterbox"
		SetVirtualResolution(width, height)
		dt = New DeltaTimer(FPS)
		SwapInterval = 1
		SeedRnd(Millisecs())
	End
	
	Method OnRender( windowCanvas:Canvas ) Override
		App.RequestRender()
	End
	
	Method OnMeasure:Vec2i() Override
		Return virtualResolution
	End
	
	Method OnWindowEvent(event:WindowEvent) Override
		Select event.Type
			Case EventType.WindowMoved
			Case EventType.WindowResized
				App.RequestRender()
			Case EventType.WindowGainedFocus
			Case EventType.WindowLostFocus
			Default
				Super.OnWindowEvent(event)
		End
	End
	
	Method SetVirtualResolution(width:Int, height:Int)
		virtualResolution = New Vec2i(width, height)
		MinSize = New Vec2i(width / 2, height / 2)
	End
End