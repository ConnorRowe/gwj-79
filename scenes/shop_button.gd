extends Node2D

signal on_purchased

@onready var main: Main = get_tree().current_scene
@onready var slot_sprite: AnimatedSprite2D = $SlotSprite
@onready var item_label: Label = $ItemLabel
@onready var cost_label: Label = $CostLabel

@export var item_text : = "Item text"
@export var stat := GameStats.Stat.FIRE_RATE
@export var stat_boost_per_level := 1.0
@export var cost_increase_nlog_multiplier := 1.5
var level := 1
var current_cost := 1.0
var locked := false

func _ready() -> void:
	update_text()
	main.get_node("CoinStack").on_coin_count_changed.connect(coint_count_changed)


func _on_texture_button_pressed() -> void:
	if locked:
		return
	
	if main.coin_stack.coin_count >= roundi(current_cost):
		main.coin_stack.remove_coins(roundi(current_cost))
		locked = true
		slot_sprite.play("default")
		SoundManager.coin_slot()
		
		level += 1
		current_cost = 1.0 + (log(level) * cost_increase_nlog_multiplier)
		
		GameStatsInst.increase_stat(stat, stat_boost_per_level)
		
		update_text()
		
		on_purchased.emit()
		
		get_tree().create_timer(0.5).connect("timeout", unlock)
		

func unlock() -> void:
	locked = false


func update_text() -> void:
	item_label.text = "%s\nlvl %d" % [item_text, level]
	cost_label.text = "x%d" % roundi(current_cost)


func coint_count_changed(new_count: int) -> void:
	cost_label.self_modulate = Color.WHITE if new_count >= roundi(current_cost) else Color("#ac3232")
