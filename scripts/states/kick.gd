extends State


func update(delta):
	if not player.kicking:
		player.handle_move_input()
		player.gravity(delta)
		
		#if player.is_on_floor():
			#if player.anim_sprite.flip_h:
				#player.velocity.x = 50
			#else:
				#player.velocity.x = -50
		
		if player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
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
	
	if player.anim_sprite.flip_h:
		player.velocity.x = lerp(200.0, Vector2.RIGHT.x * player.speed, 0.1)
	else:
		player.velocity.x = lerp(-200.0, Vector2.LEFT.x * player.speed, 0.1)

