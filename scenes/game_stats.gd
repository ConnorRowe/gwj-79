class_name GameStats
extends Node

signal stat_changed(stat: Stat, value: Variant)

enum Stat
{
	BULLET_DMG,
	CROP_LIFE,
	FIRE_RATE
}


const DEFAULT_STATS := {
	Stat.BULLET_DMG: 1.0,
	Stat.CROP_LIFE: 1.0,
	Stat.FIRE_RATE: 0.5,
}


var current_stats := DEFAULT_STATS.duplicate()


func reset_stats():
	current_stats = DEFAULT_STATS.duplicate()


func set_stat(stat: Stat, value: float) -> bool:
	if (current_stats[stat] != value):
		current_stats[stat] = value
		stat_changed.emit(stat, value)
		return true
	return false


func get_stat(stat: Stat) -> float:
	return current_stats[stat]


func increase_stat(stat: Stat, amount: float) -> void:
	set_stat(stat, get_stat(stat) + amount)
