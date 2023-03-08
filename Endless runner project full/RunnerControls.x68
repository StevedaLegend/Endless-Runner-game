*================================================================================*  
*================================================================================*
* Written by : Steve Fasoranti                                                   *
* Student Number: C00275756                                                      *
* Description: Here we declare controls to the runner and the enemy itself and   *
*             we use SP to detect if a input is available or not and every letter*
*              so we can add controls into our runner                            *
*================================================================================*
*================================================================================*
*.----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.   .----------------.  .-----------------. .----------------.  .----------------.  .----------------. 
*| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. | | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
*| |   ______     | || |   _____      | || |      __      | || |  ____  ____  | || |  _________   | || |  _______     | | | |     _____    | || | ____  _____  | || |   ______     | || | _____  _____ | || |  _________   | |
*| |  |_   __ \   | || |  |_   _|     | || |     /  \     | || | |_  _||_  _| | || | |_   ___  |  | || | |_   __ \    | | | |    |_   _|   | || ||_   \|_   _| | || |  |_   __ \   | || ||_   _||_   _|| || | |  _   _  |  | |
*| |    | |__) |  | || |    | |       | || |    / /\ \    | || |   \ \  / /   | || |   | |_  \_|  | || |   | |__) |   | | | |      | |     | || |  |   \ | |   | || |    | |__) |  | || |  | |    | |  | || | |_/ | | \_|  | |
*| |    |  ___/   | || |    | |   _   | || |   / ____ \   | || |    \ \/ /    | || |   |  _|  _   | || |   |  __ /    | | | |      | |     | || |  | |\ \| |   | || |    |  ___/   | || |  | '    ' |  | || |     | |      | |
*| |   _| |_      | || |   _| |__/ |  | || | _/ /    \ \_ | || |    _|  |_    | || |  _| |___/ |  | || |  _| |  \ \_  | | | |     _| |_    | || | _| |_\   |_  | || |   _| |_      | || |   \ `--' /   | || |    _| |_     | |
*| |  |_____|     | || |  |________|  | || ||____|  |____|| || |   |______|   | || | |_________|  | || | |____| |___| | | | |    |_____|   | || ||_____|\____| | || |  |_____|     | || |    `.__.'    | || |   |_____|    | |
*| |              | || |              | || |              | || |              | || |              | || |              | | | |              | || |              | || |              | || |              | || |              | |
*| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' | | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
*'----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'   '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 


ALL_REG                 REG     D0-D7/A0-A6
GET_KEY_INPUT_COMMAND   equ     19        

*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Runner input key command----------------------*
*------------------------------------------------------------*
*------------------------------------------------------------*
initRunnerInput
        move.l          #$20,d2
        
*--------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*
*--------------We move in key input value into the address line------------------*
*--------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*        
inputLoop
        clr.l           d0   
        move.b          #GET_KEY_INPUT_COMMAND,d0
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Trap the value command for d1 value-----------*
*------------------------------------------------------------*
*------------------------------------------------------------*
        move.l          d2,d1
        TRAP            #15
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*------If the key is called/pressed use the value ascii------*
*------------------------------------------------------------*
*------------------------------------------------------------*
        cmpi.b          #0,d1
        beq             noCall
        jsr             callFunction
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Add in the next input value-------------------*
*------------------------------------------------------------*
*------------------------------------------------------------*
noCall

        add.l           #1,d2          
*---------------------------------------------------------*
*---------------------------------------------------------*
*----Character enemy key is pressed-----------------------*
*---------------------------------------------------------*
*---------------------------------------------------------*  

        cmpi.b          #$5A,d2
        bne             inputLoop
        move.l          #0, RunnerBeamPressed
        move.l          #0, EnemyBeamPressed
        rts
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Save the registers----------------------------*
*------------------------------------------------------------*
*------------------------------------------------------------*  
callFunction
        movem.l ALL_REG,-(sp)
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Load in the function table declared-----------*
*------------------------------------------------------------*
*------------------------------------------------------------*  
        lea     FunctionTable,a0
        sub.l   #$20,d2
        lsl.l   #2,d2
        move.l  (a0,d2),d1
