extends CanvasLayer



func _on_quit_pressed():
	get_tree().quit()


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
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

