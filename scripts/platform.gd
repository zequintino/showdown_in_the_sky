extends Path2D

@onready var parent = get_parent()
@onready var platform_path_follow = $PathFollow
@onready var progress_bar = $PathFollow/ScoreArea/Control/ProgressBar
@onready var ufo_light = $PathFollow/UfoLight
@onready var timer = Node
@onready var timer_sprite = Node2D
@onready var canvas_layer = Node2D

@export var speed: float = 1.0

var controlling_platform = false
var countdown = false
var progress_max = 23.0
var progress_min = 0.0
var controlling_players = []


func _ready():
	canvas_layer = parent.get_node("CanvasLayer")
	timer_sprite = canvas_layer.get_node("TimerSprite")
	timer = timer_sprite.get_node("Timer")


func _physics_process(delta):
	if controlling_players.size() < 2:
		handle_movement(delta)
		calculate_score()


func handle_movement(delta):
	if controlling_platform:
		if platform_path_follow.progress < progress_max:
			platform_path_follow.progress += speed * delta
			if platform_path_follow.progress > progress_max:
				round(platform_path_follow.progress)
	else:
		if platform_path_follow.progress > progress_min:
			platform_path_follow.progress -= speed * delta
			if platform_path_follow.progress < progress_min:
				round(platform_path_follow.progress)


func calculate_score():
	if controlling_platform:
		progress_bar.value += 1		
	else:
		progress_bar.value -= 1
	handle_ufo_light()


func handle_ufo_light():
	if controlling_platform:
		if ufo_light.energy < 16.0:
			ufo_light.energy += 0.011
	else:
		if ufo_light.energy > 0.0:
			ufo_light.energy -= 0.011


func _on_score_area_body_entered(body):
	controlling_players.append(body)
	if controlling_players.size() < 2:
		controlling_platform = true
	else :
		controlling_platform = false
	# countdown = false
	# timer_sprite.show()
	# timer.stop()


func _on_score_area_body_exited(body):
	controlling_players.erase(body)
	if controlling_players.size() < 1:
		controlling_platform = false
	else :
		controlling_platform = true
	# countdown = false
	# timer_sprite.hide()
	# timer.stop()
