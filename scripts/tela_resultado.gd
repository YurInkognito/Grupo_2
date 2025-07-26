extends Control

@onready var dia: Label = $Panel/Dia
@onready var sabor: Label = $Panel/Sabor
@onready var prato: Label = $Panel/Prato
@onready var cliente: Label = $Panel/Cliente
@onready var resultado: Label = $Panel/Resultado
@onready var estrelas: Label = $Panel/Estrelas
@onready var fala: Label = $Panel2/Fala
@onready var secret: Label = $Panel/Secret
@onready var foto: TextureRect = $Prato/Foto

@export var sabor_value: int
@export var prato_value: int
@export var cliente_value: int
@export var resultado_value: int
@export var estrelas_value: int = 0
@export var objetivo: int = 1200

@onready var botao: Button = $Button
@onready var continuar: Button = $Button2

var labels: Array[Label]

const BASE_CRESCIMENTO = 1.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continuar.visible = false
	botao.pressed.connect(voltar)
	continuar.pressed.connect(upgradar)
	foto.texture = $"/root/GlobalData".foto_final
	dia.text = "Dia " + str($"/root/GlobalData".fase)
	sabor_value = $"/root/GlobalData".sabor_final
	prato_value = $"/root/GlobalData".mult_final
	cliente_value = $"/root/GlobalData".cliente_final
	resultado_value = sabor_value * prato_value * cliente_value
	var dia = $"/root/GlobalData".fase - 1
	if (resultado_value <= calcular_pontuacao_requerida(dia, 3000)):
		estrelas_value = 0
	elif (resultado_value <= calcular_pontuacao_requerida(dia, 5000)):
		estrelas_value = 1
	elif (resultado_value <= calcular_pontuacao_requerida(dia, 6000)):
		estrelas_value = 2
	else:
		estrelas_value = 3
	
	if estrelas_value > 0:
		continuar.visible = true
		$Panel3/Panel.recompensar(estrelas_value)
	
	labels = [sabor, prato, cliente, resultado, estrelas]
	if cliente_value == 2 and estrelas_value == 3:
		labels.append(secret)
		
	
	print("estrelas " + str(estrelas_value))
	fala.text = $"/root/GlobalData".gera_fala(estrelas_value)
	
	$Prato/Nome.text = $"/root/GlobalData".nome_final
	
	var prato_salvo = {
		nome = $"/root/GlobalData".nome_final,
		sabor = sabor_value
	}
	$"/root/GlobalData".lista_pratos.append(prato_salvo)
	show_anim()

func skip():
	if $"/root/GlobalData".fase == 1:
		if $"/root/GlobalData".estrelas == 3:
			if $"/root/GlobalData".cliente_value == 2:
				$"/root/GlobalData".Transição.change_scene('cena_aliane_picante')
			else:
				$"/root/GlobalData".Transição.change_scene('cena_aliane_suave')
	$"/root/GlobalData".proximafase()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sabor.text = "Sabor: +" + str(sabor_value)
	prato.text = "Prato: x" + str(prato_value)
	cliente.text = "Cliente: x" + str(cliente_value)
	resultado.text = "$ " + str(resultado_value)
	match estrelas_value:
		0: estrelas.text = ''
		1: estrelas.text = '*'
		2: estrelas.text = '* *'
		3: estrelas.text = '* * *'

func calcular_pontuacao_requerida(fase: int, valor_inicial: int) -> int:
	var pontuacao_bruta = float(valor_inicial) * pow(BASE_CRESCIMENTO, float(fase - 1))
	print(int(round(pontuacao_bruta / 100.0) * 100.0))
	return int(round(pontuacao_bruta / 100.0) * 100.0)

func voltar():
	reset_pontos()
	get_tree().change_scene_to_file("res://scenes/tela_titulo.tscn")
	
func upgradar():
	$Panel3.visible = true
	if $"/root/GlobalData".fase == 1:
		if estrelas_value == 3:
			if cliente_value == 2:
				Transição.change_scene('cena_aliane_picante')
			else:
				Transição.change_scene('cena_aliane_suave')

func reset_pontos():
	var temp_array: Array[String] = []
	$"/root/GlobalData".set_sabor(0)
	$"/root/GlobalData".set_mult(0)
	$"/root/GlobalData".set_tags(temp_array)
	$"/root/GlobalData".set_cliente()

func show_anim():
	var delay = 0.5
	var tempo_animacao = 0.1
	var fator_escala = 2
	
	sabor.visible = false
	prato.visible = false
	cliente.visible = false
	resultado.visible = false
	estrelas.visible = false
	
	for i in range(labels.size()):
		var label = labels[i]
		var tween = create_tween()
		tween.set_parallel()
		
		var deslocamento_x = 100
		label.position.x = label.position.x - deslocamento_x
		var posicao_original = label.position
		
		tween.tween_property(label, "scale", Vector2(fator_escala, fator_escala), 0.0).from(Vector2(1.0, 1.0))
		tween.tween_property(label, "visible", true, 0.0).from(false).set_delay(delay * (i + 1))
		tween.tween_property(label, "scale", Vector2(1.0, 1.0), tempo_animacao).set_delay(delay * (i + 1))
		tween.tween_property(label, "position", Vector2(posicao_original.x + deslocamento_x, posicao_original.y), tempo_animacao).set_delay(delay * (i + 1))
		
