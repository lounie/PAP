#include <Servo.h>

// Define os servos para cada dedo
Servo DedaoServo;
Servo indicadorServo;
Servo medioServo;
Servo anelarServo;
Servo mindinhoServo;

// Pinos dos servos
const int DedaoPin = 10;
const int indicadorPin = 3;
const int medioPin = 5;
const int anelarPin = 9;
const int mindinhoPin = 11;


void setup() {
  // Inicializa a comunicação serial
  Serial.begin(9600);



DedaoServo.write(90);

  // Anexa os servos aos pinos
  DedaoServo.attach(DedaoPin);
  indicadorServo.attach(indicadorPin);
  medioServo.attach(medioPin);
  anelarServo.attach(anelarPin);
  mindinhoServo.attach(mindinhoPin);
}

void loop()
{
 if (Serial.available() > 0) {
    // Lê a string enviada pelo Processing
    String DadosDedos = Serial.readStringUntil('\n');
   
    // Array para armazenar os valores recebidos
    int meuArray[5];  // Ajuste o tamanho conforme necessário
    int i = 0;

    // Divide a string recebida em valores individuais
    char* Ang = strtok((char*)DadosDedos.c_str(), ",");
    while (Ang != NULL) {
      meuArray[i++] = atoi(Ang);  // Converte o token para inteiro e armazena no array
      Ang = strtok(NULL, ",");
    }

    int Dedo1 = meuArray[0];
    int Dedo2 = meuArray[1];
    int Dedo3 = meuArray[2];
    int Dedo4 = meuArray[3];
    int Dedo5 = meuArray[4];

    DedaoServo.write(Dedo1);
    indicadorServo.write(Dedo2);
    medioServo.write(Dedo3);
    anelarServo.write(Dedo4);
    mindinhoServo.write(Dedo5);
}+
}