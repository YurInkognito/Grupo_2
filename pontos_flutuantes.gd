extends Label

@export var tempo_animacao: float = 0.6 # Tempo em segundos para a animação
@export var cor_texto: Color = Color.WHITE # Cor padrão do texto

var valor_numero: int = 0
var posicao_inicial: Vector2
var posicao_final: Vector2 # Nova variável para a posição final

func _ready():
	# Configurações iniciais do Label
	self.text = str(valor_numero)
	self.modulate = cor_texto # Define a cor inicial do texto
	self.position = posicao_inicial # Define a posição inicial

	# Centraliza o pivô do Label para que a animação seja mais suave
	self.pivot_offset = self.size / 2.0

	iniciar_animacao()

# Função de configuração atualizada para receber a posição final
func configurar(valor: int, pos_inicial: Vector2, pos_final: Vector2):
	valor_numero = valor
	posicao_inicial = pos_inicial
	posicao_final = pos_final # Atribui a posição final

func iniciar_animacao():
	var tween = create_tween()

	# Animação de movimento: do ponto inicial para o ponto final
	tween.tween_property(self, "position", posicao_final, tempo_animacao)

	# Animação de fade-out (transparência)
	tween.tween_property(self, "modulate:a", 0.0, tempo_animacao * 0.8) # Fazer desaparecer um pouco antes

	# Conecta o sinal para liberar o nó quando a animação terminar
	tween.tween_callback(queue_free)
