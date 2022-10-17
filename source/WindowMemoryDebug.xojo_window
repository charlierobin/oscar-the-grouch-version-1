#tag Window
Begin Window WindowMemoryDebug
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   0
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   782143487
   MenuBarVisible  =   True
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Memory"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin TextArea TextAreaLog
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF00
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      FontName        =   "SmallSystem"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   360
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   560
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  self.run()
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub run()
		  dim d as Dictionary
		  dim i, count as Integer
		  dim s, out as string
		  dim SortArray(0) as string
		  dim cr as string = chr(13) + chr(10)
		  
		  count = Runtime.ObjectCount - 1
		  out = "Object Count: " + str( count+1) + cr
		  out=out+ "Memory Used: " + format( Runtime.MemoryUsed, "#,") + cr + cr
		  
		  d = new Dictionary
		  
		  for i = 0 to count
		    
		    s = Runtime.ObjectClass( i)
		    
		    if d.HasKey( s) then
		      d.value( s) =  d.Value( s) + 1
		    else
		      d.Value( s) = 1
		    end if
		  next
		  
		  count = d.Count - 1
		  Redim SortArray( count)
		  
		  for i = 0 to count
		    SortArray( i) = Format( d.Value( d.Key( i)), "000000") + ":" + d.Key( i)
		  next
		  
		  SortArray.Sort
		  
		  for i = 0 to count
		    out = out + NthField( SortArray( i), ":", 1) + " " + NthField( SortArray( i), ":", 2) + cr
		  next
		  
		  TextAreaLog.AppendText( out)
		  
		  
		End Sub
	#tag EndMethod


#tag EndWindowCode

