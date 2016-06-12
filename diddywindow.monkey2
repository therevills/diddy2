Namespace diddy2.window

Class DiddyWindow Extends Window
	Const UPDATE_FREQUENCY:Float = 100.0
	Const SPIKE_SUPPRESSION:Int = 20
	
	Field virtualResolution := New Vec2i
	Field dt:DeltaTimer
	Field FPS:Int = 60
	
	Field screenBank:ScreenBank
	Field currentScreen:Screen
	Field screenFade:ScreenFade
	Field nextScreen:Screen
	
	Global GameTime:FixedRateLogicTimer = New FixedRateLogicTimer(UPDATE_FREQUENCY, SPIKE_SUPPRESSION)
	
	Global instance:DiddyWindow = null
	
	Function GetWindow:DiddyWindow()
		If instance = null
			instance = New DiddyWindow("Test", 640, 480, True)
		End
		
		Return instance
	End
	
	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable)
		Super.New( title, width, height, flags )
		Layout = "letterbox"
		SetVirtualResolution(width, height)
		dt = New DeltaTimer(FPS)
		Self.screenFade = New ScreenFade(width, height)
		SwapInterval = 1
		GenerateSeed()
		ClearColor = Color.Black
		instance = Self
		Self.screenBank = New ScreenBank
		Self.screenBank.AddScreen(New EmptyScreen("Empty"))
		Self.screenBank.AddScreen(New ExitScreen("Exit"))
	End
	
	Method GenerateSeed()
		SeedRnd(Millisecs())
	End
	
	Method Start(screen:Screen)
		Local s:Screen = screenBank.GetScreen("Empty")
		s.SetDestinationScreen(screen)
		s.PreStart()
	End
	
	Method GameLogic(delta:Float)
		If screenFade.active
			screenFade.Update(delta)
		End
		If currentScreen
			If Not screenFade.active Then currentScreen.Update(delta)
		End
	End
	
	Method GameRender(canvas:Canvas, tween:Float)
		If currentScreen
			currentScreen.Render(canvas, tween)
		End
		If screenFade.active Then screenFade.Render(canvas)
		RenderDebug(canvas)
	End
	
	Method RenderDebug(canvas:Canvas)
		GameTime.ShowFPS(0, 60, canvas)
		GameTime.ShowSpikeSuppression(0, 100, canvas)
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