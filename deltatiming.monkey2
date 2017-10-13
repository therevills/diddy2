Namespace diddy2.deltatimer

Class DeltaTimer
	Field targetfps:Float = 60
	Field currentticks:Float
	Field lastticks:Float
	Field frametime:Float
	Field delta:Float
	
	Method New(fps:Float)
		targetfps = fps
		lastticks = Millisecs()
	End
	
	Method UpdateDelta()
		currentticks = Millisecs()
		frametime = currentticks - lastticks
		delta = frametime / (1000.0 / targetfps)
		If delta > 5
			delta = 1
		End
		lastticks = currentticks
	End
End

' http://www.rightanglegames.com/top-down-shooter-tutorial-with-blitzmax.html
Class FixedRateLogicTimer
	Field newTime:Double = Millisecs()
	Field oldTime:Double = Millisecs()
	Field delta:Float
	Field dssOn:Int			' do we use delta spike suppression?
	Field dssIndex:Int		' index into DSS_Array where next delta value is written
	Field dssArray:Float[]	' this array contains the delta values to smooth
	Field dssLenArray:Int	' how big is the array of delta values

	Field logicFPS:Float
	Field accumulator:Float
	Field tween:Float
	
	Field fpsAccumulator:Float
	Field updateCount:Int
	Field renderCount:Int
	Field updatesPerSecond:Int
	Field rendersPerSecond:Int
	Field logicCyclesPerSecond:Float
	
	Method New(logicCyclesPerSecond:Float, numSamples:Int = 0)
		Self.logicCyclesPerSecond = logicCyclesPerSecond
		logicFPS = 1.0 / logicCyclesPerSecond
		If numSamples
			dssOn = True
			dssArray = New Float[numSamples]
			dssLenArray = numSamples
		End
	End	
	
	Method ProcessTime:Float()
		newTime = Millisecs()
		delta = Float (newTime - oldTime) * 0.001
		oldTime = newTime
		
		If dssOn
			dssArray[dssIndex] = delta
			
			Local smoothDelta:Float = 0
			
			For Local i:Int = 0 To dssLenArray - 1
				smoothDelta += dssArray[i]
			Next
			delta = Float(smoothDelta / dssLenArray)
			
			dssIndex += 1
			If dssIndex > dssLenArray - 1 Then dssIndex = 0
		End
		
		accumulator += delta
		
		fpsAccumulator += delta

		If fpsAccumulator > 1.0
			fpsAccumulator -= 1.0
			updatesPerSecond = updateCount
			updateCount = 0
			rendersPerSecond = renderCount
			renderCount = 0
		End
		Return delta
	End
	
	Method LogicUpdateRequired:Int()
		If accumulator > logicFPS
			updateCount += 1
			accumulator -= logicFPS
			Return True
		End
		Return False
	End
	
	Method CalcFrameTime:Float(ms:Float)
		Local amount:Float = updatesPerSecond
		If amount = 0
			amount = logicCyclesPerSecond
		End
		' convert Hz to ms
		Local msPerFrame:Float = 1000.0 / amount
		' convert ms to frame time
		Local rv:Float = ms / msPerFrame
		Return rv
	End
	
	Method GetLogicFPS:Float()
		Return logicFPS
	End
	
	Method GetTween:Float()
		renderCount += 1
		Return accumulator / logicFPS
	End

	Method ShowSpikeSuppression(x:Int, y:Int, canvas:Canvas)
		Local ty:Int = y - (canvas.Font.Height * (3 + Self.dssLenArray))
		canvas.DrawText("Delta Spike Suppressor:", x, ty)
		ty += canvas.Font.Height
		For Local i:Int = 0 To Self.dssLenArray - 1
			canvas.DrawText(dssArray[i], x, ty)
			ty += canvas.Font.Height
		Next
		
		ty += canvas.Font.Height
		canvas.DrawText("Final Delta: " + delta, x, ty)
	End
	
	Method ShowFPS(x:Int, y:Int, canvas:Canvas, showUpdateFPS:Int = True, showRenderFPS:Int = True)
		Local ty:Int = y - (canvas.Font.Height * 2)
		
		If showUpdateFPS
			canvas.DrawText("Logic FPS:  " + updatesPerSecond, x, ty)
			ty += canvas.Font.Height
		End
		If showRenderFPS
			canvas.DrawText("Render FPS: " + rendersPerSecond, x, ty)
		End
	End
End