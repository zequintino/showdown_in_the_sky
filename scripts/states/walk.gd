extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)
	
	if player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
		return states.IDLE
	elif Input.is_action_just_pressed(player.player_input.jump):
		return states.JUMP
	elif player.velocity.y > 0:
		return states.FALL
	elif Input.is_action_just_pressed(player.player_input.punch):
		return states.PUNCH
	elif Input.is_action_just_pressed(player.player_input.kick) and player.kick_timer.is_stopped():
		return states.KICK
	elif Input.is_action_just_pressed(player.player_input.dash) and player.dash_timer.is_stopped():
		return states.DASH
	elif player.is_hurt:
		return states.HURT
	
	return null


func enter_state():
	player.anim_sprite.play("walk")
	player.double_jumping = false
