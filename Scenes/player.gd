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
var is_flare_ready: bool = true
@onready var knife_timer = $KnifeTimer
@onready var flare_timer = $FlareTimer
var sprint = 100
var sprint_stamina_depletor := 0.9
var sprint_stamina_increase := 0.4
var depleted = true
@onready var stamina = $UI/Control/Stamina
@onready var stamOver = $UI/Control/StaminaOverlay
@onready var pause = $UI/Control/PauseMenu
@onready var sprint_timer = $SprintTimer

# Handles movement, sprint mechanics, and pause functionality
func _physics_process(_delta):
	# Fire knives when primary action is pressed and knife cooldown is ready
	if Input.is_action_pressed("action primary") and is_ready:
		fire_knives()
	
	# Toggle pause menu with 'p_key'
	if Input.is_action_just_pressed("p_key"):
		if pause.visible == true:
			pause.visible = false
		else:
			pause.visible = true
	
	# Handle sprinting when sprint button is pressed and stamina is sufficient
	if Input.is_action_pressed("Sprint") and sprint > 1 and sprint_timer.is_stopped():
		if depleted == true:
			pass
		else:
			SPEED_BONUS = 1.5
			sprint = clamp(sprint - sprint_stamina_depletor, 1, 100)
	else:
		SPEED_BONUS = 1.0
		sprint = clamp(sprint + (sprint_stamina_increase * sprint/50), 1, 100)
	
	# Start sprint timer when sprint is released
	if Input.is_action_just_released("Sprint"):
		if sprint_timer.is_stopped():
			sprint_timer.start()
	
	# Update stamina display and handle depletion
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

	# Move the character based on input and apply acceleration/friction
	direction = Input.get_vector("left", "right", "up",  "down").normalized()
	var adjusted_direction = direction * SPEED * SPEED_BONUS
	if direction:
		velocity = velocity.move_toward(adjusted_direction, ACCELLERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	# Flip the sprite based on movement direction
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
		
	move_and_slide()

# Collect items when entering a pickup zone
func _on_pickup_zone_area_entered(area):
	if area.is_in_group("Pickup"):
		if area.has_method("collect"):
			area.collect()

# Fire knives in the direction of the mouse
func fire_knives():
	is_ready = false
	for i in range(WeaponKnife.knife_projectiles):
		var knife = KNIFE.instantiate()
		knife.global_position = global_position
		var direction = global_position.direction_to(get_global_mouse_position())
		knife.rotation = direction.angle()
		world.add_child(knife)
		await get_tree().create_timer(0.1).timeout
		
	knife_timer.start()

# Reset knife cooldown when the knife timer ends
func _on_knife_timer_timeout():
	is_ready = true
