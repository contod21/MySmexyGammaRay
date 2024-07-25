extends Node2D


func _ready():
	$StrongerTimer.start()

func _process(delta):
	pass


func _on_stronger_timer_timeout():
	EnemyStats.golem_max_health += 5
	EnemyStats.golem_damage += 5
	$StrongerTimer.start()
