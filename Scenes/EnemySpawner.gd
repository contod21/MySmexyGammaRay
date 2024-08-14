extends Node

@onready var current_level = 0

@onready var monster_dict = {
	1:10,
	2:15,
	3:20,
	4:30,
	5:40,
	6:50,
	7:60,
	8:70,
	9:80,
	10:100,
}
@onready var spawn_points = $SpawnPoints.get_children()

@onready var world = get_node("/root/World")

@onready var monster = preload("res://Scenes/enemy_golem.tscn")

@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0

func _ready():
	add_to_group("world")
	EnemyStats.enemy_dead.connect(enemy_death)
	


func enemy_death():
	dead_enemies += 1
	
	if dead_enemies == monster_dict[current_level]:
		$SpawnTimer.start()
		EnemyStats.golem_max_health += 10
		EnemyStats.golem_damage += 10
		dead_enemies = 0
	

func spawn_enemy():
		for i in range(monster_dict[current_level]):
			var m = monster.instantiate()
			var spawn_point = spawn_points.pick_random()
			m.global_position = spawn_point.global_position
			world.add_child(m)
			await get_tree().create_timer(2.0).timeout
			
func update_level(level):
	print("Level" + str(level))
	spawn_enemy()

func _on_spawn_timer_timeout():
	current_level += 1
	update_level(current_level)
