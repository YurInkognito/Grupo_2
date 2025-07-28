extends Control

@onready var timer = $Timer
@onready var timer_anim = $timer_anim
@onready var jeff = $JeffChibi
@onready var fase = 0

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

@onready var rosto : TextureRect = $rosto
@onready var rosto2 : TextureRect = $rosto2
@onready var rosto3 : TextureRect = $rosto3
@onready var rosto4 : TextureRect = $rosto4
@onready var rosto5 : TextureRect = $rosto5
@onready var rosto6 : TextureRect = $rosto6

@onready var prato1 : TextureRect = $prato1
@onready var prato2 : TextureRect = $prato2
@onready var prato3 : TextureRect = $prato3
@onready var prato4 : TextureRect = $prato4
@onready var prato5 : TextureRect = $prato5
@onready var prato6 : TextureRect = $prato6

@onready var aliane = load("res://sprites/portraits/borda icone aliane.png")
@onready var jaccao = load("res://sprites/portraits/borda icone erick jaccão.png")
@onready var fogaco = load("res://sprites/portraits/borda icone fogaço.png")
@onready var ghorkon = load("res://sprites/portraits/borda icone ghorkon.png")
@onready var hiena = load("res://sprites/portraits/borda icone hiena rizzo.png")
@onready var bruxa = load("res://sprites/portraits/borda icone Bruxa Braga.png")

@onready var check: AudioStreamPlayer2D = $check
@onready var vinh_cal1: AudioStreamPlayer2D = $vinh_cal1
@onready var vinh_cal2: AudioStreamPlayer2D = $vinh_cal2

@export var prato_sopa: Texture2D
@export var prato_salada: Texture2D
@export var prato_sanduiche: Texture2D

func _ready() -> void:
	fase = GlobalData.fase
	
	var fase_pos = fase
	if fase >= 8:
		fase_pos = fase - 7
	jeff.position.x = (260 + 138 * (fase_pos - 2))
	
	var tween = create_tween()

	tween.tween_property(jeff, "position", position + Vector2(jeff.position.x + 138, jeff.position.y), 1.0)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	print("fase atual: " + str(fase))
	alterar_cliente()
	$"/root/GlobalData".set_pontuacao_fases()
	pontuacao_mostrar()
	qual_semana()
	anim_passou_dia()
	check.play()

func proxima_fase():
	match fase:
		1:
			Transição.change_scene("res://scenes/control.tscn")
		4:
			Transição.change_scene("res://scenes/evento.tscn")
		_:
			Transição.change_scene("res://scenes/control.tscn")

func qual_semana():
	if GlobalData.fase <= 7 :
		calendario1.visible = true
		calendario2.visible = false
		vinh_cal1.play()
	else:
		calendario1.visible = false
		calendario2.visible = true
		vinh_cal2.play()
	
func pontuacao_mostrar():
	resultado1.text = "$" + str($"/root/GlobalData".pontuacao_fases[2])
	resultado2.text = "$" + str($"/root/GlobalData".pontuacao_fases[3])
	resultado3.text = "$" + str($"/root/GlobalData".pontuacao_fases[4])
	resultado5.text = "$" + str($"/root/GlobalData".pontuacao_fases[5])
	resultado6.text = "$" + str($"/root/GlobalData".pontuacao_fases[6])
	resultado7.text = "$" + str($"/root/GlobalData".pontuacao_fases[7])
	resultado8.text = "$" + str($"/root/GlobalData".pontuacao_fases[8])
	resultado9.text = "$" + str($"/root/GlobalData".pontuacao_fases[9])
	resultado10.text = "$" + str($"/root/GlobalData".pontuacao_fases[10])
	resultado12.text = "$" + str($"/root/GlobalData".pontuacao_fases[11])
	resultado13.text = "$" + str($"/root/GlobalData".pontuacao_fases[12])
	resultado14.text = "$" + str($"/root/GlobalData".pontuacao_fases[13])
	
func _on_timer_timeout() -> void:
	proxima_fase()

func anim_passou_dia():
	if GlobalData.fase == 2 or GlobalData.fase == 9:
		await timer_anim.timeout
		animdia1.visible = true
		animdia1.play("default")

	elif GlobalData.fase == 3 or GlobalData.fase == 10:
		animdia1.visible = true
		animdia1.frame = 3
		await timer_anim.timeout
		animdia2.visible = true
		animdia2.play("default")

	elif GlobalData.fase == 4 or GlobalData.fase == 11:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		await timer_anim.timeout
		animdia3.visible = true
		animdia3.play("default")

	elif GlobalData.fase == 5 or GlobalData.fase == 12:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		animdia3.visible = true
		animdia3.frame = 3
		await timer_anim.timeout
		animdia4.visible = true
		animdia4.play("default")

	elif GlobalData.fase == 6 or GlobalData.fase == 13:
		animdia1.visible = true
		animdia1.frame = 3
		animdia2.visible = true
		animdia2.frame = 3
		animdia3.visible = true
		animdia3.frame = 3
		animdia4.visible = true
		animdia4.frame = 3
		await timer_anim.timeout
		animdia5.visible = true
		animdia5.play("default")

	elif GlobalData.fase == 14:
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
		await timer_anim.timeout
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
		
