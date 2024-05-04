extends StaticBody2D


@onready var timer_sprite = $TimerSprite
@onready var animation_player = $TimerSprite/AnimationPlayer
@onready var timer = $TimerSprite/Timer

@export var round_finished = false
@export var counting_down = false
@export var controlling_platform = false

func _ready():
	pass


func _process(_delta):
	pass
