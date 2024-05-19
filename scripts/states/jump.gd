extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)
	
	if player.is_on_floor() and !player.direction_x:
		return states.IDLE
	elif player.is_on_floor() and player.direction_x:
		return states.WALK
	elif Input.is_action_just_pressed(player.player_input.jump) and not player.double_jumping:
		player.double_jumping = true
		return states.JUMP
	elif player.velocity.y > Vector2.ZERO.y:
		return states.FALL
	elif Input.is_action_just_pressed(player.player_input.punch):
		return states.PUNCH
	elif Input.is_action_just_pressed(player.player_input.kick):
		return states.KICK
	elif Input.is_action_just_pressed(player.player_input.dash):
		return states.DASH
	elif player.is_hurt:
		return states.HURT
	else:
		return null	


func enter_state():
	player.anim_sprite.play("jump")
	
	if player.double_jumping:
		player.velocity.y = player.jump_speed + player.double_jump_speed
	else:
		player.velocity.y = player.jump_speed


func change_state():
	pass
