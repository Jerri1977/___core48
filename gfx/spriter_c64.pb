OpenConsole()
UsePNGImageDecoder() 
UsePNGImageEncoder() 

result=CountProgramParameters()

If  result=0
  PrintN("SpriterC64 by Jerri/RedTriangle")
  PrintN("Converting utility for Core Engine")
  PrintN("Usage: SpriterC64.exe filename.png")

  Delay(1000)  
  End
  Else
  file$=ProgramParameter()
  result-1
EndIf

name$=Left(file$,Len(file$)-4)

sprh=21

Dim col.l(3)

col(1)=RGB(000,000,000)
col(2)=RGB(255,255,255)
col(3)=RGB(255,  0,  0)


PrintN("Loading file "+file$)  
LoadImage(0,file$+".png")
width=ImageWidth(0)
height=ImageHeight(0) 

sprites=Int(height/sprh)

PrintN("sprites found:"+Str(sprites))

StartDrawing(ImageOutput(0))

CreateFile(1,file1$+".a80")
WriteStringN(1,";spriteset: "+file$+", "+Str(sprites)+" sprites")

Date$ = FormatDate("%yyyy/%mm/%dd", Date())
Time$ = FormatDate("%hh:%ii:%ss", Date())

WriteStringN(1,";auto created "+date$+" "+time$)
  
For z=0 To sprites-1
  maxY=sprh
  maxX=width
  
  PrintN(Str(maxY)+"x"+Str(maxX)) 
 
 label$=name$+"_"+RSet(Str(z),3,"0")
 WriteStringN(1,label$)

   For  y=0 To maxY-1
     line$=Chr(9)+"db"+Chr(9)
     For  x=0 To (maxx/8)-1
     sprt=0
     mask=0
     For xx=0 To 7
       color=Point(xx+x*8,z*sprh+y)
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
 
Next z
CloseFile(1)
    StopDrawing()
CloseConsole()
; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 9
; EnableXP
; Executable = spriterC64.exe
; DisableDebugger
; CurrentDirectory = D:\_work\PureBasic461\
; Compiler = PureBasic 4.61 (Windows - x86)