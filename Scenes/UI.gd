extends CanvasLayer

@onready var experience = $Control/Experience
@onready var health = $Control/Health

func _ready():
	PlayerStats.level_up.connect(update_xp)
	PlayerStats.take_damage.connect(update_health)
	PlayerStats.add_xp.connect(update_xp)
	
func update_xp():
	experience.max_value = PlayerStats.next_level
	experience.value = PlayerStats.player_experience
	
func update_health():
	health.max_value = PlayerStats.player_max_health
	health.value = PlayerStats.player_health
