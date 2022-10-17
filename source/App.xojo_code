#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Activate()
		  if Keyboard().AsyncCommandKey then 
		    
		    me.showPreferences()
		    
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Close()
		  me.savePreferences()
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function HandleAppleEvent(theEvent As AppleEvent, eventClass As String, eventID As String) As Boolean
		  if StrComp (eventClass, "AEco", 0) = 0 then
		    
		    if StrComp (eventID, "ShPr", 0) = 0 then
		      
		      me.showPreferences()
		      
		      return true
		      
		    end
		    
		    if StrComp (eventID, "ShAb", 0) = 0 then
		      
		      me.showAbout()
		      
		      return true
		      
		    end
		    
		    if StrComp (eventID, "ShOs", 0) = 0 then
		      
		      me.itsGrouchTime()
		      
		      return true
		      
		    end
		    
		  end if
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  me.loadPreferences()
		  
		  me.t = new TimerChecker()
		  
		  if Keyboard().AsyncCommandKey then 
		    
		    me.showPreferences()
		    
		  end if
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function getApplicationDataFolder() As FolderItem
		  // var f as FolderItem = SpecialFolder.ApplicationData.Child( me.getMainBundleIdentifier() )
		  
		  var f as FolderItem = new FolderItem( SpecialFolder.ApplicationData.NativePath + "/" + me.getMainBundleIdentifier(), FolderItem.PathModes.Native )
		  
		  if not f.Exists then
		    
		    f.CreateFolder()
		    
		  end if
		  
		  return f
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getMainBundleIdentifier() As String
		  const AppKit = "AppKit"
		  
		  declare function mainBundle lib AppKit selector "mainBundle" ( NSBundleClass as Ptr ) as Ptr
		  
		  declare function NSClassFromString lib AppKit ( className as CFStringRef ) as Ptr
		  
		  declare function getValue lib AppKit selector "bundleIdentifier" ( NSBundleRef as Ptr ) as CFStringRef
		  
		  var appId as String = getValue( mainBundle( NSClassFromString( "NSBundle" ) ) )
		  
		  return appId
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getPreferencesFile() As FolderItem
		  // return me.getApplicationDataFolder().Child( "preferences-v1.json" )
		  
		  return new FolderItem( me.getApplicationDataFolder().NativePath + "/" + "preferences-v1.json", FolderItem.PathModes.Native )
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub itsGrouchTime()
		  if me.w <> nil then return
		  
		  if Keyboard().AsyncCommandKey then return
		  
		  me.playAudio()
		  
		  if not me.preferencesJSON.Value( "animation" ) then return
		  
		  me.w = new WindowMain()
		  
		  // var memW as WindowMemoryDebug = new WindowMemoryDebug()
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub loadPreferences()
		  var data as String = ""
		  
		  try
		    
		    var t as TextInputStream = TextInputStream.Open( me.getPreferencesFile() )
		    
		    t.Encoding = Encodings.UTF8
		    
		    data = t.ReadAll()
		    
		    t.Close()
		    
		  catch e as IOException
		    
		    System.DebugLog( "Error preferences: " + e.Message )
		    
		  catch e as RuntimeException
		    
		    System.DebugLog( "Error preferences: " + e.Message )
		    
		  end try
		  
		  if data <> "" then
		    
		    me.preferencesJSON = new JSONItem( data )
		    
		  else
		    
		    me.preferencesJSON = new JSONItem( "{}" )
		    
		    me.preferencesJSON.Value( "animation" ) = true
		    
		    me.preferencesJSON.Value( "audio" ) = "both"
		    
		    me.preferencesJSON.Value( "vocalVolume" ) = 50
		    
		    me.preferencesJSON.Value( "musicVolume" ) = 10
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub playAudio()
		  if me.preferencesJSON.Value( "audio" ) = "none" then return
		  
		  var fVocals as FolderItem = nil
		  
		  var fMusic as FolderItem = nil
		  
		  // TODO
		  
		  if me.alternate then
		    
		    // fVocals = SpecialFolder.Resources.Child( "i love it because it's trash [vocals].mp3" )
		    
		    // fMusic = SpecialFolder.Resources.Child( "i love it because it's trash [music].mp3" )
		    
		    fVocals = new FolderItem( SpecialFolder.Resources.NativePath + "/" + "i love it because it's trash [vocals].mp3", FolderItem.PathModes.Native )
		    
		    fMusic = new FolderItem( SpecialFolder.Resources.NativePath + "/" + "i love it because it's trash [music].mp3", FolderItem.PathModes.Native )
		    
		  else
		    
		    // fVocals = SpecialFolder.Resources.Child( "i love trash [vocals].mp3" )
		    
		    // fMusic = SpecialFolder.Resources.Child( "i love trash [music].mp3" )
		    
		    fVocals = new FolderItem( SpecialFolder.Resources.NativePath + "/" + "i love trash [vocals].mp3", FolderItem.PathModes.Native )
		    
		    fMusic = new FolderItem( SpecialFolder.Resources.NativePath + "/" + "i love trash [music].mp3", FolderItem.PathModes.Native )
		    
		  end if
		  
		  me.alternate = not me.alternate
		  
		  if me.preferencesJSON.Value( "audio" ) = "vocal" then
		    
		    me.startPlayingAudioFile( fVocals, me.preferencesJSON.Value( "vocalVolume" ) )
		    
		  elseif me.preferencesJSON.Value( "audio" ) = "music" then
		    
		    me.startPlayingAudioFile( fMusic, me.preferencesJSON.Value( "musicVolume" ) )
		    
		  elseif me.preferencesJSON.Value( "audio" ) = "both" then
		    
		    me.startPlayingAudioFile( fVocals, me.preferencesJSON.Value( "vocalVolume" ) )
		    
		    me.startPlayingAudioFile( fMusic, me.preferencesJSON.Value( "musicVolume" ) )
		    
		  else
		    
		    // silence is golden
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub savePreferences()
		  me.preferencesJSON.Compact = false
		  
		  try
		    
		    var output as TextOutputStream = TextOutputStream.Create( me.getPreferencesFile() )
		    
		    output.Write( ConvertEncoding( me.preferencesJSON.ToString, Encodings.UTF8 ) )
		    
		    output.Close()
		    
		  catch e as IOException
		    
		    MessageBox( "Error preferences: " + e.Message )
		    
		  catch e as RuntimeException
		    
		    MessageBox( "Error preferences: " + e.Message )
		    
		  end try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub showAbout()
		  if me.aboutWindow is nil then
		    
		    me.aboutWindow = new WindowAbout()
		    
		  else
		    
		    me.aboutWindow.Show()
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub showPreferences()
		  if me.preferencesWindow is nil then
		    
		    me.preferencesWindow = new WindowPreferences()
		    
		  else
		    
		    me.preferencesWindow.Show()
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub startPlayingAudioFile(f as FolderItem, volume as Integer)
		  try
		    
		    var audio as Sound = Sound.Open( f )
		    
		    audio.Volume = volume
		    
		    audio.Play()
		    
		  catch error as IOException
		    
		    System.DebugLog( error.Message )
		    
		  end try
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		aboutWindow As WindowAbout
	#tag EndProperty

	#tag Property, Flags = &h21
		Private alternate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		preferencesJSON As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		preferencesWindow As WindowPreferences
	#tag EndProperty

	#tag Property, Flags = &h21
		Private t As TimerChecker
	#tag EndProperty

	#tag Property, Flags = &h0
		w As WindowMain
	#tag EndProperty


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
