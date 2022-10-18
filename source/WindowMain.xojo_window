#tag Window
Begin Window WindowMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   False
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   Height          =   128
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   782143487
   MenuBarVisible  =   True
   MinimumHeight   =   128
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "Oscar The Grouch"
   Type            =   4
   Visible         =   True
   Width           =   64
   Begin Timer TimerForAnimation
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   80
      RunMode         =   0
      Scope           =   2
      TabPanelIndex   =   0
   End
   Begin SizingThumb Sizing
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      Height          =   10
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   54
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   119
      Transparent     =   True
      Visible         =   True
      Width           =   10
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  App.preferencesJSON.Value( "Left" ) = self.Left
		  
		  App.preferencesJSON.Value( "Top" ) = self.Top
		  
		  App.preferencesJSON.Value( "Width" ) = self.Width
		  
		  App.preferencesJSON.Value( "Height" ) = self.Height
		  
		  App.w = nil
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  if self.preview then
		    
		    self.startX = X
		    
		    self.startY = Y
		    
		    self.lastX = X
		    
		    self.lastY = Y
		    
		    return true
		    
		  end if
		  
		  return false
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  if self.lastX = X and self.lastY = Y then return
		  
		  self.lastX = X
		  
		  self.lastY = Y
		  
		  self.TrueWindow.Left = self.TrueWindow.Left + X - self.startX
		  
		  self.TrueWindow.Top = self.TrueWindow.Top + Y - self.startY
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  self.makeWindowTransparent()
		  
		  self.noShadow()
		  
		  self.path = SpecialFolder.Resources.NativePath
		  
		  if not self.preview then
		    
		    // self.setLevel( NSDesktopWindowLevel )
		    
		    self.setLevel( NSOverlayWindowLevel )
		    
		    self.Sizing.Enabled = false
		    
		    self.Sizing.Visible = false
		    
		    self.playAnimation()
		    
		  else
		    
		    // self.imageCache = Picture.Open( SpecialFolder.Resources.Child( kPreviewFrameIndex.ToString( Locale.Current, "00" ) + ".png" ) )
		    
		    self.imageCache = Picture.Open( new FolderItem( self.path + "/" + kPreviewFrameIndex.ToString( Locale.Current, "00" ) + ".png", FolderItem.PathModes.Native ) )
		    
		  end if
		  
		  if Keyboard().AsyncCommandKey then
		    
		    self.Width = self.MinimumWidth
		    
		    self.Height = self.MinimumHeight
		    
		    self.Left = App.preferencesWindow.Left + App.preferencesWindow.Width + 20
		    
		    self.Top = App.preferencesWindow.Top
		    
		  else
		    
		    if App.preferencesJSON.HasKey( "Width" ) then
		      
		      self.Width = App.preferencesJSON.Value( "Width" )
		      
		      self.Height = App.preferencesJSON.Value( "Height" )
		      
		    end if
		    
		    if App.preferencesJSON.HasKey( "Left" ) then
		      
		      self.Left = App.preferencesJSON.Value( "Left" )
		      
		      self.Top = App.preferencesJSON.Value( "Top" )
		      
		    else
		      
		      self.Left = App.preferencesWindow.Left + App.preferencesWindow.Width + 20
		      
		      self.Top = App.preferencesWindow.Top
		      
		    end if
		    
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  if self.imageCache = nil then return
		  
		  g.DrawPicture( self.imageCache, 0, 0, g.Width, g.Height, 0, 0, self.imageCache.Width, self.imageCache.Height )
		  
		  
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function CloseWindow() As Boolean Handles CloseWindow.Action
			self.Close()
			
			return true
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub Constructor(preview as Boolean)
		  self.preview = preview
		  
		  super.Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub playAnimation()
		  self.index = 0
		  
		  self.TimerForAnimation.RunMode = Timer.RunModes.Multiple
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private f As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private imageCache As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private index As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private path As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private preview As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private startX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private startY As Integer
	#tag EndProperty


	#tag Constant, Name = kLastFrameIndex, Type = Double, Dynamic = False, Default = \"39", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPreviewFrameIndex, Type = Double, Dynamic = False, Default = \"14", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events TimerForAnimation
	#tag Event
		Sub Action()
		  if self.index > kLastFrameIndex then
		    
		    self.Close()
		    
		  else
		    
		    var name as String = self.index.ToString( Locale.Current, "00" )
		    
		    // self.f = SpecialFolder.Resources.Child( name + ".png" )
		    
		    self.f = new FolderItem( self.path + "/" + name + ".png", FolderItem.PathModes.Native )
		    
		    self.imageCache = Picture.Open( self.f )
		    
		    self.Invalidate()
		    
		    self.index = self.index + 1
		    
		  end if
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Sizing
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  g.DrawingColor = Color.Black
		  
		  g.FillRectangle( 0, 0, g.Width, g.Height )
		  
		  
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
