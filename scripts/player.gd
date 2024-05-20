#class_name Player
extends CharacterBody2D


## Character movement speed. Default: 95.0
@export_range(0.0, 100.0) var move_speed = 70.0
## Character jump speed. Default: -230.0
@export_range(-500.0, 0.0) var jump_speed = -145.0
## Character kick speed. Default: 130.0
@export_range(0.0, 1000.0) var kick_speed = 130.0
## Character dash speed. Default: 150.0
@export_range(0.0, 1000.0) var dash_speed = 100.0
## Movement top speed offset. Default: 0.1
@export_range(0.0 , 1.0) var accel = 6.0
## Movement decel. Default: 0.12
@export_range(0.0, 1.0) var decel = 5.0
## Action accel. Default: -80.0
@export_range(0.0, 1.0) var action_accel = -100.0
# ## Action decel. Default:
# @export_range(0.0, 1.0) var action_decel = -5.0
## Applied gravity. Default: 1000.0
@export_range(0.0, 1000.0) var gravity_value = 700.0
## Impact force after taking a punch. Default: 150
@export_range(0.0, 1000.0) var punch_impact = 120.0
## Bounce force after landing a punch. Default: 40.0
@export_range(0.0, 200.0) var punch_bounce = 110.0
## Impact force after getting kickicked . Default: 100.0
@export_range(0.0, 200.0) var kick_impact = 150.0
## Bounce force after landing a kick. Default: 100.0
@export_range(0.0, 200.0) var kick_bounce = 100.0
## Upforce force after getting kicked. Default: 128.0
@export_range(0.0, 200.0) var kick_upforce = 128.0
## Double jump speed. Default: 30.0
@export_range(0.0, 50.0) var double_jump_speed = -10.0
## Player input resource file
@export var player_input: Resource = null

@onready var states = $States
@onready var state_label = $StateLabel
@onready var punch_coll = $PunchArea/PunchCollision
@onready var kick_coll = $KickArea/KickCollision
@onready var body_coll = $BodyCollision
@onready var anim_sprite = $AnimSprite
@onready var buffer_input_timer = $BufferInputTimer

var current_state = null
var prev_state = null
var direction_x = Vector2.ZERO.x
var queued_input = ""

var body_coll_pos = 3.0
var feet_coll_pos = 1.5
var punch_coll_pos = -1.0
var kick_coll_pos = -1.5

var dashing = false
var punching = false
var kicking = false
var is_hurt = false
var double_jumping = false
var disintegrating = false
var disintegrated = false


func _ready():
	for state in states.get_children():
		state.states = states
		state.player = self
	prev_state = null
	current_state = states.IDLE


func _physics_process(delta):
	if not kicking or punching:
		set_horizontal_direction()
	
	queue_input()
	
	change_state(current_state.update(delta))
	state_label.text = str(current_state.get_name())

	move_and_slide()


func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta


func handle_move_input(_delta):
	direction_x = Input.get_axis(player_input.move_left, player_input.move_right)
	
	if direction_x != Vector2.ZERO.x and not kicking or not punching or not dashing:
		velocity.x = move_toward(velocity.x, direction_x * move_speed, accel)
	elif direction_x == Vector2.ZERO.x and not kicking or not punching or not dashing:
		velocity.x = move_toward(velocity.x, direction_x * move_speed, decel)


func queue_input():
	if Input.is_action_just_pressed(player_input.kick):
		queued_input = "kick"
		buffer_input_timer.stop()
		buffer_input_timer.start()
	elif Input.is_action_just_pressed(player_input.jump):
		queued_input = "jump"
		buffer_input_timer.stop()
		buffer_input_timer.start()
	elif Input.is_action_just_pressed(player_input.punch):
		queued_input = "punch"
		buffer_input_timer.stop()
		buffer_input_timer.start()
	elif Input.is_action_just_pressed(player_input.dash):
		queued_input = "dash"
		buffer_input_timer.stop()
		buffer_input_timer.start()


func flip_character(direction):
	if direction == "left":
		anim_sprite.flip_h = false
		punch_coll.position.x = punch_coll_pos
		kick_coll.position.x = kick_coll_pos
		body_coll.position.x = 0
	elif direction == "right":
		anim_sprite.flip_h = true
		punch_coll.position.x = -punch_coll_pos
		kick_coll.position.x = -kick_coll_pos
		body_coll.position.x = -body_coll_pos
		

func change_state(input_state):
	if input_state != null:
		prev_state = current_state 
		current_state = input_state
		prev_state.exit_state()
		current_state.enter_state()
		# print(current_state)


func set_horizontal_direction():
	if Input.is_action_pressed(player_input.move_left):
		direction_x = Vector2.LEFT.x
		if not kicking or not punching or not dashing:
			flip_character("left")
	elif Input.is_action_pressed(player_input.move_right):
		direction_x = Vector2.RIGHT.x
		if not kicking or not punching or not dashing:
			flip_character("right")



func punch_self_knockback(direction):
	if direction == "right":
		velocity.x = move_toward(-punch_bounce, Vector2.LEFT.x * move_speed, decel)
	else:
		velocity.x = move_toward(punch_bounce, Vector2.RIGHT.x * move_speed, decel)


func take_punch(direction):
	is_hurt = true
	disintegrating = false

	if direction == "right":
		velocity.x = move_toward(punch_impact, Vector2.RIGHT.x * move_speed, decel)
	else:
		velocity.x = move_toward(-punch_impact, Vector2.LEFT.x * move_speed, decel)



func take_kick(direction):
	is_hurt = true
	disintegrating = false
	
	if direction == "right":
		velocity.x = move_toward(kick_impact, Vector2.RIGHT.x * move_speed, decel)
	else:
		velocity.x = move_toward(-kick_impact, Vector2.LEFT.x * move_speed, decel)
	
	velocity.y = move_toward(-kick_upforce, Vector2.RIGHT.x * move_speed, decel)


func _on_punch_area_body_entered(body):
	if body.has_method("take_punch"):
		if anim_sprite.flip_h:
			punch_self_knockback("right")
			body.take_punch("right")
		else:
			punch_self_knockback("left")
			body.take_punch("left")


func _on_kick_area_body_entered(body):
	velocity.x = Vector2.ZERO.x
	if body.has_method("take_kick"):
		if anim_sprite.flip_h:
			body.take_kick("right")
		else:
			body.take_kick("left")


func _on_anim_sprite_animation_finished():
	if anim_sprite.animation == "punch":
		punch_coll.disabled = true
		punching = false
	elif anim_sprite.animation == "kick":
		kick_coll.disabled = true
		kicking = false
		if not is_on_floor():
			velocity.x = Vector2.ZERO.x
	elif anim_sprite.animation == "dash":
		dashing = false
		if not is_on_floor():
			velocity.x = Vector2.ZERO.x
	elif anim_sprite.animation == "hurt":
		is_hurt = false
	elif anim_sprite.animation == "disintegrate":
		disintegrated = true
