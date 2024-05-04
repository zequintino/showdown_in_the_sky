extends State


func update(delta):
	player.gravity(delta)
	player.handle_move_input()
	
	if not player.punching:
		if player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
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
