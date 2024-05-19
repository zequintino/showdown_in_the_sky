extends State


func update(delta):
	# buffer punch
	if player.kicking and Input.is_action_just_pressed(player.player_input.kick):
		player.buffer_timer.stop()
		player.buffer_timer.start()
	elif not player.kicking:
		player.gravity(delta)
		# player.handle_move_input(delta)
		
		if not player.buffer_timer.is_stopped():
			player.buffer_timer.stop()
			return states.KICK
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
		player.velocity.x = move_toward(player.kick_speed, Vector2.RIGHT.x, player.decel)
	else:
		player.velocity.x = move_toward(-player.kick_speed, Vector2.LEFT.x, player.decel)

	# player.get_tree().create_tween().tween_property(player, "velocity:x", 0.5, Tween.EASE_IN_OUT)
