extends Node

var knife_level = 1
var knife_damage = 5
var knife_speed = 500
var knife_projectiles = 1 
var knife_time = 0.8
var knife_knockback = 10

func level_up_knife():
	knife_level =+ 1
	match knife_level:
		1:
			pass
		2:
			knife_damage = 10
			knife_speed = 500
			knife_projectiles = 2 
			knife_time = 0.8
			knife_knockback = 15
		3:
			knife_damage = 15
			knife_speed = 500
			knife_projectiles = 2 
			knife_time = 0.5
			knife_knockback = 20
