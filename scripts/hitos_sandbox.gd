class_name HitosSandbox
extends RefCounted

static func obtener_hitos() -> Array[Dictionary]:
	return [
		{
			"id": 1,
			"clave": "PRIMEROS_PASOS",
			"titulo": "1. Circuito Inicial: Tomar, Girar y Dejar",
			"descripcion": "Estás en el centro del hangar frente a la Caja de Suministros (al Este). Toma una tuerca con [Tomar Pieza], da media vuelta hacia el Oeste, avanza hacia la Máquina Forjadora de Patas (-2, 0) y deposítala con [Ensamblar / Depositar].",
			"meta_texto": "Toma la tuerca al Este, gira al Oeste y deposítala en la Máquina (-2, 0)",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 1, # Mirando al Este (+X, hacia la caja en (1, 0))
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "DEPOSITAR_INSUMO",
			"recompensa_creditos": 20,
			"mensaje_ada": "¡Excelente maniobra! Has ejecutado tu primer algoritmo completo: tomar, girar y entregar. La máquina forjadora ha recibido su primer insumo (1/2).",
			"pista": "Usa [Tomar Pieza], da media vuelta con dos giros, avanza 1 paso y pulsa [Ensamblar / Depositar].",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(1, 0)}
			]
		},
		{
			"id": 2,
			"clave": "FRICCION_Y_REPETICION",
			"titulo": "2. Línea de Producción: Segunda Entrega",
			"descripcion": "La Máquina Forjadora necesita 2 insumos para terminar de fabricar las patas mecánicas (progreso: 1/2). Realiza un segundo viaje manual de ida y vuelta para depositar la segunda tuerca.",
			"meta_texto": "Lleva la 2ª tuerca a la Máquina para forjar las Patas",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 1,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "FABRICAR_PATAS",
			"recompensa_creditos": 25,
			"mensaje_ada": "¡Patas forjadas con éxito! Pero nota que escribir 14 bloques a mano para repetir viajes se vuelve agotador. En programación usamos Bucles. Abre el Centro de Mejoras y adquiere el [BLOQUE BUCLE].",
			"pista": "Programa el viaje de retorno a la caja de suministros y vuelve a la máquina con la segunda tuerca.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(1, 0)}
			]
		},
		{
			"id": 3,
			"clave": "BUCLE_FARMEO",
			"titulo": "3. Automatización Continua: El Bucle",
			"descripcion": "Abre MEJORAS y adquiere el 'Bloque [LOOP] Bucle Continuo' (20 tuercas). Envuelve tu circuito de transporte para que Astro 1 mantenga la máquina forjadora abastecida de forma 100% autónoma.",
			"meta_texto": "Compra el Bloque [LOOP] en Mejoras y activa el transporte continuo",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 1,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "ACTIVAR_BUCLE",
			"recompensa_creditos": 30,
			"mensaje_ada": "¡Fábrica automatizada! Astro 1 transporta insumos sin parar. La pata mecánica terminada espera en la bandeja de salida. ¡Es momento de ensamblar a Spido!",
			"pista": "Compra el bloque Bucle en MEJORAS y agrégalo a tu algoritmo.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(1, 0)}
			]
		},
		{
			"id": 4,
			"clave": "CADENA_MONTAJE_ASTRO2",
			"titulo": "4. Cadena de Montaje: Astro 2 y Mesa Spido",
			"descripcion": "¡La pata mecánica está lista en la bandeja de salida! En MEJORAS compra la 'Mesa Central Spido' (30 tuercas) y despierta a 'Astro 2 (Tracción)' (35 tuercas). Programa a Astro 2 para recoger la pata del mesón y montarla en Spido.",
			"meta_texto": "Instala la Mesa Spido, activa a Astro 2 y acopla las Patas en Spido",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 2,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 1,
			"pos_astronauta_2": Vector2i(-1, -1),
			"ori_astronauta_2": 2, # Mirando hacia el mesón de patas
			"mostrar_mesa": true,
			"pos_mesa": Vector2i(0, -2),
			"mostrar_meson_patas": true,
			"tipo_meta": "ENSAMBLAR",
			"piezas_requeridas": 1,
			"recompensa_creditos": 50,
			"mensaje_ada": "¡Pipeline concurrente exitoso! Astro 1 abastece la forja mientras Astro 2 traslada y acopla las patas en Spido.",
			"pista": "Astro 2 toma la pata de la salida del mesón y la traslada a la Mesa de Spido en (0, -2).",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(1, 0)}
			]
		},
		{
			"id": 5,
			"clave": "EXPANSION_Y_SENSORES",
			"titulo": "5. Expansión y Mesón de Sensores (Astro 3)",
			"descripcion": "Expande el taller a 7x7 casillas en MEJORAS, instala el 'Mesón de Sensores' y despierta a 'Astro 3 (Sensores)'. Coordina la línea para forjar el cabezal óptico y montarlo en Spido.",
			"meta_texto": "Expande a 7x7 casillas y ensambla los Sensores en Spido",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 3,
			"tamano_sector": 7,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 1,
			"pos_astronauta_2": Vector2i(-1, -1),
			"ori_astronauta_2": 2,
			"pos_astronauta_3": Vector2i(1, -1),
			"ori_astronauta_3": 0,
			"mostrar_mesa": true,
			"pos_mesa": Vector2i(0, -2),
			"mostrar_meson_patas": true,
			"tipo_meta": "ENSAMBLAR",
			"piezas_requeridas": 2,
			"recompensa_creditos": 70,
			"mensaje_ada": "¡Impresionante coordinación! Tres agentes colaborando en paralelo sin colisiones.",
			"pista": "Astro 3 alimenta y traslada los componentes ópticos hacia la estación central de Spido.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(1, 0)},
				{"tipo": "CHIP", "celda": Vector2i(2, 0)}
			]
		},
		{
			"id": 6,
			"clave": "DESPERTAR_SPIDO",
			"titulo": "6. Escuadrón Completo y Despertar de Spido",
			"descripcion": "¡Hangar expandido a máxima capacidad! Todos los módulos de Spido están ensamblados. Coloca al astronauta frente a Spido y ejecuta [DIAGNOSTICO] para activarlo.",
			"meta_texto": "Ejecuta DIAGNOSTICO frente a Spido",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR", "DIAGNOSTICO"],
			"cantidad_astronautas": 3,
			"tamano_sector": 9,
			"pos_astronauta": Vector2i(0, -1),
			"ori_astronauta": 0,
			"mostrar_mesa": true,
			"pos_mesa": Vector2i(0, -2),
			"mostrar_meson_patas": true,
			"tipo_meta": "DIAGNOSTICO",
			"recompensa_creditos": 100,
			"mensaje_ada": "¡Sistemas en línea! Spido ha despertado y camina. ¡Has dominado la programación algorítmica y la concurrencia espacial!",
			"pista": "Párate frente a la mesa de Spido mirando hacia él y ejecuta el bloque Diagnóstico.",
			"piezas": []
		}
	]
