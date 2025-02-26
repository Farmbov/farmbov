import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const String privacyPolicy = """
**Política de Privacidade**

Esta política de privacidade se aplica ao aplicativo Farmbov (doravante referido como "Aplicativo") para dispositivos móveis, criado pela Farmbov (doravante referido como "Provedor de Serviços") como um serviço Freemium. Este serviço é destinado ao uso "COMO ESTÁ".

**Coleta e Uso de Informações**

O Aplicativo coleta informações quando você o baixa e usa. Essas informações podem incluir:

* O endereço IP do seu dispositivo (por exemplo, endereço IP)
* As páginas do Aplicativo que você visita, a hora e a data da sua visita, o tempo gasto nessas páginas
* O tempo gasto no Aplicativo
* O sistema operacional que você usa em seu dispositivo móvel

O Aplicativo não coleta informações precisas sobre a localização do seu dispositivo móvel.

O Aplicativo coleta a localização do seu dispositivo, o que ajuda o Provedor de Serviços a determinar sua localização geográfica aproximada e utilizá-la nas seguintes maneiras:

* Serviços de Geolocalização: O Provedor de Serviços utiliza os dados de localização para fornecer recursos como conteúdo personalizado, recomendações relevantes e serviços baseados em localização.
* Análises e Melhorias: Dados de localização agregados e anonimizados ajudam o Provedor de Serviços a analisar o comportamento do usuário, identificar tendências e melhorar o desempenho e a funcionalidade geral do Aplicativo.
* Serviços de Terceiros: Periodicamente, o Provedor de Serviços pode transmitir dados de localização anonimizados para serviços externos. Esses serviços os auxiliam a aprimorar o Aplicativo e otimizar suas ofertas.

O Provedor de Serviços pode usar as informações que você forneceu para entrar em contato com você de tempos em tempos para fornecer informações importantes, avisos necessários e promoções de marketing.

Para uma melhor experiência ao usar o Aplicativo, o Provedor de Serviços pode exigir que você forneça certas informações pessoalmente identificáveis. As informações solicitadas pelo Provedor de Serviços serão retidas por eles e usadas conforme descrito nesta política de privacidade.

**Acesso de Terceiros**

Apenas dados agregados e anonimizados são periodicamente transmitidos a serviços externos para ajudar o Provedor de Serviços a melhorar o Aplicativo e seus serviços. O Provedor de Serviços pode compartilhar suas informações com terceiros nas formas descritas nesta declaração de privacidade.

Observe que o Aplicativo utiliza serviços de terceiros que possuem suas próprias Políticas de Privacidade sobre o tratamento de dados. Abaixo estão os links para a Política de Privacidade dos provedores de serviços de terceiros utilizados pelo Aplicativo:

* [Google Play Services](https://www.google.com/policies/privacy/)
* [Google Analytics for Firebase](https://firebase.google.com/support/privacy)
* [Firebase Crashlytics](https://firebase.google.com/support/privacy/)

O Provedor de Serviços pode divulgar Informações Fornecidas pelo Usuário e Informações Coletadas Automaticamente:

* conforme exigido por lei, como para cumprir uma intimação ou processo legal semelhante;
* quando acreditar de boa fé que a divulgação é necessária para proteger seus direitos, proteger sua segurança ou a segurança de terceiros, investigar fraudes ou responder a uma solicitação do governo;
* com seus provedores de serviços confiáveis que trabalham em seu nome, não têm um uso independente das informações que divulgamos a eles e concordaram em seguir as regras estabelecidas nesta declaração de privacidade.

**Direitos de Exclusão**

Você pode interromper toda a coleta de informações pelo Aplicativo facilmente desinstalando-o. Você pode usar os processos padrão de desinstalação que podem estar disponíveis como parte do seu dispositivo móvel ou via mercado de aplicativos móveis ou rede.

**Política de Retenção de Dados**

O Provedor de Serviços reterá os dados fornecidos pelo usuário enquanto você usar o Aplicativo e por um período razoável após isso. Se você gostaria que eles excluíssem os Dados Fornecidos pelo Usuário que você forneceu via Aplicativo, entre em contato pelo e-mail contato@farmbov.com e eles responderão em um tempo razoável.

**Crianças**

O Provedor de Serviços não usa o Aplicativo para solicitar dados ou fazer marketing de forma consciente a crianças menores de 13 anos.

O Aplicativo não é destinado a menores de 13 anos. O Provedor de Serviços não coleta intencionalmente informações pessoalmente identificáveis de crianças com menos de 13 anos de idade. Caso o Provedor de Serviços descubra que uma criança menor de 13 anos forneceu informações pessoais, o Provedor de Serviços as excluirá imediatamente de seus servidores. Se você for pai ou responsável e estiver ciente de que seu filho nos forneceu informações pessoais, entre em contato com o Provedor de Serviços (contato@farmbov.com) para que eles possam tomar as medidas necessárias.

**Segurança**

O Provedor de Serviços está preocupado com a proteção da confidencialidade de suas informações. O Provedor de Serviços fornece proteções físicas, eletrônicas e processuais para proteger as informações que processa e mantém.

**Alterações**

Esta Política de Privacidade pode ser atualizada periodicamente por qualquer motivo. O Provedor de Serviços notificará você sobre quaisquer alterações na Política de Privacidade atualizando esta página com a nova Política de Privacidade. Você é aconselhado a consultar esta Política de Privacidade regularmente para verificar qualquer alteração, pois o uso contínuo é considerado como aprovação de todas as alterações.

Esta política de privacidade é eficaz a partir de 21 de agosto de 2024.

**Seu Consentimento**

Ao usar o Aplicativo, você concorda com o processamento de suas informações conforme estabelecido nesta Política de Privacidade, agora e conforme alterado por nós.

**Contate-Nos**

Se você tiver alguma dúvida sobre privacidade ao usar o Aplicativo, ou tiver perguntas sobre as práticas, entre em contato com o Provedor de Serviços via e-mail em contato@farmbov.com.

---

Esta página de política de privacidade foi gerada pelo [App Privacy Policy Generator](https://app-privacy-policy-generator.nisrulz.com/)
""";

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Política de Privacidade',style: TextStyle(color: Colors.white),),
          
        ),
        body: Markdown(
          data: privacyPolicy,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      );
}
