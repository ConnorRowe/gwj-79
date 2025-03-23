class_name SoundSettings
extends Control

@onready var master_v_slider: VSlider = $GridContainer/MasterVSlider
@onready var music_v_slider: VSlider = $GridContainer/MusicVSlider
@onready var sfxv_slider: VSlider = $GridContainer/SFXVSlider
@onready var master_val_label: Label = $GridContainer/MasterValLabel
@onready var music_val_label: Label = $GridContainer/MusicValLabel
@onready var sfx_val_label: Label = $GridContainer/SFXValLabel

var master_bus : int
var music_bus : int
var sfx_bus : int

func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	master_v_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_v_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfxv_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	
	master_v_slider.mouse_entered.connect(SoundManager.pip)
	music_v_slider.mouse_entered.connect(SoundManager.pip)
	sfxv_slider.mouse_entered.connect(SoundManager.pip)


func vol_value_changed(vol: float, bus_index: int):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol))
	SoundManager.pop()


func _on_master_v_slider_value_changed(value: float) -> void:
	vol_value_changed(value, master_bus)
	master_val_label.text = str(roundi(value * 100))


func _on_music_v_slider_value_changed(value: float) -> void:
	vol_value_changed(value, music_bus)
	music_val_label.text = str(roundi(value * 100))


func _on_sfxv_slider_value_changed(value: float) -> void:
	vol_value_changed(value, sfx_bus)
	sfx_val_label.text = str(roundi(value * 100))
