extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)
	
	# # buffer punch
	# if player.punching and Input.is_action_just_pressed(player.player_input.punch):
	# 	player.buffer_timer.stop()
	# 	player.buffer_timer.start()

	if not player.punching:
		if not player.buffer_input_timer.is_stopped():
			player.buffer_input_timer.stop()
			match player.queued_input:
				"jump": return states.JUMP
				"dash": return states.DASH
				"punch": return states.PUNCH
				"kick": return states.KICK
		elif player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
			return states.IDLE
		elif player.direction_x != Vector2.ZERO.x:
			return states.WALK
		elif Input.is_action_just_pressed(player.player_input.jump) and not player.double_jumping:
			player.double_jumping = true
			return states.JUMP
		elif player.velocity.y > Vector2.ZERO.y:
			return states.FALL
	else:
		return null


func enter_state():
	player.punching = true
	player.punch_coll.disabled = false
	player.anim_sprite.play("punch")
