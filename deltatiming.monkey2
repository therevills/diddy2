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

Class FixedRateLogicTimer
	Field newTime:Double = Millisecs()
	Field oldTime:Double = Millisecs()
	Field delta:Float
	Field dssOn:Int		' do we use delta spike suppression?
	Field dssIndex:Int		' index into DSS_Array where next delta value is written
	Field dssArray:Float[]	' this array contains the delta values to smooth
	Field dssLenArray:Int	' how big is the array of delta values

	Field logicFPS:Float
	Field accumulator:Float, tween:Float
	
	Field fpsAccumulator:Float
	Field updateCount:Int
	Field renderCount:Int
	Field updatesPerSecond:Int
	Field rendersPerSecond:Int
	
	Method New(logicCyclesPerSecond:Float, numSamples:Int = 0)
		logicFPS = 1.0 / logicCyclesPerSecond
		Print "logicFPS = " + logicFPS
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
	
	Method GetLogicFPS:Float()
		Return logicFPS
	End
	
	Method GetTween:Float()
		renderCount += 1
		Return accumulator / logicFPS
	End

	Method ShowSpikeSuppression(x:Int, y:Int, canvas:Canvas)
		canvas.DrawText("Delta Spike Suppressor:", x, y)
		canvas.DrawText("Final Delta: " + delta, x, y + 20)
	End
	
	Method ShowFPS(x:Int, y:Int, canvas:Canvas, showUpdateFPS:Int = True, showRenderFPS:Int = True)
		Local ty:Int = y
		
		If showUpdateFPS
			canvas.DrawText("Logic FPS:  " + updatesPerSecond, x, ty)
			ty += 20
		End
		If showRenderFPS
			canvas.DrawText("Render FPS: " + rendersPerSecond, x, ty)
		End
	End
End