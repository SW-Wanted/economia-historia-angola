import 'package:flutter/material.dart';

import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const faqs = ['O conteudo e gratuito?', 'Quem escreve os textos?', 'Como posso contribuir?', 'Como funciona o Jindungo?'];
    return ScreenFrame(title: 'Central de Ajuda', showBack: true, children: [
      const TextField(decoration: InputDecoration(hintText: 'Pesquisar ajuda', prefixIcon: Icon(Icons.search))),
      const SizedBox(height: 18),
      for (final faq in faqs) ...[EhCard(child: Row(children: [Expanded(child: Text(faq)), const Icon(Icons.expand_more)])), const SizedBox(height: 10)],
    ]);
  }
}
