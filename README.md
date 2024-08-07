Automação WhatsApp com Docker, Appium e Emulador Android com KVM
Descrição
Este projeto configura um ambiente Docker para automatizar interações no WhatsApp utilizando Appium e um Emulador Android. O projeto foi otimizado para utilizar KVM (Kernel-based Virtual Machine) para aceleração de hardware, melhorando o desempenho do emulador.

Pré-requisitos
Docker instalado na máquina host
KVM instalado e configurado no host para permitir a aceleração de hardware
Instruções
1. Configurar KVM no Host
Certifique-se de que KVM está instalado e configurado no host:

bash
Copiar código
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo usermod -aG libvirt $(whoami)
Verifique se o KVM está funcionando:

bash
Copiar código
sudo kvm-ok
2. Build da Imagem Docker
Construa a imagem Docker utilizando o Dockerfile fornecido:

bash
Copiar código
docker build -t whatsapp-automation-kvm .
3. Executar o Contêiner
Inicie o contêiner Docker, garantindo que os dispositivos KVM sejam montados corretamente:

bash
Copiar código
docker run --device /dev/kvm -p 5901:5901 -p 4723:4723 whatsapp-automation-kvm
4. Automação com Appium
O contêiner inicia o emulador Android com aceleração de hardware utilizando KVM, configura o ambiente Appium e executa o script de automação do WhatsApp.

Observações
VNC: A porta 5901 está exposta para acessar o VNC.
ADB e Appium: As portas 5554, 5555 e 4723 estão expostas para o ADB e Appium, respectivamente.
Contato WhatsApp: Substitua "Contact Name" no script por um nome de contato real.
Licença
Este projeto é licenciado sob a MIT License.