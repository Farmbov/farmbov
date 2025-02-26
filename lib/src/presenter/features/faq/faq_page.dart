import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../common/themes/theme_constants.dart';
import '../../shared/components/generic_page_content.dart';


class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FaqItem> faqList = [
      FaqItem(
        question: 'O aplicativo está em desenvolvimento?',
        answer:
            'Sim, o aplicativo ainda está em desenvolvimento. Novas funcionalidades e melhorias estão sendo implementadas continuamente para oferecer a melhor experiência possível.',
      ),
      FaqItem(
        question: 'Como posso cadastrar animais?',
        answer:
            '''Existem duas formas de cadastrar animais:
1. Na tela inicial, utilize o botão "+ Cadastrar Animais".
2. Acesse a seção "Meus Animais" que abrirá a Dashboard de Animais. Lá, pressione "Ver todos" para acessar a lista completa, onde você encontrará também o botão "+ Cadastrar Animais". Nesta tela, é possível cadastrar animais individualmente ou em lote.''',
      ),
      FaqItem(
        question: 'Onde posso alterar as configurações da conta?',
        answer:
            'Para alterar as configurações da conta, procure o ícone de pessoa (se não houver foto de perfil) ou clique na sua foto de perfil. Isso abrirá a tela com os dados da sua conta para edição.',
      ),
      FaqItem(
        question: 'O que posso fazer na seção Configurações?',
        answer:
            '''A seção Configurações pode ser acessada de duas formas:
1. No menu lateral (disponível em telas grandes como tablets e notebooks).
2. Na seção de fazendas:
   - Em telas grandes: pelo menu lateral.
   - Em telas pequenas: pelo último item do Bottom Navigation Bar.

Em cada fazenda cadastrada, você encontrará 4 botões no menu:
- O terceiro botão, um menu flutuante, exibe a opção Configurações como o primeiro item. Nesta seção, você pode personalizar sua fazenda: configurar raças dos animais, vacinas, vias de administração, motivos de baixa e muito mais no futuro.''',
      ),
      FaqItem(
        question: 'Como acessar as Áreas e Lotes?',
        answer:
            '''Para acessar as Áreas e Lotes em dispositivos móveis, acesse a tela de fazendas pelo menu de navegação na parte inferior da tela.
      - Em cada fazenda cadastrada, você encontrará 4 botões no menu, o terceiro botão, um menu flutuante, exibe as opções de Áreas e Lotes.
      - Em dispositivos maiores, é possível acessar pelo menu lateral.''',
      ),
      FaqItem(
        question: 'Como aplicar vacina em um animal?',
        answer:
            '''Existem duas formas de aplicar vacinas:

1. Vacinação em lote:
   - Em telas grandes: Acesse o submenu "Vacinação em Lote" dentro da seção Vacinas no menu lateral.
   - Em telas pequenas: Use o botão "+ Aplicar Vacina" na tela de Vacinas.

2. Vacinação individual:
   - Acesse a tela do animal: Vá em "Meus Animais" -> Dashboard de Animais -> Lista de animais.
   - Utilize a busca pelo brinco do animal para acesso direto.
   - Na tela do animal, role até a seção de manejos, escolha "Manejo Sanitário" e pressione "+ Adicionar Manejo Sanitário" para preencher os dados.''',
      ),
    ];

    return GenericPageContent(
      title: 'Perguntas Frequentes',
      titlePadding: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      useGridRows: false,
      showBackButton: ResponsiveBreakpoints.of(context).isMobile,
      childrenMainAxisAlignment: MainAxisAlignment.start,
      childrenCrossAxisAlignment: CrossAxisAlignment.stretch,
      children: faqList.map((faq) {
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          
          child: ExpansionTile(
            iconColor: AppColors.primaryGreenDark,
            collapsedIconColor: AppColors.primaryGreen,
            title: Text(
              faq.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            expandedAlignment: Alignment.topLeft,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                child: Text(
                  faq.answer,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    required this.question,
    required this.answer,
  });
}
