extends Node

const HIT_PARTICLES = preload("res://scenes/HitParticles.tscn")
const TAU_PROC_SPEED := 2.0

var process_tau := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func instantiate_and_position_tscn(tscn: PackedScene, global_position: Vector2) -> Node2D:
	var scene := tscn.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.global_position = global_position
	return scene


func spawn_hit_particles(global_position: Vector2, colour: Color) -> void:
	instantiate_and_position_tscn(HIT_PARTICLES, global_position).self_modulate = colour


func _process(delta: float) -> void:
	process_tau = wrapf(process_tau + (delta * TAU_PROC_SPEED), 0, TAU)
