Namespace diddy2.window

Class DiddyWindow Extends Window
	Const UPDATE_FREQUENCY:Float = 100.0
	Const SPIKE_SUPPRESSION:Int = 20
	
	Field virtualResolution := New Vec2i
	Field dt:DeltaTimer
	Field FPS:Int = 60
	
	Field currentScreen:Screen
	Field screenFade:ScreenFade
	
	Global GameTime:FixedRateLogicTimer = New FixedRateLogicTimer(UPDATE_FREQUENCY, SPIKE_SUPPRESSION)
	
	Method New( title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable )
		Super.New( title, width, height, flags )
		Layout = "letterbox"
		SetVirtualResolution(width, height)
		dt = New DeltaTimer(FPS)
		SwapInterval = 1
		SeedRnd(Millisecs())
	End
	
	Method GameLogic(delta:Float)
		If screenFade.active
			screenFade.Update(delta)
		End
		If currentScreen
			currentScreen.Render(delta)
		End
	End
	
	Method GameRender(canvas:Canvas, tween:Float)
		If currentScreen
			If Not screenFade.active Or (screenFade.allowScreenUpdate And screenFade.active)
				currentScreen.Update()
			End
		End
		RenderDebug(canvas)
	End
	
	Method RenderDebug(canvas:Canvas)
		GameTime.ShowSpikeSuppression(100, 40, canvas)
		GameTime.ShowFPS(0, 60, canvas)
	End
	
	Method OnRender(canvas:Canvas) Override
		App.RequestRender()
		Local delta:Float = GameTime.ProcessTime()
		While GameTime.LogicUpdateRequired()
			GameLogic(delta)
		End
		Local tween:Float = GameTime.GetTween()
		GameRender(canvas, tween)
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