*================================================================================*  
*================================================================================*
* Written by : Steve Fasoranti                                                   *
* Student Number: C00275756                                                      *
* Description: This here we check if the player was hit with the enemy projectile*                                                               *
*================================================================================*
*================================================================================*
CheckProjectileCollision

EnemyBeamCollisionDetection
    *check and see if the projectile collided
    cmpi.l  #1, d1
    BNE     RunnerBeamCollisionDetection

    move.l  EnemyX, d1
    move.l  EnemyY, d2
    *Use lsr to shift the pixel bits into d2
    lsr.l   #FRAC_BITS, d2

    add.l   EnemyWidth, d1 
    cmp     d1, d3
    BGT     RunnerBeamCollisionDetection
    
    sub.l   EnemyWidth, d1

    cmp     d1, d3
    BLT     EnemyBeamCollisionDetection
    
    add.l   EnemyHeight, d2
    cmp     d2, d4
    BGT     RunnerBeamCollisionDetection
    
    sub.l   EnemyHeight, d2

    cmp     d2, d4
    BLT     RunnerBeamCollisionDetection
    *check if any colliding happens on the screen if so and it hits the player we allow the enemy to spawn another


RunnerBeamCollisionDetection
    move.l  EnemyProjectileActive, d1
    cmpi.l  #1, d1
    BNE     BeamToBeamCollisionDetection

    move.l  RunnerX, d1
    move.l  RunnerY, d2
    lsr.l   #FRAC_BITS, d2
    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    
    add.l   RunnerWidth, d1 
    cmp     d1, d3
    BGT     BeamToBeamCollisionDetection
    
    sub.l   RunnerWidth, d1
    add.l   EnemyProjectileWidth, d3
    cmp     d1, d3
    BLT     BeamToBeamCollisionDetection
    
    add.l   RunnerHeight, d2
    cmp     d2, d4
    BGT     BeamToBeamCollisionDetection
    
    sub.l   RunnerHeight, d2
    add.l   EnemyProjectileHeight, d4
    cmp     d2, d4
    BLT     BeamToBeamCollisionDetection
    jsr     BeamHitRunner

*Now use the same logic to see if the beam has collided 
BeamToBeamCollisionDetection
    move.l  EnemyProjectileActive, d1
    cmpi.l  #1, d1
    BNE     exitBeamCollisionDetection
    

    cmpi.l  #1, d1
    BNE     exitBeamCollisionDetection



    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    

    cmp     d1, d3
    BGT     exitBeamCollisionDetection
    

    add.l   EnemyProjectileWidth, d3
    cmp     d1, d3
    BLT     exitBeamCollisionDetection
    

    cmp     d2, d4
    BGT     exitBeamCollisionDetection
    

    add.l   EnemyProjectileHeight, d4
    cmp     d2, d4
    BLT     exitBeamCollisionDetection    
    BRA     BeamsCollided

BeamHitRunner
    *If Runner has been hit take away 1 from health
    move.l  RunnerHealth, d1
    sub.l   EnemyProjectileDamage, d1
    *check if his health is at 0
    cmpi.l  #0, d1
    BGE     ContinueBeamHitRunner
    *if its at 0 print 0 to the screen
    jsr     SetHealthToZero
ContinueBeamHitRunner  
*update player health and sprite
    move.l  d1, RunnerHealth
    move.l  RunnerDamageSprite, RunnerChunkX    
    move.l  #0, EnemyProjectileActive
    
    *redraw background behind player after the sprite has occured
    lea     BackGround, a0
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    move.l  EnemyProjectileX, d5
    move.l  EnemyProjectileY, d6
    jsr     DRAWIMAGE
    *draw updated score for runner
    jsr     updateScoreBackGround
    move.l  RunnerHealth, d0
    move.l  RunnerScoreX, d5
    jsr     updateHealth
   
    
    *spawn sound of runner that was hit after being hit
    lea     GetHit, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    bra     exitBeamCollisionDetection


BeamsCollided

    
    lea     BackGround, a0
    
    jsr     DRAWIMAGE
    
    move.l  #0, EnemyProjectileActive
    
    lea     BackGround, a0
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    move.l  EnemyProjectileX, d5
    move.l  EnemyProjectileY, d6
    jsr     DRAWIMAGE
    
COLLISION_CHECK_DONE:               ; No Collision Update points
    ADD.B   #POINTS,    D1          ; Move points upgrade to D1
    ADD.L   PLAYER_SCORE,D1         ; Add to current player score
    MOVE.L  D1, PLAYER_SCORE        ; Update player score in memory
    RTS                             ; Return to subrouti
    
exitBeamCollisionDetection
    rts
    
SetHealthToZero
    move.l  #0, d1
    rts






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
