extends Control

@onready var timer = $Timer
@onready var jeff = $JeffChibi
@onready var fase = 3

@onready var calendario1 : TextureRect = $"Calendario1"
@onready var calendario2 : TextureRect = $"Calendario2"

@onready var resultado1 : Label = $'Calendario1/Painel 1/Resultado1'
@onready var resultado2 : Label = $'Calendario1/Painel 2/Resultado2'
@onready var resultado3 : Label = $'Calendario1/Painel 3/Resultado3'
@onready var resultado5 : Label = $'Calendario1/Painel 5/Resultado5'
@onready var resultado6 : Label = $'Calendario1/Painel 6/Resultado6'
@onready var resultado7 : Label = $'Calendario1/Painel 7/Resultado7'

@onready var resultado8 : Label = $'Calendario2/Painel 8/Resultado8'
@onready var resultado9 : Label = $'Calendario2/Painel 9/Resultado9'
@onready var resultado10 : Label = $'Calendario2/Painel 10/Resultado10'
@onready var resultado12 : Label = $'Calendario2/Painel 12/Resultado12'
@onready var resultado13 : Label = $'Calendario2/Painel 13/Resultado13'
@onready var resultado14 : Label = $'Calendario2/Painel 14/Resultado14'

@onready var animdia1 : AnimatedSprite2D = $AnimDia1
@onready var animdia2 : AnimatedSprite2D = $AnimDia2
@onready var animdia3 : AnimatedSprite2D = $AnimDia3
@onready var animdia4 : AnimatedSprite2D = $AnimDia4
@onready var animdia5 : AnimatedSprite2D = $AnimDia5
@onready var animdia6 : AnimatedSprite2D = $AnimDia6
@onready var animdia7 : AnimatedSprite2D = $AnimDia7

func _ready() -> void:
	#var fase = GlobalData.fase
	jeff.position.x = (260 + 135 * (fase - 2))
	
	var tween = create_tween()

	tween.tween_property(jeff, "position", position + Vector2(jeff.position.x + 135, jeff.position.y), 1.0)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	print("a fase atual é:" + str(fase))
	qual_semana()
	anim_passou_dia()

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

func anim_passou_dia():
	if fase == 2 or fase == 9:
		animdia1.visible = true
		animdia1.play("default")

	elif fase == 3 or fase == 10:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.play("default")

	elif fase == 4 or fase == 11:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		animdia3.visible = true
		animdia3.play("default")

	elif fase == 5 or fase == 12:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		animdia3.visible = true
		animdia3.frame = 3
		animdia4.visible = true
		animdia4.play("default")

	elif fase == 6 or fase == 13:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		animdia3.visible = true
		animdia3.frame = 3
		animdia4.visible = true
		animdia4.frame = 3
		animdia5.visible = true
		animdia5.play("default")

	elif fase == 14:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		animdia3.visible = true
		animdia3.frame = 3
		animdia4.visible = true
		animdia4.frame = 3
		animdia5.visible = true
		animdia5.frame = 3
		animdia6.visible = true
		animdia6.frame = 3
		animdia7.visible = true
		animdia7.play("default")
		
	else:
		animdia1.visible = false
		animdia2.visible = false
		animdia3.visible = false
		animdia4.visible = false
		animdia5.visible = false
		animdia6.visible = false
		animdia7.visible = false
		
		
		
