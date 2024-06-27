extends CanvasLayer

@onready var experience = $Control/Experience
@onready var health = $Control/Health
@onready var level_up_notice = $Control/LevelUpNotice

func _ready():
	PlayerStats.level_up.connect(level_up)
	PlayerStats.take_damage.connect(update_health)
	PlayerStats.add_xp.connect(update_xp)
	WeaponKnife.level_up_knife()
	


func level_up():
	update_xp()
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
	pass # Replace with function body.


func _on_btn_kife_level_pressed():
	WeaponKnife.level_up_knife()
	print("The knife damage is now", WeaponKnife.knife_damage)
	level_up_notice.visible = false
