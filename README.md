# Farmbov

### _Farmbov permite aos produtores rurais gerenciar suas fazendas e animais de forma simples e intuitiva._

## ▶️ Run (depurar)

Para rodar o projeto basta pressionar F5 no VS Code que serão utilizadas as configurações padrões do arquivo **.vscode/launch.json**.
Ou rode por linha de comando, selecionando o ambiente desejado.

```sh
flutter run meu_emulador_2024 --release (ou --debug)
```

- _-t (target)_
  - main_dev.dart, main_uat.dart ou main.dart.
- _-d (device)_
  - ID do dispositivo é opcional, utilize `flutter devices` para ver as opções disponíveis.

## Build - Passos Iniciais

1. `flutter clean`
2. `flutter pub get`
3. `flutter gen-l10n`(para gerar a internacionalização do app)

## Build - Web

Para buildar o projeto no navegador, execute o seguinte comando:

```sh
 flutter build web --release --no-tree-shake-icons -t lib/src/app/prod.dart
```

## 🤖 Build - Android

O build do Android deve ser feito utilizando _APPBUNDLE_, ao invés do tradicional _APK_. Esta nova tecnologia permite dentre outras coisas, a minificação do aplicativo final. Utilize o seguinte comando:

```sh
flutter build appbundle --flavor prod --release -t lib/src/app/prod.dart
```
```sh
flutter build apk --flavor dev --release -t lib/src/app/prod.dart       
```

Com o argumento --obfuscate é possível dificultar engenharia reversa (Exemplo no formato appbundle e flavor prod):
```sh
flutter build appbundle --flavor prod --release -t lib/src/app/prod.dart --obfuscate --split-debug-info=build/debug-info/
```
> Certifique-se sempre de limpar os builds anteriores com o comando `flutter clean`

A chave JKS para publicação na loja está localizada na pasta /.keys/key.jks.

> Senha da chave JKS: Chave ainda não definida.

## 🍏 Build - iOS

No terminal do VSCode (ou qualquer terminal na pasta), execute os seguintes comandos para gerar o projeto que será aberto no XCode.


> `flutter build ios -t lib/envs/main.dart --release`

Feito isso, abra o arquivo "Runner.xcworkspace" da pasta lib/ios (abrirá o XCode) e execute os seguintes passos:

4. Abra o projeto Runner e verifique se o número da versão e do build são maiores que o da última versão da loja (incrementa de 1 em 1).
5. Selecione **"GENERIC DEVICE"** nas opções de build.
6. No Menu, **PRODUCT** > **ARCHIVE**.
7. Ao final, **DISTRIBUTE APP**.
8. Siga os passos de publicação e conexão da loja que devem ser automáticos em todas as etapas.


## Firebase

### Deploy
firebase deploy -P prod

firebase deploy -P dev

* É possível utilizar o argumento (--only hosting) para poder atulizar apenas a implementação nova do app e não outras coisas como os indices do firestore. Exemplo:

firebase deploy -P dev --only hosting

### Pegar indexes do banco em JSON
firebase firestore:indexes

## Como adiciona novos ícones?

TODO: passar acesso do iconmoon e do figma
#
