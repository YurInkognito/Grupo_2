extends Control

@onready var timer = $Timer
@onready var jeff = $JeffChibi
@onready var fase = 0
@onready var calendario1 : TextureRect = $"Calendario1"
@onready var calendario2 : TextureRect = $"Calendario2"
@onready var resultado1 : Label = $'Calendario1/Painel 1/Resultado1'

func _ready() -> void:
	var fase = GlobalData.fase
	jeff.position.x = (260 + 135 * (fase - 2))
	
	var tween = create_tween()

	tween.tween_property(jeff, "position", position + Vector2(jeff.position.x + 135, jeff.position.y), 1.0)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	qual_semana()

func proxima_fase():
	match fase:
		1:
			Transição.change_scene("res://scenes/cena_aliane.tscn")
		#5:
			#leva pra cutscene 2
		#	get_tree().change_scene_to_file("res://scenes/control.tscn")
		_:
			Transição.change_scene("res://scenes/control.tscn")

func qual_semana():
	if fase <= 7 :
		calendario1.visible = true
		calendario2.visible = false
	else:
		jeff.position.x = 260
		calendario1.visible = false
		calendario2.visible = true
	
func pontuacao_do_dia():
	resultado1.text = "$" + str($"/root/GlobalData".resultado_value)

func _on_timer_timeout() -> void:
	proxima_fase()
