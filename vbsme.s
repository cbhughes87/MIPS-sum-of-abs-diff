#  Team Members:    Christopher Hughes & Sarah Wiltbank
#  % Effort    :   Christopher Hughes 50 / 50 Sarah Wiltbank
#
# ECE369A,  
# 

########################################################################################################################
### data
########################################################################################################################
.data
# test input
# asize : dimensions of the frame [i, j] and window [k, l]
#         i: number of rows,  j: number of cols
#         k: number of rows,  l: number of cols  
# frame : frame data with i*j number of pixel values
# window: search window with k*l number of pixel values
#
# $v0 is for row / $v1 is for column
#  Test Score
#   1    12
#   2    12
#   3    12
#   4    12
#   5    12
#   6    15
#   7    15
#   8    16
#   9    16
#  10    16
#  11    16
#  12    16
#  13    15
#  If any of the tests  7 through 12 fails then search pattern is not correct. Check for implementation
# if you confirm search pattern is not zig zag follow the grading criteria in the word document for penalty
# conditions

# test 10 For the 16X16 frame size and 4X4 window size
# The result should be 1, 12 Move down
#Test case checks for a downward movement when hitting the right boundary following an upward diagonal movement

asize9:  .word    16, 16, 4, 4    #i, j, k, l
frame9:  .word    0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         .word    1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 
         .word    2, 3, 32, 1, 2, 3, 12, 14, 16, 18, 20, 1, 1, 2, 3, 4, 
         .word    3, 4, 1, 2, 3, 4, 18, 21, 24, 27, 30, 33, 2, 3, 4, 5, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 3, 4, 5, 6, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 3, 4, 5, 6, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 10, 3, 100, 3, 
         .word    0, 13, 26, 39, 52, 65, 78, 91, 104, 114, 130, 143, 36, 42, 23, 44, 
         .word    0, 14, 28, 42, 56, 70, 84, 98, 112, 126, 140, 154, 25, 34, 33, 58, 
         .word    0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 35, 74, 55, 66 
window9: .word    0, 1, 2, 3, 
         .word    1, 2, 3, 4, 
         .word    2, 3, 4, 5, 
         .word    3, 4, 5, 6 


newline: .asciiz     "\n" 


########################################################################################################################
### main
########################################################################################################################

.text

.globl main

main: 
    addi    $sp, $sp, -4    # Make space on stack
    sw      $ra, 0($sp)     # Save return address
 
   
    # Start test 9 
    ############################################################
    la      $a0, asize9     # 1st parameter: address of asize9[0]
    la      $a1, frame9     # 2nd parameter: address of frame9[0]
    la      $a2, window9    # 3rd parameter: address of window9[0] 

    jal     vbsme           # call function
    endProg:
   j endProg
    ############################################################
    # End of test 9      


#####################################################################
### vbsme
#####################################################################


# vbsme.s 
# motion estimation is a routine in h.264 video codec that 
# takes about 80% of the execution time of the whole code
# given a frame(2d array, x and y dimensions can be any integer 
# between 16 and 64) where "frame data" is stored under "frame"  
# and a window (2d array of size 4x4, 4x8, 8x4, 8x8, 8x16, 16x8
# or 16x16) where "window data" is stored under "window" 
# and size of "window" and "frame" arrays are stored under
# "asize"

# - initially current sum of difference is set to a very large value
# - move "window" over the "frame" one cell at a time starting with location (0,0)
# - moves are based on zigzag pattern 
# - for each move, function calculates  the sum of absolute difference (SAD) 
#   between the window and the overlapping block on the frame.
# - if the calculated sum of difference is less than the current sum of difference
#   then the current sum of difference is updated and the coordinate of the top left corner 
#   for that matching block in the frame is recorded. 

# for example SAD of two 4x4 arrays "window" and "block" shown below is 3  
# window         block
# -------       --------
# 1 2 2 3       1 4 2 3  
# 0 0 3 2       0 0 3 2
# 0 0 0 0       0 0 0 0 
# 1 0 0 5       1 0 0 4

# program keeps track of the window position that results 
# with the minimum sum of absolute difference. 
# after scannig the whole frame
# program returns the coordinates of the block with the minimum SAD
# in $v0 (row) and $v1 (col) 


