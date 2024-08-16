extends Area2D

@export var SPEED = 350
@onready var light = $PointLight2D


func _ready():
	await get_tree().create_timer(2).timeout
	for i in range(45):
		await get_tree().create_timer(0.2).timeout
		light.texture_scale -= 0.1
	queue_free()
