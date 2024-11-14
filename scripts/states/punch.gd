extends State


func handle_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed(player.player_input.jump): #and not player.double_jumping:
				player.double_jumping = true
				return states.JUMP


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)

	if not player.punching:
		player.punch_coll.disabled = true
		
		if not player.buffer_input_timer.is_stopped():
			player.buffer_input_timer.stop()
			match player.queued_input:
				"jump":
					if player.is_on_floor():
						return states.JUMP
				"dash": 
					if player.dash_timer.is_stopped():
						return states.DASH
				"punch": return states.PUNCH
				"kick": 
					if player.kick_timer.is_stopped():
						return states.KICK
		elif player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
			return states.IDLE
		elif player.direction_x != Vector2.ZERO.x:
			return states.WALK
		elif player.velocity.y > Vector2.ZERO.y:
			return states.FALL
	else:
		return null


func enter_state():
	player.anim_sprite.play("punch")
	player.punching = true
	player.punch_coll.disabled = false
