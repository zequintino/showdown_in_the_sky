extends Node2D


@export var round_finished = false
@export var counting_down = false

@onready var players = $Players
@onready var player_1_marker = $Player1Marker
@onready var player_2_marker = $Player2Marker
@onready var player_1_respawn_timer = $Player1RespawnTimer
@onready var player_2_respawn_timer = $Player2RespawnTimer


func _ready():
	pass


func _process(_delta):
	pass	


func start_countdown():
	pass


func _on_pit_area_body_entered(body):
	if body.player_input.player == 1:
		print(player_1_respawn_timer)
		player_1_respawn_timer.start()
	if body.player_input.player == 2:
		player_2_respawn_timer.start()


func _on_player_1_respawn_timer_timeout():
	for player in players.get_children():
		if player.player_input.player == 1:
			player.position = player_1_marker.position


func _on_player_2_respawn_timer_timeout():
	for player in players.get_children():
		if player.player_input.player == 2:
			player.position = player_2_marker.position