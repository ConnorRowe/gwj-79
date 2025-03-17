extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const MAX_GROWTH_STEP := 8
var current_growth_step := 0


func _on_grow_timer_timeout() -> void:
	current_growth_step += 1
	
	if current_growth_step > MAX_GROWTH_STEP:
		spawn_carrot()
		current_growth_step = 0
	
	sprite_2d.frame = current_growth_step


func spawn_carrot() -> void:
	pass
