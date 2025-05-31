######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

.data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display.
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard.
ADDR_KBRD:
    .word 0xffff0000
# The address of the medicine bottle.
ADDR_MEDICINE:
	.word 0x1000848C
# The address of the color red.
COLOR_RED:
	.word 0xff0000
# The address of the color white.
COLOR_BLUE:
	.word 0x0000ff
# The address of the color yellow.
COLOR_YELLOW:
	.word 0xffff00
# The address of the color white.
COLOR_WHITE:
	.word 0xffffff
# The address of the color black.
COLOR_BLACK:
	.word 0x000000
# The starting address of the lower medicine bottle.
ADDR_LOWER:
    .word 0x1000881C
# Ending address of lowr
ADDR_ENDING: 
    .word 0x10008B4A
##############################################################################
# Mutable Data
##############################################################################
# The position of tile one of the capsule.
POS_ONE:
    .word 0x10008320
# The position of the second tile of the capsule.
POS_TWO:
    .word 0x100083A0
##############################################################################
# Code
##############################################################################
.text
.globl main

# ----------------------------------------------------------------------------
# [main] running the game

main:
    # initialize the game
	# load base address of display into $s0.
	lw $s0, ADDR_DSPL
	# load base address of keyboard into $s1.
	lw $s1, ADDR_KBRD
    # load the color of tile one into $s2.
    # load the color of the second tile into $s3.
	# load base address of medicine bottle into $s4.
	lw $s4, ADDR_MEDICINE
	# load capsule in vertical down position.
	li $s5, 1
	# load base address for position of capsule tile one into $s6.
	lw $s6, POS_ONE
	# load base address for position of capsule tile two into $s7.
	lw $s7, POS_TWO
	# load the color red into $t0.
	lw $t0 COLOR_RED
	# load the color blue into $t1.
	lw $t1, COLOR_BLUE
	# load the color yellow into $t2.
	lw $t2, COLOR_YELLOW
    # load the starting time into $t6.
    li $v0, 30
    syscall
    move $t6, $a0
	# load black color for the background.
	lw $t9, COLOR_BLACK
    
    # color for tile one in preview capsule
	addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal capsule_color_a
	lw $ra, 0($sp) 
    addi $sp, $sp, 4 

    # color for second tile in preview capsule
	addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal capsule_color_b
    lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jal draw_preview_capsule

    # color for tile one in capsule
	addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal capsule_color_a
	lw $ra, 0($sp) 
    addi $sp, $sp, 4 

    # color for second tile in capsule
	addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal capsule_color_b
    lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jal draw_beginning_capsule
    jal draw_preview_circle
    jal draw_viruses
	jal draw_medicine_bottle # draw the medicine bottle

    j game_loop
    
capsule_color_a:
    li $v0, 42
    li $a0, 0
    li $a1, 4
    syscall
    move $t3, $a0

    beq $t3, 0, color_red_a
    beq $t3, 1, color_blue_a
    beq $t3, 2, color_yellow_a # color for tile one in capsule
    beq $t3, 3, color_neon_pink
color_red_a:
    move $s2, $t0
    jr $ra # color red for tile one in capsule
color_blue_a:
    move $s2, $t1
    jr $ra # color blue for tile one in capsule
color_yellow_a:
    move $s2, $t2
    jr $ra     # color yellow for tile one in capsule
color_neon_pink:
    la $t3, 0xFF10F0
    move $s2, $t3
    jr $ra
capsule_color_b:
    li $v0, 42
    li $a0, 0 
    li $a1, 4
    syscall
    move $t3, $a0

    beq $t3, 0, color_red_b
    beq $t3, 1, color_blue_b
    beq $t3, 2, color_yellow_b # color for second tile in capsule
    beq $t3, 3, color_neon_green
color_red_b: # color red for second tile in capsule
    move $s3, $t0
    jr $ra
color_blue_b:
    move $s3, $t1
    jr $ra # color blue for second tile in capsule
color_yellow_b:
    move $s3, $t2
    jr $ra		 # color yellow for second tile in capsule
color_neon_green:
    la $t3, 0x39FF14
    move $s3, $t3
    jr $ra
draw_preview_capsule:
    sw $s2, 200($s4)
    sw $s3, 328($s4)

    jr $ra
draw_beginning_capsule:
    sw $s2, 800($s0)
    sw $s3, 928($s0)

    jr $ra
   
