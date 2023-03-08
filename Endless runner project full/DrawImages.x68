*================================================================================*  
*================================================================================*
* Written by : Steve Fasoranti                                                   *
* Student Number: C00275756                                                      *
* Description: This here is where we declare all the images using innerloops     *
*              and outter loops to reroll the image in the game with its sprites *
*            We then use draw image to draw the images we decared in the Main.x68*
*            In the program we have (sp) which is a stack pointer where we ensure* 
*          that the program is adding right data into the stack and not somewhere* 
*            else.                                                               *
*================================================================================*
*================================================================================*
*.----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
*| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
*| |  ________    | || |  _______     | || |      __      | || | _____  _____ | || |   ______     | || |     _____    | || |  ____  ____  | || |  _________   | || |   _____      | || |    _______   | |
*| | |_   ___ `.  | || | |_   __ \    | || |     /  \     | || ||_   _||_   _|| || |  |_   __ \   | || |    |_   _|   | || | |_  _||_  _| | || | |_   ___  |  | || |  |_   _|     | || |   /  ___  |  | |
*| |   | |   `. \ | || |   | |__) |   | || |    / /\ \    | || |  | | /\ | |  | || |    | |__) |  | || |      | |     | || |   \ \  / /   | || |   | |_  \_|  | || |    | |       | || |  |  (__ \_|  | |
*| |   | |    | | | || |   |  __ /    | || |   / ____ \   | || |  | |/  \| |  | || |    |  ___/   | || |      | |     | || |    > `' <    | || |   |  _|  _   | || |    | |   _   | || |   '.___`-.   | |
*| |  _| |___.' / | || |  _| |  \ \_  | || | _/ /    \ \_ | || |  |   /\   |  | || |   _| |_      | || |     _| |_    | || |  _/ /'`\ \_  | || |  _| |___/ |  | || |   _| |__/ |  | || |  |`\____) |  | |
*| | |________.'  | || | |____| |___| | || ||____|  |____|| || |  |__/  \__|  | || |  |_____|     | || |    |_____|   | || | |____||____| | || | |_________|  | || |  |________|  | || |  |_______.'  | |
*| |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
*| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
* '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 

PenColorCode      EQU     80 ;Use the pen to draw the image
DrawPixelCode     EQU     82 ;Draw the pixels in the game (assets and sprites)
ScreenChangeCode  EQU     33 ;Used to change the resolution


*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Draw the chucnks of the image-----------------*
*------------------------------------------------------------*
*------------------------------------------------------------*
DrawChunk
        move.l  4(sp), a0               ;Stores the pointer so we can grab image access
        move.l  10(a0), d0              ;get the header of the image
        rol.w   #8, d0                  ;rotate the image so it mot upside down          
        swap    d0                      ;we swap so that the image can fully rotate
        rol.w   #8, d0                  ;we then rotate again so that the value of the image can be stored
        add.w   d0, a0                  add the position from memory into data
        

*------------------------------------------------------------*
*------------------------------------------------------------*
*----------Draw begining position of the chunk from Y--------*
*------------------------------------------------------------*
*------------------------------------------------------------*        
    
        clr.l   d4
        move.l  36(sp),d4
        move.l  20(sp), d5
        add.l   12(sp), d5
        sub.l   d5, d4
        clr.l   d5
        move.w  d4, d5
        clr.l   d4
        
        move.l  32(sp), d4
        
        mulu.w  d4, d5
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--Add the position in the current address to draw the chunk-*
*------------------------------------------------------------*
*------------------------------------------------------------*

        add.l   d5, a0
        add.l   d5, a0 
        add.l   d5, a0       
        move.l  12(sp), d3
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------We set the x counter for the loop-------------*
*------------------------------------------------------------*
*------------------------------------------------------------*        
        
OUTERLOOP
        move.w  #0, d6                  
        move.l  16(sp), d4
        mulu.w  #3, d4
        add.w   d4, a0                  
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------We reset the x counter for the other loop-----*
*------------------------------------------------------------*
*------------------------------------------------------------*
INNERLOOP
        clr.l   d4                      ;make sure we clear d4
        move.b  (a0)+,d4                ;indicate the first pixel of the image loop
        swap.w  d4                      ;swap the pixel so we change its position
        clr.l   d5                      ;we now clear d5 (so the image can load into it)
        move.l  d4, d5                  ;store previously found pixel data in d5 for next value
        clr.l   d4                      ;clear d4 
        move.b  (a0)+, d4               ;get the memorys next bit
        lsl     #8, d4                  ;we use logical shift left to get pixel in top of second word to combine with previous pixel bit
        add.l   d4, d5                  ;combine the data
        clr.l   d4                      ;clear d4 once again
        move.b  (a0)+, d4               ;use that last bits
        add.l   d4, d5                  ;combine it to the end of the previous two bits to get the pixel value
        
        
        clr.l   d4                      ;If pixel isnt pink, do not draw it as we declared pink backgrounds as a colour 
        move.b  $FF, d4
        swap    d4
        move.b  $FF, d4
        
        cmp     d4, d5
        BEQ     INCREMENT
        
        BRA     DRAWPIXEL               ;pixel meets criteria and can be printed

