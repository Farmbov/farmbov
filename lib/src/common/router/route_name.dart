class RouteName {
  static const String root = '/';
  static const String welcome = 'bem-vindo';
  static const String settings = '/configuracoes';
  static const String notifications = '/notificacoes';

  static const String privacyPolicy = '/politica-privacidade';
  static const String termsConditions = '/termos-condicoes';
  static const String deleteAccount = '/exclusao-conta';

  static const String signin = 'entrar';
  static const String signup = 'cadastro';
  static const String resetPassword = 'redefinir-senha';
  static const String account = '/conta';
  static const String faq = '/faq';

  static const String home = '/inicio';
  static const String startTutorial = '$home/começar';

  static const String reports = '/relatorios';
  static const String animalsDown = 'relatorio-baixa-animais';
  static const String animalsInventory = 'relatorio-inventario-animais';
  static const String animalsHandling = 'relatorio-manejo-animais';
  static const String reportAnimalsHandling = '$reports/$animalsHandling';
  static const String dashboard = '/dashboard';
  static const String areas = '/areas';
  static const String lots = '/lotes';

  static const String animals = '/animais';
  static const String animalsImport = '$animals/importar';

  static const String animalCreate = '$animals/cadastrar';
  static const String animalUpdate = '$animals/editar/$genericId';
  static const String animalDown = '$animals/baixa';
  static const String animalDownId = '$animals/baixa/$genericId';
  static const String animalVisualize = '$animals/visualizar';

  static const String animalHandlings = '$animals/manejos';
  static const String animalWeighingHandling = '$animals/manejos/pesagem/novo';
  static const String animalVaccineHandling = '$animals/manejos/sanitario/novo';
  static const String animalReproductionHandling = '$animals/manejos/reprodutivo/novo';
  
  static const String animalHandlingCreate = '$animalHandlings/$genericCreate';
  static const String animalHandlingUpdate = '$animalHandlings/$genericId';

  static const String animalBreeds = 'racas';
  static const String animalBreedCreate = '$animalBreeds/$genericCreate';
  static const String animalBreedUpdate = '$animalBreeds/$genericId';

  static const String animalDownReasons = 'motivos-baixa';

  static const String farms = '/fazendas';
  static const String farmCreate = '$home/nova-fazenda';
  static const String farmUpdate = '$home/editar-fazenda';
  static const String farmSharedUsers = '$farms/compartilhados';

  static const String vaccines = '/vacinas';
  static const String vaccineCreate = '$vaccines/$genericCreate';
  static const String vaccineUpdate = '$vaccines/$genericId';
  static const String vaccineApplyLot = 'aplicar-lote';
  static const String vaccineLot = '$vaccines/$vaccineApplyLot';

  static const String vaccineBatches = 'lotes';
  static const String vaccineListBatches =
      '$vaccines/$genericId/$vaccineBatches';

  static const String vaccinesConfiguration = 'vacinas';

  static const String drugAdministrationTypes = 'vias-de-administracao';

  static const String lotsVisualize = '$lots/visualizar';

  static const String underMaintenance = '/em-manutencao';
  static const String genericVisualize = 'visualizar';
  static const String genericCreate = 'novo';
  static const String genericId = ':id';
}
