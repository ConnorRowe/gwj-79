extends Node

const ALIEN_HIT_PARTICLES = preload("res://scenes/AlienHitParticles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func instantiate_and_position_tscn(tscn: PackedScene, global_position: Vector2) -> Node2D:
	var scene := tscn.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.global_position = global_position
	return scene


func spawn_alien_hit_particles(global_position: Vector2) -> void:
	instantiate_and_position_tscn(ALIEN_HIT_PARTICLES, global_position)
