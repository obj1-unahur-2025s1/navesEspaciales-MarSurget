class Nave {
  var velocidad 
  var direccionRespectoSol
  var property combustible 

   method direccionRespectoSol() = direccionRespectoSol
   method acelerar(unNumero) {
     velocidad = (velocidad + unNumero).min(100000)
   }
     method desacelerar(unNumero) {
     velocidad = (velocidad - unNumero).max(0) 
   }
   method irHaciaElSol() {
     direccionRespectoSol = 10
   }

    method escaparDelSol() {
     direccionRespectoSol = -10
   }

   method  ponerseParaleloAlSol() {
      direccionRespectoSol = 0
   }

   method acercarseUnPocoAlSol() {
     direccionRespectoSol = (direccionRespectoSol + 1).min(10)
   }
   method alejarseUnPocoDelSol() {
     direccionRespectoSol = (direccionRespectoSol - 1).max(-10)
   }

   method prepararNave() {
    combustible += 30000
    self.acelerar(5000)
   }

   method estaTranquila() = combustible <= 4000 and velocidad < 12000

  method recibirAmenaza() { 
    self.escaparAmenaza()
    self.avisarAmenaza()
  }
  
  method escaparAmenaza() {  }

  method avisarAmenaza() {  }

  method estaDeRelajo() {
    self.estaTranquila() and self.tienePocaActividad()
  } 

  method tienePocaActividad(){}
}

class NavesBaliza inherits Nave{
  var colorBaliza 
  method cambiarColorDeBaliza(colorNuevo) {
    if(!coloresNaves.coloresValidos.contains(colorNuevo)){
      self.error(colorNuevo + " no es un color valido")
    }
    colorBaliza = colorNuevo
  }
  method initialize() {
     if(!coloresNaves.coloresValidos.contains(colorBaliza)){
      // self.error("no es un color valido")
      throw new Exception(message ="no es un color valido")
    }
  }

//  cambian el color de la baliza a verde, y se ponen paralelas al Sol.
  override method prepararNave() {
      super()
      colorBaliza = "verde"
      direccionRespectoSol = 0
  }

  override method estaTranquila() = super() and (colorBaliza = "rojo")

  override method escaparAmenaza() {
    self.irHaciaElSol()
  }

  override method avisarAmenaza() {
    colorBaliza = "rojo"
  }


}

object coloresNaves {
  const coloresValidos = ["verde", "rojo",  "azul"]
}

class NavesPasajeros inherits Nave {
  var cantPasajeros 
  var property racionesComida
  var property bebida 

  method cantPasajeros() = cantPasajeros

// carga 4 raciones de comida, y 6 de bebida, para cada pasajero que llevan. 
//se acercan un poco al Sol
  override method prepararNave() { 
    super()
    racionesComida = 4 * cantPasajeros
    bebida = 6 * cantPasajeros
    self.acercarseUnPocoAlSol()
  }

  override method escaparAmenaza() {
    velocidad = velocidad * 2
  }

  override method avisarAmenaza() {
    racionesComida -= 1
    bebida -= 2
  }
}

class NavesCombate inherits Nave {
  var  property estaVisible 
  var property misiles
  const mensajes  

  method estaInvisible() = !estaVisible 

  method misilesDesplegados() = misiles

  method emitirMensaje(unMensaje) {
   /// tengo q hacer la salvedad de que sea un str
    mensajes.add(unMensaje)   
  }
  method mensajesEmitidos() {
  
  }
  
  method primerMensajesEmitidos() {
    mensajes.first()  
  }

  method ultiimoMensajesEmitidos() {
    mensajes.last()
  }

  method esEscueta() {
    mensajes.all({m=>m.length() <= 30})
  }

//se ponen visibles, repliegan sus misiles, aceleran 15000 kms/seg,
// y emiten un mensaje 
  override method prepararNave() { 
    super()
    estaVisible = true
    misiles = true
    self.acelerar(15000)
    mensajes.add("Saliendo en mision")
  }

  override method estaTranquila() = super() and !misiles

  override method escaparAmenaza() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisarAmenaza() {
    mensajes.add("Amenaza recibida")
  }
}

class NaveHospital inherits NavesPasajeros {
  var property quirofanosPreparados
  override method estaTranquila() = super() and !quirofanosPreparados

  override method recibirAmenaza() {
    super()
    quirofanosPreparados = true
  }
}

class NaveCombateSigilosa inherits NavesCombate {
  override method estaTranquila() = super() and estaVisible
  override method escaparAmenaza() {
    super()
    misiles = true
    estaVisible = false
  }
}