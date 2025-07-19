extends Panel

@export var reliquias: Array[CartaData]
@export var lista_reliquias: Array[CartaData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func efeitos():
	for r in reliquias:
		$"..".aplicar_efeitos_carta(r)
