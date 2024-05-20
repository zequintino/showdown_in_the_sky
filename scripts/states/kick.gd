extends State


func update(delta):
	if not player.kicking:
		player.gravity(delta)
		if not player.buffer_input_timer.is_stopped():
			player.buffer_input_timer.stop()
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
	player.anim_sprite.play("kick")
	player.kicking = true
	player.velocity.y = Vector2.ZERO.y
	player.kick_coll.disabled = false
	
	if player.anim_sprite.flip_h: # facing right
		kick("right")
	else:
		kick("left")
		


func kick(direction):
	if direction == "right":
		player.velocity.x = move_toward(player.kick_speed, Vector2.RIGHT.x, player.decel)
	else:
		player.velocity.x = move_toward(-player.kick_speed, Vector2.LEFT.x, player.decel)