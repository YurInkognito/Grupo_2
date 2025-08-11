extends Control

@onready var evento_1: Control = $Evento1
@onready var evento_2: Control = $Evento2
@onready var evento_3: Control = $Evento3
var evento_sorteado
var n_evento_max = 3
@onready var remover_carta_1: Button = $Evento2/RemoverCarta1
@onready var remover_carta_2: Button = $Evento2/RemoverCarta2
@onready var remover_carta_3: Button = $Evento2/RemoverCarta3
@onready var remover_carta_4: Button = $Evento2/RemoverCarta4

@onready var explorar_cuidado_button: Button = $Evento3/ExplorarCuidadoButton
@onready var explorar_correndo_button: Button = $Evento3/ExplorarCorrendoButton
@onready var contratrar_alguem_button: Button = $Evento3/ContratrarAlguemButton
@onready var nao_fazer_nada_button: Button = $Evento3/NaoFazerNadaButton



var cartas_sorteadas: Array[CartaData] = []
var reliquias_opcoes = []



func _ready() -> void:
	randomize()
	evento_sorteado = randi_range(1,3)
	print("Evento sorteado:" , evento_sorteado)
	ajusta_evento(evento_sorteado)
	gerar_reliquias_opcoes()
	atualizar_botoes()

var lista_eventos: Array = [
	executa_evento_1,
	executa_evento_2,	
	executa_evento_3
	]

func ajusta_evento(n_evento: int):
	if n_evento >= 1 and n_evento <= lista_eventos.size():
		lista_eventos[n_evento - 1].call()
	else:
		print("Evento inválido")
		

func executa_evento_1(): #Carroça de vegetal tombou
	evento_1.visible = true
	print("Carroça de vegetal tombou")
func executa_evento_2(): #Aniversário do Decartes
	evento_2.visible = true
	sortear_cartas()
	print("Aniversário do Decartes")
func executa_evento_3(): #Buraco na parede
	evento_3.visible = true
	print("Buraco na parede")


func _on_adotar_repolho_pressed() -> void:
	var repolho_data: CartaData = preload("res://Cartas/Repolho.tres") as CartaData
	if repolho_data:
		$"/root/GlobalData".lista_cartas.append(repolho_data)
		print("Repolho adicionada ao deck!")
	else:
		printerr("Falha ao carregar Repolho.tres")
	Transição.change_scene("res://scenes/control.tscn")


func _on_adotar_cenoura_pressed() -> void:
	var cenoura_data: CartaData = preload("res://Cartas/Cenoura Morto-Vivo.tres") as CartaData
	if cenoura_data:
		$"/root/GlobalData".lista_cartas.append(cenoura_data)
		print("Cenoura Morto‑Vivo adicionada ao deck!")
	else:
		printerr("Falha ao carregar Cenoura Morto‑Vivo.tres")
	Transição.change_scene("res://scenes/control.tscn")


func _on_adotar_mandragora_pressed() -> void:
	var mandra_data: CartaData = preload("res://Cartas/MandragoraReal.tres") as CartaData
	if mandra_data:
		$"/root/GlobalData".lista_cartas.append(mandra_data)
		print("Mandrágora Real adicionada ao deck!")
	else:
		printerr("Falha ao carregar MandragoraReal.tres")
	Transição.change_scene("res://scenes/control.tscn")

func _on_adotar_ninguem_pressed() -> void:
		Transição.change_scene("res://scenes/control.tscn")


func sortear_cartas() -> void:
	var disponiveis = $"/root/GlobalData".lista_cartas.duplicate()
	disponiveis.shuffle()
	cartas_sorteadas = disponiveis.slice(0, min(4, disponiveis.size()))
	if cartas_sorteadas.size() > 0:
		$Evento2/RemoverCarta1/Label.text = cartas_sorteadas[0].nome
	else:
		$Evento2/RemoverCarta1/Label.text = "—"
	if cartas_sorteadas.size() > 1:
		$Evento2/RemoverCarta2/Label.text = cartas_sorteadas[1].nome
	else:
		$Evento2/RemoverCarta2/Label.text = "—"
	if cartas_sorteadas.size() > 2:
		$Evento2/RemoverCarta3/Label.text = cartas_sorteadas[2].nome
	else:
		$Evento2/RemoverCarta3/Label.text = "—"
	if cartas_sorteadas.size() > 3:
		$Evento2/RemoverCarta4/Label.text = cartas_sorteadas[3].nome
	else:
		$Evento2/RemoverCarta4/Label.text = "—"

