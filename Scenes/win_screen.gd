extends CanvasLayer

var total := 0.0
var killed := 0.0
var duration = 0.0
var percentage := 0.0

var minutes
var seconds
var time_string

func _ready() -> void:
	
	var duration = PlayerStats.player_time
	var killed = PlayerStats.enemies_killed
	var total = PlayerStats.num_enemies
	
	if total > 0:
		percentage = (killed / total) * 100
	else:
		percentage = 0
	
	if duration > 0.0:
		minutes = duration / 60
		seconds = fmod(duration, 60)
		time_string = "%2d Minutes %02d Seconds" % [minutes, seconds]
	else:
		time_string = "0"
	
	
	$Stats.text = "Game Stats:\nTime Taken: " + str(time_string) + "\nEnemies Killed: " + str(percentage) + "%"
	
