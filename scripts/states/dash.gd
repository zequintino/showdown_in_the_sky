extends State


@export var curve : Curve


func update(delta):
	if not player.dashing:
		player.handle_move_input()
		player.gravity(delta)
		
		if player.is_on_floor():
			if player.anim_sprite.flip_h:
				player.velocity.x = 50
			else:
				player.velocity.x = -50
		
		if player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
			return states.IDLE
		elif player.velocity.y > Vector2.ZERO.y:
			return states.FALL
		elif player.direction_x != Vector2.ZERO.x:
			return states.WALK
	else:
		return null


func enter_state():
	player.anim_sprite.play("dash")
	player.dashing = true
	player.velocity.y = Vector2.ZERO.y
	
	if player.anim_sprite.flip_h:
		player.dash("right")
	else:
		player.dash("left")
