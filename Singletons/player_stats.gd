extends Node

var player_level = 1
var player_experience = 0
var player_health = 100
var player_max_health = 100
var next_level = 15
var knife_timer = 1

signal level_up
signal add_xp
signal take_damage
signal update_speed

func level_up_player():
	player_level += 1
	next_level += 10
	player_experience = 0
	emit_signal("level_up")
	
func add_experience(val):
	player_health += 5
	if player_health > player_max_health:
		player_health = player_max_health
	emit_signal("take_damage")
	player_experience += val
	emit_signal("add_xp")
	if player_experience >= next_level:
		level_up_player()

func damage_player(amount):
	player_health -= amount
	emit_signal("take_damage")
	if player_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	
func add_max_health():
	player_max_health += 20
	player_health += 20
	emit_signal("take_damage")
	
func reduce_knife_timer():
	knife_timer -= 0.02
	emit_signal("update_speed")

