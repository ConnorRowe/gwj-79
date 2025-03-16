class_name Jiggler
extends Node

@export var max_position_jiggle := Vector2.ZERO
@export var scale_jiggle := Vector2.ZERO
@export var max_skew_jiggle := 0.0
@export var max_rotation_jiggle := 0.0
@export var decay: float = .9
@export var noise: Noise = preload("res://assets/new_fast_noise_lite.tres")
var trauma: float = 0
var noise_y: int = 0
var parent: Node2D

func _ready() -> void:
	parent = get_parent()

func _process(delta) -> void:
	if trauma > 0:
		trauma = maxf(trauma - (decay * delta), 0)
		
		var amount: float = pow(trauma, 2)
		
		if noise_y > 1000000:
			noise_y = 0
		else:
			noise_y += 1
		
		# Jiggle skew
		if(max_skew_jiggle > 0):
			var skew_jiggle = max_skew_jiggle * amount * ((noise.get_noise_2d(noise.seed, noise_y) * 2) - 1)
			parent.skew = skew_jiggle
		
		# Jiggle rotation
		if(max_rotation_jiggle > 0):
			var rotation_jiggle = max_rotation_jiggle * amount * ((noise.get_noise_2d(noise.seed, noise_y) * 2) - 1)
			parent.rotation_degrees = rotation_jiggle
		
		# Jiggle scale
		if(scale_jiggle.x > 0 or scale_jiggle.y > 0):
			var scale = Vector2()
			scale.x = scale_jiggle.x * amount * noise.get_noise_2d(noise.seed * 4, noise_y)
			scale.y = scale_jiggle.y * amount * noise.get_noise_2d(noise.seed * 5, noise_y)		
			parent.scale = Vector2.ONE + scale
		
		# Jiggle position
		if(max_position_jiggle.x > 0 or max_position_jiggle.y > 0):
			var pos = Vector2()
			pos.y = max_position_jiggle.y * amount * noise.get_noise_2d(noise.seed * 5, noise_y)		
			pos.x = max_position_jiggle.x * amount * noise.get_noise_2d(noise.seed * 4, noise_y)
			parent.position = pos

func jiggle(strength: float) -> void:
	trauma = minf(trauma + strength, 1)
