extends Node

@onready var spawn_points = $SpawnPoints.get_children()

@onready var world = get_node("/root/World")
@onready var monster = preload("res://Scenes/enemy_golem.tscn")

func _ready():
	await get_tree().create_timer(1.0).timeout
	spawn_enemy()


func spawn_enemy():
	for spawn in spawn_points:
		for i in range(randi_range(1,4)):
			var m = monster.instantiate()
			m.global_position = spawn.global_position + Vector2(randi_range(1,4), randi_range(1,4))
			world.add_child(m)
