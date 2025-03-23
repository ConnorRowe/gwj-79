extends Control

@onready var intro_anim: IntroAnim = $IntroAnim

func _ready() -> void:
	SoundManager.play_drums()
	intro_anim.play_intro()


func _on_intro_replay_button_pressed() -> void:
	intro_anim.play_intro()
