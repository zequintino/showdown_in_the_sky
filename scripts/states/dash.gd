extends State


@export var curve : Curve

## Speed of the dash curve. Default: 400
@export var curve_factor = 400
var curve_time = 0.0



func update(delta):
	if player.dashing:
		dash()
	else:
		player.velocity.x = Vector2.ZERO.x
		player.gravity(delta)
		player.dash_timer.start()
		
		curve_time = 0.0
		
		if not player.buffer_input_timer.is_stopped():
			player.buffer_input_timer.stop()
			match player.queued_input:
				# Double jump
				# "jump": return states.JUMP
				"punch": return states.PUNCH
				"kick":
					if player.kick_timer.is_stopped():
						return states.KICK
		elif player.is_on_floor() and player.direction_x == Vector2.ZERO.x:
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
	

func dash():
	curve_time += 0.06 
	
	if player.anim_sprite.flip_h: # Facing right
		player.velocity.x = curve.sample(curve_time) * curve_factor
	else: # Facing left
		player.velocity.x = curve.sample(curve_time) * -curve_factor

	curve_time = clamp(curve_time, 0, 1)
	print("curve_time: ", curve_time)
	
