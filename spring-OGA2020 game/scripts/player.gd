extends KinematicBody2D

export (int) var speed = 100
export (int) var jump_speed = -150
export (int) var gravity = 300

# input sample with accel or friction adjust
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.1
# This represents the player's inertia.
export (int, 0, 5000) var push = 50

var velocity = Vector2.ZERO
var dbgStates
var dbgCoyotesCanJump = true

var isJumping: bool = false


onready var cytTimer = $cytTimer
onready var cytJBuffer = $cytJBuffer

onready var leftLeg = $raycasts/leftLeg
onready var rightLeg = $raycasts/rightLeg
onready var wallLeft = $raycasts/wallLeft
onready var wallRight = $raycasts/wallRight 

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		$AniSprite.scale.x = dir
		#make state machine for this.
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
#func resolveMovement(delta):
#	get_input() #get inputs
#	applyGrav(delta) #add gravity to velocity
##	applyMovement() #this calls the move_and_slide
#	if is_on_floor() :
#		jump() #
#		pass

func jump():
	velocity.y = jump_speed
	isJumping = true

func applyGrav(delta):
	velocity.y += gravity * delta #gravity
	if isJumping && velocity.y >= 0:
		if is_on_floor():
			cytTimer.stop()
			isJumping = false
			

func applyMovement(delta):
	var wasOnFloor = is_on_floor()
	dbgStates = wasOnFloor
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	
	if !is_on_floor() && wasOnFloor && !isJumping:
		cytTimer.start()
	
	for index in get_slide_count(): # after calling move_and_slide()
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if is_on_floor() || !cytTimer.is_stopped():
			cytTimer.stop()
			jump()

func _physics_process(delta):
	get_input()
	applyGrav(delta)
	applyMovement(delta)
	
	if Input.is_action_just_pressed("pray"):
		dbgStates = $PLAYERHEART.heartColorArray[0][0]
		prints(dbgStates)
		
	
	prints(cytTimer.time_left)


func _on_cytTimer_timeout():
	pass # Replace with function body.