draw_preview_circle: 
    lw $t4, COLOR_WHITE
    
    sw $t4, -60($s4) # top area of the circle 
    sw $t4, -56($s4)
    sw $t4, -52($s4)

    sw $t4, 580($s4) # bottom area of the circle
    sw $t4, 584($s4)
    sw $t4, 588($s4)

    sw $t4, 64($s4) # left area of the circle
    sw $t4, 192($s4)
    sw $t4, 320($s4)
    sw $t4, 448($s4)
    
    sw $t4, 80($s4) # right area of the circle
    sw $t4, 208($s4)
    sw $t4, 336($s4)
    sw $t4, 464($s4)

    jr $ra
draw_viruses: # draw the viruses in the game
    sw $t0, 1688($s0)
	sw $t1, 2728($s0)
	sw $t2, 2064($s0)

	jr $ra
    
draw_medicine_bottle:
    # load white color for the medicine bottle drawing into $t3.
	lw $t3, COLOR_WHITE

	addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	sw $t3, 792($s0)
	sw $t3, 808($s0)
	sw $t3, 920($s0)
	sw $t3, 936($s0)

	sw $t3, 1032($s0)
	sw $t3, 1036($s0)
	sw $t3, 1040($s0)
	sw $t3, 1044($s0)
	sw $t3, 1048($s0)
	
	sw $t3, 1064($s0)
	sw $t3, 1068($s0)
	sw $t3, 1072($s0)
	sw $t3, 1076($s0)
	sw $t3, 1080($s0)
	
	sw $t3, 2956($s0)
	sw $t3, 2960($s0)
	sw $t3, 2964($s0)
	sw $t3, 2968($s0)
	sw $t3, 2972($s0)
	sw $t3, 2976($s0)
	sw $t3, 2980($s0)
	sw $t3, 2984($s0)
	sw $t3, 2988($s0)
	sw $t3, 2992($s0)
	sw $t3, 2996($s0)

	li $t0, 0
	li $t1, 15
	addu $s0, $s0, 1160

	jal draw_border_loop # draw the border of the medicine bottle

	lw $ra, 0($sp)
    addi $sp, $sp, 4

	jr $ra
draw_border_loop: # draw the border of the medicine bottle
	bge $t0, $t1, end_border_loop
	
	sw $t3, 0($s0)
	addi $s0, $s0, 48
	sw $t3, 0($s0)
	addi $s0, $s0, 80
	
	addi $t0, $t0, 1
	
	j draw_border_loop
end_border_loop: # end drawing of the border of the medicine bottle
	lw $s0, ADDR_DSPL
	li $t0, 0
	li $t1, 0

	jr $ra

# ----------------------------------------------------------------------------
# [game_loop] running the loop of the game

# the game_loop which is checking whether we should handle_gravity
game_loop:
    li $v0, 30 # load the current time
    syscall
    move $t7, $a0

    sub $t1, $t7, $t6 # calculate elapsed time and load into $t1
    li $t8, 500 # load 500ms into $t8
    bge $t1, $t8, handle_gravity # if elapsed time < 500ms, then handle_gravity
# the regular_game_loop for after we have confirmed that we should not handle_gravity yet
regular_game_loop:
    jal is_key_pressed # [1a] checking if a key has been pressed
    jal keyboard_input # [1b] checking which key has been pressed
    jal is_collision # [2a] checking for collisions
    jal update_capsule_location # [2b] if there are no collisions, update capsule location
    jal draw_screen_processing # [3a] after updating capsule location, draw the screen
    jal is_landed # [3b] checking whether capsule landed on a virus, another capsule, or the ground
    # [3c] checking for four-in-a-row or four-in-a-column after landed
    jal sleep # [4] now, we allow our program to sleep.
    
    j game_loop #[5] loop back for game_loo
# handle_gravity which would allow each capsule go down one row
handle_gravity:
    li $t7, 3 # this will store_move_down
    jal is_collision
    jal update_capsule_location 

    # continue with the remaining game routine
    jal draw_screen_processing
    jal is_landed
    jal sleep
    
    li $v0, 30
    syscall
    move $t6, $a0 # update the last gravity timing with current time ()

    j game_loop # continue with the game loop
    
# ----------------------------------------------------------------------------
# [1a] checking if a key has been pressed

is_key_pressed:
	lw $t0, 0($s1) # load key press status
	li $t1, 1
	
	beq $t0, $t1, return # if pressed, return to game_loop and execute keyboard_input
	j game_loop # else, loop again
# returning to game_loop for executing keyboard_input
return:
	jr $ra
    
# ----------------------------------------------------------------------------
# [1b] checking which key has been pressed

