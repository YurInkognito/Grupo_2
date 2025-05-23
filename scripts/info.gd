extends Panel

@export var pontos: int = 0
@onready var pontos_label: Label = $Pontos
@onready var nome_label: Label = $Nome
@export var mult: int = 1
@onready var mult_label: Label = $Mult

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pontos_label.text = str(pontos)
	mult_label.text = 'X' + str(mult)
	nome_label.text = $"..".gerar_nome()

func set_pontos(pontos_externos: int):
	pontos = pontos_externos

func set_mult(mult_externo: int):
	mult = mult_externo
