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

enum lastDir {LEFT, RIGHT}

enum P_STATE{OFFSCREEN, IDLE, WALKING, JUMPING} #new STATE MACHINE for clean anims.

onready var heart = $HEART

onready var cytTimer = $cytTimer
var dbgAutojump: bool = false

#onready var cytJBuffer = $cytJBuffer

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
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	

func jump():
	velocity.y = jump_speed
	isJumping = true

func applyGrav(delta):
	if cytTimer.wait_time > 0.01:
		velocity.y += gravity * delta #gravity
	if isJumping && velocity.y >= 0:
		if is_on_floor():
			cytTimer.stop()
			isJumping = false
			

func applyMovement(delta):
	var wasOnFloor = is_on_floor() #must always be before move_and_slide
	
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	
	if !is_on_floor() && wasOnFloor && !isJumping: #must be after move_and_slide
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
	dbgAutojump =false
	
	get_input()
	applyGrav(delta)
	applyMovement(delta)
	
	if Input.is_action_pressed("autoJump"):
		dbgAutojump = true
	
	if cytTimer.time_left > 0.1: print(cytTimer.time_left)


func _on_cytTimer_timeout():
	if dbgAutojump == true:
		jump()
		print("jump")
	else:
		print("coyotes can no longer jump")
		

