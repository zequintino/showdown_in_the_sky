extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)
	
	if not player.buffer_input_timer.is_stopped() and player.is_on_floor():
		player.buffer_input_timer.stop()
		match player.queued_input:
			"jump": 
				# if player.double_jumping:
				return states.JUMP
	elif player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
		return states.IDLE
	elif player.is_on_floor() and player.direction_x != Vector2.ZERO.x:
		return states.WALK
	# elif Input.is_action_just_pressed(player.player_input.jump) and not player.double_jumping:
	# 	player.double_jumping = true
	# 	return states.JUMP
	# elif Input.is_action_just_pressed(player.player_input.punch):
	# 	return states.PUNCH
	elif Input.is_action_just_pressed(player.player_input.kick) and player.kick_timer.is_stopped():
			return states.KICK
	elif Input.is_action_just_pressed(player.player_input.dash) and player.dash_timer.is_stopped():
		return states.DASH
	elif Input.is_action_just_pressed(player.player_input.slam) and player.slam_timer.is_stopped():
		return states.SLAM
	elif player.is_hurt:
		return states.HURT
	else:
		return null


func enter_state():
	player.anim_sprite.play("fall")
	
