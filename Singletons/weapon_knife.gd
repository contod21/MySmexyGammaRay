extends Node

var knife_level = 0
var knife_damage = 5
var knife_speed = 350
var knife_projectiles = 1 
var knife_time = 0.8
var knife_knockback = 10

func level_up_knife():
	knife_level += 1
	match knife_level:
		1:
			pass
		2:
			knife_damage = 10
			knife_projectiles = 2 
		3:
			knife_damage = 15
			knife_projectiles = 2 
		4: 
			knife_damage = 20
			knife_projectiles = 2 
		5:
			knife_damage = 25
			knife_projectiles = 4
		6:
			knife_damage = 30
			knife_projectiles = 4
		7:
			knife_damage = 35
			knife_projectiles = 4
		8:
			knife_damage = 40
			knife_projectiles = 4
		9:
			knife_damage = 45
			knife_projectiles = 6
		10:
			knife_damage = 50
			knife_projectiles = 10
