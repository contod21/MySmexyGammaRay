extends Camera2D

var is_stopped := false

var time_elapsed := 0.0
var minutes
var seconds
var milliseconds
var time_string


func _process(delta: float) -> void:
	time_elapsed += delta
	minutes = time_elapsed / 60
	seconds = fmod(time_elapsed, 60)
	milliseconds = fmod(time_elapsed, 1) * 100
	time_string = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	$TimeTaken.text = time_string

func reset() -> void:
	time_elapsed = 0.0
	is_stopped = false

func stop() -> void:
	is_stopped = true
