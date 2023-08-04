B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.51
@EndOfDesignText@
'Author: Alexander Stolte
'Version: 1.0
'AS Ripple View

#DesignerProperty: Key: Duration, DisplayName: Animation Duration, FieldType: Int, DefaultValue: 800, Description: The Duration of the Ripple Animation. Default is 800.
#DesignerProperty: Key: FadeDuration, DisplayName: Fade Duration, FieldType: Int, DefaultValue: 3000, Description: The Duration of the Ripple Animation. Default is 3000.
#DesignerProperty: Key: RippleColor, DisplayName: Ripple Color, FieldType: Color, DefaultValue: 0xFF39569A, Description: The Color of the Ripple Effect.

'#Event: AnimationCompleted'comes with the next update

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As B4XView 'ignore
	Private xui As XUI 'ignore
	
	Private running As Boolean = False
	Private ripple_bmp As B4XBitmap
	
	'p = properties
	Private p_duration As Int
	Private p_fadeduration As Int
	Private p_color As Int
	
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base

#If B4A or B4I
mBase.SetColorAndBorder(xui.Color_Transparent,0,xui.Color_Transparent,mBase.width/2)

#End If


	ini_props(Props)

	CreateHaloEffect
	
	#If B4A
	Base_Resize(mBase.Width,mBase.Height)
	#End If

End Sub

Private Sub ini_props(Props As Map)
	
	p_duration = Props.Get("Duration")
	p_fadeduration = Props.Get("FadeDuration")
	p_color = xui.PaintOrColorToColor(Props.Get("RippleColor"))
	
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
  
	mBase.SetLayoutAnimated(0,mBase.Left,mBase.Top,Width,Height)
  
End Sub

#Region Properties

'Adds the View per code to the Parent (base)
Public Sub AddView(base As Object,duration As Int,fade_duration As Int, ripple_color As Int)
	
	Dim tmp_map As Map
	tmp_map.Initialize
	tmp_map.Put("Duration",duration)
	tmp_map.Put("FadeDuration",fade_duration)
	tmp_map.Put("RippleColor",ripple_color)
	
	Dim tmp_lbl As Label
	tmp_lbl.Initialize("")
	
	DesignerCreateView(base,tmp_lbl,tmp_map)
	
End Sub

Public Sub setDuration(duration As Int)
	
	p_duration = duration
	
End Sub

Public Sub getDuration As Int
	
	Return p_duration
	
End Sub

Public Sub setFadeDuration(duration As Int)
	
	p_fadeduration = duration
	
End Sub

Public Sub getFadeDuration As Int
	
	Return p_fadeduration
	
End Sub

Public Sub setRippleColor(color As Int)
	
	p_color = color
	
End Sub

Public Sub getRippleColor As Int
	
	Return p_color
	
End Sub

'Starts the animation
Public Sub Start
	
	running = True
	Effect
	
End Sub

'Stops the Animation
Public Sub Stop
	
	running = False
	
End Sub

'Checks the state of the animation
Public Sub getIsRunning As Boolean
	
	Return running
	
End Sub

'Applys the changes on the View for example: change color
Public Sub Apply
	
	CreateHaloEffect
	
End Sub

#End Region

#Region Functions
'https://www.b4x.com/android/forum/threads/b4x-xui-simple-halo-animation.80267/#content
Private Sub CreateHaloEffect
	
	Dim cvs As B4XCanvas
	Dim p As B4XView = xui.CreatePanel("")

		p.SetLayoutAnimated(0, 0, 0, mBase.Width/2 * 2, mBase.Width/2 * 2)
	cvs.Initialize(p)
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, cvs.TargetRect.Width / 2, p_color, True, 0)
	ripple_bmp= cvs.CreateBitmap
	
End Sub

Private Sub Effect
	
	Do While running = True
		CreateHaloEffectHelper(mBase, mBase.Width/2, mBase.Height/2, mBase.Width/2)
		Sleep(p_duration)
	Loop
	
End Sub

Sub CreateHaloEffectHelper (Parent As B4XView, x As Int, y As Int, radius As Int)
	Dim iv As ImageView
	iv.Initialize("")
	Dim p As B4XView = iv
	p.SetBitmap(ripple_bmp)
	Parent.AddView(p, x, y, 0, 0)
	p.SetLayoutAnimated(p_fadeduration, x - radius, y - radius, 2 * radius, 2 * radius)
	p.SetVisibleAnimated(p_fadeduration, False)
	Sleep(p_fadeduration)
	p.RemoveViewFromParent
End Sub

#End Region

