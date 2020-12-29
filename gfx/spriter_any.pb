OpenConsole()
UsePNGImageDecoder() 
UsePNGImageEncoder() 

addsize=0

result=CountProgramParameters()

If  result=0
  PrintN("Spriter by Jerri/RedTriangle")
  PrintN("Converting utility for Core Engine")
  PrintN("Usage: Spriter.exe filename.png [flags]")
  PrintN("flags: /addsize")

  Delay(1000)  
  End
  Else
  file$=ProgramParameter()
  result-1
EndIf

  While result<>0
    
    result-1
    result$=ProgramParameter()
    
    Select  UCase(result$)
      Case  "/ADDSIZE"
        addsize=1
        
      Default
        PrintN("Wrong parameter: "+result$)
        Input()
        End
    EndSelect
   Wend
      
  name$=Left(file$,Len(file$)-4)
  
  
Dim col.l(4)

col(1)=RGB(000,000,000)
col(2)=RGB(255,255,255)
col(3)=RGB(255,  0,  0)
col(4)=RGB(  0,255,  0)

file1$=file$

PrintN("Loading file "+file$)  
LoadImage(0,file$)
width=ImageWidth(0)
height=ImageHeight(0) 

StartDrawing(ImageOutput(0))

CreateFile(1,file1$+".a80")
WriteStringN(1,";spriteset: "+file$+" sprites")

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
  
  
  Repeat
    color=Point(0,tempY)
    count-1
    tempY+1
    If color<>col(4)
      maxY+1
    EndIf
    
  Until color=col(4) Or count=0
  
  PrintN(Str(maxY)+"x"+Str(maxX)) 
 
  label$=name$+"_"+RSet(Str(z),3,"0")
  z+1
  
  WriteStringN(1,label$)
  line$=Chr(9)+"db"+Chr(9)+Str(maxY)+","+Str(maxX/8)
  If  addsize=0
    line$=";"+line$
  EndIf
   WriteStringN(1,line$)
     For  y=0 To maxY-1
     line$=Chr(9)+"db"+Chr(9)
     For  x=0 To (maxx/8)-1
     sprt=0
     mask=0
     For xx=0 To 7
       color=Point(xx+x*8,currY+y)
           sprt*2
           mask*2
       Select color
         Case col(1)  ;dot 0
           sprt+1
           mask+1
         Case col(2)  ;dot 1
           mask+1
         Case col(3)  ;transparent
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
; ExecutableFormat = Console
; CursorPosition = 11
; EnableXP
; Executable = ..\..\_KnG\c64_data\c64ripper.exe
; DisableDebugger
; CurrentDirectory = D:\_work\PureBasic461\
; Compiler = PureBasic 4.61 (Windows - x86)