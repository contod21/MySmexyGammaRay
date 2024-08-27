extends Node

@onready var current_level = 0
@onready var label = $Label

@onready var monster_dict = {
	1: {"enemyNum": 10, "text": "One"},
	2: {"enemyNum": 15, "text": "Two"},
	3: {"enemyNum": 20, "text": "Three"},
	4: {"enemyNum": 30, "text": "Four"},
	5: {"enemyNum": 40, "text": "Five"},
	6: {"enemyNum": 50, "text": "Six"},
	7: {"enemyNum": 60, "text": "Seven"},
	8: {"enemyNum": 70, "text": "Eight"},
	9: {"enemyNum": 80, "text": "Nine"},
	10: {"enemyNum": 100, "text": "Ten"}
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
	
	if dead_enemies == monster_dict[current_level].enemyNum:
		$SpawnTimer.start()
		EnemyStats.golem_max_health += 10
		EnemyStats.golem_damage += 2
		dead_enemies = 0
	

func spawn_enemy():
		for i in range(monster_dict[current_level]["enemyNum"]):
			var m = monster.instantiate()
			var spawn_point = spawn_points.pick_random()
			m.global_position = spawn_point.global_position
			world.add_child(m)
			await get_tree().create_timer(1.0).timeout
			
func update_level(level):
	label.visible = true
	print("Level " + str(level))
	label.text = "Round "  + monster_dict[level]["text"]
	spawn_enemy()
	await get_tree().create_timer(2.0).timeout
	label.visible = false

func _on_spawn_timer_timeout():
	current_level += 1
	update_level(current_level)
