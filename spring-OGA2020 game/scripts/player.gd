
##
extends KinematicBody2D


#export vars to editor for ease even though i never use the editor
export (int) var speed = 200
export (int) var jump_speed = -250
export (int) var gravity = 400
# input sample with accel or friction adjust
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
# this is the force  amount it pushes rigid bodies
export (int, 0, 5000) var push = 50
# this for double jumps
#export (int, 0, 3) var MAXJMPS
const MAXJMPS = 2

var velocity = Vector2.ZERO
var coyoteCanJump : bool
var jmp_timer : float

#gndSensor vars:
onready var rcGndL = $CollisionShape2D/rays/rcGndL
onready var rcGndR = $CollisionShape2D/rays/rcGndR
onready var rcWallL = $CollisionShape2D/rays/rcWallL
onready var rcWallR = $CollisionShape2D/rays/rcWallR

#jump timer
export (float, 0 , 1) var coyoteTime : float

onready var cyTimer = $coyote_timer
onready var cyCanJump = true

func get_input():
	var dir = 0 #every input cycle it resets dir to either -1, 0, 1
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		$CollisionShape2D.scale.x = dir
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	#jump
#	if Input.is_action_just_pressed("jmp"):
#		if detectGND():
#			jmp_timer += delta()
#
#			jump()
	
	#player presses button and prayer starts.
	if Input.is_action_just_pressed("pray"):
		
		pass

func detectGND(delta): #can Jump Detector
	#this handles all the wall/gnd sensing.
	var GNDresult : bool = false #the result
	
#	this is garbage, the fix should look like this:
#	canJump(bool):
#	result == false
#	if is_touch ground:
#		results == true:
#	else:
#	 	if not test if coyote time is > 0.4:
#			results == true
#		else:
#			results == false
#	return result



	if rcGndL.is_colliding() or rcGndR.is_colliding() or rcWallL.is_colliding() or rcWallR.is_colliding():
		GNDresult = true
		coyoteCanJump=true
#		jmp_timer += delta
	else:
		GNDresult = false
#		if jmp_timer > coyoteTime:
#			coyoteCanJump=true
#		else:
#			coyoteCanJump=false

	return GNDresult


func jump():
	velocity.y = jump_speed

func _physics_process(delta):
	get_input()
	
	#this is the gravity pulling groundwards.
	velocity.y += gravity * delta
	
	#velocity = move_and_slide(velocity, Vector2.UP)
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	
	#jump code needs to be in phy_Process to gain access to delta?
	if detectGND(delta): #check can jump
		jmp_timer += delta #start jump timer
#		cytimer.start()
		
		if (Input.is_action_just_pressed("jmp") and coyoteCanJump):
			jmp_timer = 0
			jump()
	
	print(coyoteCanJump, jmp_timer)
	
#	#the objects pusher. this is necessary for pushing ridigbodys
#	# after calling move_and_slide()
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider.is_in_group("bodies"):
#			collision.collider.apply_central_impulse(-collision.normal * push)
