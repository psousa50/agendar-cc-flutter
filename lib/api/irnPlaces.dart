import 'dart:convert';

import 'package:agendar_cc_flutter/models.dart';

var irnPlacesString = '''
[
  {
    "_id": "Conservatória do Registo Predial de Matosinhos",
    "address": "Rua Alfredo da Cunha, 264 - 4º",
    "countyId": 9,
    "districtId": 15,
    "name": "Conservatória do Registo Predial de Matosinhos",
    "phone": "229399944",
    "postalCode": "4450-021",
    "gpsLocation": {
      "latitude": 41.18484180000001,
      "longitude": -8.680864099999999
    }
  },
  {
    "_id": "Espaço Registos Bragança",
    "address": "Rua dos Combatentes da Grande Guerra, nº 64",
    "countyId": 24,
    "districtId": 5,
    "name": "Espaço Registos Bragança",
    "phone": "273300960",
    "postalCode": "5300-113",
    "gpsLocation": {
      "latitude": 41.8055448,
      "longitude": -6.7537231
    }
  },
  {
    "_id": "CRCPCom Arruda dos Vinhos / Conservatória do Registo Civil, Predial e Comercial de Arruda dos Vinhos",
    "address": "Rua Heliodoro Salgado, n.º 18",
    "countyId": 43,
    "districtId": 12,
    "name": "CRCPCom Arruda dos Vinhos / Conservatória do Registo Civil, Predial e Comercial de Arruda dos Vinhos",
    "phone": "263977430",
    "postalCode": "2630-242",
    "gpsLocation": {
      "latitude": 38.9836689,
      "longitude": -9.0771184
    }
  },
  {
    "_id": "Loja do Cidadão de Penafiel",
    "address": "Rua Joaquim Araújo",
    "countyId": 12,
    "districtId": 15,
    "name": "Loja do Cidadão de Penafiel",
    "phone": "255718014",
    "postalCode": "4560-467",
    "gpsLocation": {
      "latitude": 41.2055443,
      "longitude": -8.286227100000001
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Beja",
    "address": "Praça do Ultramar, nº 1-A, Loja E",
    "countyId": 29,
    "districtId": 3,
    "name": "Conservatória do Registo Civil de Beja",
    "phone": "284311640",
    "postalCode": "7800-429",
    "gpsLocation": {
      "latitude": 38.010926,
      "longitude": -7.865569699999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil Predial Comercial e Automóvel da Horta",
    "address": "Avenida 25 de Abril - Palácio da Justiça",
    "countyId": 38,
    "districtId": 1,
    "name": "Conservatória do Registo Civil Predial Comercial e Automóvel da Horta",
    "phone": "292292375",
    "postalCode": "9901-851",
    "gpsLocation": {
      "latitude": 38.5348447,
      "longitude": -28.6299812
    }
  },
  {
    "_id": "Posto de Atendimento - Registos - de Portalegre",
    "address": "Rua Dr. Mário Chambel, Bloco 3, RC",
    "countyId": 19,
    "districtId": 14,
    "name": "Posto de Atendimento - Registos - de Portalegre",
    "phone": "245203204",
    "postalCode": "7300-179",
    "gpsLocation": {
      "latitude": 39.2990906,
      "longitude": -7.428488099999999
    }
  },
  {
    "_id": "2ª Conservatória do Registo Predial de Oeiras",
    "address": "Avenida D. João I, Nº 16, 1º Piso-B",
    "countyId": 11,
    "districtId": 12,
    "name": "2ª Conservatória do Registo Predial de Oeiras",
    "phone": "214405760",
    "postalCode": "2780-065",
    "gpsLocation": {
      "latitude": 38.684168,
      "longitude": -9.3179471
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Ponta Delagada",
    "address": "Praça Gonçalo Velho, nº 12, 2º",
    "countyId": 33,
    "districtId": 1,
    "name": "Conservatória do Registo Civil de Ponta Delagada",
    "phone": "296302170",
    "postalCode": "9500-063",
    "gpsLocation": {
      "latitude": 37.7391292,
      "longitude": -25.6683861
    }
  },
  {
    "_id": "Conservatória do Registo Civil, Predial, Comercial e Automóvel de Alenquer",
    "address": "Av. 25 de Abril _ Palácio da Justiça",
    "countyId": 48,
    "districtId": 12,
    "name": "Conservatória do Registo Civil, Predial, Comercial e Automóvel de Alenquer",
    "phone": "263730650",
    "postalCode": "2580-367",
    "gpsLocation": {
      "latitude": 39.0507256,
      "longitude": -9.0044509
    }
  },
  {
    "_id": "Conservatória do Registo Predial do Barreiro",
    "address": "Avenida  Alfredo da Silva, nºs 84 e 86",
    "countyId": 3,
    "districtId": 17,
    "name": "Conservatória do Registo Predial do Barreiro",
    "phone": "212068670",
    "postalCode": "2830-302",
    "gpsLocation": {
      "latitude": 38.6613379,
      "longitude": -9.0770229
    }
  },
  {
    "_id": "Conservatória do Registo Civil, Predial, Comercial e Automóvel de Penafiel",
    "address": "Av. José Júlio, nº115 - 1º - Edif. TIAGUS",
    "countyId": 12,
    "districtId": 15,
    "name": "Conservatória do Registo Civil, Predial, Comercial e Automóvel de Penafiel",
    "phone": "255729670",
    "postalCode": "4560-547",
    "gpsLocation": {
      "latitude": 41.2001391,
      "longitude": -8.2891389
    }
  },
  {
    "_id": "Conservatória do Registo Civil, Predial, Comercial e Automóvel de Felgueiras",
    "address": "Av. Dr. José de Castro Leal Faria - Edifício Sucesso 2000 Lote 3 A/B e Lote A",
    "countyId": 6,
    "districtId": 15,
    "name": "Conservatória do Registo Civil, Predial, Comercial e Automóvel de Felgueiras",
    "phone": "255310460",
    "postalCode": "4610-104",
    "gpsLocation": {
      "latitude": 41.36686599999999,
      "longitude": -8.1987109
    }
  },
  {
    "_id": "Loja do Cidadão de Castelo Branco",
    "address": "Rua do Saibreiro, s/n",
    "countyId": 26,
    "districtId": 6,
    "name": "Loja do Cidadão de Castelo Branco",
    "phone": "272349061",
    "postalCode": "6000-197",
    "gpsLocation": {
      "latitude": 39.8234053,
      "longitude": -7.4897711
    }
  },
  {
    "_id": "Conservatória do Registo Civil, Predial e Comercial de Sobral de Monte Agraço",
    "address": "Av. Marquês do Pombal, n.º 41, 1.º",
    "countyId": 44,
    "districtId": 12,
    "name": "Conservatória do Registo Civil, Predial e Comercial de Sobral de Monte Agraço",
    "phone": "261940650",
    "postalCode": "2590-041",
    "gpsLocation": {
      "latitude": 39.0197534,
      "longitude": -9.152102
    }
  },
  {
    "_id": "Espaço Registos Guimarães",
    "address": "Rua da Ramada, nº 357",
    "countyId": 36,
    "districtId": 4,
    "name": "Espaço Registos Guimarães",
    "phone": "253421040",
    "postalCode": "4810-445",
    "gpsLocation": {
      "latitude": 41.4393211,
      "longitude": -8.2915365
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Santo Tirso",
    "address": "Avenida Sousa Cruz, 99 a 135",
    "countyId": 47,
    "districtId": 15,
    "name": "Conservatória do Registo Civil de Santo Tirso",
    "phone": "252850296",
    "postalCode": "4780-365",
    "gpsLocation": {
      "latitude": 41.3456602,
      "longitude": -8.4755178
    }
  },
  {
    "_id": "Gabinete de Identificação Civil da Loja do Cidadão da Madeira",
    "address": "Avenida Arriaga, Edifício Arriaga, n.º 42 A, Balcao n.º 24",
    "countyId": 37,
    "districtId": 13,
    "name": "Gabinete de Identificação Civil da Loja do Cidadão da Madeira",
    "phone": "291212203",
    "postalCode": "9000-064",
    "gpsLocation": {
      "latitude": 32.6470456,
      "longitude": -16.9123828
    }
  },
  {
    "_id": "1ª Conservatória do Registo Predial da Maia",
    "address": "Rua Augusto Martins, n.º 33, Sala 1, 1.º Andar",
    "countyId": 8,
    "districtId": 15,
    "name": "1ª Conservatória do Registo Predial da Maia",
    "phone": "229436280",
    "postalCode": "4470-146",
    "gpsLocation": {
      "latitude": 41.23137819999999,
      "longitude": -8.6215726
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Aveiro",
    "address": "Rua D. António José Cordeiro, Nº 26/28",
    "countyId": 18,
    "districtId": 2,
    "name": "Conservatória do Registo Civil de Aveiro",
    "phone": "234404450",
    "postalCode": "3800-003",
    "gpsLocation": {
      "latitude": 40.6399306,
      "longitude": -8.637916299999999
    }
  },
  {
    "_id": "Conservatória do Registo Predial e Comercial de Odivelas",
    "address": "Praceta Sacadura Cabral, 8 - B",
    "countyId": 10,
    "districtId": 12,
    "name": "Conservatória do Registo Predial e Comercial de Odivelas",
    "phone": "219345848",
    "postalCode": "2675-515",
    "gpsLocation": {
      "latitude": 38.7858594,
      "longitude": -9.1867509
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Viana do Castelo",
    "address": "Rua João Alves Cerqueira, 1º",
    "countyId": 22,
    "districtId": 18,
    "name": "Conservatória do Registo Civil de Viana do Castelo",
    "phone": "258800660",
    "postalCode": "4900-321",
    "gpsLocation": {
      "latitude": 41.6911634,
      "longitude": -8.8293149
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Angra do Heroísmo",
    "address": "Avenida Tenente Coronel José Agostinho, nº 2",
    "countyId": 32,
    "districtId": 1,
    "name": "Conservatória do Registo Civil de Angra do Heroísmo",
    "phone": "295402890",
    "postalCode": "9701-866",
    "gpsLocation": {
      "latitude": 38.6560873,
      "longitude": -27.2248889
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Vila Franca de Xira",
    "address": "Rua do Curado Edifício Planicie, nº 9 B",
    "countyId": 42,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Vila Franca de Xira",
    "phone": "263270640",
    "postalCode": "2600-133",
    "gpsLocation": {
      "latitude": 38.9564703,
      "longitude": -8.986597
    }
  },
  {
    "_id": "1ª Conservatória do Registo Predial e Comercial da Amadora",
    "address": "Rua Ernesto Melo Antunes, n.º 12 A, c/h",
    "countyId": 2,
    "districtId": 12,
    "name": "1ª Conservatória do Registo Predial e Comercial da Amadora",
    "phone": "214929410",
    "postalCode": "2700-002",
    "gpsLocation": {
      "latitude": 38.7595162,
      "longitude": -9.2379564
    }
  },
  {
    "_id": "Loja do Cidadão de Leira",
    "address": "Largo das Forças Armadas, 211",
    "countyId": 27,
    "districtId": 11,
    "name": "Loja do Cidadão de Leira",
    "phone": "244022000",
    "postalCode": "2400-143",
    "gpsLocation": {
      "latitude": 39.7452092,
      "longitude": -8.806718799999999
    }
  },
  {
    "_id": "Loja do Cidadão de Coimbra",
    "address": "Avenida Central, 16, 18 e 20",
    "countyId": 34,
    "districtId": 7,
    "name": "Loja do Cidadão de Coimbra",
    "phone": "239863392",
    "postalCode": "3000-206",
    "gpsLocation": {
      "latitude": 40.21036549999999,
      "longitude": -8.4312706
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Chaves",
    "address": "Rua Cândido dos Reis, Loja nº 35",
    "countyId": 35,
    "districtId": 19,
    "name": "Conservatória do Registo Civil de Chaves",
    "phone": "276301170",
    "postalCode": "5400-163",
    "gpsLocation": {
      "latitude": 41.741151,
      "longitude": -7.468471800000001
    }
  },
  {
    "_id": "Conservatória do Registo Civil e Automóvel de Loulé",
    "address": "Rua Drª. Laura Ayres, Palácoio da Justiça",
    "countyId": 30,
    "districtId": 9,
    "name": "Conservatória do Registo Civil e Automóvel de Loulé",
    "phone": "289410770",
    "postalCode": "8100-568",
    "gpsLocation": {
      "latitude": 37.13824779999999,
      "longitude": -8.0175489
    }
  },
  {
    "_id": "Espaço Registos Guarda",
    "address": "Avenida Bombeiros Voluntários Egitanienses, 5, Centro Comercial La Vie",
    "countyId": 20,
    "districtId": 10,
    "name": "Espaço Registos Guarda",
    "phone": "271205106",
    "postalCode": "6300-523",
    "gpsLocation": {
      "latitude": 40.54046150000001,
      "longitude": -7.266388200000001
    }
  },
  {
    "_id": "Espaço Registos Santarém",
    "address": "Rua Vasco da Gama, Lote 4, RC",
    "countyId": 21,
    "districtId": 16,
    "name": "Espaço Registos Santarém",
    "phone": "243377060",
    "postalCode": "2000-232",
    "gpsLocation": {
      "latitude": 39.2328536,
      "longitude": -8.684517
    }
  },
  {
    "_id": "Loja de Cidadão de Palmela (em Pinhal Novo)",
    "address": "Praça da Independência, Edifício do Mercado Municipal, Pinhal Novo",
    "countyId": 45,
    "districtId": 17,
    "name": "Loja de Cidadão de Palmela (em Pinhal Novo)",
    "phone": "210120011",
    "postalCode": "2955-999",
    "gpsLocation": {
      "latitude": 38.6312796,
      "longitude": -8.911758299999999
    }
  },
  {
    "_id": "Loja do Cidadão de Odivelas",
    "address": "Strada Shopping, loja 2048, Estrada da Paiã - Casal do Troca",
    "countyId": 10,
    "districtId": 12,
    "name": "Loja do Cidadão de Odivelas",
    "phone": "211526035",
    "postalCode": "2675-626",
    "gpsLocation": {
      "latitude": 38.7822701,
      "longitude": -9.192486599999999
    }
  },
  {
    "_id": "Gabinete de Identificação Civil na Loja do Cidadão de Aveiro",
    "address": "Rua Dr. Orlando de Oliveira, 41-47, Urb. Forca Vouga",
    "countyId": 18,
    "districtId": 2,
    "name": "Gabinete de Identificação Civil na Loja do Cidadão de Aveiro",
    "phone": "234405785",
    "postalCode": "3800-004",
    "gpsLocation": {
      "latitude": 40.6386988,
      "longitude": -8.639299099999999
    }
  },
  {
    "_id": "Espaço de Registos da Maia",
    "address": "Trav Adjacente à R. Dr. Augusto Martins, 42, r/c",
    "countyId": 8,
    "districtId": 15,
    "name": "Espaço de Registos da Maia",
    "phone": "229439800",
    "postalCode": "4470-145",
    "gpsLocation": {
      "latitude": 41.2316215,
      "longitude": -8.6219562
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Viseu",
    "address": "Rua Conselheiro Afonso de Melo, 31, 1º",
    "countyId": 25,
    "districtId": 20,
    "name": "Conservatória do Registo Civil de Viseu",
    "phone": "232484140",
    "postalCode": "3510-024",
    "gpsLocation": {
      "latitude": 40.6575263,
      "longitude": -7.914921099999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Amadora",
    "address": "Rua Ernesto Melo Antunes 12A c/h - Amadora",
    "countyId": 2,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Amadora",
    "phone": "214929410",
    "postalCode": "2700-002",
    "gpsLocation": {
      "latitude": 38.7609697,
      "longitude": -9.2373537
    }
  },
  {
    "_id": "2ª Conservatória do Registo Predial de Vila Franca de Xira (Alverca do Ribatejo)",
    "address": "Praceta do Edifício Parque, n.º 1 - Alverca do Ribatejo",
    "countyId": 42,
    "districtId": 12,
    "name": "2ª Conservatória do Registo Predial de Vila Franca de Xira (Alverca do Ribatejo)",
    "phone": "219575633",
    "postalCode": "2615-077",
    "gpsLocation": {
      "latitude": 38.89541759999999,
      "longitude": -9.0393575
    }
  },
  {
    "_id": "Loja do Cidadão de Viseu",
    "address": "R Eça de queiroz, lote 8-10",
    "countyId": 25,
    "districtId": 20,
    "name": "Loja do Cidadão de Viseu",
    "phone": "232484881",
    "postalCode": "3500-419",
    "gpsLocation": {
      "latitude": 40.6569478,
      "longitude": -7.8846078
    }
  },
  {
    "_id": "Conservatória do RegistoCivil de Palmela",
    "address": "Avª da Liberdade, lote 19, 1º",
    "countyId": 45,
    "districtId": 17,
    "name": "Conservatória do RegistoCivil de Palmela",
    "phone": "212337800",
    "postalCode": "2950-201",
    "gpsLocation": {
      "latitude": 38.632014,
      "longitude": -8.916142599999999
    }
  },
  {
    "_id": "Conservatória do Registo Predial de Loulé",
    "address": "Rua Drª Laura Ayres, Palácio da Justiça",
    "countyId": 30,
    "districtId": 9,
    "name": "Conservatória do Registo Predial de Loulé",
    "phone": "289410540",
    "postalCode": "8100-568",
    "gpsLocation": {
      "latitude": 37.13824779999999,
      "longitude": -8.0175489
    }
  },
  {
    "_id": "Espaço Cidadão UF São Martinho do Bispo e Ribeira de Frades",
    "address": "Rua Principal da Bencanta",
    "countyId": 34,
    "districtId": 7,
    "name": "Espaço Cidadão UF São Martinho do Bispo e Ribeira de Frades",
    "phone": "300003990",
    "postalCode": "3045-382",
    "gpsLocation": {
      "latitude": 40.2373066,
      "longitude": -8.491888699999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Santarém",
    "address": "Rua Dr. Ginestal Machado, 5",
    "countyId": 21,
    "districtId": 16,
    "name": "Conservatória do Registo Civil de Santarém",
    "phone": "243303340",
    "postalCode": "2000-175",
    "gpsLocation": {
      "latitude": 39.2352419,
      "longitude": -8.687703299999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil da Guarda",
    "address": "Rua Vasco da Gama, 4, r/c",
    "countyId": 20,
    "districtId": 10,
    "name": "Conservatória do Registo Civil da Guarda",
    "phone": "271210386",
    "postalCode": "6300-772",
    "gpsLocation": {
      "latitude": 40.5308408,
      "longitude": -7.2221421
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Évora",
    "address": "Avenida Lino de Carvalho, s/n,",
    "countyId": 28,
    "districtId": 8,
    "name": "Conservatória do Registo Civil de Évora",
    "phone": "266750400",
    "postalCode": "7005-467",
    "gpsLocation": {
      "latitude": 38.5780356,
      "longitude": -7.902343900000001
    }
  },
  {
    "_id": "Departamento de Identificação Civil do Porto",
    "address": "Rua Gonçalo Cristóvão, n.º. 373 –  Palacete dos Pestanas - Porto",
    "countyId": 13,
    "districtId": 15,
    "name": "Departamento de Identificação Civil do Porto",
    "phone": "221156600",
    "postalCode": "4000-270",
    "gpsLocation": {
      "latitude": 41.152076,
      "longitude": -8.6106325
    }
  },
  {
    "_id": "1ª Conservatoria do Registo Predial de Almada",
    "address": "Praça S. João Baptista, 4 F",
    "countyId": 1,
    "districtId": 17,
    "name": "1ª Conservatoria do Registo Predial de Almada",
    "phone": "212721250",
    "postalCode": "2800-199",
    "gpsLocation": {
      "latitude": 38.6789249,
      "longitude": -9.1579798
    }
  },
  {
    "_id": "Espaço de Registos de Ermesinde",
    "address": "Ed. Dr. Fernando Faria Sampaio, Rua Aldeia dos Lavradores, 240",
    "countyId": 40,
    "districtId": 15,
    "name": "Espaço de Registos de Ermesinde",
    "phone": "229722719",
    "postalCode": "4445-640",
    "gpsLocation": {
      "latitude": 41.2133704,
      "longitude": -8.546399700000002
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Coimbra",
    "address": "Av. Fernão Magalhães, 521",
    "countyId": 34,
    "districtId": 7,
    "name": "Conservatória do Registo Civil de Coimbra",
    "phone": "239854000",
    "postalCode": "3004-508",
    "gpsLocation": {
      "latitude": 40.2150751,
      "longitude": -8.4357586
    }
  },
  {
    "_id": "Loja do Cidadão de Faro",
    "address": "Largo Dr. Francisco Sá Carneiro, Edifício do Mercado Municipal, 1º Piso",
    "countyId": 31,
    "districtId": 9,
    "name": "Loja do Cidadão de Faro",
    "phone": "289106520",
    "postalCode": "8000-151",
    "gpsLocation": {
      "latitude": 37.020222,
      "longitude": -7.9288269
    }
  },
  {
    "_id": "Loja do Cidadão do Porto",
    "address": "Av. Fernão de Magalhães, 1862 - 1º",
    "countyId": 13,
    "districtId": 15,
    "name": "Loja do Cidadão do Porto",
    "phone": "225571887",
    "postalCode": "4350-158",
    "gpsLocation": {
      "latitude": 41.165363,
      "longitude": -8.588645699999999
    }
  },
  {
    "_id": "1ª Conservatória do Registo Civil do Porto",
    "address": "Rua de Ceuta, nº 16, 2º andar",
    "countyId": 13,
    "districtId": 15,
    "name": "1ª Conservatória do Registo Civil do Porto",
    "phone": "226052330",
    "postalCode": "4050-189",
    "gpsLocation": {
      "latitude": 41.1483729,
      "longitude": -8.6134048
    }
  },
  {
    "_id": "Loja do Cidadão de Vila Nova de Gaia",
    "address": "Centro Comercial Arrábida Shoping - R. Manuel Moreira de Barros e Praceta Henrique Moreira 244, Afurada, loja A nº 029",
    "countyId": 16,
    "districtId": 15,
    "name": "Loja do Cidadão de Vila Nova de Gaia",
    "phone": "223749010",
    "postalCode": "4400-346",
    "gpsLocation": {
      "latitude": 41.1414625,
      "longitude": -8.6364535
    }
  },
  {
    "_id": "Loja do Cidadão de Setúbal",
    "address": "Av. Bento Gonçalves, nº 30 D",
    "countyId": 14,
    "districtId": 17,
    "name": "Loja do Cidadão de Setúbal",
    "phone": "265550275",
    "postalCode": "2410-431",
    "gpsLocation": {
      "latitude": 38.5281239,
      "longitude": -8.882213799999999
    }
  },
  {
    "_id": "2ª Conservatória do Registo Civil do Porto",
    "address": "Av. de França, 358, loja 64, Edifício Capitólio,",
    "countyId": 13,
    "districtId": 15,
    "name": "2ª Conservatória do Registo Civil do Porto",
    "phone": "228348530",
    "postalCode": "4 050 27",
    "gpsLocation": {
      "latitude": 41.1607042,
      "longitude": -8.6271805
    }
  },
  {
    "_id": "Espaço de Registos de Valongo",
    "address": "Av. Emídio Navarro, 299/355",
    "countyId": 40,
    "districtId": 15,
    "name": "Espaço de Registos de Valongo",
    "phone": "224224617",
    "postalCode": "4440-649",
    "gpsLocation": {
      "latitude": 41.1927987,
      "longitude": -8.495198
    }
  },
  {
    "_id": "Conservatória do Registo Comercial do Porto",
    "address": "Rua Álvares Cabral, 116",
    "countyId": 13,
    "districtId": 15,
    "name": "Conservatória do Registo Comercial do Porto",
    "phone": "222007850",
    "postalCode": "4050-040",
    "gpsLocation": {
      "latitude": 41.1548992,
      "longitude": -8.617495000000002
    }
  },
  {
    "_id": "4ª Conservatória do Registo Civil do Porto",
    "address": "Rua do Cunha, n.º 404",
    "countyId": 13,
    "districtId": 15,
    "name": "4ª Conservatória do Registo Civil do Porto",
    "phone": "225088826",
    "postalCode": "4200-250",
    "gpsLocation": {
      "latitude": 41.166737,
      "longitude": -8.601648299999999
    }
  },
  {
    "_id": "Conservatória de Registo Predial do Porto",
    "address": "Rua Gonçalo Cristovão, 347, 1º piso, salas 107-111",
    "countyId": 13,
    "districtId": 15,
    "name": "Conservatória de Registo Predial do Porto",
    "phone": "223393790",
    "postalCode": "4000-270",
    "gpsLocation": {
      "latitude": 41.1535117,
      "longitude": -8.6112612
    }
  },
  {
    "_id": "3ª Conservatória do Registo Civil do Porto",
    "address": "Rua Álvares Cabral, 432",
    "countyId": 13,
    "districtId": 15,
    "name": "3ª Conservatória do Registo Civil do Porto",
    "phone": "223393200",
    "postalCode": "4050-040",
    "gpsLocation": {
      "latitude": 41.1542159,
      "longitude": -8.6138097
    }
  },
  {
    "_id": "1º Cartório Notarial de Competência Especializada de  Matosinhos",
    "address": "Estrada Nacional 107 km 3 - Edif.de Serviços da AEP (junto Exponor) - Leça da Palmeira",
    "countyId": 9,
    "districtId": 15,
    "name": "1º Cartório Notarial de Competência Especializada de  Matosinhos",
    "phone": "229956333",
    "postalCode": "4450-617",
    "gpsLocation": {
      "latitude": 41.2372715,
      "longitude": -8.626859699999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Matosinhos",
    "address": "Rua Alfredo Cunha, 264, 2º Dto",
    "countyId": 9,
    "districtId": 15,
    "name": "Conservatória do Registo Civil de Matosinhos",
    "phone": "229398140",
    "postalCode": "4450-021",
    "gpsLocation": {
      "latitude": 41.1847068,
      "longitude": -8.681080099999999
    }
  },
  {
    "_id": "Espaço Cidadão Canaviais",
    "address": "Praça José Joaquim Calado Piteira, nº 1",
    "countyId": 28,
    "districtId": 8,
    "name": "Espaço Cidadão Canaviais",
    "phone": "300003990",
    "postalCode": "7005-247",
    "gpsLocation": {
      "latitude": 38.6114755,
      "longitude": -7.903143600000001
    }
  },
  {
    "_id": "Loja do Cidadão de Braga",
    "address": "Rua dos Granjinhos, 6",
    "countyId": 4,
    "districtId": 4,
    "name": "Loja do Cidadão de Braga",
    "phone": "253205814",
    "postalCode": "4704-575",
    "gpsLocation": {
      "latitude": 41.5474961,
      "longitude": -8.421968999999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Braga",
    "address": "Av. Central, 33, 1º andar",
    "countyId": 4,
    "districtId": 4,
    "name": "Conservatória do Registo Civil de Braga",
    "phone": "253206710",
    "postalCode": "4710-228",
    "gpsLocation": {
      "latitude": 41.5528611,
      "longitude": -8.422706
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Setúbal",
    "address": "Av. Dr. António Rodrigues Manito, 80 e 86",
    "countyId": 14,
    "districtId": 17,
    "name": "Conservatória do Registo Civil de Setúbal",
    "phone": "265236016",
    "postalCode": "2900-062",
    "gpsLocation": {
      "latitude": 38.5403492,
      "longitude": -8.895126
    }
  },
  {
    "_id": "2ª Conservatória do Registo Predial Almada",
    "address": "Praça S.João Batista, 6-A",
    "countyId": 1,
    "districtId": 17,
    "name": "2ª Conservatória do Registo Predial Almada",
    "phone": "212738180",
    "postalCode": "2800-199",
    "gpsLocation": {
      "latitude": 38.6789281,
      "longitude": -9.158201499999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Almada",
    "address": "Praça São João Baptista, 6 B",
    "countyId": 1,
    "districtId": 17,
    "name": "Conservatória do Registo Civil de Almada",
    "phone": "212725710",
    "postalCode": "2800-199",
    "gpsLocation": {
      "latitude": 38.6789281,
      "longitude": -9.158201499999999
    }
  },
  {
    "_id": "2ª Conservatória do Registo Predial de Vila Nova de Gaia",
    "address": "Av.da República, 872- 1º - Sala 19",
    "countyId": 16,
    "districtId": 15,
    "name": "2ª Conservatória do Registo Predial de Vila Nova de Gaia",
    "phone": "223757773",
    "postalCode": "4430-190",
    "gpsLocation": {
      "latitude": 41.1307319,
      "longitude": -8.606851299999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Vila Nova de Gaia",
    "address": "Rua Conselheiro Veloso da Cruz, 801",
    "countyId": 16,
    "districtId": 15,
    "name": "Conservatória do Registo Civil de Vila Nova de Gaia",
    "phone": "223749080",
    "postalCode": "4400-096",
    "gpsLocation": {
      "latitude": 41.129188,
      "longitude": -8.6103667
    }
  },
  {
    "_id": "Loja do Cidadão das Laranjeiras",
    "address": "Rua Abranches Ferrão, 10 - piso 1 Edif. Atlanta",
    "countyId": 7,
    "districtId": 12,
    "name": "Loja do Cidadão das Laranjeiras",
    "phone": "217231299",
    "postalCode": "1600-001",
    "gpsLocation": {
      "latitude": 38.7511073,
      "longitude": -9.1712039
    }
  },
  {
    "_id": "Departamento de Identificação Civil de Marvila",
    "address": "Av Sto Condestável Centro Comercial Pingo Doce, Loja 34",
    "countyId": 7,
    "districtId": 12,
    "name": "Departamento de Identificação Civil de Marvila",
    "phone": "211987104",
    "postalCode": "1900-806",
    "gpsLocation": {
      "latitude": 38.7495622,
      "longitude": -9.116795900000001
    }
  },
  {
    "_id": "Departamento de Identificação Civil da Boa Hora - Lisboa",
    "address": "Rua Nova do Almada, 35",
    "countyId": 7,
    "districtId": 12,
    "name": "Departamento de Identificação Civil da Boa Hora - Lisboa",
    "phone": "215991100",
    "postalCode": "1200-288",
    "gpsLocation": {
      "latitude": 38.7095395,
      "longitude": -9.139184499999999
    }
  },
  {
    "_id": "Departamento de Identificação Civil Campus da Justiça",
    "address": "Av. D. João II, nº 1.8.01D, RC - Edificio J, Parque das Nações  Apartado 8295",
    "countyId": 7,
    "districtId": 12,
    "name": "Departamento de Identificação Civil Campus da Justiça",
    "phone": "211550426",
    "postalCode": "1990-097",
    "gpsLocation": {
      "latitude": 38.7747724,
      "longitude": -9.095922
    }
  },
  {
    "_id": "Registo Nacional de Pessoas Colectivas - Lisboa",
    "address": "Praça Silvestre Pinheiro Ferreira, 1 - C - Apartado 4064",
    "countyId": 7,
    "districtId": 12,
    "name": "Registo Nacional de Pessoas Colectivas - Lisboa",
    "phone": "217714300",
    "postalCode": "1501-803",
    "gpsLocation": {
      "latitude": 38.7433999,
      "longitude": -9.1761803
    }
  },
  {
    "_id": "Loja de Cidadão do Saldanha",
    "address": "Rua Eng. Vieira da Silva",
    "countyId": 7,
    "districtId": 12,
    "name": "Loja de Cidadão do Saldanha",
    "phone": "215853430",
    "postalCode": "1050-105",
    "gpsLocation": {
      "latitude": 38.7313091,
      "longitude": -9.1441749
    }
  },
  {
    "_id": "Espaço de Registos de Agualva Cacém",
    "address": "Edifício Municipal - Praceta Duque de Saldanha, 17",
    "countyId": 15,
    "districtId": 12,
    "name": "Espaço de Registos de Agualva Cacém",
    "phone": "214324390",
    "postalCode": "2735-330",
    "gpsLocation": {
      "latitude": 38.7691963,
      "longitude": -9.3049474
    }
  },
  {
    "_id": "Conservatória do Registo Predial de Queluz",
    "address": "Rua Prof. Vírgilio Machado, 12 A - Monte Abraão",
    "countyId": 15,
    "districtId": 12,
    "name": "Conservatória do Registo Predial de Queluz",
    "phone": "214398340",
    "postalCode": "2745-342",
    "gpsLocation": {
      "latitude": 38.7568345,
      "longitude": -9.265496
    }
  },
  {
    "_id": "Centro de Entregas do Areeiro",
    "address": "Praça Francisco Sá Carneiro, nº 13 - C",
    "countyId": 7,
    "districtId": 12,
    "name": "Centro de Entregas do Areeiro",
    "phone": "218438050",
    "postalCode": "1000-160",
    "gpsLocation": {
      "latitude": 38.7417417,
      "longitude": -9.132766199999999
    }
  },
  {
    "_id": "Conservatória do Registo Comercial de Sintra",
    "address": "Rua Dr. Alfredo da Costa, nº 32-34",
    "countyId": 15,
    "districtId": 12,
    "name": "Conservatória do Registo Comercial de Sintra",
    "phone": "219104680",
    "postalCode": "2710-523",
    "gpsLocation": {
      "latitude": 38.7990907,
      "longitude": -9.386502199999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Mafra",
    "address": "Av. 25 de Abril, Palácio da Justiça",
    "countyId": 41,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Mafra",
    "phone": "261817450",
    "postalCode": "2640-456",
    "gpsLocation": {
      "latitude": 38.9395063,
      "longitude": -9.328254399999999
    }
  },
  {
    "_id": "Conservatória do Registo Predial e Comercial de Mafra",
    "address": "Avenida 25 de Abril, Palácio da Justiça",
    "countyId": 41,
    "districtId": 12,
    "name": "Conservatória do Registo Predial e Comercial de Mafra",
    "phone": "261817400",
    "postalCode": "2640-456",
    "gpsLocation": {
      "latitude": 38.9395063,
      "longitude": -9.328254399999999
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Cascais",
    "address": "Palácio da Justiça - Rua Jayme Thompson",
    "countyId": 5,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Cascais",
    "phone": "214812090",
    "postalCode": "2750-378",
    "gpsLocation": {
      "latitude": 38.70095510000001,
      "longitude": -9.4283102
    }
  },
  {
    "_id": "Centro de Entregas Agualva-Cacém",
    "address": "Rua Carlos Charbel, Centro Lúdico",
    "countyId": 15,
    "districtId": 12,
    "name": "Centro de Entregas Agualva-Cacém",
    "phone": "",
    "postalCode": "2735-018",
    "gpsLocation": {
      "latitude": 38.7768498,
      "longitude": -9.2956232
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Oeiras",
    "address": "Avenida D. João I, 16, R/C",
    "countyId": 11,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Oeiras",
    "phone": "214544770",
    "postalCode": "2784-508",
    "gpsLocation": {
      "latitude": 38.684168,
      "longitude": -9.3179471
    }
  },
  {
    "_id": "2ª Conservatória do Registo Predial de Sintra",
    "address": "Rua Dr Câmara Pestana, 25 A",
    "countyId": 15,
    "districtId": 12,
    "name": "2ª Conservatória do Registo Predial de Sintra",
    "phone": "219249780",
    "postalCode": "2710-546",
    "gpsLocation": {
      "latitude": 38.8028312,
      "longitude": -9.3830423
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Queluz",
    "address": "Avenida Miguel Bombarda, nº 33",
    "countyId": 15,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Queluz",
    "phone": "214344910",
    "postalCode": "2745-175",
    "gpsLocation": {
      "latitude": 38.7601861,
      "longitude": -9.2573166
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Sintra",
    "address": "Av. Heliodoro Salgado 59",
    "countyId": 15,
    "districtId": 12,
    "name": "Conservatória do Registo Civil de Sintra",
    "phone": "219239211",
    "postalCode": "2714-558",
    "gpsLocation": {
      "latitude": 38.8027304,
      "longitude": -9.3818355
    }
  },
  {
    "_id": "Conservatória do Registo Civil do Barreiro",
    "address": "Avª Santa Maria, Palácio Justiça",
    "countyId": 3,
    "districtId": 17,
    "name": "Conservatória do Registo Civil do Barreiro",
    "phone": "212149330",
    "postalCode": "2830-007",
    "gpsLocation": {
      "latitude": 38.6608149,
      "longitude": -9.0790724
    }
  },
  {
    "_id": "Conservatória do Registo Civil de Ponta Delgada",
    "address": "Praça Gonçalo Velho, nº 12, 2º",
    "countyId": 33,
    "districtId": 1,
    "name": "Conservatória do Registo Civil de Ponta Delgada",
    "phone": "296302170",
    "postalCode": "9500-063",
    "gpsLocation": {
      "latitude": 37.7391292,
      "longitude": -25.6683861
    }
  },
  {
    "_id": "Conservatória Registo Civil de Faro",
    "address": "Av. 5 de Outubro, 25-27 - Faro",
    "countyId": 31,
    "districtId": 9,
    "name": "Conservatória Registo Civil de Faro",
    "phone": "289804625",
    "postalCode": "8000-077",
    "gpsLocation": {
      "latitude": 37.0177883,
      "longitude": -7.9268283
    }
  },
  {
    "_id": "Loja do Cidadão de Leiria",
    "address": "Largo das Forças Armadas, 211",
    "countyId": 27,
    "districtId": 11,
    "name": "Loja do Cidadão de Leiria",
    "phone": "244022000",
    "postalCode": "2400-143",
    "gpsLocation": {
      "latitude": 39.7452414,
      "longitude": -8.806813
    }
  },
  {
    "_id": "Centro de Entregas Fontes Pereira de Melo",
    "address": "Avenida Fontes Pereira de Melo, n.ºs 7 a 11, Piso - 1 , Apartado 12118",
    "countyId": 7,
    "districtId": 12,
    "name": "Centro de Entregas Fontes Pereira de Melo",
    "phone": "218438050",
    "postalCode": "1050-115",
    "gpsLocation": {
      "latitude": 38.7303248,
      "longitude": -9.1469912
    }
  },
  {
    "_id": "Espaço Registos de Ermesinde",
    "address": "Ed. Dr. Fernando Faria Sampaio, Rua Aldeia dos Lavradores, 240",
    "countyId": 40,
    "districtId": 15,
    "name": "Espaço Registos de Ermesinde",
    "phone": "229722719",
    "postalCode": "4445-640",
    "gpsLocation": {
      "latitude": 41.2142898,
      "longitude": -8.5458407
    }
  },
  {
    "_id": "Espaço Registos da Maia",
    "address": "Trav Adjacente à R. Dr. Augusto Martins, 42, r/c",
    "countyId": 8,
    "districtId": 15,
    "name": "Espaço Registos da Maia",
    "phone": "229439800",
    "postalCode": "4470-145",
    "gpsLocation": {
      "latitude": 41.2316215,
      "longitude": -8.6219562
    }
  },
  {
    "_id": "Espaço Registos de Valongo",
    "address": "Av. Emídio Navarro, 299/355",
    "countyId": 40,
    "districtId": 15,
    "name": "Espaço Registos de Valongo",
    "phone": "224224617",
    "postalCode": "4440-649",
    "gpsLocation": {
      "latitude": 41.1927987,
      "longitude": -8.495198
    }
  },
  {
    "_id": "Espaço Registos de Agualva Cacém",
    "address": "Edifício Municipal - Praceta Duque de Saldanha, 17",
    "countyId": 15,
    "districtId": 12,
    "name": "Espaço Registos de Agualva Cacém",
    "phone": "214324390",
    "postalCode": "2735-330",
    "gpsLocation": {
      "latitude": 38.7691963,
      "longitude": -9.3049474
    }
  },
  {
    "_id": "Conservatória Registo Civil, Predial e Comercial de Arruda dos Vinhos",
    "address": "Rua Heliodoro Salgado, n.º 18",
    "countyId": 43,
    "districtId": 12,
    "name": "Conservatória Registo Civil, Predial e Comercial de Arruda dos Vinhos",
    "phone": "263977430",
    "postalCode": "2630-242",
    "gpsLocation": {
      "latitude": 38.9836904,
      "longitude": -9.0771727
    }
  },
  {
    "_id": "Conservatória Registo Civil Amadora",
    "address": "Rua Ernesto Melo Antunes 12A c/h - Amadora",
    "countyId": 2,
    "districtId": 12,
    "name": "Conservatória Registo Civil Amadora",
    "phone": "214929410",
    "postalCode": "2700-002",
    "gpsLocation": {
      "latitude": 38.7607599,
      "longitude": -9.2435423
    }
  }
]
''';

var irnPlaces = (json.decode(irnPlacesString) as Iterable)
    .map((i) => IrnPlace.fromMap(i))
    .toList();
