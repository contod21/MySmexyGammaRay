extends CharacterBody2D


const SPEED = 95
const JUMP_VELOCITY = -400.0
@onready var sprite = $Sprite
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var pep = get_tree()
const EXPLOSION = preload("res://Scenes/explosion.tscn")	
const EXPERIENCE_GEM = preload("res://Scenes/experience_gem.tscn")
@onready var damage_timer = $HurtBox/DamageTimer
@onready var health_bar = $Control/Health
@export var health = 10
@export var max_health = 10

func _ready():
	health = EnemyStats.golem_max_health
	max_health = EnemyStats.golem_max_health

func check_collisions():
	if not damage_timer.is_stopped():
		return
	var collisions = $HurtBox.get_overlapping_bodies()
	if collisions:
		for collision in collisions:
			if collision.is_in_group("Player") and damage_timer.is_stopped():
				PlayerStats.damage_player(EnemyStats.golem_damage)
				damage_timer.start()

func _physics_process(delta):
	var direction_to_player = global_position.direction_to(player.global_position)
	velocity = direction_to_player * SPEED
	
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false 
	
	check_collisions()
	move_and_slide()

func take_damage(dmg):
	health -= dmg
	DamageNumbers.display_number(dmg, global_position)
	update_enemy_health()
	if (health <= 0):
		EnemyStats.emit_signal("enemy_dead")
		queue_free()
		var new_explosion = EXPLOSION.instantiate()
		new_explosion.global_position = global_position
		add_sibling(new_explosion)
		var new_gem = EXPERIENCE_GEM.instantiate()
		new_gem.global_position = global_position
		add_sibling(new_gem)


func update_enemy_health():
	health_bar.visible = true
	health_bar.max_value = max_health
	health_bar.value = health
