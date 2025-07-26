extends Panel

@export var pontos: int = 0
@onready var pontos_label: RichTextLabel = $Pontos
@onready var nome_label: Label = $Nome
@export var mult: int = 1
@onready var mult_label: Label = $Mult
@onready var foto: TextureRect = $TextureRect

@export var prato_sopa: Texture2D
@export var prato_sanduiche: Texture2D
@export var prato_salada: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pontos_label.text = str(pontos) + '[color=red]x' + str(mult) + '[/color]'
	#mult_label.text = 'X' + str(mult)
	nome_label.text = $"..".gerar_nome()
	var prato = $"..".tipo_prato
	match prato:
		"Sopa": 
			foto.texture = prato_sopa
			$"/root/GlobalData".foto_final = prato_sopa
		"Sanduiche": 
			foto.texture = prato_sanduiche
			$"/root/GlobalData".foto_final = prato_sanduiche
		"Salada": 
			foto.texture = prato_salada
			$"/root/GlobalData".foto_final = prato_salada

func set_pontos(pontos_externos: int):
	pontos = pontos_externos

func set_mult(mult_externo: int):
	mult = mult_externo
