extends StaticBody2D


@export var round_finished = false
@export var counting_down = false

# @onready var timer_sprite = $TimerSprite
# @onready var animation_player = $TimerSprite/AnimationPlayer
# @onready var timer = $TimerSprite/Timer


func _ready():
	pass


func _process(_delta):
	start_countdown()


func start_countdown():
	pass
	# if not counting_down:
	# 	counting_down = true
	# 	timer_sprite.show()
	# 	animation_player.play()
	# 	timer.start()