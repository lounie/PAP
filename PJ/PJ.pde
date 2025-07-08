import controlP5.*;
import de.voidplus.leapmotion.*;
import processing.serial.*;

LeapMotion leap;
Serial myPort;
ControlP5 cp5;
String[] serialPorts;
ListBox portList;
Serial porta;
void setup() {
  size(800, 500, P3D);
  background(255);
 
cp5 = new ControlP5(this);
// Cria uma ListBox para selecionar a porta serial
  portList = cp5.addListBox("portList")
                .setPosition(0, 0)
                .setSize(100, 150)
                .setItemHeight(20)
                .setBarHeight(20)
                .setLabel("Selecione a Porta");

  serialPorts = Serial.list();
  for (int i = 0; i < serialPorts.length; i++) {
    portList.addItem(serialPorts[i], i);
  }
  // Inicializa o Leap Motion
  leap = new LeapMotion(this);
}
// Função chamada quando uma porta é selecionada na ListBox
void portList(int n) {
  String portName = serialPorts[n];
  if (porta != null) {
    porta.stop(); // Fecha a porta atual, se aberta
  }
  porta = new Serial(this, portName, 9600); // Abre a nova porta
  println("Porta selecionada: " + portName);
}

void draw() {
  background(255);

  // Taxa de quadros por segundo do Leap Motion
  int fps = leap.getFrameRate();

  // Itera sobre as mãos detectadas
  for (Hand hand : leap.getHands()) {
    // Desenha a mão
    hand.draw();

    // Captura os dedos da mão
    Finger[] fingers = hand.getFingers().toArray(new Finger[0]);

    // Array para armazenar os ângulos dos dedos
    float[] fingerAngles = new float[5];

    // Itera sobre os dedos
    for (int i = 0; i < fingers.length; i++) {
      Finger finger = fingers[i];

      // Obtém a posição da ponta do dedo
      PVector fingerTip = finger.getPosition();

      // Obtém a direção do dedo
      PVector fingerDirection = finger.getDirection();

      // Calcula o ângulo do dedo (simplificado)
      float angle = degrees(PVector.angleBetween(fingerDirection, new PVector(1, 1, 1)));
      fingerAngles[i] = angle;

      // Desenha a ponta do dedo
      fill(255, 0, 0);
      noStroke();
      pushMatrix();
      translate(fingerTip.x, fingerTip.y, fingerTip.z);
      sphere(5);
      popMatrix();
    }

    // Envia os ângulos dos dedos para o Arduino (com inversão)
    EnviarAngulo(fingerAngles);
  }
}

// Função para enviar dados para o Arduino
void EnviarAngulo(float[] angles) {
    if (porta == null) return; // Garante que a porta serial foi aberta antes de enviar

    float mappedAngles[] = new float[5];

    // Mapeia cada dedo separadamente com faixas ajustadas
    mappedAngles[0] = map(angles[0], 100, 170, 0, 180);  // Polegar
    mappedAngles[1] = map(angles[1], 30, 150, 0, 180);  // Indicador
    mappedAngles[2] = map(angles[2], 30, 150, 0, 180);  // Médio
    mappedAngles[3] = map(angles[3], 35, 140, 0, 180);  // Anelar
    mappedAngles[4] = map(angles[4], 25, 130, 0, 180);  // Mínimo

    // Garante que os valores fiquem dentro do intervalo válido (0 a 180)
    for (int i = 0; i < 5; i++) {
 
    }

    // Formata os dados para envio
    String data = "";
    for (int i = 0; i < mappedAngles.length; i++) {
        data += int(mappedAngles[i]);
        if (i < mappedAngles.length - 1) data += ",";
    }
    data += "\n"; // Adiciona uma nova linha no final

    println("Enviando: " + data);
    porta.write(data); // Agora os dados são realmente enviados para o Arduino
}
