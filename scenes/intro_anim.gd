class_name IntroAnim
extends Node2D


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	visible = false


func play_intro() -> void:
	visible = true
	$AnimationPlayer.play("intro")
