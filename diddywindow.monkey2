Namespace diddy2.window

Class DiddyWindow Extends Window

Private
	Field _virtualResolution := New Vec2i
	Field _dt:DeltaTimer
	Field _fps:Int = 60
	Field _debugOn:Bool
	
	Field _screenBank:ScreenBank
	Field _currentScreen:Screen
	Field _screenFade:ScreenFade
	Field _nextScreen:Screen
	
Public
	Const UPDATE_FREQUENCY:Float = 100.0
	Const SPIKE_SUPPRESSION:Int = 20
	
	Global GameTime:FixedRateLogicTimer = New FixedRateLogicTimer(UPDATE_FREQUENCY, SPIKE_SUPPRESSION)
	Global instance:DiddyWindow = null

	Method New(title:String, width:Int, height:Int, filterTextures:Bool = True, flags:WindowFlags = WindowFlags.Resizable)
		Super.New( title, width, height, flags )
		Layout = "letterbox"
		SetVirtualResolution(width, height)
		_dt = New DeltaTimer(_fps)
		Self._screenFade = New ScreenFade(width, height)
		SwapInterval = 1
		GenerateSeed()
		ClearColor = Color.Black
		instance = Self
	End
	
	Method CreateScreenBank(app:DiddyApp)
		Self._screenBank = New ScreenBank(app)
		Self._screenBank.AddScreen(New EmptyScreen("Empty"))
		Self._screenBank.AddScreen(New ExitScreen("Exit"))
	End
	
	Property VirtualResolution:Vec2i()
		Return _virtualResolution
	End
	
	Property ScreenBank:ScreenBank()
		Return _screenBank
	End
	
	Property ScreenFade:ScreenFade()
		Return _screenFade
	End
	
	Property NextScreen:Screen()
		Return _nextScreen
	Setter (screen:Screen)
		_nextScreen = screen
	End	
	
	Property CurrentScreen:Screen()
		Return _currentScreen
	Setter (screen:Screen)
		_currentScreen = screen
	End	
	
	Method GenerateSeed()
		SeedRnd(Millisecs())
	End
	
	Method Start(screen:Screen)
		Local s:Screen = _screenBank.GetScreen("Empty")
		s.SetDestinationScreen(screen)
		s.PreStart()
	End
	
	Method GameLogic(delta:Float)
		If _screenFade.Active
			_screenFade.Update(delta)
		End
		If _currentScreen
			If Not _screenFade.Active Then _currentScreen.Update(delta)
		End
	End
	
	Method GameRender(canvas:Canvas, tween:Float)
		If _currentScreen
			_currentScreen.Render(canvas, tween)
		End
		If _screenFade.Active Then _screenFade.Render(canvas)
		RenderDebug(canvas)
	End
	
	Method RenderDebug(canvas:Canvas)
		If _debugOn
			GameTime.ShowFPS(0, 60, canvas)
			GameTime.ShowSpikeSuppression(0, 100, canvas)
		End
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
		Return _virtualResolution
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
		_virtualResolution = New Vec2i(width, height)
		MinSize = New Vec2i(width / 2, height / 2)
	End
End