func _on_remover_carta_1_pressed() -> void:
	remover_carta(cartas_sorteadas, 0)


func _on_remover_carta_2_pressed() -> void:
	remover_carta(cartas_sorteadas, 1)


func _on_remover_carta_3_pressed() -> void:
	remover_carta(cartas_sorteadas, 2)


func _on_remover_carta_4_pressed() -> void:
	remover_carta(cartas_sorteadas, 3)

func remover_carta(cartas_sorteadas: Array, index: int) -> void:
	if index < 0 or index >= cartas_sorteadas.size():
		printerr("Índice de carta inválido:", index)
		Transição.change_scene("res://scenes/control.tscn")
		return
	var carta_para_remover: CartaData = cartas_sorteadas[index]
	var gd = get_node("/root/GlobalData")               
	var global_list = gd.lista_cartas                   
	if global_list.has(carta_para_remover):
		global_list.erase(carta_para_remover)
		print("Removida do deck:", carta_para_remover.nome)
	else:
		printerr("Carta não encontrada em GlobalData.lista_cartas:", carta_para_remover.nome)
	Transição.change_scene("res://scenes/control.tscn")


func _on_explorar_cuidado_button_pressed() -> void:
	perde_turno()
	ganha_reliquia_com_reliquia(reliquias_opcoes[0])
	GlobalData.proxima_fase()
	


func _on_explorar_correndo_button_pressed() -> void:
	perde_compra_por_turno()
	ganha_reliquia_com_reliquia(reliquias_opcoes[1])
	GlobalData.proxima_fase()



func _on_nao_fazer_nada_button_pressed() -> void:
	GlobalData.proxima_fase()

func ganha_reliquia() -> void:
	var reliquias_disponiveis = GlobalData.TODAS_RELIQUIAS.duplicate()
	
	# Remove as que o jogador já tem
	for r in GlobalData.lista_reliquias:
		reliquias_disponiveis.erase(r)
	
	if reliquias_disponiveis.is_empty():
		print("Você já possui todas as relíquias!")
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var index = rng.randi_range(0, reliquias_disponiveis.size() - 1)
	var nova_reliquia = reliquias_disponiveis[index]

	GlobalData.lista_reliquias.append(nova_reliquia)
	print("Ganhou a relíquia:", nova_reliquia.nome)

func perde_turno() -> void:
	GlobalData.perde_um_turno = true
	print("Vai perder o próximo turno.")

func perde_compra_por_turno() -> void:
	GlobalData.perde_compra()

func perde_carta_aleatoria() -> void:
	if GlobalData.lista_cartas.is_empty():
		printerr("Deck está vazio, não há carta para remover.")
		return
	
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0, GlobalData.lista_cartas.size() - 1)
	var removida = GlobalData.lista_cartas[index]
	GlobalData.lista_cartas.remove_at(index)
	print("Carta removida aleatoriamente:", removida.nome)
	
func gerar_reliquias_opcoes():
	var todas = GlobalData.TODAS_RELIQUIAS.duplicate()
	# Remove as que o jogador já tem
	for r in GlobalData.lista_reliquias:
		todas.erase(r)
		
	todas.shuffle()
	reliquias_opcoes = todas.slice(0, min(3, todas.size()))
	
func atualizar_botoes():
	$Evento3/ExplorarCuidadoButton/Label.text = "Explorar com cuidado (Perde um turno, ganha " + reliquias_opcoes[0].nome + ")"
	$Evento3/ExplorarCorrendoButton/Label.text = "Explorar correndo (Perde uma compra, ganha " + reliquias_opcoes[1].nome + ")"
	$Evento3/ContratrarAlguemButton/Label.text = "Contratar alguém (Perde uma carta aleatória, ganha " + reliquias_opcoes[2].nome + ")"
	$Evento3/NaoFazerNadaButton/Label.text = "Fechar o buraco"

func ganha_reliquia_com_reliquia(reliquia: CartaData) -> void:
	GlobalData.reliquias.append(reliquia)
	print("Ganhou a relíquia:", reliquia.nome)


func _on_contratrar_alguem_button_pressed() -> void:
	perde_carta_aleatoria()
	ganha_reliquia_com_reliquia(reliquias_opcoes[2])
	GlobalData.proxima_fase()