keyboard_input:
    lw $t2, 0xffff0004
    li $t1, 0x61 # 'a'
    beq $t2, $t1, store_move_left
    li $t1, 0x64 # 'd'
    beq $t2, $t1, store_move_right
    li $t1, 0x73 # 's'
    beq $t2, $t1, store_move_down 
	li $t1, 0x77 # 'w'
	beq $t2, $t1, store_rotate
	li $t1, 0x71 # 'q'
	beq $t2, $t1, exit
    li $t1, 0x70 # 'p'
    beq $t2, $t1, pause
    li $t1, 0x6D # 'm'
    beq $t2, $t1, freeze

# if 'a' then store move left flag in $t3.
store_move_left:
    li $t7, 1
    jr $ra
# if 'd' then store move right flag in $t3.
store_move_right:
    li $t7, 2
    jr $ra
# if 's' then store move down flag in $t3.
store_move_down:
    li $t7, 3
    jr $ra
# if 'w' then store rotate flag in $t3.
store_rotate:
    li $t7, 4 
    jr $ra
# if 'q' then clear_screen and exit the game.
exit:
	move $t0, $s0
	li $t1, 1024

	jal clear_screen

	li $v0, 10
	syscall
clear_screen: # animated clearing of the screen
	sw $t9, 0($t0)
        
	addi $t0, $t0, 4
	subi $t1, $t1, 1

    li $v0, 32 
    li $a0, 3
    syscall
    
	bnez $t1, clear_screen

	jr $ra
    
# if 'p' then save the screen.
pause: 
    lw $t4, COLOR_WHITE
    sw $t4, 360($s0)
    sw $t4, 488($s0)
    sw $t4, 616($s0)
    sw $t4, 744($s0)
    
    sw $t4, 372($s0)
    sw $t4, 500($s0)
    sw $t4, 628($s0)
    sw $t4, 756($s0)
    
	j in_pause
in_pause: # looping while the screen is paused
    lw $t5, 0xffff0000 # check if a key has been pressed
    beqz $t5, in_pause # loop if no key has been pressed

    lw $t5, 0xffff0004 # read the key that has been pressed
    li $t9, 0x70 # 'p'
    bne $t5, $t9, in_pause # looping again as not 'p'

    j reset_pause # else if 'p' then reset_pause
reset_pause: # if 'p' again then reset pause and return to game_loop
    # load black color for the background.
	lw $t9, COLOR_BLACK
    
    sw $t9, 360($s0)
    sw $t9, 488($s0)
    sw $t9, 616($s0)
    sw $t9, 744($s0)
    
    sw $t9, 372($s0)
    sw $t9, 500($s0)
    sw $t9, 628($s0)
    sw $t9, 756($s0)
    
    j game_loop

