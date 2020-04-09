##

extends KinematicBody2D


export (int) var speed = 200
export (int) var jump_speed = -250
export (int) var gravity = 800
# input sample with accel or friction adjust
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
# this is the force  amount it pushes rigid bodies
export (int, 0, 5000) var push = 50
# this for double jumps
#export (int, 0, 3) var MAXJMPS
const MAXJMPS = 2

var velocity = Vector2.ZERO

#gndSensor vars:
onready var rcGndL = $CollisionShape2D/rcGndL
onready var rcGndR = $CollisionShape2D/rcGndR



# input sample with no accel or friction adjust
#func get_input():
#	velocity.x = 0
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += speed
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= speed

##the mouse handler sample script. 
#func _input(event):
#	# Mouse in viewport coordinates
#	if event is InputEventMouseButton:
#		print("Mouse Click/Unclick at: ", event.position)
#	elif event is InputEventMouseMotion:
#		print("Mouse Motion at: ", event.position)
## Print the size of the viewport
#	print("Viewport Resolution is: ", get_viewport_rect().size)
#	#end mouse handler.

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
	
	#player presses button and prayer starts.
#	if Input.is_action_just_pressed("pray"):
		

func detectGND(): 
	var GNDresult : int = false
	if rcGndL.is_colliding() or rcGndR.is_colliding():
		GNDresult = true
	else:
		GNDresult = false
#	print(GNDresult)
	return GNDresult
	

func jmp():
	velocity.y = jump_speed

func _physics_process(delta):
	var is_grounded = detectGND() #detect gnd with custom handler
	get_input()
	velocity.y += gravity * delta
	#velocity = move_and_slide(velocity, Vector2.UP)
	velocity = move_and_slide(velocity, Vector2.UP,
					 false, 4, PI/4, false)
	if Input.is_action_just_pressed("jmp"):
		if is_grounded:
#			jmp(jump_speed)
			velocity.y = jump_speed
			
	# after calling move_and_slide()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

