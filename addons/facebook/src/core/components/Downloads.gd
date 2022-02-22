tool
extends VBoxContainer

onready var FacebookEditor : Control = find_parent("FacebookEditor")

onready var godot_version : String = String(Engine.get_version_info().major) \
		+ "." + String(Engine.get_version_info().minor) + "." \
		+ String(Engine.get_version_info().patch)
var actual_downloading_file : String = ""
var downloaded_plugin_version : String = ""

var android_dictionary : Dictionary = {
		"version" : [
			"CURRENT", 
		],
		"download_directory" : "res://addons/facebook/downloads/android"
	} setget set_android_dictionary

var ios_dictionary : Dictionary = {
		"version" : [
			"CURRENT", 
		],
		"download_directory" : "res://addons/facebook/downloads/ios"
	} setget set_ios_dictionary

var current_dir_download_label = "Current Download Directory: %s"
var download_complete_message = "Download of %s completed! \n%s"

func set_android_dictionary(value):
	android_dictionary = value
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel \
			.text =  current_dir_download_label \
					% android_dictionary.download_directory
	
func set_ios_dictionary(value):
	ios_dictionary = value 
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel\
			.text =  current_dir_download_label \
					% ios_dictionary.download_directory

func _ready():
	if godot_version[godot_version.length()-1] == "0":
		godot_version = godot_version.substr(0, godot_version.length()-2)
	ios_dictionary.version.append_array(
			FacebookEditor.FacebookSettings.godot_version_support.ios)
	android_dictionary.version.append_array(
			FacebookEditor.FacebookSettings.godot_version_support.android) 
	set_process(false)
	$TabContainer/Android/VersionHBoxContainer/AndroidVersion.clear()
	$TabContainer/iOS/VersionHBoxContainer/iOSVersion.clear()
	for i in android_dictionary.version:
		$TabContainer/Android/VersionHBoxContainer/AndroidVersion.add_item(i)
	for i in ios_dictionary.version:
		$TabContainer/iOS/VersionHBoxContainer/iOSVersion.add_item(i)
	
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel \
			.text =  current_dir_download_label % \
					android_dictionary.download_directory
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel \
			.text =  current_dir_download_label % \
					ios_dictionary.download_directory

func _process(delta):
	var bodySize = $HTTPRequest.get_body_size()
	var downloadedBytes = $HTTPRequest.get_downloaded_bytes()
	var percent = int(downloadedBytes*100/bodySize)
	$ProgressBar.value = percent


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		$AdviceAcceptDialog.dialog_text = "!!!DOWNLOAD FAILED!!!"
		$ProgressBar.value = 0
	else:
		$AdviceAcceptDialog.dialog_text = download_complete_message \
				% [actual_downloading_file, downloaded_plugin_version]

	set_process(false)
	$AdviceAcceptDialog.popup_centered()


func _on_DownloadFacebookSdkiOS_pressed():
	var file_name = "facebooksdk.zip"
	var plugin_version = FacebookEditor.FacebookSettings.version_support.ios
	var directory = ios_dictionary.download_directory + "/" + file_name
	$HTTPRequest.download_file = directory
	var repository = "https://github.com/deflinhec/godot-facebook-ios"
	$HTTPRequest.request(repository + "/releases/download/" \
			+ plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	downloaded_plugin_version = "iOS Plugin Version: " + plugin_version

	set_process(true)

func _on_DownloadiOSTemplate_pressed():
	var ios_version = $TabContainer/iOS/VersionHBoxContainer/iOSVersion.text
	if ios_version == "CURRENT":
		ios_version = godot_version

	var file_name = "ios-template-v" + ios_version + ".zip"
	var plugin_version = FacebookEditor.FacebookSettings.version_support.ios
	var directory = ios_dictionary.download_directory + "/" + file_name
	$HTTPRequest.download_file = directory
	var repository = "https://github.com/deflinhec/godot-facebook-ios"
	$HTTPRequest.request(repository + "/releases/download/" \
			 + plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	downloaded_plugin_version = "iOS Plugin Version: " + plugin_version
	
	set_process(true)

func _on_DownloadAndroidTemplate_pressed():
	var version = $TabContainer/Android/VersionHBoxContainer/AndroidVersion
	var android_version = version.text.to_lower()
	if android_version == "current":
		android_version = godot_version
	
	var button = $TabContainer/Android/TargetHBoxContainer/MenuButton
	var android_target = button.text.to_lower()
	
	if android_target == "current":
		android_target = "mono" if Engine.has_singleton("GodotSharp") \
				else "standard"
	
	
	var file_name = "android-%s-template-v%s.zip" % [
		android_target, android_version
	]
	var plugin_version = FacebookEditor.FacebookSettings.version_support.android
	var directory = android_dictionary.download_directory + "/" + file_name
	$HTTPRequest.download_file = directory
	var repository = "https://github.com/deflinhec/godot-facebook-android"
	$HTTPRequest.request(repository + "/releases/download/" \
			+ plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	
	downloaded_plugin_version = "Android Plugin Version: " + plugin_version
	
	set_process(true)


func _on_AndroidChangeDirectoryFileDialog_dir_selected(dir):
	self.android_dictionary.download_directory = dir

func _on_AndroidChangeDirectoryButton_pressed():
	$TabContainer/Android/ChangeDirectoryHBoxContainer/AndroidChangeDirectoryFileDialog.popup_centered()


func _on_iOSChangeDirectoryFileDialog_dir_selected(dir):
	self.ios_dictionary.download_directory = dir

func _on_iOSChangeDirectoryButton_pressed():
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/iOSChangeDirectoryFileDialog.popup_centered()


func _on_AndroidOpenDirectoryButton_pressed():
	var path_directory = ProjectSettings.globalize_path(android_dictionary.download_directory)
	OS.shell_open(str("file://", path_directory))


func _on_iOSOpenDirectoryButton_pressed():
	var path_directory = ProjectSettings.globalize_path(ios_dictionary.download_directory)
	OS.shell_open(str("file://", path_directory))