func alterar_cliente():
	if GlobalData.fase == 1:
		rosto.texture = aliane
		rosto.visible = true
	
	match GlobalData.fase:
		2:
			rosto.visible = true
			rosto2.texture = qual_cliente()
			#rosto2.position.x = rosto2.position.x - ajustar_pos()[0]
			#rosto2.position.y = rosto2.position.y - ajustar_pos()[1]
			rosto2.visible = true
			prato1.texture = qual_prato()
			prato1.visible = true
		3:
			rosto.visible = true
			rosto2.visible = true
			rosto3.texture = qual_cliente()
			#rosto3.position.x = rosto3.position.x - ajustar_pos()[0]
			#rosto3.position.y = rosto3.position.y - ajustar_pos()[1]
			rosto3.visible = true
			prato1.visible = true
			prato2.texture = qual_prato()
			prato2.visible = true
		4:
			rosto4.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.texture = qual_prato()
			prato3.visible = true
		5:
			rosto.visible = true
			rosto2.visible = true
			rosto3.visible = true
			rosto4.texture = qual_cliente()
			#rosto4.position.x = rosto4.position.x - ajustar_pos()[0]
			#rosto4.position.y = rosto4.position.y - ajustar_pos()[1]
			rosto4.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.visible = true
		6:
			rosto.visible = true
			rosto2.visible = true
			rosto3.visible = true
			rosto4.visible = true
			rosto5.texture = qual_cliente()
			#rosto5.position.x = rosto5.position.x - ajustar_pos()[0]
			#rosto5.position.y = rosto5.position.y - ajustar_pos()[1]
			rosto5.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.visible = true
			prato4.texture = qual_prato()
			prato4.visible = true
		7:
			rosto.visible = true
			rosto2.visible = true
			rosto3. visible = true
			rosto4.visible = true
			rosto5.visible = true
			rosto6.texture = qual_cliente()
			#rosto6.position.x = rosto6.position.x - ajustar_pos()[0]
			#rosto6.position.y = rosto6.position.y - ajustar_pos()[1]
			rosto6.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.visible = true
			prato4.visible = true
			prato5.texture = qual_prato()
			prato5.visible = true
		8:
			rosto2.visible = false
			rosto3.visible = false
			rosto4.visible = false
			rosto5.visible = false
			rosto6.visible = false
			rosto.texture = qual_cliente()
			#rosto.position.x = rosto.position.x - ajustar_pos()[0]
			#rosto.position.y = rosto.position.y - ajustar_pos()[1]
			rosto.visible = true
			prato1.visible = false
			prato2.visible = false
			prato3.visible = false
			prato4.visible = false
			prato5.visible = false
			#prato6.texture = qual_prato()
			#prato6.visible = true
		9:
			rosto.visible = true
			rosto2.texture = qual_cliente()
			#rosto2.position.x = rosto2.position.x - ajustar_pos()[0]
			#rosto2.position.y = rosto2.position.y - ajustar_pos()[1]
			rosto2.visible = true
			prato1.texture = qual_prato()
			prato1.visible = true
		10:
			rosto.visible = true
			rosto2.visible = true
			rosto3.texture = qual_cliente()
			#rosto3.position.x = rosto3.position.x - ajustar_pos()[0]
			#rosto3.position.y = rosto3.position.y - ajustar_pos()[1]
			rosto3.visible = true
			prato1.visible = true
			prato2.texture = qual_prato()
			prato2.visible = true
		11:
			rosto4.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.texture = qual_prato()
			prato3.visible = true
		12:
			rosto.visible = true
			rosto2.visible = true
			rosto3.visible = true
			rosto4.texture = qual_cliente()
			#rosto4.position.x = rosto4.position.x - ajustar_pos()[0]
			#rosto4.position.y = rosto4.position.y - ajustar_pos()[1]
			rosto4.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.visible = true
		13:
			rosto.visible = true
			rosto2.visible = true
			rosto3.visible = true
			rosto4.visible = true
			rosto5.texture = qual_cliente()
			#rosto5.position.x = rosto5.position.x - ajustar_pos()[0]
			#rosto5.position.y = rosto5.position.y - ajustar_pos()[1]
			rosto5.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.visible = true
			prato4.texture = qual_prato()
			prato4.visible = true
		14:
			rosto.visible = true
			rosto2.visible = true
			rosto3. visible = true
			rosto4.visible = true
			rosto5.visible = true
			rosto6.texture = qual_cliente()
			#rosto6.position.x = rosto6.position.x - ajustar_pos()[0]
			#rosto6.position.y = rosto6.position.y - ajustar_pos()[1]
			rosto6.visible = true
			prato1.visible = true
			prato2.visible = true
			prato3.visible = true
			prato4.visible = true
			prato5.texture = qual_prato()
			prato5.visible = true
			

func qual_prato():
	var lista = $"/root/GlobalData".lista_pratos
	var nome = lista[lista.size() - 1].nome
	print(nome)
	if nome.contains("Sopa"):
		return prato_sopa
	if nome.contains("Salada"):
		return prato_salada
	if nome.contains("Sanduiche"):
		return prato_sanduiche

func qual_cliente():
	match GlobalData.cliente_temp["nome"]:
		"Fogaço":
			return fogaco
		"Erick Jacão":
			return jaccao
		"Hyena Rizo":
			return hiena
		"Ghork'Ohn Ahm'sey":
			return ghorkon
		"Ana Maria Praga":
			return bruxa
		_:
			return aliane

func ajustar_pos():
	match qual_cliente():
		fogaco:
			return [4,5]
		jaccao:
			return [4,5]
		bruxa:
			return [8,11]
		ghorkon:
			return [0,10]
		hiena:
			return [3,11]
