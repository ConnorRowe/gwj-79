extends GPUParticles2D

@onready var explosion_player: AudioStreamPlayer = $ExplosionPlayer

func _on_exposion_sound_timer_timeout() -> void:
	explosion_player.play()
