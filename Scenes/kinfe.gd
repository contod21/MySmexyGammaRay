extends Area2D

@export var SPEED = 350


func _ready():
	pass



func _process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * SPEED * delta)



func _on_body_entered(body):
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		body.take_damage(WeaponKnife.knife_damage)
		queue_free()
