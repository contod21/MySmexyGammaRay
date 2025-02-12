extends CanvasLayer

@onready var experience = $Control/Experience
@onready var health = $Control/Health
@onready var level_up_notice = $Control/LevelUpNotice
@onready var knife_timer = $"../KnifeTimer"
@onready var shop = false

@onready var pause_menu = $Control/PauseMenu

func _ready():
	PlayerStats.level_up.connect(level_up) 
	PlayerStats.take_damage.connect(update_health)
	PlayerStats.add_xp.connect(update_xp)
	PlayerStats.update_speed.connect(update_speed)
	WeaponKnife.level_up_knife()

func level_up():
	update_xp()
	if PlayerStats.knife_timer <= 0.2:
		$Control/LevelUpNotice/MarginContainer/VBoxContainer/btn_speed_level.disabled = true
	if WeaponKnife.knife_level == 10:
		$Control/LevelUpNotice/MarginContainer/VBoxContainer/btn_kife_level.disabled = true
	level_up_notice.visible = true

func update_xp():
	experience.max_value = PlayerStats.next_level
	experience.value = PlayerStats.player_experience
	
func update_health():
	health.max_value = PlayerStats.player_max_health
	health.value = PlayerStats.player_health

func _on_level_up_notice_visibility_changed():
	if level_up_notice.visible == true:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_btn_health_level_pressed():
	PlayerStats.add_max_health()
	level_up_notice.visible = false


func _on_btn_speed_level_pressed():
	PlayerStats.reduce_knife_timer()
	level_up_notice.visible = false



func _on_btn_kife_level_pressed():
	WeaponKnife.level_up_knife()
	level_up_notice.visible = false
	
func update_speed():
	knife_timer.set_wait_time(PlayerStats.knife_timer)


func _on_texture_button_pressed():
	print(shop)
	if shop == false:
		get_tree().paused = true
		shop = true
	else:
		get_tree().paused = false
		shop = false


func _on_btn_resume_pressed() -> void:
	pause_menu.visible = false


func _on_pause_menu_visibility_changed() -> void:
	if pause_menu.visible == true:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_btn_menu_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func _on_btn_quit_game_pressed() -> void:
	get_tree().quit()
