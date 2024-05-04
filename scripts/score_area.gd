extends Area2D


@onready var progress_bar = $Control/ProgressBar
@onready var point_light = $"../PointLight"
@onready var timer = $"../TimerSprite/Timer"
@onready var timer_sprite = $TimerSprite
@onready var animation_player = $TimerSprite/AnimationPlayer


var controlling_area = false
var countdown = false
#var score = 0


func _physics_process(_delta):
	if controlling_area:
		if progress_bar.value <= 500:
			progress_bar.value += 1
		else:
			if progress_bar.value >= progress_bar.max_value and not countdown:
				countdown = true
				timer_sprite.visible = true
				animation_player.play("default")
				timer.start()
				
			progress_bar.value += 2
			
		if point_light.energy < 9.0:
			point_light.energy += 0.02
	else:
		if progress_bar.value >= 500:
			progress_bar.value -= 2
		else:
			progress_bar.value -= 3
		
		if point_light.energy > 0.0:
			point_light.energy -= 0.02


func _on_body_entered(body):
	print("body_entered:", body)
	controlling_area = true
	

func _on_body_exited(body):
	print("body_exited:", body)
	controlling_area = false
	countdown = false
	timer_sprite.visible = false
	timer.stop()


func _on_timer_timeout():
	print("win")
	timer_sprite.visible = false
	countdown = false
