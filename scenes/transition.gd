class_name Transition
extends TextureRect


func transition_to_scene(path: String):
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/fade", 1.0, 0.5).from(0.0)
	
	await tween.finished
	get_tree().change_scene_to_file(path)


func fade_in():
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/fade", 0.0, 0.5).from(1.0)
