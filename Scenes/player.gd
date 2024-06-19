extends CharacterBody2D


@export var SPEED = 100.0
@export var ACCELLERATION = 20
@export var FRICTION = 10
@onready var sprite = $Sprite
const KNIFE = preload("res://Scenes/knife.tscn")
@onready var world = get_node("/root/World")
var direction = Vector2.ZERO
var is_ready: bool = true
@onready var knife_timer = $KnifeTimer

func _physics_process(delta):
	if Input.is_action_just_pressed("action primary") and is_ready:
		var knife = KNIFE.instantiate()
		knife.global_position = global_position
		knife.rotate(global_position.direction_to(get_global_mouse_position()).angle())
		world.add_child(knife)
		knife_timer.start()
		is_ready = false

	direction = Input.get_vector("left", "right", "up",  "down").normalized()
	if direction:
		velocity = velocity.move_toward(direction * SPEED, ACCELLERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false

	move_and_slide()


func _on_knife_timer_timeout():
	is_ready = true



func _on_pickup_zone_area_entered(area):
	if area.is_in_group("Pickup"):
		if area.has_method("collect"):
			area.collect()
