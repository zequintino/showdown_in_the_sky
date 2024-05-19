extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)
	
	if player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
		return states.IDLE
	elif player.is_on_floor() and player.direction_x != Vector2.ZERO.x:
		return states.WALK
	elif Input.is_action_just_pressed(player.player_input.jump) and not player.double_jumping:
		player.double_jumping = true
		return states.JUMP
	elif Input.is_action_just_pressed(player.player_input.punch):
		return states.PUNCH
	elif Input.is_action_just_pressed(player.player_input.kick):
			return states.KICK
	elif Input.is_action_just_pressed(player.player_input.dash):
		return states.DASH
	elif player.is_hurt:
		return states.HURT
	
	return null


func enter_state():
	player.anim_sprite.play("fall")
	