*------------------------------------------------------------*
*------------------------------------------------------------*
*------------If the key is unknown ignore the pressed key----*
*------------------------------------------------------------*
*------------------------------------------------------------*  
        cmpi.l  #0,d1
        beq     noFuncPtr
*---------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------*
*--------------Move in the value into Addressline 1 and call it-------------------*
*---------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------*  

        move.l  d1,a1
        jsr     (a1) 

*---------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------*
*--------------This calls if a function in the game was used or not---------------*
*---------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------* 
noFuncPtr
        movem.l (sp)+,ALL_REG
        rts










*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Input routines to function on the screen------*
*------------------------------------------------------------*
*------------------------------------------------------------*  
spaceRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        
*------------------------------------------------------------------------------------------*
*------------------------------------------------------------------------------------------*
*---When button is pressed moved the player is moved from its Y position-------------------*
*------------------------------------------------------------------------------------------*
*------------------------------------------------------------------------------------------*                 
        move.l  #550, d0
        move.l  RunnerY, d1
        lsr     #FRAC_BITS, d1
        cmp.l   d0,d1
        BNE     jumpLoop
     
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Player is on the ground-----------------------*
*------------------------------------------------------------*
*------------------------------------------------------------*         
jumpLoop
        move.l  #0, RunnerVelocity
        move.l  RunnerY, d4
        move.l  #50, d5
        lsl     #FRAC_BITS, d5
        move.l  RunnerY, d6
        move.l  RunnerSpeed, d3
        lsl     #FRAC_BITS, d3
        sub.l   d3, d6
        cmp     d5, d6
        BLT     spaceRoutineExit
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*---Change the player current sprite to the jumping sprite---*
*------------------------------------------------------------*
*------------------------------------------------------------*
        move.l  RunnerJumpSprite, RunnerChunkX
        sub.l   d3, d4
        move.l  d4, RunnerY
        move.l  #1, RunnerJumping
        
*------------------------------------------------------------*
*------------------------------------------------------------*
*--------------Space Button is pressed-----------------------*
*------------------------------------------------------------*
*------------------------------------------------------------*         
spaceRoutineExit
        rts
        
leftRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
upRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts 
rightRoutine   
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
downRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine0
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine2
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine3
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine4
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine5
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine6
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine7
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine8
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine9
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineA
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineB
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineC
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineD
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineE
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineF
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineG
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineH
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineI
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineJ
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineK
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineL
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineM
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineN
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineO
        *Spawn beam for player 2
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        *check boolean of button pressed and projectile active
        move.l  EnemyBeamPressed, d0
        cmpi.l  #0, d0
        BNE     routineOExit
        
        move.l  #1, EnemyBeamPressed
        
        move.l  EnemyProjectileActive, d0
        cmpi.l  #0, d0
        BNE     routineOExit
        *update sprite
        move.l  EnemyBeamSprite, EnemyChunkX
        
        jsr     spawnEnemyProjectile
        
routineOExit
        rts

routineP
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineQ
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineR
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineS
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineT
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineU
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineV

        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineW
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineX
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineY
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineZ
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
        

*------------------------------------------------------------*
*------------------------------------------------------------*
*------We use the address spacebar to move our runner--------*
*------------------------------------------------------------*
*------------------------------------------------------------*
FunctionTable   
                
                dc.l    spaceRoutine
                dc.l    0,0,0,0
                dc.l    leftRoutine,upRoutine,rightRoutine,downRoutine
                dc.l    0,0,0,0,0,0,0
                dc.l    routine0,routine1,routine2,routine3,routine4,routine5,routine6,routine7,routine8,routine9
                dc.l    0,0,0,0,0,0,0
                dc.l    routineA,routineB,routineC,routineD,routineE,routineF,routineG
                dc.l    routineH,routineI,routineJ,routineK,routineL,routineM,routineN
                dc.l    routineO,routineP,routineQ,routineR,routineS,routineT,routineU
                dc.l    routineV,routineW,routineX,routineY,routineZ
                
RunnerBeamPressed
        dc.l    0
EnemyBeamPressed
        dc.l    0
        



































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
