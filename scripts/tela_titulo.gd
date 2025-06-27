extends Control

@export var lista_cartas: Array[CartaData]

const CONFIG = preload("res://scenes/config.tscn")
@onready var credits: Control = $Credits
@onready var margin_container_content: MarginContainer = %MarginContainerContent

func _ready() -> void:
	$"/root/GlobalData".fase = 0

func _on_botao_iniciar_pressed() -> void:
	$"/root/GlobalData".set_cartas(lista_cartas)
	$"/root/GlobalData".fase += 1
	$"/root/GlobalData".proxima_fase()
	
func _on_botao_cutscene_pressed() -> void:
	$"/root/GlobalData".set_cartas(lista_cartas)
	$"/root/GlobalData".proxima_fase()
	
func _on_botao_sair_pressed() -> void:
	get_tree().quit()


func _on_botao_config_pressed() -> void:
	var config_instance = CONFIG.instantiate()
	add_child(config_instance)


func _on_botao_creditos_pressed() -> void:
	credits.visible = true
	margin_container_content.visible = false
