extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -250
export (int) var gravity = 800
# input sample with accel or friction adjust
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
# This represents the player's inertia.
export (int, 0, 5000) var push = 50

var velocity = Vector2.ZERO

# input sample with no accel or friction adjust
#func get_input():
#	velocity.x = 0
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += speed
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= speed


func get_input():
	var dir = 0 #every input cycle it resets dir to either -1, 0, 1
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		$CollisionShape2D.scale.x = dir
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	if !dir:
		print(dir)
		

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	#velocity = move_and_slide(velocity, Vector2.UP)
	velocity = move_and_slide(velocity, Vector2.UP,
					 false, 4, PI/4, false)
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_speed
			
	# after calling move_and_slide()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

