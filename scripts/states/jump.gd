extends State


@export var curve : Curve

## Speed of the jump curve. Default: -180
@export var curve_factor = -180
var curve_time = 0.0
var jumping = false


func handle_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed(player.player_input.punch):
				curve_time = 0.0
				return states.PUNCH
			elif Input.is_action_just_pressed(player.player_input.kick):
				curve_time = 0.0
				return states.KICK
			elif Input.is_action_just_pressed(player.player_input.dash) and player.dash_timer.is_stopped():
				jumping = false
				curve_time = 0.0
				return states.DASH

func update(delta):
	player.handle_move_input(delta)
	player.gravity(delta)

	# Double jump
	# if Input.is_action_just_pressed(player.player_input.jump) and not player.is_on_floor() and not player.double_jumping:
	# 	player.double_jumping = true
	# 	curve_time = 0.0
	# 	return states.JUMP

	if jumping:
		jump()

		if player.is_hurt:
			curve_time = 0.0
			return states.HURT
		else:
			return null
	else:
		curve_time = 0.0
		
		if player.is_on_floor() and !player.direction_x:
			return states.IDLE
		elif player.is_on_floor() and player.direction_x:
			return states.WALK
		elif player.velocity.y > Vector2.ZERO.y:
			return states.FALL
		else:
			return null	


func enter_state():
	jumping = true
	player.anim_sprite.play("jump")


func jump():
	curve_time += 0.05
	
	# Single jump
	player.velocity.y = curve.sample(curve_time) * (curve_factor)
	print(player.velocity.y)
	print(player.position.y)
	# Double jump
	# if not player.double_jumping:
	# 	player.velocity.y = curve.sample(curve_time) * (curve_factor)
	# else:
	# 	player.velocity.y = curve.sample(curve_time) * (curve_factor + 20)

	curve_time = clamp(curve_time, 0, 1)
	print(curve_time)
	
	if curve_time == 1:
		jumping = false
	