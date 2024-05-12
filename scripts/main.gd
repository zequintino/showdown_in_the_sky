extends Node2D


const ZE = preload("res://scenes/ze.tscn")
const RAJ = preload("res://scenes/raj.tscn")
const PLAYER_1_INPUT = preload("res://resources/player_1_input.tres")
const PLAYER_2_INPUT = preload("res://resources/player_2_input.tres")
const STAGE = preload("res://scenes/stage.tscn")


func _ready():
	# Create the stage
	var stage = STAGE.instantiate()
	add_child(stage)
	
	# Get the players node
	var players = stage.get_node("Players")
	var player_1_marker = stage.get_node("Player1Marker")
	var player_2_marker = stage.get_node("Player2Marker")
	
	# Init player 1
	var ze = ZE.instantiate()
	var ze_punch_area = ze.get_node("PunchArea")
	var ze_kick_area = ze.get_node("KickArea")
	ze.player_input = PLAYER_1_INPUT
	ze.set_collision_layer_value(2, true)
	ze_punch_area.set_collision_mask_value(3, true)
	ze_kick_area.set_collision_mask_value(3, true)
	
	# Init player 2
	var raj = RAJ.instantiate()
	var raj_punch_area = raj.get_node("PunchArea")
	var raj_kick_area = raj.get_node("KickArea")
	raj.player_input = PLAYER_2_INPUT
	raj.set_collision_layer_value(3, true)
	raj_punch_area.set_collision_mask_value(2, true)
	raj_kick_area.set_collision_mask_value(2, true)

	# Add players to the stage
	players.add_child(ze, true)
	players.add_child(raj, true)
	ze.position = player_1_marker.position
	raj.position = player_2_marker.position


func _process(_delta):
	pass
