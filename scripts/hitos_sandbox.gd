class_name HitosSandbox
extends RefCounted

static func obtener_hitos() -> Array[Dictionary]:
	return [
		{
			"id": 1,
			"clave": "PRIMEROS_PASOS",
			"titulo": "1. Calibración: Primer Suministro",
			"descripcion": "Estás en el hangar frente a la bahía de piezas básicas. Programa a tu astronauta para avanzar hacia la caja y recolectar una pieza con [Tomar Pieza].",
			"meta_texto": "Avanza y toma una pieza de la bahía de suministros",
			"bloques_disponibles": ["AVANZAR", "TOMAR_PIEZA"],
			"cantidad_astronautas": 1,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 3, # Mirando al Oeste (-X)
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "TOMAR_PIEZA",
			"recompensa_creditos": 15,
			"mensaje_ada": "¡Pieza asegurada! Has ejecutado tu primer algoritmo lineal: Avanzar y Tomar. Ahora completemos el circuito de entrega.",
			"pista": "Usa [Avanzar 1 Paso] y luego [Tomar Pieza].",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 0)}
			]
		},
		{
			"id": 2,
			"clave": "GIRO_Y_DEPOSITO",
			"titulo": "2. Circuito: Transportar a la Máquina",
			"descripcion": "Con la pieza en manos, camina hasta el Mesón Forjador de Patas en (-2, 0), deposítala con [Ensamblar / Depositar] y regresa a tu posición inicial.",
			"meta_texto": "Deposita el insumo en el Mesón Forjador (-2, 0)",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 3,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "DEPOSITAR_INSUMO",
			"recompensa_creditos": 20,
			"mensaje_ada": "¡Insumo entregado! Nota cuántos bloques individuales necesitaste para completar un solo viaje de ida y vuelta.",
			"pista": "Avanza, toma la pieza, camina hacia el Mesón en (-2, 0) y presiona [Ensamblar / Depositar].",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 0)}
			]
		},
		{
			"id": 3,
			"clave": "BUCLE_FARMEO",
			"titulo": "3. Automatización: Adquirir Bloque [LOOP]",
			"descripcion": "La máquina forjadora necesita más insumos para forjar una pata. Para no programar 20 bloques a mano, abre MEJORAS y adquiere el 'Bloque [LOOP] Bucle Continuo'. Enciérralo en tu rutina para abastecer sin parar.",
			"meta_texto": "Compra el Bloque [LOOP] en Mejoras y forja la primera Pata Mecánica",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 3,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "ACTIVAR_BUCLE",
			"recompensa_creditos": 30,
			"mensaje_ada": "¡Increíble! Con el bucle algorítmico continuo, Astro 1 alimenta la máquina de forma 100% autónoma y la primera pata ha sido forjada.",
			"pista": "Compra el bloque Bucle en MEJORAS y agrégalo a tu lista de instrucciones.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 0)}
			]
		},
		{
			"id": 4,
			"clave": "CADENA_MONTAJE_ASTRO2",
			"titulo": "4. Cadena de Montaje: Astro 2 y Mesa Spido",
			"descripcion": "¡La pata mecánica está lista en la bandeja de salida! En MEJORAS compra la 'Mesa Central Spido' y despierta a 'Astro 2 (Tracción)'. Programa a Astro 2 para recoger la pata del mesón y montarla en Spido.",
			"meta_texto": "Instala la Mesa Spido, activa a Astro 2 y acopla las Patas en Spido",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 2,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(0, 0),
			"ori_astronauta": 3,
			"pos_astronauta_2": Vector2i(-1, -1),
			"ori_astronauta_2": 2, # Mirando hacia el mesón
			"mostrar_mesa": true,
			"pos_mesa": Vector2i(0, -2),
			"mostrar_meson_patas": true,
			"tipo_meta": "ENSAMBLAR",
			"piezas_requeridas": 1,
			"recompensa_creditos": 50,
			"mensaje_ada": "¡Pipeline concurrente exitoso! Astro 1 abastece la forja mientras Astro 2 traslada y acopla las patas en Spido.",
			"pista": "Astro 2 toma la pata de la salida del mesón y la traslada a la Mesa de Spido en (0, -2).",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 0)}
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
			"ori_astronauta": 3,
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
				{"tipo": "TUERCA", "celda": Vector2i(-1, 0)},
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
