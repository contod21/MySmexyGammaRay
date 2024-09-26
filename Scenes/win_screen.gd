extends CanvasLayer

var total := 0.0
var killed := 0.0
var duration = 0.0
var percentage := 0.0

var leaderboard = [
	{
		"time": 100,
		"percentage": "50",
		"player": "Joe_Biden"
	},
	{
		"time": 100,
		"percentage": "70",
		"player": "BOBCONNOM"
	},
	{
		"time": 113.5,
		"percentage": "70",
		"player": "pickl3s_s"
	},
	{
		"time": 123,
		"percentage": "10",
		"player": "Temia116"
	}
]

var minutes
var seconds
var time_string

func _ready() -> void:
	duration = 100.0
	killed = 100.0
	total = 200.0

	if total > 0:
		percentage = (killed / total) * 100
	else:
		percentage = 0

	if duration > 0.0:
		minutes = int(duration / 60)
		seconds = int(fmod(duration, 60))
		time_string = "%d Minutes %02d Seconds" % [minutes, seconds]
	else:
		time_string = "0"

	$Stats.text = "Game Stats:\nTime Taken: " + str(time_string) + "\nEnemies Killed: " + str(percentage).pad_decimals(2) + "%"

func _on_line_edit_text_submitted(new_text: String) -> void:
	$LineEdit.editable = false
	var text = new_text.strip_edges().replace(" ", "_")
	$LineEdit.text = text

	var data = {
		"time": float(duration),
		"percentage": str(percentage),
		"player": text
	}
	leaderboard.push_back(data)
	
	leaderboard.sort_custom(func(a, b): return a["time"] > b["time"])
	leaderboard.sort_custom(_custom_sort)
	
	for entry in leaderboard:
		print(entry)

func _custom_sort(a, b):
	if a["time"] == b["time"]:
		var a_percentage = float(a["percentage"])
		var b_percentage = float(b["percentage"])
		if a_percentage > b_percentage:
			return -1
		elif a_percentage < b_percentage:
			return 1
		else:
			return 0
