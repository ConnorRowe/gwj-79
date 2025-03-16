class_name JigglyCamera2D
extends Camera2D

@export var max_offset_jiggle := Vector2.ZERO
@export var max_zoom_jiggle := 0.0
@export var decay: float = .9
@export var noise: Noise = preload("res://assets/new_fast_noise_lite.tres")
var trauma: float = 0
var noise_y: int = 0

func _process(delta) -> void:
	if trauma > 0:
		trauma = maxf(trauma - (decay * delta), 0)
		
		var amount: float = pow(trauma, 2)
		
		if noise_y > 1000000:
			noise_y = 0
		else:
			noise_y += 1
		
		# Jiggle zoom
		var zoom_jiggle = max_zoom_jiggle * amount * ((noise.get_noise_2d(noise.seed, noise_y) * 2) - 1)
		zoom = Vector2.ONE + Vector2(zoom_jiggle, zoom_jiggle)
		
		# Jiggle offset
		var offset_jiggle = Vector2()
		offset_jiggle.x = max_offset_jiggle.x * amount * noise.get_noise_2d(noise.seed * 4, noise_y)
		offset_jiggle.y = max_offset_jiggle.y * amount * noise.get_noise_2d(noise.seed * 5, noise_y)		
		offset = Vector2.ONE + offset_jiggle

func jiggle(strength: float) -> void:
	trauma = minf(trauma + strength, 1)
