extends Control

@onready var intro_anim: IntroAnim = $IntroAnim
@onready var transition: Transition = $Transition

func _ready() -> void:
	SoundManager.play_drums()
	intro_anim.play_intro()
	transition.fade_in()


func _on_intro_replay_button_pressed() -> void:
	intro_anim.play_intro()


func _on_play_button_pressed() -> void:
	transition.transition_to_scene("res://scenes/main.tscn")