# Sample Inputs and Output shown below:
# Frame:
#
#  0   1   2   3   0   0   0   0   0   0   0   0   0   0   0   0 
#  1   2   3   4   4   5   6   7   8   9  10  11  12  13  14  15 
#  2   3  32   1   2   3  12  14  16  18  20  22  24  26  28  30 
#  3   4   1   2   3   4  18  21  24  27  30  33  36  39  42  45 
#  0   4   2   3   4   5  24  28  32  36  40  44  48  52  56  60 
#  0   5   3   4   5   6  30  35  40  45  50  55  60  65  70  75 
#  0   6  12  18  24  30  36  42  48  54  60  66  72  78  84  90 
#  0   7  14  21  28  35  42  49  56  63  70  77  84  91  98 105 
#  0   8  16  24  32  40  48  56  64  72  80  88  96 104 112 120 
#  0   9  18  27  36  45  54  63  72  81  90  99 108 117 126 135 
#  0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 
#  0  11  22  33  44  55  66  77  88  99 110 121 132 143 154 165 
#  0  12  24  36  48  60  72  84  96 108 120 132   0   1   2   3 
#  0  13  26  39  52  65  78  91 104 117 130 143   1   2   3   4 
#  0  14  28  42  56  70  84  98 112 126 140 154   2   3   4   5 
#  0  15  30  45  60  75  90 105 120 135 150 165   3   4   5   6 

# Window:
#  0   1   2   3 
#  1   2   3   4 
#  2   3   4   5 
#  3   4   5   6 

# cord x = 12, cord y = 12 returned in $v0 and $v1 registers

 
.text
.globl  vbsme


# Preconditions:
#   1st parameter (a0) address of the first element of the dimension info (address of asize[0])
#   2nd parameter (a1) address of the first element of the frame array (address of frame[0][0])
#   3rd parameter (a2) address of the first element of the window array (address of window[0][0])
# Postconditions: 
#   result (v0) x coordinate of the block in the frame with the minimum SAD
#          (v1) y coordinate of the block in the frame with the minimum SAD


