extends Panel

@export var nome = ""
@export var sabor = 0

@onready var nome_l = $Label
@onready var foto: TextureRect = $TextureRect
@onready var sabor_l: Label = $Label2

@export var prato_sopa: Texture2D
@export var prato_sanduiche: Texture2D
@export var prato_salada: Texture2D
@export var prato_base: Texture2D

func _process(delta: float) -> void:
	nome_l.text = nome
	sabor_l.text = "$" + str(sabor)
	if nome.contains("Sopa"):
		foto.texture = prato_sopa
	elif nome.contains("Salada"):
		foto.texture = prato_salada
	elif nome.contains("Sanduiche"):
		foto.texture = prato_sanduiche
	else:
		foto.texture = prato_base