*------------------------------------------------------------*
*------------------------------------------------------------*
*---We increment the image so we find an empty address to use*
*------------------------------------------------------------*
*------------------------------------------------------------*        
INCREMENT
        clr.l   d4                      ;make sure d4 is empty for use  
        add.w   #1,d6                   ;increment x counter by one
        

        move.l  16(sp), d4
        add.l   d6, d4
        move.l  32(sp), d5
        cmp     d5, d4
        BEQ     INCREMENTY
      
        move.l  8(sp), d4               ;move width of image into register
        cmp     d4, d6                  ;see if counter is beyond x bounds
        BNE     INNERLOOP               ;if it is not, loop again
        

        clr.l   d4
        move.l  16(sp), d4
        add.l   8(sp), d4
        clr.l   d5
        move.l  32(sp), d5
        sub.l   d4, d5
        mulu.w  #3, d5
  
        add.l   d5, a0    ;add an offest to the address
        
        
*-----------------------------------------------------------------------------------------------*
*-----------------------------------------------------------------------------------------------*
*--------------We now use the padding variable to increment the image into centre---------------*
*-----------------------------------------------------------------------------------------------*
*-----------------------------------------------------------------------------------------------*
INCREMENTY        

        add.l   Padding, a0             ;add padding.  If there is none, the address won't skip anything
        
        sub.w   #1, d3                  ;decrement y counter to see if you are out of the y iteration
        BNE     OUTERLOOP               ;if it is not, loop back to outer loop
        BRA     ENDROUTINE              ;branch to end of subroutine, whole image has been iterated
        
        
*--------------------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------------------*
*--------------Use the pen color code and draw pixel code to draw the image------------------*
*--------------------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------------------*
DRAWPIXEL
        move.l  d5, d1                  ;move pixel data into d1 for pen color
        move.l  #PenColorCode, d0       ;set trap code for setting the pen color
        trap    #15                     ;set pen color
                         
        move.l   24(sp), d1             ;store the starting x position of the chunk
        add.l    d6, d1                 ;add iteration position of x to start of chunk
        
        move.l  28(sp), d2              ;start at top of chunk to flip image
        add.l   d3, d2                  ;subtract current y position
        move.l  #DrawPixelCode, d0      ;Set trap code to draw pixel at position
        trap    #15                     ;draw pixel at position
        
        BRA     INCREMENT               ;increment position
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*---------Branch back to the end of the program--------------*
*------------------------------------------------------------*
*------------------------------------------------------------*
        
ENDROUTINE
        rts                             ;branch back to end of program


*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Draw the images declared in the Main.x68------*
*------------------------------------------------------------*
*------------------------------------------------------------*
DRAWIMAGE

        ;Reset the padding
        move.l  #0, Padding
        
        move.l  #36, d0                 ;number of 7 4 byte arguments to prepare stack to receive
        sub.l   d0, sp                  ;prepare stack to receive arguments 
        
        move.l  a0, (sp)                ;load pointer to the .bmp file onto the stack
        
        ;store width of chunk on the stack
        move.l  d1, 4(sp)
        ;store height of the chunk on the stack 
        move.l  d2, 8(sp)               
        
        ;add start of chunk to move with image
        move.l   d5, 12(sp)             ;store Top left x of draw chunk on stack
        
        ;subtract y position from height to get start y
        move.l  d6, 16(sp)              ;store Top left y of draw chunk on stack                      

        move.l  d3, 20(sp)              ;store Beginning print location for x axis on stack
        move.l  d4, 24(sp)              ;store Beginning print location for y axis on stack
        
        move.l  18(a0), d1              ;get width of image from .bmp file
        rol.w   #8, d1          
        swap    d1
        rol.w   #8, d1                  ;rotate and swap long word to get true width value to use later
        move.l  d1, 28(sp)              ;store width of image to make variable not global

        
   
        move.l  #4, d2                  ;move the value 4 into d2 for padding calculation
        mulu.w  #3, d1                  ;multiply image width by 3 for formula
        divu.w  #4, d1                  ;divide by four to find remainder
        swap    d1                      ;swap remainder into lower word
        clr.l   d4                      ;make sure d4 is empty
        move.w  #0, d4                  ;move 0 into d4 
        cmp.w   d1, d4                  ;if equal, there is no padding
        BEQ     RUNPROGRAM              ;continue in program for special case of being divisible by 4
        
        
*--------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*
*--------------Store the height and width padding for the image------------------*
*--------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*        
ACCOUNTFORPADDING
        sub.w   d1, d2                  ;subtract remainder from 4 to get padding
        move.l  d2, Padding             ;store padding for later use
        
        
*---------------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------------*
*--------------We now run the program and get the image file declared ------------------*
*---------------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------------*        
RUNPROGRAM       
        move.l  22(a0), d2              ;get the height of our bmp file we delared 
        rol.w   #8, d2          
        swap    d2
        rol.w   #8, d2                  ;rotate and swap long
        move.l  d2, 32(sp)              ;store the height of the image so that its a varible delcared and not a global image

        jsr     DrawChunk               ;we then call the subroutine of the image stack  
       
        clr.l   d0
        move.l  #36, d0                
        add.l   d0, sp                  ;we finally fix the stack into screen
        
        clr.l   d7
        
        rts

Padding
        dc.l    0                       ;Place the image into the centre 



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
