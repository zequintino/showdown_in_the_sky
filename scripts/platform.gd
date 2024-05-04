extends Path2D

@onready var parent = get_parent()
@onready var platform_path_follow = $PathFollow

@export var speed: float = 1.0

func _ready():
	print("parent message: ", parent.something)


func _physics_process(_delta):
	platform_path_follow.progress += speed * _delta
