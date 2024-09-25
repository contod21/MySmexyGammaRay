extends Node2D

@onready var current_level = 9
@onready var label = $Camera/Label
@onready var tiemr = $SpawnTimer
var started = false

@onready var monster_dict = {
	1: {"enemyNum": 10, "text": "You thought you could escape me? Think again."},
	2: {"enemyNum": 15, "text": "Maybe you aren't as weak as I thought."},
	3: {"enemyNum": 20, "text": "WHY WON'T YOU DIE ALREADY?!?!?"},
	4: {"enemyNum": 30, "text": "Shoom Bagala Boom Boom"},
	5: {"enemyNum": 40, "text": "Fetch me their souls!"},
	6: {"enemyNum": 50, "text": "Wait, you're not dead??"},
	7: {"enemyNum": 60, "text": "I'm going to get you this time!"},
	8: {"enemyNum": 70, "text": "Are you dead yet?"},
	9: {"enemyNum": 80, "text": "NEIN!"},
	10: {"enemyNum": 1, "text": "You're surerly dead this time."}
}
@onready var spawn_points = $SpawnPoints.get_children()

@onready var world = get_node("/root/World")

@onready var monster = preload("res://Scenes/enemy_golem.tscn")

@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var total_enemies = 0

func _ready():
	print("ready")
	add_to_group("world")
	EnemyStats.enemy_dead.connect(enemy_death)
	


func enemy_death():
	if started == false:
		return
	
	dead_enemies += 1
	total_enemies += 1
	
	if dead_enemies == monster_dict[current_level].enemyNum:
		$SpawnTimer.start()
		EnemyStats.golem_max_health += 10
		EnemyStats.golem_damage += 2
		dead_enemies = 0
	

func spawn_enemy():
	for i in range(monster_dict[current_level].enemyNum):
		var m = monster.instantiate()
		m.player_spotted = true
		var spawn_point = spawn_points.pick_random()
		m.global_position = spawn_point.global_position
		world.add_child(m)
		await get_tree().create_timer(1.0).timeout
			
func update_level(level):
	label.visible = true
	print(str(level))
	label.text = monster_dict[level].text
	spawn_enemy()
	await get_tree().create_timer(2.0).timeout
	label.visible = false

func win_game():
	$Camera/TimeTaken.stop()
	PlayerStats.player_time = $Camera/TimeTaken.time_elapsed
	PlayerStats.enemies_killed = total_enemies
	PlayerStats.num_enemies = $RoomSpawner.spawned + 475
	
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")

func _on_spawn_timer_timeout():
	current_level += 1
	if current_level == 11:
		win_game()
	update_level(current_level)


func _on_area_2d_body_entered(body: Node2D) -> void:
	started = true
	tiemr.start()
