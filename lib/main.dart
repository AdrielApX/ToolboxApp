import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// Definición de las constantes para la edad
const int EDAD_JOVEN_MAX = 29;
const int EDAD_ANCIANO_MIN = 65;

void main() {
  runApp(const MultiToolApp());
}

class MultiToolApp extends StatelessWidget {
  const MultiToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuración para usar el ícono del usuario como icono de la App
    // Esto se maneja en los archivos nativos de Android/iOS (AndroidManifest.xml, Info.plist, etc.)
    // y la colocación de la imagen en las carpetas de recursos nativos.
    return MaterialApp(
      title: 'MultiTool App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/genero': (context) => const GeneroPredictionPage(),
        '/edad': (context) => const EdadPredictionPage(),
        '/universidades': (context) => const UniversidadesPage(),
        '/clima': (context) => const ClimaRDPage(),
        '/pokemon': (context) => const PokemonPage(),
        '/wordpress': (context) => const WordPressNewsPage(),
        '/acerca_de': (context) => const AcercaDePage(),
      },
    );
  }
}

// ===================================
// 1. VISTA DE INICIO 
// ===================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String _toolboxImageUrl = 'assets/images/toolbox.png'; // imagen de caja de herramientas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiToolbox App')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(_toolboxImageUrl),
            ),
            const Text(
              'Selecciona una herramienta:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _FeatureCard(
                    title: 'Predecir Género',
                    icon: Icons.person_search,
                    route: '/genero'),
                _FeatureCard(
                    title: 'Predecir Edad',
                    icon: Icons.cake,
                    route: '/edad'),
                _FeatureCard(
                    title: 'Universidades',
                    icon: Icons.school,
                    route: '/universidades'),
                _FeatureCard(
                    title: 'Clima en RD',
                    icon: Icons.cloud,
                    route: '/clima'),
                _FeatureCard(
                    title: 'Info. Pokémon',
                    icon: Icons.catching_pokemon,
                    route: '/pokemon'),
                _FeatureCard(
                    title: 'Noticias WordPress',
                    icon: Icons.article,
                    route: '/wordpress'),
                _FeatureCard(
                    title: 'Acerca de',
                    icon: Icons.info,
                    route: '/acerca_de'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const _FeatureCard({required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 50.0),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================
// 2. VISTA PREDICCIÓN DE GÉNERO
// ===================================
class GeneroPredictionPage extends StatefulWidget {
  const GeneroPredictionPage({super.key});

  @override
  State<GeneroPredictionPage> createState() => _GeneroPredictionPageState();
}

class _GeneroPredictionPageState extends State<GeneroPredictionPage> {
  final TextEditingController _nameController = TextEditingController();
  String _genderResult = '';
  Color _resultColor = Colors.white;

  Future<void> _predictGender(String name) async {
    final response = await http
        .get(Uri.parse('https://api.genderize.io/?name=${name.toLowerCase()}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final gender = data['gender'];

      setState(() {
        if (gender == 'male') {
          _genderResult = 'Masculino ♂️';
          _resultColor = Colors.blue.shade100;
        } else if (gender == 'female') {
          _genderResult = 'Femenino ♀️';
          _resultColor = Colors.pink.shade100;
        } else {
          _genderResult = 'Género no predicho';
          _resultColor = Colors.grey.shade300;
        }
      });
    } else {
      setState(() {
        _genderResult = 'Error al predecir género';
        _resultColor = Colors.red.shade100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Género')),
      body: Container(
        color: _resultColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Introduce un nombre'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _predictGender(_nameController.text),
              child: const Text('Predecir'),
            ),
            const SizedBox(height: 30),
            Text(
              _genderResult,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================
// 3. VISTA PREDICCIÓN DE EDAD
// ===================================
class EdadPredictionPage extends StatefulWidget {
  const EdadPredictionPage({super.key});

  @override
  State<EdadPredictionPage> createState() => _EdadPredictionPageState();
}

class _EdadPredictionPageState extends State<EdadPredictionPage> {
  final TextEditingController _nameController = TextEditingController();
  Map<String, dynamic>? _ageResult;

  Future<void> _predictAge(String name) async {
    final response =
        await http.get(Uri.parse('https://api.agify.io/?name=${name.toLowerCase()}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _ageResult = data;
      });
    } else {
      setState(() {
        _ageResult = {'error': 'Error al predecir edad'};
      });
    }
  }

  String _getAgeCategory(int age) {
    if (age <= EDAD_JOVEN_MAX) {
      return 'Joven';
    } else if (age < EDAD_ANCIANO_MIN) {
      return 'Adulto';
    } else {
      return 'Anciano';
    }
  }

  String _getAgeImage(String category) {
    switch (category) {
      case 'Joven':
        return 'https://picsum.photos/id/163/300/200'; // Placeholder Joven
      case 'Adulto':
        return 'https://picsum.photos/id/292/300/200'; // Placeholder Adulto
      case 'Anciano':
        return 'https://picsum.photos/id/40/300/200'; // Placeholder Anciano
      default:
        return 'https://picsum.photos/300/200';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Edad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Introduce un nombre'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _predictAge(_nameController.text),
              child: const Text('Predecir'),
            ),
            const SizedBox(height: 30),
            if (_ageResult != null && _ageResult!['age'] != null)
              Column(
                children: [
                  Text(
                    'Edad: ${_ageResult!['age']}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Categoría: ${_getAgeCategory(_ageResult!['age'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Image.network(_getAgeImage(_getAgeCategory(_ageResult!['age']))),
                ],
              ),
            if (_ageResult != null && _ageResult!['age'] == null)
              Text(_ageResult!['error'] ?? 'Edad no encontrada'),
          ],
        ),
      ),
    );
  }
}

// ===================================
// 4. VISTA DE UNIVERSIDADES
// ===================================
class UniversidadesPage extends StatefulWidget {
  const UniversidadesPage({super.key});

  @override
  State<UniversidadesPage> createState() => _UniversidadesPageState();
}

class _UniversidadesPageState extends State<UniversidadesPage> {
  final TextEditingController _countryController = TextEditingController();
  List<dynamic> _universities = [];

  Future<void> _searchUniversities(String country) async {
    // La API requiere el nombre del país en inglés
    final response = await http.get(Uri.parse(
        'http://universities.hipolabs.com/search?country=${country.replaceAll(' ', '+')}'));

    if (response.statusCode == 200) {
      setState(() {
        _universities = json.decode(response.body);
      });
    } else {
      setState(() {
        _universities = [{'name': 'Error al buscar universidades'}];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Universidades')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                  labelText: 'País (en inglés, ej: Dominican Republic)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _searchUniversities(_countryController.text),
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _universities.length,
                itemBuilder: (context, index) {
                  final uni = _universities[index];
                  return Card(
                    child: ListTile(
                      title: Text(uni['name'] ?? 'Nombre no disponible'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dominio: ${uni['domains']?.join(', ') ?? 'N/A'}'),
                          GestureDetector(
                            onTap: () async {
                              final url = uni['web_pages']?.isNotEmpty == true
                                  ? uni['web_pages'][0]
                                  : null;
                              if (url != null) {
                                // Usamos launchUrl con forceWebView opcional para mejor compatibilidad
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              }
                            },
                            child: Text(
                              'Web: ${uni['web_pages']?.isNotEmpty == true ? uni['web_pages'][0] : 'N/A'}',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================
// 5. VISTA DE CLIMA EN RD
// ===================================
class ClimaRDPage extends StatelessWidget {
  const ClimaRDPage({super.key});

  // *ADVERTENCIA*: Reemplaza {YOUR_API_KEY} con tu clave API real de OpenWeatherMap.
  final String _apiKey = '214ddedfe2e348d12149081ec96d87bc'; // Clave API 
  final String _city = 'Santo Domingo,DO'; // Ciudad principal de RD
  
  Future<Map<String, dynamic>> _fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$_apiKey&units=metric&lang=es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Fallo al cargar el clima. Verifica la API Key y la conexión.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima en República Dominicana')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}\n(Verifica tu API Key de clima)'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final temp = data['main']['temp'];
            final desc = data['weather'][0]['description'];
            final icon = data['weather'][0]['icon'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Clima en ${data['name']}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Image.network('http://openweathermap.org/img/w/$icon.png'),
                  Text('${temp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 60)),
                  Text(desc.toString().toUpperCase(), style: const TextStyle(fontSize: 24)),
                  Text('Máxima: ${data['main']['temp_max']}°C / Mínima: ${data['main']['temp_min']}°C', style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay datos de clima disponibles.'));
        },
      ),
    );
  }
}

// ===================================
// 6. VISTA DE POKÉMON
// ===================================
class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final TextEditingController _nameController = TextEditingController();
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = false;

  Future<void> _fetchPokemon(String name) async {
    setState(() {
      _isLoading = true;
      _pokemonData = null;
    });

    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}'));

    if (response.statusCode == 200) {
      setState(() {
        _pokemonData = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _pokemonData = {'error': 'Pokémon no encontrado o error en la API'};
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre de Pokémon'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _fetchPokemon(_nameController.text),
              child: const Text('Buscar Pokémon'),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_pokemonData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_pokemonData!['error'] != null)
                        Text(_pokemonData!['error'], style: const TextStyle(color: Colors.red))
                      else
                        _PokemonDetails(data: _pokemonData!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PokemonDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  const _PokemonDetails({required this.data});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = data['sprites']['front_default'] ?? 'https://picsum.photos/200';
    final int baseExperience = data['base_experience'] ?? 0;
    final List<dynamic> abilities = data['abilities'];
    // La API de PokeAPI no tiene un campo de 'sonido' directo, pero tiene 'cries'
    final String cryUrl = data['cries']['latest'] ?? 'No disponible';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          data['name'].toString().toUpperCase(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Image.network(imageUrl, height: 150),
        const Divider(),
        _infoRow(context, 'Experiencia Base:', baseExperience.toString()),
        const Divider(),
        const Text('Habilidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...abilities.map<Widget>((a) => Text(a['ability']['name'].toString().toUpperCase())),
        const Divider(),
        _infoRow(context, 'Sonido (URL):', cryUrl),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

// ===================================
// 7. VISTA DE NOTICIAS WORDPRESS
// ===================================
class WordPressNewsPage extends StatelessWidget {
  const WordPressNewsPage({super.key});

  // Ejemplo de URL de API REST pública de WordPress.
  // URL de ejemplo de un blog conocido (TechCrunch).
  // Nota: Debes verificar el CORS en producción o usar un proxy si la app falla.
  final String _apiUrl =
      'https://techcrunch.com/wp-json/wp/v2/posts?_embed&per_page=3';

  Future<List<dynamic>> _fetchPosts() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Fallo al cargar las noticias. Revisa la URL y la conexión.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Logo de TechCrunch (Placeholder)', style: TextStyle(fontSize: 16)),
                  ),
                ),
                ...snapshot.data!.map((post) => _PostCard(post: post)),
              ],
            );
          }
          return const Center(child: Text('No hay noticias disponibles.'));
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final title = post['title']['rendered'] ?? 'Sin título';
    final summary = post['excerpt']['rendered'] ?? 'Sin resumen';
    final link = post['link'] ?? '#';

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Limpia el HTML del resumen para mostrar el texto plano
            Text(
              summary.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''), 
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final uri = Uri.parse(link);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                'Visitar Noticia',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================
// 8. VISTA ACERCA DE (About)
// ===================================
class AcercaDePage extends StatelessWidget {
  const AcercaDePage({super.key});

  @override
  Widget build(BuildContext context) {
    // La imagen está en assets/images/mi_foto1.png
    const String assetsImagePath = 'assets/images/mi_foto1.png';

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de Mí')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Mi foto
              ClipOval(
                child: Image.asset(
                  assetsImagePath, 
                  width: 150, 
                  height: 150, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 150),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Desarrollador de Aplicaciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '¡Hola! Soy un desarrollador con experiencia en la creación de soluciones móviles.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.email),
                title: Text('Correo Electrónico'),
                subtitle: Text('adriel0206.1@gmail.com'),
              ),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('Teléfono'),
                subtitle: Text('+1 829-812-6638'),
              ),
              const ListTile(
                leading: Icon(Icons.code),
                title: Text('Portafolio/GitHub'),
                subtitle: Text('[https://github.com/AdrielApX]'),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Abierto a oportunidades de trabajo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}