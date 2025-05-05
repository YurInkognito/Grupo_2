extends Panel

@export var pontos: int = 0
@onready var pontos_label: Label = $Pontos
@onready var nome_label: Label = $Nome

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pontos_label.text = str(pontos)
	nome_label.text = $"..".gerar_nome()

func set_pontos(pontos_externos: int):
	pontos = pontos_externos