# Begin subroutine
vbsme:  
    li      $v0, 0               # reset $v0 and $V1
    li      $v1, 0

    addi    $sp, $sp, -4         # make space on the stack
    sw      $ra, 0($sp)          # store the return address on the stack

    li      $s0, 0               # s0 will be the x coordinate starting at 0
    li      $s1, 0               # s1 will be the y coordinate starting at 0
    jal     calcEnds          # will find the max x position and set $s2 equal to that value
    li      $s4, 4000            # $s4 will keep the lowest SAD score, initialize at very  so when SAD is called the first time it will initialize to first value
    jal     SAD                  # calculate SAD for starting position
   jal      checkEnd          # check if reached end of path

  ShiftRight:
   addi  $s0, $s0, 1          # increment x coordinate by one
   jal      SAD               # calculate new SAD
   jal   checkEnd             # Check if reached last position
   beq   $s1, 0, ShiftDownLeft   # if y = 0 go to shiftDownLeft function
   j     ShiftUpRight         # if y != 0 go to shiftUpRight funtion

  ShiftDown:
   addi  $s1, $s1, 1          # increment y coordinate by one
   jal   SAD                  # calculate and check SAD at new position
   jal      checkEnd          # check if reached end of path
   beq      $s0, 0, ShiftUpRight    # if x = 0 go to function shiftUpRight

  ShiftDownLeft:
   addi  $s0, $s0, -1         # decrement x coordinate by one
   addi  $s1, $s1, 1          # increment y coordinate by one
   jal   SAD                  # calculate and check SAD at new position
   beq   $s1, $s3, ShiftRight    # if y = ymax go to function ShiftRight
   beq   $s0, $zero, ShiftDown   # if x = 0 go to function ShiftDown
   j     ShiftDownLeft        # if y!= ymax && x != 0 then loop back to ShiftDownLeft Function

  ShiftUpRight:      
   addi  $s0, $s0, 1          # increment x coordinate by one
   addi  $s1, $s1, -1         # decrement x coorcinate by one
   jal   SAD                  # calculate and check SAD at new postion
   beq   $s0, $s2, ShiftDown  # if x = xmax go to function ShiftDown
   beq   $s1, $zero, ShiftRight  # if y = 0 go to function ShiftRight
   j     ShiftUpRight         # if x!= xmax && y != 0 loop back to ShiftUpRight funciton

  calcEnds:
   lw       $t0, 4($a0)          # t0 = frame x size
   lw       $t1, 12($a0)         # t1 = window x size
   sub   $s2, $t0, $t1        # s2 = xmax position
   lw       $t0, 0($a0)          # t0 = frame y size
   lw       $t1, 8($a0)          # t1 = window y size
   sub   $s3, $t0, $t1        # s3 = ymax position
   j     $ra

  checkEnd:                   # checkEnd tests the current position to see if the end of the path has been reached
   bne   $s0, $s2, notEnd     # if x != xmax return to linked address
   bne   $s1, $s3, notEnd     # if y != ymax return to linked address
   lw       $ra, 0($sp)          # get the return address from the stack onto ra
    addi    $sp, $sp, 4          # remove space from the stack
    jr      $ra               # return from the vbsme function

  notEnd:
   j     $ra               # did not reach the end of the path, return to linked address
   
   SAD:                       # calculates the new SAD and updates if current position is the lowest SAD
   addi  $s5, $s0, 0          # store current x location into $s5
   addi  $s6, $s1, 0          # stores current y location into $s6
   li       $s7, 0               # set $s7 = 0 to keep track of current SAD
   addi  $sp, $sp, -4         # make space on the stack
    sw      $ra, 0($sp)          # store the return address on the stack
    jal     calcSAD

  shiftRightSAD:
   addi  $s5, $s5, 1          # shifts the xCoordinate by one
   jal   calcSAD

  checkRightSAD:
   lw       $t0, 12($a0)         # store the x window size into $t0
   add   $t0, $s0, $t0        # add start SAD x position to x window size
   addi  $t0, $t0, -1         # subtract 1
   beq   $t0, $s5, checkBottomSAD # if current SAD x coordinate is at the end go down one
   j     shiftRightSAD        # if not at end right go to shiftRightSAD

  checkBottomSAD:
   lw       $t0, 8($a0)          # store the y window size into $t0
   add   $t0, $s1, $t0        # add start SAD y position to y window size
   addi  $t0, $t0, -1         # subtract one
   beq   $t0, $s6, EndSAD     # if $t0 = $s6 then the end of the SAD is reached, jump to EndSAD
   addi  $s6, $s6, 1          # branch not taken increment SAD y position by one
   addi  $s5, $s0, 0          # change SAD x position back to start
   jal   calcSAD
   j     shiftRightSAD

  calcSAD:
   sub   $t0, $s5, $s0        # sub SAD x position from main position to get window x position
   sub   $t1, $s6, $s1        # find the window y position
   lw       $t2, 12($a0)         # set $t2 = max window x size
   mul   $t2, $t2, $t1        # multiply xmax by y window pos
   add   $t0, $t2, $t0        # add x position, this gives absolute position in window frame
   sll   $t0, $t0, 2          # multiply window position by 4
   add   $t0, $t0, $a2        # add the window position to the window starting address
   lw       $t9, 0($t0)          # store the vlaue of the window position into $t9
   lw       $t0, 4($a0)          # store frame x max into $t0
   mul   $t0, $t0, $s6        # y position times x max
   add   $t0, $t0, $s5        # add the x position, this gives absolute position in the frame
   sll   $t0, $t0, 2          # multiply position by 4
   add   $t0, $t0, $a1        # add the t0 value to the frame starting address
   lw       $t8, 0($t0)          # get the value of the frame position and store into $t8
   slt   $t0, $t8, $t9        # if $t8 < $t9 set $t0 = 1
   beq   $t0, $zero, SUM      # if $t0 == 0 then go to function SUM
   sub   $t0, $t9, $t8
   add   $s7, $s7, $t0        # update SAD total
   j     $ra

  SUM:
   sub   $t0, $t8, $t9        
   add   $s7, $s7, $t0        # update SAD total
   j     $ra

  EndSAD:
   lw       $ra, 0($sp)          # get the return address from the stack onto ra
    addi    $sp, $sp, 4          # remove space from the stack
    slt  $t0, $s4, $s7        # check previous SAD total vs current SAD total, if new SAD is lower $t0 = 0 
    beq  $t0, $zero, updateSAD         # if s7 <= s4 then update new SAD
   j     $ra                  # if s7 > s4 jump back

  updateSAD:
   add   $s4, $s7, $zero      # update new SAD total into $s4
   add   $v0, $s1, $zero         # update new x coordinate
   add   $v1, $s0, $zero         # update new y coordinate
   j     $ra 