game_over:
    move $t0, $s0
    li $t1, 1024

    jal clear_screen

    lw $t4, COLOR_WHITE

    # 'R'
    sw $t4, 1052($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1056($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1060($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1064($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1180($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1308($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1436($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1564($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1692($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1820($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1196($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1324($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1448($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1444($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1440($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1580($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1708($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1836($s0)
    li $v0, 32 
    li $a0, 50
    syscall

    # 'T'
    sw $t4, 1080($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1084($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1088($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1092($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1096($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1216($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1344($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1472($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1600($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1728($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1856($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    #' O'
    sw $t4, 1104($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1108($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1112($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1116($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1120($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1232($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1360($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1488($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1616($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1744($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1872($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1248($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1376($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1504($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1632($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1760($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1888($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1876($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1880($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 1884($s0)
    li $v0, 32 
    li $a0, 50
    syscall


    # 'R'
    sw $t4, 2184($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2312($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2440($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2568($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2696($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2824($s0)
    li $v0, 32 
    li $a0, 50
    syscall 
    sw $t4, 2952($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2188($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2192($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2196($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2328($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2456($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2580($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2576($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2572($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2712($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2840($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2968($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    # 'E'
    sw $t4, 2208($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2212($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2216($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2220($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2224($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2336($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2464($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2592($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2596($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2600($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2604($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2608($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2720($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2848($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2976($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2980($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2984($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2988($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2992($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    # 'T'
    sw $t4, 2232($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2236($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2240($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2244($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2248($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2368($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2496($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2624($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2752($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2880($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3008($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    # 'R'
    sw $t4, 2256($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2260($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2264($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2268($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2384($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2512($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2640($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2768($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2896($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3024($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2400($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2528($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2652($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2648($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2644($s0)
    li $v0, 32
    li $a0, 50
    syscall
    sw $t4, 2784($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2912($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3040($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    # 'Y'
    sw $t4, 2280($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2408($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2536($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2664($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2668($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2672($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2292($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2420($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2548($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2676($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2804($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 2932($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3060($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3056($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3052($s0)
    li $v0, 32 
    li $a0, 50
    syscall
    sw $t4, 3048($s0)

    j retry

retry:
    lw $t5, 0xffff0000 # check if a key has been pressed
    beqz $t5, retry # loop if no key has been pressed

    lw $t5, 0xffff0004 # read the key that has been pressed
    li $t8, 0x72 # 'r'
    bne $t5, $t8, retry # looping again as not 'r'

    move $t0, $s0
	li $t1, 1024
    jal clear_screen
    
    j main # else if 'r' then jump to main

freeze:
    li $v0, 30 # get current time in m/s
    syscall
    move $t5, $a0

    j freeze_loop

freeze_loop:
    li $v0, 30 # get new time in m/s
    syscall
    move $t6, $a0

    sub $t1, $t6, $t5 # the elapsed timing
    li $t8, 1000

    bge $t1, $t8, game_loop  # return to game_loop after ten seconds

    li $t7, 3 # this will store_move_down
    jal is_collision
    jal update_capsule_location 

    # continue with the remaining game routine
    jal draw_screen_processing
    jal is_landed
    jal sleep

    j freeze_loop # otherwise, loop again
    
# ----------------------------------------------------------------------------
# [2a] checking for collisions

is_collision:
	# if 'a' was pressed then check left_collision.
	beq $t7, 1, left_collision
	# if 'd' was pressed then check right_collision.
	beq $t7, 2, right_collision
	# if 's' was pressed then check down_collision.
	beq $t7, 3, down_collision
	# if 'w' was pressed then check rotate_collision.
	beq $t7, 4, rotate_collision

# checking whether capsule could have a collision on the left
left_collision:
	# horizontal capsule with $s6 on the left
	addi $t0, $s6, 4 # calculate the address to the right of $s6
	beq $t0, $s7, s6_leading_left # if $t0 is equal to $s7, it is horizontal with $s6 on the left
	
	# horizontal capsule with s7 on the move_left
	addi $t0, $s7, 4 # calculate the address to the right of $s6
	beq $t0, $s6, s7_leading_left # if $t0 is equal to $s6, it is horizontal with $s7 on the left
	
	# else we have a vertical capsule 
	lw $t3, -4($s6)
    lw $t4, -4($s7)
    or $t5, $t3, $t4
    bnez $t5, game_loop # if left collision, loop again.
	jr $ra # else, return to game_loop for updating locations.
s6_leading_left:
    # check only $s6 for left collision
    lw $t3, -4($s6)
    bnez $t3, game_loop # if left collision, loop again.
    jr $ra # else, return to game_loop for updating locations.
s7_leading_left:
    # check only $s7 for left collision
    lw $t3, -4($s7)
    bnez $t3, game_loop # if left collision, loop again.
	jr $ra # else, return to game_loop for updating locations.
# checking whether capsule could have a collision on the right
right_collision:
	# horizontal capsule with $s6 on the right
	addi $t0, $s6, -4 # calculate the address to the left of $s6s
	beq $t0, $s7, s6_leading_right # if $t0 is equal to $s7, it is horizontal with $s6 on the right
	
	# horizontal capsule with s7 on the move_left
	addi $t0, $s7, -4 # calculate the address to the left of $s6
	beq $t0, $s6, s7_leading_right # if $t0 is equal to $s6, it is horizontal with $s7 on the right
	
	# else we have a vertical capsule 
	lw $t3, 4($s6)
    lw $t4, 4($s7)
    or $t5, $t3, $t4
    bnez $t5, game_loop # if right collision, loop again.
	jr $ra # else, return to game_loop for updating locations.
s6_leading_right:
    # check only $s6 for right collision
    lw $t3, 4($s6)
    bnez $t3, game_loop # if right collision, loop again.
	jr $ra # else, return to game_loop for updating locations.
s7_leading_right:
    # check only $s7 for right collision
    lw $t3, 4($s7)
    bnez $t3, game_loop # if right collision, loop again.
	jr $ra # else, return to game_loop for updating locations
# checking whether capsule could have a collision below
down_collision:
	# vertical capsule with $s6 on the bottom
	addi $t0, $s6, -128 # calculate the address above $s6
	beq $t0, $s7, s6_leading_bottom # if $t0 is equal to $s7, it is vertical with $s6 on the bottom
	
	# vertical capsule with $s7 on the bottom
	addi $t0, $s7, -128 # calculate the address above $s7
	beq $t0, $s6, s7_leading_bottom # if $t0 is equal to $s6, it is vertical with $s7 on the bottom
	
	# else we have a horizontal capsule 
	lw $t3, 128($s6)
    lw $t4, 128($s7)
    or $t5, $t3, $t4
    bnez $t5, game_loop # if bottom collision, loop again.
    jr $ra # else, return to game_loop for updating locations.
s6_leading_bottom:
    # check only $s6 for bottom collision
    lw $t3, 128($s6)
    bnez $t3, game_loop # if bottom collision, loop again.
	jr $ra # else, return to game_loop for updating locations.
s7_leading_bottom:
    # check only $s7 for bottom collision
    lw $t3, 128($s7)
    bnez $t3, game_loop # if bottom collision, loop again.
	jr $ra # else, return to game_loop for updating locations.
# checking whether capsule could have a collision while rotating
rotate_collision:
    # update rotation state (0 -> 1 -> 2 -> 3 -> 0)
    addi $s5, $s5, 1
    andi $s5, $s5, 3 # keep $s5 between 0 and 3

	# checking for collision on the basis of which direction capsule is being rotated.
    beq $s5, 0, rotate_right_collision # state 0: horizontal right
    beq $s5, 1, rotate_down_collision # state 1: vertical down
    beq $s5, 2, rotate_left_collision # State 2: horizontal left
    beq $s5, 3, rotate_up_collision # State 3: vertical up
rotate_right_collision:
	lw $t3, 4($s6)
    bnez $t3, reset_rotation_state # if rotation collision, reset rotation state, and loop again.
	subi $s5, $s5, 1 # reset our rotation state
	jr $ra # else, return to game_loop for updating locations.
rotate_down_collision:
	lw $t3, 128($s6) 
    bnez $t3, game_loop	# if rotation collision, reset rotation state, and loop again.
	subi $s5, $s5, 1 # reset our rotation state
	jr $ra # else, return to game_loop for updating locations.
rotate_left_collision:
	lw $t3, -4($s6)
    bnez $t3, reset_rotation_state # if rotation collision, reset rotation state, and loop again.
	subi $s5, $s5, 1 # reset our rotation state
	jr $ra # else, return to game_loop for updating locations.
rotate_up_collision:
	lw $t3, -128($s6)
    bnez $t3, reset_rotation_state # if rotation collision, reset rotation state, and loop again.
	subi $s5, $s5, 1 # reset our rotation state
	jr $ra # else, return to game_loop for updating locations.
reset_rotation_state:
	# subi $s5, $s5, 1 
	j game_loop

# ----------------------------------------------------------------------------
# [2b] if there are no collisions, update capsule location

update_capsule_location:
	# color where the capsule was before as black
	sw $t9, 0($s6)
    sw $t9, 0($s7)
	# if 'a' was pressed then update position to move left.
	beq $t7, 1, update_position_left
	# if 'd' was pressed then update position to move right.
	beq $t7, 2, update_position_right
	# if 's' was pressed then update position to move down.
	beq $t7, 3, update_position_down
	# if 'w' was pressed then update position to rotate.
	beq $t7, 4, update_position_rotate

# updating capsule position to move left
update_position_left:
	subu $s6, $s6, 4
    subu $s7, $s7, 4
	jr $ra
# updating capsule position to move right
update_position_right:
	addi $s6, $s6, 4
    addi $s7, $s7, 4
	jr $ra
# updating capsule position to move down
update_position_down:
	addi $s6, $s6, 128
    addi $s7, $s7, 128
	jr $ra

# updating capsule position to rotate
update_position_rotate:
	# update rotation state (0 -> 1 -> 2 -> 3 -> 0)
    addi $s5, $s5, 1
	# keeping $s5 between 0 and 3
    andi $s5, $s5, 3 

	# clear $t0 for calculations
    li $t0, 0     

	li $t4, 4 # horizontal offset
	li $t5, 128 # vertical offset

    beq $s5, 0, update_position_rotate_right # state 0: horizontal right
    beq $s5, 1, update_position_rotate_down # state 1: vertical down
    beq $s5, 2, update_position_rotate_left # state 2: horizontal left
    beq $s5, 3, update_position_rotate_up # state 3: vertical up
# updating capsule position to rotate right
update_position_rotate_right:
	lw $t3, 4($s6)
    add $s7, $s6, $t4 # move $s7 to the right of $s6.
    jr $ra
# updating capsule position to rotate down
update_position_rotate_down:
	lw $t3, 128($s6) 
    add $s7, $s6, $t5 # move $s7 below $s6
    jr $ra
# Updating capsule position to left
update_position_rotate_left:
	lw $t3, -4($s6)
    sub $s7, $s6, $t4 # move $s7 to the left of $s6
    jr $ra
# updating capsule position to rotate up
update_position_rotate_up:
	lw $t3, -128($s6)
    sub $s7, $s6, $t5 # move $s7 above $s6
    jr $ra

# ----------------------------------------------------------------------------
# [3a] after updating capsule location, draw the screen

draw_screen_processing:
	# confirming loop that the key has been released
    lw $t0, 0($s1)
    li $t1, 0
    beq $t0, $t1, draw_screen # once released, draw the screen
	
    j draw_screen_processing 
# draw the screen, after processing that the key has been released.
draw_screen:
    sw $s2, 0($s6)
    sw $s3, 0($s7)

	jr $ra
	
# ----------------------------------------------------------------------------
# [3b] checking whether capsule landed on a virus, another capsule, or the ground

is_landed:
	# vertical capsule with $s6 on the bottom
	addi $t0, $s6, -128 # calculate the address above $s6
	beq $t0, $s7, s6_leading_bottom_b # if $t0 is equal to $s7, it is vertical with $s6 on the bottom
	
	# vertical capsule with $s7 on the bottom
	addi $t0, $s7, -128 # calculate the address above $s7
	beq $t0, $s6, s7_leading_bottom_b # if $t0 is equal to $s6, it is vertical with $s7 on the bottom
	
	# else we have a horizontal capsule 
	lw $t3, 128($s6)
    lw $t4, 128($s7)
    or $t5, $t3, $t4
    bnez $t5, handle_landing # if bottom collision, then handle_landing.
    jr $ra # else, return to game_loop.
s6_leading_bottom_b:
    # check only $s6 for bottom collision
    lw $t3, 128($s6)
    bnez $t3, handle_landing # if bottom collision, then handle_landing.
	jr $ra # else, return to game_loop.
s7_leading_bottom_b:
    # check only $s7 for bottom collision
    lw $t3, 128($s7)
    bnez $t3, handle_landing # if bottom collision, then handle_landing.
	jr $ra # else, return to game_loop.
handle_landing:
    la $t3, 0xFF10F0
    lw $t4, COLOR_WHITE
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal handle_pink_landing
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
	# [3c] checking for four-in-a-row or four-in-a-column after landed.
	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_four
	lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    # sava $ra on the stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal reset
    
    lw $t4, 200($s4)
    lw $t5, 328($s4)

    jal capsule_translation
    
    jal capsule_color_a
    jal capsule_color_b
    jal draw_preview_capsule

    move $s2, $t4
    move $s3, $t5
    jal draw_beginning_capsule

    # checking whether bottle is full
    lw $t1, 16($s4)
    lw $t2, 20($s4)
    lw $t3, 24($s4)
    bne $t1, $zero, game_over # then game_over
    bne $t2, $zero, game_over # then game_over
    bne $t3, $zero, game_over # then game_over

    # restore $ra from the stack
    lw $ra, 0($sp)
    addi $sp, $sp, 4
	
    jr $ra

handle_pink_landing:
    bne $t3, $s2, completion
    
    lw $t1, 128($s6)
    beq $t1, $t4, handle_pink_landing_on_ground
    lw $t2, COLOR_BLACK

    sw $t2, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t3, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t2, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t3, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t2, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t1, 0($s6)
    move $s2, $s6

    li $v0, 32 
    li $a0, 350
    syscall
    
    jr $ra
handle_pink_landing_on_ground:
    la $t1, 0xff0000
    lw $t2, COLOR_BLACK

    sw $t2, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t3, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t2, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t3, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t2, 0($s6)
    
    li $v0, 32 
    li $a0, 350
    syscall

    sw $t1, 0($s6)
    move $s2, $s6

    li $v0, 32 
    li $a0, 350
    syscall
    
    jr $ra
    
reset:
	# load capsule in vertical down position
	li $s5, 1
	# load base address for position of capsule tile one into $s6
	lw $s6, POS_ONE
	# load base address for position of capsule tile two into $s7
	lw $s7, POS_TWO
	# load the color red into $t0
	lw $t0 COLOR_RED
	# load the color blue into $t1
	lw $t1, COLOR_BLUE
	# load the color yellow into $t2
	lw $t2, COLOR_YELLOW

	jr $ra    
capsule_translation:
    lw $t9, COLOR_BLACK 
    lw $t8, COLOR_WHITE

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 128
    
    # draw capsule after moving up
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 128
    
    # draw capsule after moving up
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 128
    
    # draw capsule after moving up
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t8, 328($s4)
    
    sub $s4, $s4, 128
    
    # draw capsule after moving up
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 128
    
    # draw capsule after moving up
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 128
    
    # draw capsule after moving up
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

     # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    sub $s4, $s4, 4
    
    # draw capsule after moving left
    sw $t4, 200($s4)
    sw $t5, 328($s4)
    
    li $v0, 32
    li $a0, 150
    syscall

    # erase capsule
    sw $t9, 200($s4)
    sw $t9, 328($s4)
    
    # reset the value of $s4
    addi $s4, $s4, 820

    jr $ra

# ----------------------------------------------------------------------------
# [3c] checking for four-in-a-row or four-in-a-column after landed

# check for four_in_a_column and four_in_a_row
is_four:
	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_four_in_a_column
	lw $ra, 0($sp) 
    addi $sp, $sp, 4 
	
	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_four_in_a_row
	lw $ra, 0($sp) 
    addi $sp, $sp, 4 

	jr $ra

# check for four_in_a_column
is_four_in_a_column:
	move $t6, $s4
	li $t4, 0 # row counter
	li $t5, 0 # column counter

	j vertical_loop	
vertical_loop: # a vertical_loop through each column
	bge $t4, 11, vertical_loop_next_column # move to next column after the tenth row

	lw $t0, 0($t6) 
	lw $t1, 128($t6)
	lw $t2, 256($t6)
	lw $t3, 384($t6)

    # move to the next row if any of the tiles are black
	beq $t0, $zero, vertical_loop_next_row
	beq $t1, $zero, vertical_loop_next_row
	beq $t2, $zero, vertical_loop_next_row
	beq $t3, $zero, vertical_loop_next_row

    # else check whether tile one and the second tile are the same
	beq $t0, $t1, vertical_loop_check_a
	j vertical_loop_next_row
vertical_loop_check_a: # check whether the second tile and tile three are the same
	beq $t1, $t2, vertical_loop_check_b
	j vertical_loop_next_row
vertical_loop_check_b: # check whether tile three and tile four are the same
	beq $t2, $t3, found_four_in_a_column # we have found four_in_a_column
	j vertical_loop_next_row # else we check for four_in_a_column starting from the next row
vertical_loop_next_row: # move to the next row
	addi $t4, $t4, 1 # add one to the row counter
	addi $t6, $t6, 128
	j vertical_loop
vertical_loop_next_column: # move to the next column
	bge $t5, 10, completion # end looping after we have checked over the tenth column
	addi $t5, $t5, 1 # add one to the column counter
	li $t4, 0 # reset the row counter (0 - 10) for each column

	move $t6, $s4
	sll $t7, $t5, 2
	add $t6, $t6, $t7
	j vertical_loop
found_four_in_a_column: # we have found four_in_a_column, and now we check for unsupported capsules
    lw $t8, 0($t6)
    la $t9, 0x39FF14
    beq $t8, $t9, handle_four_green_in_a_column
    
    la $t8, 0x505050
    lw $t9, COLOR_BLACK

    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall

	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4
	
    jr $ra
handle_four_green_in_a_column:
    la $t8, 0x505050
    lw $t9, COLOR_BLACK

    lw $t0, -128($t6)
    lw $t1, 512($t6)
    lw $t2, COLOR_WHITE
    
    beq $t0, $t2, handle_green_column_ceiling
    beq $t1, $t2, handle_green_column_floor
    
    sw $t8, -128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 512($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 512($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, -128($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jr $ra 
handle_green_column_ceiling:
    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 512($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 512($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jr $ra
handle_green_column_floor:
    sw $t8, -128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 384($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 256($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 128($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, -128($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jr $ra

# check for four_in_a_row
is_four_in_a_row:
	move $t6, $s4
	li $t4, 0 # row counter
	li $t5, 0 # column counter

	j horizontal_loop
horizontal_loop: # a horizontal_loop through each column
	bge $t5, 8, horizontal_loop_next_row # move to next row after the seventh column

	lw $t0, 0($t6)
	lw $t1, 4($t6)
	lw $t2, 8($t6)
	lw $t3, 12($t6)

    # move to the next column if any of the tiles are black
	beq $t0, $zero, horizontal_loop_next_column
	beq $t1, $zero, horizontal_loop_next_column
	beq $t2, $zero, horizontal_loop_next_column
	beq $t3, $zero, horizontal_loop_next_column

    # else check whether tile one and the second tile are the same
	beq $t0, $t1, horizontal_loop_check_a
	j horizontal_loop_next_column
horizontal_loop_check_a: # check whether the second tile and tile three are the same
	beq $t1, $t2, horizontal_loop_check_b
	j horizontal_loop_next_column
horizontal_loop_check_b: # check whether tile three and tile four are the same
	beq $t2, $t3, found_four_in_a_row # we have found four_in_a_row
	j horizontal_loop_next_column # else we check for four_in_a_row starting from the next column
horizontal_loop_next_column: # move to the next column
	addi $t5, $t5, 1 # add one to the row counter
	addi $t6, $t6, 4
	j horizontal_loop
horizontal_loop_next_row: # move to the next row
	bge $t4, 13, completion # end looping after we have checked over the thirteenth row
	
	addi $t4, $t4, 1  # add one to the row counter
	li $t5, 0 # reset the column counter (0 - 7) for each row

	add $t6, $t6, 96
	j horizontal_loop
found_four_in_a_row: # we have found four_in_a_row, and now we check for unsupported capsules
	lw $t8, 0($t6)
    la $t9, 0x39FF14
    beq $t8, $t9, handle_four_green_in_a_row
    
    la $t8, 0x505050
    lw $t9, COLOR_BLACK

    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall

	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4
	
    jr $ra
handle_four_green_in_a_row:
    la $t8, 0x505050
    lw $t9, COLOR_BLACK

    lw $t0, -4($t6)
    lw $t1, 16($t6)
    lw $t2, COLOR_WHITE
    
    beq $t0, $t2, handle_green_row_left
    beq $t1, $t2, handle_green_row_right

    sw $t8, -4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 16($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 16($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, -4($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jr $ra
handle_green_row_left:
    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 16($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 16($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4
    
    jr $ra
handle_green_row_right:
    sw $t8, -4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t8, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    sw $t9, 12($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 8($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 4($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, 0($t6)
    li $v0, 32 
    li $a0, 150
    syscall
    sw $t9, -4($t6)
    li $v0, 32 
    li $a0, 150
    syscall

    addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_unsupported_capsule
	lw $ra, 0($sp) 
    addi $sp, $sp, 4

    jr $ra

is_unsupported_capsule:
	move $t6, $s4
	li $t4, 0 # row counter
	li $t5, 0 # column counter

	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal field_loop
	lw $ra, 0($sp) 
    addi $sp, $sp, 4 

	jr $ra
field_loop:
	bge $t5, 11, next_row
	lw $t0, 0($t6)

    li $t1, 1688
    add $t1, $t1, $s0
    beq $t6, $t1, next_column
    li $t1, 2728
    add $t1, $t1, $s0
    beq $t6, $t1, next_column
    li $t1, 2064              
    add $t1, $t1, $s0 
    beq $t6, $t1, next_column

	bne $t0, $zero, is_unsupported_below

	addi $t5, $t5, 1
	addi $t6, $t6, 4
	
	j field_loop
next_row:
	bge $t4, 13, completion
	
	addi $t4, $t4, 1
	li $t5, 0
	add $t6, $t6, 84
	
	j field_loop
next_column:
	addi $t5, $t5, 1
	addi $t6, $t6, 4

	j field_loop
is_unsupported_below:
	lw $t1, 128($t6)
	bne $t1, $zero, next_column

    lw $t1, 128($t6) # checking the tile below
    bne $t1, $zero, next_column  # if below, it is supported

    j is_left
is_left:
    lw $t1, -4($t6) # left side
    bne $t1, $zero, is_unsupported_left # then there is a left, so we check whether such is supported
    j is_right # else we return for checking the right side
is_unsupported_left:
    lw $t2, 124($t6) # below the left side
    bne $t2, $zero, next_column # then the left is supported, so we return to next column
    j is_right # else we return for checking the right side, as it could be unsupported on the left but supported on the right
is_right:
    lw $t3, 4($t6) # right side
    bne $t3, $zero, is_unsupported_right # then there is a right, so we check whether such is supported

	j falling_loop # else this is an unsupported capsule and we return

is_unsupported_right:
    lw $t4, 132($t6) # below the right side
    bne $t4, $zero, next_column # then the right is supported, so we return to next column

	j falling_loop # else this is an unsupported capsule and we return
falling_loop:
   li $v0, 32 
   li $a0, 30 
   syscall
   
   lw $t9, COLOR_BLACK
   lw $t1, 128($t6)

   bne $t1, $zero, unsupported_is_four
   
   addi $t6, $t6, 128

   sw $t0, 0($t6)
   sw $t9, -128($t6)

   li $v0, 32
   li $a0, 30
   syscall

   j falling_loop # continue looping
unsupported_is_four: # check whether the fallen unsupported capsules have been a four_in_a_row or four_in_a_column
	addi $sp, $sp, -4
    sw $ra, 0($sp)
	jal is_four
	lw $ra, 0($sp) 
    addi $sp, $sp, 4 

    j is_unsupported_capsule
    
completion:
    jr $ra

# ----------------------------------------------------------------------------
# [4] now, we allow our program to sleep.
sleep:
    li $v0, 32 
    li $a0, 17 # sleep for 1/60 of a second 
    syscall
    jr $ra

# Wania Gondal <3
