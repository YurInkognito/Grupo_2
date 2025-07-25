extends Control

@onready var sfx_slider: HSlider = $Panel/Volume/SFXSlider
@onready var music_slider: HSlider = $Panel/Volume/MusicSlider
@onready var volume: Control = $Panel/Volume
@onready var pause_menu: Control = $Panel/PauseMenu
@onready var tutorial_button: TextureButton = $Panel/PauseMenu/TutorialButton

var sfx_bus_id
var music_bus_id
func _ready() -> void:
	pause_game()
	volume.visible = false
	sfx_bus_id = AudioServer.get_bus_index("SFX")
	music_bus_id = AudioServer.get_bus_index("Music")
	
	var sfx_bus_value = AudioServer.get_bus_volume_linear(1)
	var music_bus_value = AudioServer.get_bus_volume_linear(2)
	
	sfx_slider.value = sfx_bus_value
	music_slider.value = music_bus_value
	var current_parent = get_tree().get_current_scene()
	if current_parent.name == "TelaTitulo":
		tutorial_button.visible = false 
	else:
		tutorial_button.visible = true
func _on_button_back_pressed() -> void:
		unpause_game()
		self.queue_free()

func pause_game():
	pass
	#get_parent().get_tree().paused = true

func unpause_game():
	get_parent().get_tree().paused = false


func _on_sfx_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(sfx_bus_id,db)


func _on_music_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_id,db)


func _on_button_volume_section_pressed() -> void:
	volume.visible = true
	pause_menu.visible = false


func _on_quit_button_pressed() -> void:
	#get_tree().quit()
	get_tree().change_scene_to_file("res://scenes/tela_titulo.tscn")


func _on_button_back_pause_pressed() -> void:
	volume.visible = false
	pause_menu.visible = true


func _on_texture_button_pressed() -> void:
	get_tree().get_nodes_in_group("control")[0].start_tutorial()
	_on_button_back_pressed()
