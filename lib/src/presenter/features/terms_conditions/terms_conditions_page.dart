import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const String termsConditions = """
**Termos e Condições**

Estes termos e condições se aplicam ao aplicativo Farmbov (doravante referido como "Aplicativo") para dispositivos móveis, criado pela Farmbov (doravante referido como "Provedor de Serviços") como um serviço Freemium.

Ao baixar ou utilizar o Aplicativo, você está automaticamente concordando com os seguintes termos. É fortemente recomendado que você leia e compreenda estes termos antes de usar o Aplicativo. A cópia não autorizada, modificação do Aplicativo, qualquer parte do Aplicativo ou de nossas marcas registradas é estritamente proibida. Tentativas de extrair o código-fonte do Aplicativo, traduzir o Aplicativo para outros idiomas ou criar versões derivadas não são permitidas. Todas as marcas registradas, direitos autorais, direitos sobre bancos de dados e outros direitos de propriedade intelectual relacionados ao Aplicativo permanecem sendo propriedade do Provedor de Serviços.

O Provedor de Serviços se dedica a garantir que o Aplicativo seja o mais útil e eficiente possível. Assim, eles se reservam o direito de modificar o Aplicativo ou cobrar pelos seus serviços a qualquer momento e por qualquer motivo. O Provedor de Serviços assegura que quaisquer cobranças pelo Aplicativo ou seus serviços serão claramente comunicadas a você.

O Aplicativo armazena e processa dados pessoais que você forneceu ao Provedor de Serviços para que o Serviço seja oferecido. É sua responsabilidade manter a segurança do seu telefone e o acesso ao Aplicativo. O Provedor de Serviços recomenda fortemente que você não faça jailbreak ou root no seu telefone, o que envolve a remoção de restrições e limitações de software impostas pelo sistema operacional oficial do seu dispositivo. Essas ações podem expor seu telefone a malware, vírus, programas maliciosos, comprometer os recursos de segurança do seu telefone e podem resultar no funcionamento incorreto ou total falha do Aplicativo.

Observe que o Aplicativo utiliza serviços de terceiros que possuem seus próprios Termos e Condições. Abaixo estão os links para os Termos e Condições dos provedores de serviços de terceiros utilizados pelo Aplicativo:

* [Google Play Services](https://policies.google.com/terms)
* [Google Analytics for Firebase](https://www.google.com/analytics/terms/)
* [Firebase Crashlytics](https://firebase.google.com/terms/crashlytics)

Por favor, esteja ciente de que o Provedor de Serviços não assume responsabilidade por certos aspectos. Algumas funções do Aplicativo requerem uma conexão ativa com a internet, que pode ser via Wi-Fi ou fornecida pelo seu provedor de rede móvel. O Provedor de Serviços não pode ser responsabilizado se o Aplicativo não funcionar em sua totalidade devido à falta de acesso ao Wi-Fi ou se você tiver esgotado sua franquia de dados.

Se você estiver usando o aplicativo fora de uma área com Wi-Fi, por favor, esteja ciente de que os termos do seu contrato com seu provedor de rede móvel ainda se aplicam. Consequentemente, você pode incorrer em cobranças do seu provedor de rede móvel pelo uso de dados enquanto estiver conectado ao aplicativo, ou outras cobranças de terceiros. Ao usar o aplicativo, você aceita a responsabilidade por quaisquer dessas cobranças, incluindo as de roaming de dados, se você usar o aplicativo fora do seu território de origem (ou seja, região ou país) sem desativar o roaming de dados. Se você não for o pagador da conta do dispositivo em que está usando o aplicativo, presume-se que você obteve permissão do pagador da conta.

Da mesma forma, o Provedor de Serviços não pode sempre assumir responsabilidade pelo uso que você faz do aplicativo. Por exemplo, é sua responsabilidade garantir que seu dispositivo permaneça carregado. Se o seu dispositivo ficar sem bateria e você não conseguir acessar o Serviço, o Provedor de Serviços não pode ser responsabilizado.

No que diz respeito à responsabilidade do Provedor de Serviços pelo uso que você faz do aplicativo, é importante notar que, embora eles se esforcem para garantir que ele esteja sempre atualizado e preciso, eles dependem de terceiros para fornecer informações para que possam disponibilizá-las a você. O Provedor de Serviços não aceita responsabilidade por qualquer perda, direta ou indireta, que você experimente como resultado de confiar inteiramente nesta funcionalidade do aplicativo.

O Provedor de Serviços pode desejar atualizar o aplicativo em algum momento. O aplicativo está atualmente disponível conforme os requisitos para o sistema operacional (e para quaisquer sistemas adicionais que eles decidam estender a disponibilidade do aplicativo) podem mudar, e você precisará baixar as atualizações se quiser continuar usando o aplicativo. O Provedor de Serviços não garante que sempre atualizará o aplicativo para que seja relevante para você e/ou compatível com a versão particular do sistema operacional instalada em seu dispositivo. No entanto, você concorda em sempre aceitar as atualizações do aplicativo quando forem oferecidas a você. O Provedor de Serviços também pode desejar deixar de fornecer o aplicativo e pode encerrar o seu uso a qualquer momento sem fornecer aviso de rescisão. A menos que eles informem o contrário, após qualquer rescisão, (a) os direitos e licenças concedidos a você nestes termos serão encerrados; (b) você deve cessar o uso do aplicativo e (se necessário) excluí-lo do seu dispositivo.

**Alterações a Estes Termos e Condições**

O Provedor de Serviços pode atualizar periodicamente seus Termos e Condições. Portanto, você é aconselhado a revisar esta página regularmente para verificar quaisquer mudanças. O Provedor de Serviços notificará você sobre quaisquer alterações publicando os novos Termos e Condições nesta página.

Estes termos e condições são eficazes a partir de 21 de agosto de 2024.

**Contate-Nos**

Se você tiver alguma dúvida ou sugestão sobre os Termos e Condições, por favor, não hesite em contatar o Provedor de Serviços em contato@farmbov.com .

---

Esta página de Termos e Condições foi gerada pelo [App Privacy Policy Generator](https://app-privacy-policy-generator.nisrulz.com/)
""";

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text('Termos e Condições',style: TextStyle(color: Colors.white),),
        ),
        body: Markdown(
          data: termsConditions,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      );
}
