# Raspberry PI Zero Headless Setup

Este script configura os arquivos necessários para que o raspberry pi zero/zero 2W funcione como um dispositivo USB Serial Gadget Mode.

Em resumo este setup consiste em:

- Ativa o serviço de ssh na inicialização.
- Cria um usuário com as credenciais fornecidas no início do script prepare-uart-otg.sh (Se houver erro na criacao do usuario, as informações estarão em /boot/failed_userconf.txt).
- Habilita o modo USB OTG na inicializacao.
- Habilita a função de USB Serial Gadget.

## Como usar

Abra o script desejado e altere as variáveis: DEVICE, USERNAME e PASSWORD de acordo com o seu cenário.

Em seguida execute o script como root (ou sudo) após gravar a imagem desejada num cartão.

Conecte um cabo USB à porta OTG do raspberry pi zero e aguarde, a primeira inicialização demora um pouco por conta da preparação do ambiente para uso (redimensionamento do sistema de arquivos, criação de usuário, ativação de serviços, reboot, etc)

OBSERVAÇÃO: Não é necessário alimentar o raspberry pi zero pelo conector power!

Ao final da inicialização será criada uma porta serial (ttyACM0) que será utlizada para acessar o raspberry.

Se tudo correr bem, nas mensagens do kernel da máquina host deve aparecer algo como:

```bash
[Tue Aug 20 18:49:59 2024] usb 2-1.4: new full-speed USB device number 7 using xhci_hcd
[Tue Aug 20 18:50:03 2024] usb 2-1.4: new high-speed USB device number 8 using xhci_hcd
[Tue Aug 20 18:50:03 2024] usb 2-1.4: New USB device found, idVendor=0525, idProduct=a4a7, bcdDevice= 6.06
[Tue Aug 20 18:50:03 2024] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[Tue Aug 20 18:50:03 2024] usb 2-1.4: Product: Gadget Serial v2.4
[Tue Aug 20 18:50:03 2024] usb 2-1.4: Manufacturer: Linux 6.6.31+rpt-rpi-v7 with 3f980000.usb
[Tue Aug 20 18:50:03 2024] cdc_acm 2-1.4:2.0: ttyACM0: USB ACM device
[Tue Aug 20 18:50:03 2024] usbcore: registered new interface driver cdc_acm
[Tue Aug 20 18:50:03 2024] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
```

Para ter acesso ao prompt de login do raspberry você pode utilizar o comando 'cu' ou 'screen'.

```bash
cu -s 115200 -l /dev/ttyACM0
```

```bash
screen /dev/ttyACM0 115200,N,8,1
```

O prompt de login deve ser algo como:

```bash
Raspbian GNU/Linux 12 raspberrypi ttyGS0

raspberrypi login: 
```

## Disclaimer

Segue cenário do teste:

Distribuição linux:

- Linux Mint 21.2 (Victoria)

Target Device

- Raspberry PI Zero
- Raspberry PI Zero 2W

RaspiOS

- 2024-07-04-raspios-bookworm-armhf-lite (legacy)

Os métodos de gravação foram:

- Balena Etcher
- Disk Image Writer (do GNOME)

Cartão microsd

- SanDisk Ultra microSDXC (16Gb e 64Gb)

## TODO

- Realizar configuração da rede sem fios
- Criar script para ethernet gadget
- Incluir suporte para raspios-bookworm-arm64-lite

## Troubleshooting

Caso haja dúvidas sobre a funcionalidade do hardware é possível fazer o seguinte teste:

Remova o cartão microSD e Conecte um cabo USB ao conector OTG, nas mensagens do kernel do linux deve aparecer algo como:

Raspberry PI Zero

```bash
[Tue Aug 20 19:10:33 2024] usb 2-1.4: new full-speed USB device number 15 using xhci_hcd
[Tue Aug 20 19:10:33 2024] usb 2-1.4: New USB device found, idVendor=0a5c, idProduct=2763, bcdDevice= 0.00
[Tue Aug 20 19:10:33 2024] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[Tue Aug 20 19:10:33 2024] usb 2-1.4: Product: BCM2708 Boot
[Tue Aug 20 19:10:33 2024] usb 2-1.4: Manufacturer: Broadcom
```

Raspberry PI Zero 2 W

```bash
[Tue Aug 20 19:09:25 2024] usb 2-1.4: new high-speed USB device number 13 using xhci_hcd
[Tue Aug 20 19:09:31 2024] usb 2-1.4: new high-speed USB device number 14 using xhci_hcd
[Tue Aug 20 19:09:31 2024] usb 2-1.4: config index 0 descriptor too short (expected 55, got 32)
[Tue Aug 20 19:09:31 2024] usb 2-1.4: New USB device found, idVendor=0a5c, idProduct=2764, bcdDevice= 0.00
[Tue Aug 20 19:09:31 2024] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[Tue Aug 20 19:09:31 2024] usb 2-1.4: Product: BCM2710 Boot
[Tue Aug 20 19:09:31 2024] usb 2-1.4: Manufacturer: Broadcom
```

## Contribuções

Contribuções são bem vindas, sintam-se à vontade para abrir issues ou pull requests.

## Autor

[santanamobile](https://www.github.com/santanamobile)

## License

[MIT](https://choosealicense.com/licenses/mit/)
