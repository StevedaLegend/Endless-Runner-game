*================================================================================*  
*================================================================================*
* Written by : Steve Fasoranti                                                   *
* Student Number: C00275756                                                      *
* Description: This is where we spawn the enemys projectiles across the screem   *                                                              *
*================================================================================*
*================================================================================*

*Spawn Enemy Projectile on the right going to left
spawnEnemyProjectile
    move.l  #1, EnemyProjectileActive
    move.l  EnemyLeft, d1
    cmpi.l  #1, d1
    BEQ     spawnEnemyProjectileLeft
spawnEnemyProjectileRight
    move.l  #0, EnemyProjectileLeft


    move.l  EnemyChunkY, d0
    cmpi.l  #0, d0
    BEQ     drawTinyEnemyProjectileRight
    
 
    
    BRA     drawEnemyProjectileRight
    
    
*Enemy projectile   
drawTinyEnemyProjectileRight
    lea     smallBeam, a0
    

    
drawEnemyProjectileRight
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyX, EnemyProjectileX
    move.l  EnemyProjectileX, d0
    add.l   EnemyWidth, d0
    move.l  d0, EnemyProjectileX
    move.l  EnemyProjectileX, d3
    move.l  EnemyY, d4
    lsr.l   #4, d4
    move.l  d4, EnemyProjectileY
    move.l  EnemyProjectileYOffset,d5
    add.l   d5, EnemyProjectileY
    move.l  EnemyProjectileY, d4
    move.l  EnemyProjectileWidth, EnemyProjectileChunkX
    move.l  EnemyProjectileChunkX, d5
    move.l  EnemyProjectileChunkY, d6
    jsr     DRAWIMAGE
    rts
    
*Projectile going to the left
spawnEnemyProjectileLeft
    move.l  #1, EnemyProjectileLeft
    move.l  EnemyChunkY, d0
    cmpi.l  #0, d0
    BEQ     drawTinyEnemyProjectileLeft
    
    
    
    BRA     drawEnemyProjectileLeft
    
    
drawTinyEnemyProjectileLeft
    lea     smallBeam, a0
 

drawEnemyProjectileLeft
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyX, EnemyProjectileX
    move.l  EnemyProjectileX, d0
    sub.l   EnemyProjectileWidth, d0
    move.l  d0, EnemyProjectileX
    move.l  EnemyProjectileX, d3
    move.l  EnemyY, d4
    lsr.l   #FRAC_BITS, d4
    move.l  d4, EnemyProjectileY
    move.l  EnemyProjectileYOffset,d5
    add.l   d5, EnemyProjectileY
    move.l  EnemyProjectileY, d4
    move.l  #0, EnemyProjectileChunkX
    move.l  EnemyProjectileChunkX, d5
    move.l  EnemyProjectileChunkY, d6
    jsr     DRAWIMAGE
    rts

    
    
*update Enemy projectiles each assest across the screen
updateProjectilesBackground
    move.l  EnemyProjectileActive, d0
    cmpi.l  #1, d0
    BNE     exitProjectileUpdate

    lea     BackGround, a0
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    move.l  EnemyProjectileX, d5
    move.l  EnemyProjectileY, d6
    jsr     DRAWIMAGE
    
    move.l  EnemyProjectileActive, d0
    cmpi.l  #1, d0
    BNE     exitProjectileUpdate

    move.l  EnemyProjectileLeft, d0
    cmpi.l  #1, d0
    BNE     updateProjectile2PositionRight

updateProjectile2PositionLeft
    
    
    move.l  EnemyProjectileX, d0
    sub.l   ProjectileSpeed, d0
    move.l  d0, EnemyProjectileX

    move.l  EnemyProjectileX, d0
    add.l   EnemyProjectileWidth, d0
    cmpi.l  #0, d0
    BGT     moveProjectile2Right
    
    move.l  #0, EnemyProjectileActive

moveProjectile2Left
    move.l  EnemyChunkY, d0
    cmpi.l  #0, d0
    BEQ     updateTinyEnemyProjectileLeft
    

    BRA     updateDrawProjectile2Left
    
updateTinyEnemyProjectileLeft
    lea     smallBeam, a0

updateDrawProjectile2Left
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    move.l  EnemyProjectileChunkX, d5
    move.l  EnemyProjectileChunkY, d6
    jsr     DRAWIMAGE
    
    BRA     exitProjectileUpdate
    
updateProjectile2PositionRight   
    move.l  EnemyProjectileX, d0
    add.l   ProjectileSpeed, d0
    move.l  d0, EnemyProjectileX

    move.l  EnemyProjectileX, d0
    cmpi.l  #700, d0
    BLT     moveProjectile2Right
    
    move.l  #0, EnemyProjectileActive

moveProjectile2Right
    move.l  EnemyChunkY, d0
    cmpi.l  #0, d0
    BEQ     updateTinyEnemyProjectileRight
    

    BRA     updateDrawProjectile2Right
    
updateTinyEnemyProjectileRight
    lea     smallBeam, a0

updateDrawProjectile2Right
    move.l  EnemyProjectileWidth, d1
    move.l  EnemyProjectileHeight, d2
    move.l  EnemyProjectileX, d3
    move.l  EnemyProjectileY, d4
    move.l  EnemyProjectileChunkX, d5
    move.l  EnemyProjectileChunkY, d6
    jsr     DRAWIMAGE
    
    BRA     exitProjectileUpdate
    
    
    
*Player2 move projectile    
exitProjectileUpdate
    rts

 
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
