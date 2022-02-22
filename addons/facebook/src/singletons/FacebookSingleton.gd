extends Node

signal initialization_complete

signal login_success
signal login_failed(error)
signal login_canceled

signal share_success
signal share_failed(error)
signal share_canceled

var FacebookSettings = preload("res://addons/facebook/src/utils/FacebookSettings.gd").new()
onready var config = FacebookSettings.config
var _plugin : Object
var _token: String

func _ready() -> void:
	if config.general.enabled:
		if (Engine.has_singleton("Facebook")):
			_plugin = Engine.get_singleton("Facebook")
			_connect_signals()
			_initialize()


func _initialize() -> void:
	if _plugin:
		if OS.get_name() == 'iOS':
			_plugin.set_advertiser_tracking(config.general.advertiser_tracking)
		_plugin.initialize(config.general.app_id)


func _connect_signals() -> void:
	_plugin.connect("initialization_complete", self, "_on_Facebook_initialization_complete")

	_plugin.connect("login_success", self, "_on_Facebook_login_success")
	_plugin.connect("login_failed", self, "_on_Facebook_login_failed")
	_plugin.connect("login_canceled", self, "_on_Facebook_login_canceled")
	
	_plugin.connect("share_success", self, "_on_Facebook_share_success")
	_plugin.connect("share_failed", self, "_on_Facebook_share_failed")
	_plugin.connect("share_canceled", self, "_on_Facebook_share_canceled")


func _on_Facebook_initialization_complete() -> void:
	emit_signal("initialization_complete")
	print("[INFO] Facebook initialization complete")


func _on_Facebook_login_success(token: String) -> void:
	_token = token; emit_signal("login_success")
	print("[INFO] Facebook token: %s" % [token])


func _on_Facebook_login_failed(error : String) -> void:
	emit_signal("login_failed", error)


func _on_Facebook_login_canceled() -> void:
	emit_signal("login_canceled")


func _on_Facebook_share_success() -> void:
	emit_signal("share_success")


func _on_Facebook_share_failed(error : String) -> void:
	emit_signal("share_failed", error)


func _on_Facebook_share_canceled() -> void:
	emit_signal("share_canceled")

