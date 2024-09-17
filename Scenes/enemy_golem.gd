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

@onready var los = $RayCast2D
@onready var nav : NavigationAgent2D = $NavigationAgent2D

var player_spotted: bool = false

func _ready():
	health = EnemyStats.golem_max_health
	max_health = EnemyStats.golem_max_health
	nav.target_position = player.global_position

func check_collisions():
	if not damage_timer.is_stopped():
		return
	var collisions = $HurtBox.get_overlapping_bodies()
	if collisions:
		for collision in collisions:
			if collision.is_in_group("Player") and damage_timer.is_stopped():
				PlayerStats.damage_player(EnemyStats.golem_damage)
				damage_timer.start()

func _physics_process(_delta):
	
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if (player_spotted):
			var direction = generate_path()
			translate(direction * SPEED * _delta)
	
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false 
	
	move()

func check_player_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
		return true
	return false

func generate_path():
	nav.target_position = player.global_position
	var direction = (nav.get_next_path_position() - global_position).normalized()
	return direction

func move():
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
