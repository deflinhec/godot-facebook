tool
extends VBoxContainer

onready var FacebookEditor : Control = find_parent("FacebookEditor")

onready var AppId := $HBoxContainer/AppIdText
onready var AdvertiseTracking := $AdvertiseTracking
onready var Enabled := $Enabled

func _ready():
	AppId.text = FacebookEditor.FacebookSettings \
			.config.general.app_id
	Enabled.pressed = FacebookEditor.FacebookSettings \
			.config.general.enabled
	AdvertiseTracking.pressed = FacebookEditor.FacebookSettings \
			.config.general.advertiser_tracking


func _on_AdvertiseTracking_toggled(button_pressed):
	FacebookEditor.FacebookSettings \
			.config.general.advertiser_tracking = button_pressed
	FacebookEditor.FacebookSettings.save()


func _on_Enabled_toggled(button_pressed):
	FacebookEditor.FacebookSettings \
			.config.general.enabled = button_pressed
	FacebookEditor.FacebookSettings.save()


func _on_AppIdText_text_changed(new_text):
	FacebookEditor.FacebookSettings \
			.config.general.app_id = new_text
	FacebookEditor.FacebookSettings.save()
