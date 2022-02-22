extends CanvasLayer


onready var Message := $CenterContainer/VBoxContainer/Message

func _ready():
	MobileFacebook.connect("initialization_complete", 
			self, "_on_Facebook_initialization_complete")
	MobileFacebook.connect("login_success", 
			self, "_on_Facebook_login_success")
	MobileFacebook.connect("login_failed", 
			self, "_on_Facebook_login_failed")
	MobileFacebook.connect("login_canceled", 
			self, "_on_Facebook_login_canceled")
	MobileFacebook.connect("share_success", 
			self, "_on_Facebook_share_success")
	MobileFacebook.connect("share_failed", 
			self, "_on_Facebook_share_failed")
	MobileFacebook.connect("share_canceled", 
			self, "_on_Facebook_share_canceled")


func _on_ShareScreenShot_pressed():
	MobileFacebook.share_screen_shot()


func _on_Facebook_initialization_complete() -> void:
	Message.text = "initialization_complete"


func _on_Facebook_login_success() -> void:
	Message.text = "login_success"


func _on_Facebook_login_failed(error: String) -> void:
	Message.text = "login_failed %s" % [error]


func _on_Facebook_login_canceled() -> void:
	Message.text = "login_canceled"


func _on_Facebook_share_success() -> void:
	Message.text = "share_success"


func _on_Facebook_share_failed(error: String) -> void:
	Message.text = "share_failed %s" % [error]


func _on_Facebook_share_canceled() -> void:
	Message.text = "share_canceled"


func _on_Login_pressed():
	var permissions = [
		"email",
		"public_profile"
	]
	MobileFacebook.login(permissions)


func _on_Logout_pressed():
	MobileFacebook.logout()
