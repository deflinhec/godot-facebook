tool
extends Control
var FacebookSettings = preload("res://addons/facebook/src/utils/FacebookSettings.gd").new()
var support_version_text = "[rainbow sat=10]iOS[/rainbow][color=black]:%s[/color] [rainbow sat=10]Android[/rainbow][color=black]:%s[/color]"

onready var SupportVersion := $BottomPanel/SupportVersion
onready var CurrentVersion := $BottomPanel/CurrentVersion

func _ready():
	SupportVersion.bbcode_text = support_version_text % [ \
		FacebookSettings.version_support.ios, \
		FacebookSettings.version_support.android \
		]
	var plugin_config_file := ConfigFile.new()
	plugin_config_file.load("res://addons/facebook/plugin.cfg")
	var version = plugin_config_file.get_value("plugin", "version")
	CurrentVersion.text = "Version: " + version


func _on_AndroidButton_pressed():
	OS.shell_open("https://github.com/deflinhec/godot-facebook-android#installation") 


func _on_iOSButton_pressed():
	OS.shell_open("https://github.com/deflinhec/godot-facebook-ios#installation") 


func _on_FacebookButton_pressed():
	OS.shell_open("https://github.com/deflinhec/godot-facebook") 
