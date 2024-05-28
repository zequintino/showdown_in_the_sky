extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input(delta)
	
	if player.direction_x != Vector2.ZERO.x:
		return states.WALK
	elif Input.is_action_just_pressed(player.player_input.jump):
		return states.JUMP
	elif player.velocity.y > Vector2.ZERO.y:
		return states.FALL
	elif Input.is_action_just_pressed(player.player_input.punch):
		return states.PUNCH
	elif Input.is_action_just_pressed(player.player_input.kick):
		return states.KICK
	elif Input.is_action_just_pressed(player.player_input.dash) and player.dash_timer.is_stopped():
		return states.DASH
	elif player.is_hurt:
		return states.HURT
	elif player.disintegrating:
		return states.DISINTEGRATE
	else:
		return null


func enter_state():
	player.anim_sprite.play("idle")
	player.double_jumping = false
