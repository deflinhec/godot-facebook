
const PATH_FACEBOOK_PROJECT_SETTINGS = "facebook/config"

var version_support : Dictionary = {
	"ios" : "v1.0.0",
	"android" : "v0.1.0"
}

var godot_version_support: Dictionary = {
	"ios" : [
		"3.4.2", 
		"3.4.1", 
		"3.4", 
		"3.3.4", 
		"3.3.3", 
		"3.3.2", 
		"3.3.1", 
		"3.3"
	],
	"android" : [
		"3.4.2", 
		"3.4.1", 
		"3.4", 
		"3.3.4", 
		"3.3.3", 
		"3.3.2", 
		"3.3.1", 
		"3.3"
	]
}

var config : Dictionary = {
	"general" : {
		"enabled": true,
		"advertiser_tracking": false,
		"app_id": ""
	},
} setget set_config


static func load_config() -> Dictionary:
	var path = PATH_FACEBOOK_PROJECT_SETTINGS
	if ProjectSettings.has_setting(path):
		return ProjectSettings.get_setting(path)
	return {}

static func save_config(config: Dictionary):
	var path = PATH_FACEBOOK_PROJECT_SETTINGS
	ProjectSettings.set_setting(path, config)
	ProjectSettings.save()


static func merge(target : Dictionary, patch : Dictionary):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]


func _init():
	var previous = load_config()
	merge(config, previous)
	if Engine.editor_hint:
		save_config(self.config)


func save():
	save_config(self.config)


func set_config(value : Dictionary):
	config = value
	save_config(self.config)
