extends CharacterBody2D


@export var SPEED = 100.0
@export var ACCELLERATION = 20
@export var FRICTION = 10
@export var SPEED_BONUS := 1.0
@onready var sprite = $Sprite
const KNIFE = preload("res://Scenes/knife.tscn")
@onready var world = get_node("/root/World")
var direction = Vector2.ZERO
var is_ready: bool = true
@onready var knife_timer = $KnifeTimer
var sprint = 20 
var sprint_stamina_depletor := 0.9
var sprint_stamina_increase := 0.4
var depleted = true
@onready var stamina = $UI/Control/Stamina
@onready var stamOver = $UI/Control/StaminaOverlay

func _physics_process(delta):
	
	if Input.is_action_pressed("action primary") and is_ready:	
		var knife = KNIFE.instantiate()
		knife.global_position = global_position
		knife.rotate(global_position.direction_to(get_global_mouse_position()).angle())
		world.add_child(knife)
		knife_timer.start()
		is_ready = false
	if Input.is_action_pressed("Sprint") and sprint > 1:
		if depleted == true:
			pass
		else:
			SPEED_BONUS = 1.5
			sprint = clamp(sprint - sprint_stamina_depletor, 1, 100)
	else:
		SPEED_BONUS = 1.0
		sprint = clamp(sprint + (sprint_stamina_increase * sprint/50), 1, 100)
		
	
	if sprint > 99:
		stamina.visible = false
		stamOver.visible = false
		depleted = false
	elif sprint <= 1:
		depleted = true
		stamina.visible = true
		stamOver.visible = true
	elif sprint >= 20:
		depleted = false
		stamina.visible = true
		stamOver.visible = true
	else:
		stamina.visible = true
	stamina.value = sprint

	direction = Input.get_vector("left", "right", "up",  "down").normalized()
	var adjusted_direction = direction * SPEED * SPEED_BONUS
	if direction:
		velocity = velocity.move_toward(adjusted_direction, ACCELLERATION)
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
