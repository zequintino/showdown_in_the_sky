extends Node2D


@onready var players = $Players
@onready var player_1_marker = $Player1Marker
@onready var player_2_marker = $Player2Marker

const ZE = preload("res://scenes/ze.tscn")
const RAJ = preload("res://scenes/raj.tscn")
const PLAYER_1_INPUT = preload("res://resources/player_1_input.tres")
const PLAYER_2_INPUT = preload("res://resources/player_2_input.tres")

func _ready():
	var ze = ZE.instantiate()
	var ze_punch_area = ze.get_node("PunchArea")
	var ze_kick_area = ze.get_node("KickArea")
	ze.player_input = PLAYER_1_INPUT
	ze.set_collision_layer_value(2, true)
	#ze_punch_area.set_collision_layer_value(2, true)
	ze_punch_area.set_collision_mask_value(3, true)
	#ze_kick_area.set_collision_layer_value(2, true)
	ze_kick_area.set_collision_mask_value(3, true)
	
	var raj = RAJ.instantiate()
	var raj_punch_area = raj.get_node("PunchArea")
	var raj_kick_area = raj.get_node("KickArea")
	raj.player_input = PLAYER_2_INPUT
	raj.set_collision_layer_value(3, true)
	#raj_punch_area.set_collision_layer_value(3, true)
	raj_punch_area.set_collision_mask_value(2, true)
	#raj_kick_area.set_collision_layer_value(3, true)
	raj_kick_area.set_collision_mask_value(2, true)
#
	players.add_child(ze, true)
	players.add_child(raj, true)
	ze.position = player_1_marker.position
	raj.position = player_2_marker.position


func _process(_delta):
	pass
