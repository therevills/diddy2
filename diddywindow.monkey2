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
	Field _scrollX:Float
	Field _scrollY:Float
	Field _maxScrollX:Float
	Field _maxScrollY:Float
Public
	Const UPDATE_FREQUENCY:Float = 100.0
	Const SPIKE_SUPPRESSION:Int = 10
	
	Global GameTime:FixedRateLogicTimer
	Global instance:DiddyWindow = null

	Method New(title:String, width:Int, height:Int, virtualResolutionWidth:Int, virtualResolutionHeight:Int, flags:WindowFlags = WindowFlags.Resizable, layout:String = "letterbox", fps:Int = 60, swapInterval:Int = 1)
		Super.New(title, width, height, flags)
		Layout = layout
		SetVirtualResolution(virtualResolutionWidth, virtualResolutionHeight)
		_maxScrollX = width
		_maxScrollY = height
		_fps = fps
		_dt = New DeltaTimer(_fps)
		Self._screenFade = New ScreenFade(width, height)
		SwapInterval = swapInterval
		GenerateSeed()
		ClearColor = Color.Black
		instance = Self
		GameTime = New FixedRateLogicTimer(UPDATE_FREQUENCY, SPIKE_SUPPRESSION)
	End
	
	Method CreateScreenBank(app:DiddyApp)
		Self._screenBank = New ScreenBank(app)
		Self._screenBank.AddScreen(New EmptyScreen(Screen.EMPTY_SCREEN))
		Self._screenBank.AddScreen(New ExitScreen(Screen.EXIT_SCREEN))
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
	
	Property DebugOn:Bool()
		Return _debugOn
	Setter (debugOn:Bool)
		_debugOn = debugOn
	End	
  
	Method GenerateSeed()
		SeedRnd(Millisecs())
	End
	
	Method Start(screen:Screen)
		Local s:Screen = _screenBank.GetScreen(Screen.EMPTY_SCREEN)
		s.SetDestinationScreen(screen)
		s.AllowUpdatesInFade = True
		NextScreen = screen
		s.PreStart(ScreenFade.FADE_IN, 0)
	End
	
	Method GameLogic(fixedRate:Float)
		If _screenFade.Active
			_screenFade.Update(fixedRate)
		End
		If _currentScreen
			If Not _screenFade.Active Or _currentScreen.AllowUpdatesInFade
				_currentScreen.Update(fixedRate)
			End
		End
	End
	
	Method GameRender(canvas:Canvas, tween:Float)
		If _currentScreen
			_currentScreen.Render(canvas, tween)
		End
		If _screenFade.Active
			_screenFade.Render(canvas)
		End
		If _currentScreen
			_currentScreen.PostRender(canvas, tween)
		End
		RenderDebug(canvas)
	End
	
	Method RenderDebug(canvas:Canvas)
		If _debugOn
			GameTime.ShowFPS(0, canvas.Viewport.Height, canvas)
			GameTime.ShowSpikeSuppression(canvas.Viewport.Width - 230, canvas.Viewport.Height, canvas)
			
			Local x:Int = 0
			Local y:Int = 0
			Local gap:Int = canvas.Font.Height
			canvas.DrawText("Current Screen: " + _currentScreen.Name, x, y)
			y += gap
			canvas.DrawText("Sound Volume  : " + DiddyApp.GetInstance().SoundVolume, x, y)
			y += gap
			canvas.DrawText("Music Volume  : " + DiddyApp.GetInstance().MusicVolume, x, y)
		End
	End
	
	Method OnRender(canvas:Canvas) Override
		App.RequestRender()
		Local delta:Float = GameTime.ProcessTime()
		While GameTime.LogicUpdateRequired()
			GameLogic(GameTime.GetLogicFPS())
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
	
	Property ScrollX:Float()
		Return _scrollX
	Setter(scrollX:Float)
		_scrollX = scrollX
	End
	
	Property ScrollY:Float()
		Return _scrollY
	Setter(scrollY:Float)
		_scrollY = scrollY
	End
	
	Property MaxScrollX:Float()
		Return _maxScrollX
	Setter(maxScrollX:Float)
		_maxScrollX = maxScrollX
	End
	
	Property MaxScrollY:Float()
		Return _maxScrollY
	Setter(maxScrollY:Float)
		_maxScrollY = maxScrollY
	End
	
	Method Scroll(amountX:Float, amountY:Float = 0)
		_scrollX += amountX
		_scrollY += amountY
		_scrollX = Clamp(_scrollX, 0.0, _maxScrollX)
		_scrollY = Clamp(_scrollY, 0.0, _maxScrollY)
	End
End