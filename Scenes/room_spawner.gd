extends Node

@onready var spawn_points = $SpawnPoints.get_children()

@onready var world = get_node("/root/World")
@onready var monster = preload("res://Scenes/enemy_golem.tscn")

func _ready():
	add_to_group("world")
	randomize()
	spawn_enemy()


func spawn_enemy():
	print("Spawn Points Found: ", spawn_points.size())
	for spawn in spawn_points:
		print("Spawning at: ", spawn.global_position)
		for i in range(randi_range(1,5)):
			var m = monster.instantiate()
			m.global_position = spawn.global_position
			world.add_child(m)
			print("Spawned Monster at: ", m.global_position)
