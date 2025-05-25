extends Control
@onready var menu_content: MarginContainer = $MarginContainerContent
const CONFIG = preload("res://scenes/config.tscn")

func _on_botao_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")
	
func _on_botao_cutscene_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cena_aliane.tscn")
	
func _on_botao_sair_pressed() -> void:
	get_tree().quit()


func _on_botao_config_pressed() -> void:
	menu_content.visible = false
	var config_instance = CONFIG.instantiate()
	add_child(config_instance)


func _on_botao_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
