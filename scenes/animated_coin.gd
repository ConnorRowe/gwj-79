extends Node2D

signal on_coin_anim_finished


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fly_to_stack":
		on_coin_anim_finished.emit()
		queue_free()
