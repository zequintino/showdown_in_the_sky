extends State


@export var curve : Curve
var curve_time = 0.0
var curve_factor = 400 # speed of curve


func update(delta):
	# player.handle_move_input(delta)
	if player.dashing:
		if curve:
			print("player.direction_x", player.direction_x)
			curve_time += 0.1 #0.059 # * player.direction_x
			if player.anim_sprite.flip_h: # facing right
				player.velocity.x = curve.sample(curve_time) * curve_factor #500 is factor
			else: # facing left
				player.velocity.x = curve.sample(curve_time) * -curve_factor

			# curve_time = clamp(curve_time, 0, 1)
			print("curve_time: ", curve_time)
	
	elif not player.dashing:
		curve_time = 0.0
		player.gravity(delta)
		# if player.is_on_floor():
		player.velocity.x = Vector2.ZERO.x


		if not player.buffer_input_timer.is_stopped():
			player.buffer_input_timer.stop()
			print("player.queued_input: ", player.queued_input)
			match player.queued_input:
				"jump": return states.JUMP
				"dash": return states.DASH
				"punch": return states.PUNCH
				"kick": return states.KICK
				
		elif player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
			return states.IDLE
		elif player.velocity.y > Vector2.ZERO.y:
			return states.FALL
		elif player.direction_x != Vector2.ZERO.x:
			return states.WALK
	else:
		return null


func enter_state():
	player.anim_sprite.play("dash")
	player.dashing = true
	player.velocity.y = Vector2.ZERO.y
	
	# if player.anim_sprite.flip_h: # facing right
	# 	dash("right")
	# else:
	# 	dash("left")


func dash(dash_direction):
	if dash_direction == "right":
		player.velocity.x = move_toward(player.dash_speed, Vector2.RIGHT.x, player.action_accel)
	else:
		player.velocity.x = move_toward(-player.dash_speed, Vector2.LEFT.x, player.action_accel)
	# print("player.velocity.x: ", player.velocity.x)
	
