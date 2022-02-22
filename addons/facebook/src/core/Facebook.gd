tool
extends EditorPlugin

var FacebookEditor : Control

func _enter_tree():
	add_autoload_singleton("MobileFacebook", "res://addons/facebook/src/singletons/MobileFacebook.gd")
	FacebookEditor = load("res://addons/facebook/src/core/FacebookEditor.tscn").instance()
	get_editor_interface().get_editor_viewport().add_child(FacebookEditor)
	FacebookEditor.hide()

func _exit_tree():
	remove_autoload_singleton("MobileFacebook")
	get_editor_interface().get_editor_viewport().remove_child(FacebookEditor)
	FacebookEditor.queue_free()
	
func has_main_screen():
	return true

func make_visible(visible):
	FacebookEditor.visible = visible

func get_plugin_name():
	return "Facebook"

func get_plugin_icon():
	return load("res://addons/facebook/assets/icon-15.png")
