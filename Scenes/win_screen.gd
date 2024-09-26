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
		"time": 113.5,
		"percentage": "70",
		"player": "pickl3s_s"
	},
	{
		"time": 123,
		"percentage": "10",
		"player": "Temia116"
	},
	{
		"time": 100,
		"percentage": "70",
		"player": "BOBCONNOM"
	},
]
var lb = []

var minutes
var seconds
var time_string

var minutes1
var seconds1
var time_string1

func _ready() -> void:
	# Initialize player stats and calculate percentage
	duration = PlayerStats.player_time
	killed = PlayerStats.enemies_killed
	total = PlayerStats.num_enemies

	percentage = (killed / total) * 100 if total > 0 else 0

	# Format time string
	if duration > 0.0:
		minutes = int(duration / 60)
		seconds = int(fmod(duration, 60))
		time_string = "%d Minutes %02d Seconds" % [minutes, seconds]
	else:
		time_string = "0"
	
	# Display game stats
	$Stats.text = "[color=RED][b][font_size={60}]Game Stats:[/font_size][/b][/color]\n\n[font_size={30}][b]Time Taken:[/b] " + str(time_string) + "[/font_size]\n[font_size={30}][b]Enemies Killed:[/b] " + str(percentage).pad_decimals(2) + "%[/font_size]"
	
	set_text()

# Handles submitted text and adds player to leaderboard
func _on_line_edit_text_submitted(new_text: String) -> void:
	$LineEdit.editable = false
	var text = new_text.strip_edges().replace(" ", "_")
	$LineEdit.text = text

	# Add an 'added_at' field to track when the entry was added
	var data = {
		"time": float(duration),
		"percentage": str(percentage),
		"player": text,
	}
	leaderboard.push_back(data)
	
	# Call set_text without sorting
	set_text()

# Custom sort function: sorts by percentage if time is same
func _custom_sort(a, b):
	if a["time"] == b["time"]:
		var a_percentage = float(a["percentage"])
		var b_percentage = float(b["percentage"])
		print(a_percentage, b_percentage)
		if a_percentage == b_percentage:
			return 0
		elif a_percentage > b_percentage:
			return -1
		elif a_percentage < b_percentage:
			return 1
	else:
		return a["time"] - b["time"]

# Updates leaderboard display
func set_text():
	# Sort leaderboard using custom sort
	leaderboard.sort_custom(func(a, b): return a["time"] > b["time"])
	leaderboard.sort_custom(_custom_sort)
	
	var lb = []
	var position = 1

	for entry in leaderboard:
		if entry["time"] > 0.0:
			# Get minutes and seconds from the time
			var minutes1 = int(entry["time"] / 60)
			var seconds1 = int(fmod(entry["time"], 60))
			var time_string1 = "%d Minutes %02d Seconds" % [minutes1, seconds1]
			
			# Append formatted leaderboard entry
			lb.push_back(str(position) + ". [b]" + entry["player"] + ":[/b] [color=green]" + str(time_string1) + "[/color] " + str(entry["percentage"]).pad_decimals(0) + "%")
			
			# Increment position for the next entry
			position += 1

	# Join the leaderboard array into a single string with line breaks
	var string = "\n".join(lb)

	# Update the RichTextLabel with the leaderboard
	$RichTextLabel.text = "[b][font_size={30}]Leaderboard[/font_size][/b]\n" + string

# Handles resetting player and enemy stats when retry button is pressed
func _on_retry_pressed() -> void:
	reset_stats()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

# Handles resetting player and enemy stats when home button is pressed
func _on_home_pressed() -> void:
	reset_stats()
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Helper function to reset player and enemy stats
func reset_stats() -> void:
	PlayerStats.player_level = 1
	PlayerStats.player_experience = 0
	PlayerStats.player_health = 100
	PlayerStats.player_max_health = 100
	PlayerStats.next_level = 15
	
	WeaponKnife.knife_level = 0
	WeaponKnife.knife_damage = 5
	WeaponKnife.knife_speed = 350
	WeaponKnife.knife_projectiles = 1
	WeaponKnife.knife_time = 0.8
	WeaponKnife.knife_knockback = 10
	
	EnemyStats.golem_max_health = 10
	EnemyStats.golem_damage = 5
