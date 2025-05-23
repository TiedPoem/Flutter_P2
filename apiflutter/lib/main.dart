import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja de pecas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    ProdutoCadastro(),
    ProdutoList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Cadastro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
        ],
      ),
    );
  }
}

class ProdutoCadastro extends StatefulWidget {
  @override
  _ProdutoCadastroState createState() => _ProdutoCadastroState();
}

class _ProdutoCadastroState extends State<ProdutoCadastro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  Future<void> adicionarCadastro() async {
  final nome = nomeController.text.trim();
  final marca = marcaController.text.trim();
  final preco = precoController.text.trim();
  final cep = cepController.text.trim();

  if (nome.isEmpty || marca.isEmpty || preco.isEmpty || cep.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos!'))
    );
    return;
  }

  final response = await http.post(
    Uri.parse('http://localhost:8080/item'),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
    body: json.encode({
      'nome': nome,
      'marca': marca,
      'preco': double.tryParse(preco) ?? 0.0,
      'cep': int.tryParse(cep),
    }),
  );

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cadastro enviado com sucesso!'))
    );
    nomeController.clear();
    marcaController.clear();
    precoController.clear();
    cepController.clear();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao enviar cadastro'))
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Produtos')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: marcaController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: precoController,
              decoration: InputDecoration(labelText: 'Preco'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // aceita número com até 2 casas decimais
                ],
            ),
            TextField(
              controller: cepController,
              decoration: InputDecoration(labelText: 'Cep do Vendedor'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,           // só números
                LengthLimitingTextInputFormatter(8), // aceita número 8 numeros
                ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: adicionarCadastro,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProdutoList extends StatefulWidget {
  @override
  _ProdutoListState createState() => _ProdutoListState();
}

class _ProdutoListState extends State<ProdutoList> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPosts();
    searchController.addListener(_filtrarProdutos);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filtrarProdutos() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products.where((produto) {
          final nome = produto['nome'].toString().toLowerCase();
          return nome.contains(query);
        }).toList();
      }
    });
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(
          Uri.parse('http://localhost:8080/item'),
          headers: {'Content-Type': 'application/json; charset=utf8'}
          );

    if (response.statusCode == 200) {
      setState(() {

        String data = utf8.decode(response.bodyBytes);
        products = json.decode(data);
        _filtrarProdutos();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> deletarProduto(String id) async {
  final response = await http.delete(
    Uri.parse('http://localhost:8080/item/$id'),
  );


  if (response.statusCode != 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produto excluído com sucesso!'))
    );
    await fetchPosts(); // Recarrega a lista
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao excluir produto.'))
    );
    await fetchPosts();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        Expanded(
  child: ListView.separated(
    itemCount: filteredProducts.length,
    separatorBuilder: (context, index) => Divider(),
    itemBuilder: (context, index) {
      final produto = filteredProducts[index];
      return ListTile(
        title: Text('ID: ${produto['codigo']} - ${produto['nome']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Marca: ${produto['marca']}, Preço: ${produto['preco']}, CEP: ${produto['cep']}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdutoEditar(produto: produto)),
              ).then((_) => fetchPosts());
            } else if (value == 'excluir') {
              deletarProduto(produto['id']);
            } else if (value == 'cep') {
              final cep = produto['cep'];
              if (cep != null && cep >= 10000000 && cep <= 99999999) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CepInfoPage(cep: cep.toString())),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('CEP inválido ou não cadastrado')),
                );
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'editar', child: Text('Editar')),
            PopupMenuItem(value: 'excluir', child: Text('Excluir')),
            PopupMenuItem(value: 'cep', child: Text('Checar CEP')),
          ],
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }
}

class CepInfoPage extends StatelessWidget {
  final String cep;

  const CepInfoPage({required this.cep});

  Future<Map<String, dynamic>> buscarCep() async {
    final response = await http.get(
      Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao consultar o CEP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informações do CEP')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: buscarCep(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar o CEP'));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CEP: ${data['cep']}', style: TextStyle(fontSize: 18)),
                  Text('Logradouro: ${data['logradouro']}'),
                  Text('Bairro: ${data['bairro']}'),
                  Text('Cidade: ${data['localidade']}'),
                  Text('UF: ${data['uf']}'),
                  Text('DDD: ${data['ddd']}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ProdutoEditar extends StatefulWidget {
  final Map produto;

  ProdutoEditar({required this.produto});

  @override
  _ProdutoEditarState createState() => _ProdutoEditarState();
}

class _ProdutoEditarState extends State<ProdutoEditar> {
  late TextEditingController nomeController;
  late TextEditingController marcaController;
  late TextEditingController precoController;
  late TextEditingController cepController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.produto['nome']);
    marcaController = TextEditingController(text: widget.produto['marca']);
    precoController = TextEditingController(text: widget.produto['preco'].toString());
    cepController = TextEditingController(text: widget.produto['cep'].toString());
  }

  Future<void> editarProduto() async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/item/${widget.produto['id']}'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: json.encode({
        'nome': nomeController.text,
        'marca': marcaController.text,
        'preco': double.tryParse(precoController.text) ?? 0.0,
        'cep': int.tryParse(cepController.text),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto editado com sucesso!'))
      );
      Navigator.pop(context, true); // volta para a lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao editar produto.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Produto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
            TextField(controller: marcaController, decoration: InputDecoration(labelText: 'Marca')),
            TextField(
              controller: precoController,
              decoration: InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // aceita número com até 2 casas decimais
                ],
            ),
            TextField(
              controller: cepController,
              decoration: InputDecoration(labelText: 'Cep'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,           // só números
                LengthLimitingTextInputFormatter(8), // aceita número 8 numeros
                ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: editarProduto,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
