UsePNGImageDecoder() 
UsePNGImageEncoder() 

addsize=0

result=CountProgramParameters()

If  result=0
  If InitSprite() And InitKeyboard() And OpenWindow(0, 0, 0, 400,200, "Core Spriter 1.0", #PB_Window_SystemMenu |  #PB_Window_TitleBar     | #PB_Window_ScreenCentered)
    OpenWindowedScreen(WindowID(0), 0, 0, 280, 200, 0, 0, 0)
    EnableWindowDrop(0,#PB_Drop_Files,#PB_Drag_Copy)
      ClearScreen(RGB(0, 0, 31))
      If StartDrawing(ScreenOutput())
        DrawingMode(1)
        FrontColor(RGB(128, 255, 0))
        DrawText( 60, 10, "Universal Sprite extractor")
        DrawText( 10, 25, "(c)2021 Jerri/RT")
        DrawText( 10, 50, "Usage: Spriter.exe filename.png [flags]")
        DrawText( 10, 70, "flags: /height add sprite height to output")
        DrawText( 10, 90, "flags: /length add sprite length to output")
        DrawText(10, 110, "flags: /cutup  trims the empty top edge")
        DrawText(10, 130, "flags: /cutright trims the empty right edge")
        DrawText(10, 150, "flags: /andor make classic masked pairs")
        DrawText(90, 180, "drop sprite set here")
        StopDrawing()
        redraw=1
      EndIf
      ;ширина спрайта
      
      CheckBoxGadget(1,300, 70,20*4,20,"Height")
      CheckBoxGadget(2,300, 90,20*4,20,"Length")
      CheckBoxGadget(3,300,110,20*4,20,"Cut Up")
      CheckBoxGadget(4,300,130,20*4,20,"Cut Right")
      CheckBoxGadget(5,300,150,20*4,20,"And Or")
      
      Repeat
        If redraw
          FlipBuffers()
          redraw=0
        EndIf
        Event = WindowEvent() 
        
        Select event
          Case #PB_Event_CloseWindow
            End
          Case #PB_Event_Menu
            value=EventMenu()
            
            
            
            
            
      EndSelect
  
    
    Until Event = #PB_Event_WindowDrop
            file$ = EventDropFiles()
            file$ = StringField(File$, 1, Chr(10))
            ;поймали файл                      
  EndIf
  
  If GetGadgetState(1)=#PB_Checkbox_Checked
        addhigh=1
  EndIf
  If GetGadgetState(2)=#PB_Checkbox_Checked
        addlen=1
  EndIf
  If GetGadgetState(3)=#PB_Checkbox_Checked
        cutup=1
  EndIf
  If GetGadgetState(4)=#PB_Checkbox_Checked
        cutright=1
  EndIf
  If GetGadgetState(5)=#PB_Checkbox_Checked
        andor=1
  EndIf
    
  CloseWindow(0)
  OpenConsole()
  Else
  file$=ProgramParameter()
  result-1


While result<>0
    
    result-1
    result$=ProgramParameter()
    
    Select  UCase(result$)
      Case  "/HIGH"
        addhigh=1
      Case  "/LENGTH"
        addlen=1
      Case  "/CUTUP"
        cutup=1
      Case  "/CUTRIGHT"
        cutright=1
      Case  "/ANDOR"
        andor=1
      Default
        PrintN("Wrong parameter: "+result$)
        Input()
        End
    EndSelect
   Wend
EndIf
      
  name$=Left(file$,Len(file$)-4)
  
  While FindString(name$,"\")<>0
    pos=FindString(name$,"\")
    name$=Right(name$,Len(name$)-pos)
  Wend
  
  
;Dim col.l(4)
;col(1)=RGB(000,000,000)
;col(2)=RGB(255,255,255)
;col(3)=RGB(255,  0,  0)
;col(4)=RGB(  0,255,  0)

file1$=file$

PrintN("Loading file "+file$)  
LoadImage(0,file$)
width=ImageWidth(0)
height=ImageHeight(0) 

StartDrawing(ImageOutput(0))

CreateFile(1,file1$+".a80")
WriteStringN(1,";spriteset: "+name$)

Date$ = FormatDate("%yyyy/%mm/%dd", Date())
Time$ = FormatDate("%hh:%ii:%ss", Date())

WriteStringN(1,";auto created "+date$+" "+time$)

count=height


tempY=0
z=0

Repeat
  
  currY=tempY
  maxY=0
  maxX=width
  
;считаем высоту текущего спрайта
  Repeat
    color=Point(0,tempY)
    count-1
    tempY+1
    
    If  Red(color)<63 And Blue(color)<63 And Green(color)>127
      color=4
    Else
      color=0
    EndIf
    
    If color<>4
      maxY+1
    EndIf
    
  Until color=4 Or count=0
 ;------------------------------
  
  PrintN(Str(maxY)+"x"+Str(maxX)) 
 
  label$=name$+"_"+RSet(Str(z),3,"0")
  z+1
  
  WriteStringN(1,label$)
  If  addhigh=1
  line$=Chr(9)+"db"+Chr(9)+Str(maxY)+Chr(9)+";high"
  WriteStringN(1,line$)
  EndIf
  
  If  addlen=1
  line$=Chr(9)+"db"+Chr(9)+Str(maxX/8)+Chr(9)+";len"
  WriteStringN(1,line$)
  EndIf
  

  
     For  y=0 To maxY-1
     line$=Chr(9)+"db"+Chr(9)
     For  x=0 To (maxx/8)-1
     sprt=0
     mask=0
     For xx=0 To 7
       color=Point(xx+x*8,currY+y)
       
       If Red(color)>127 And Green(color)<127 And Blue(color)<127 ;color red = mask
         tempcolor=3
       EndIf
       
       If Red(color)<127 And Green(color)<127 And Blue(color)<127 ;color black=sprite
         tempcolor=1
       EndIf
       
       If Red(color)>127 And Green(color)>127 And Blue(color)>127 ;color white=mask 
         tempcolor=2
       EndIf
       color=tempcolor
       
           sprt*2
           mask*2
       Select color
         Case 1  ;dot 0
           sprt+1
           mask+1
         Case 2  ;dot 1
           mask+1
         Case 3  ;transparent
         Default
           PrintN("wrong color "+Hex(color)+" at "+Str(xx+x*8)+","+Str((z+1)*sprh-y))
           Input()
           End
       EndSelect
     Next xx
     line$+"#"+RSet(Hex(mask),2,"0")+",#"+RSet(Hex(sprt),2,"0")+","      
   Next x
   line$=RTrim(line$,",")
   WriteStringN(1,line$)
 Next y
 
Until  count=0

 CloseFile(1)
    StopDrawing()
  ;PrintN("Saving tiles "+file1$)  
  ;Result = SaveImage(1, file1$+".png", #PB_ImagePlugin_PNG)

;Input()
CloseConsole()
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 207
; FirstLine = 183
; EnableXP
; Executable = ..\..\_KnG\c64_data\c64ripper.exe
; CurrentDirectory = D:\_work\PureBasic461\
; Compiler = PureBasic 4.61 (Windows - x86)