extends "res://addons/facebook/src/singletons/FacebookSingleton.gd" 

func _ready() -> void:
	pass


func login(permissions: Array) -> void:
	if _plugin:
		if not is_logged_in():
			_plugin.login(permissions)
		else:
			emit_signal("login_success")
		


func logout() -> void:
	if _plugin:
		_plugin.logout()


func is_logged_in() -> bool:
	if _plugin:
		return _plugin.is_logged_in()
	return false


func log_event(event, value = 0, params = null):
	if _plugin:
		if value != 0 and params != null:
			_plugin.log_event_value_params(event, value, params)
		elif value != 0:
			_plugin.log_event_value(event, value)
		elif params != null:
			_plugin.log_event_params(event, params)
		else:
			_plugin.log_event(event)

static func get_datetime() -> String:
	var tm = OS.get_datetime()
	return "%s%s%s-%s%s%s" % [
		tm.year, tm.month, tm.day,
		tm.hour, tm.minute, tm.sec
	]


func share_screen_shot() -> void:
	if not _plugin:
		return
	# Let two frames pass to make sure the screen was captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	# Retrieve the captured image
	var img = get_viewport().get_texture().get_data()
	# Flip it on the y-axis (because it's flipped)
	img.flip_y()

	var image_save_path = OS.get_user_data_dir()
	image_save_path += "/%s.png" % [get_datetime()]
	img.save_png(image_save_path)
	_plugin.share_screen_shot(image_save_path)

