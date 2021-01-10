import 'package:flutter/material.dart';
import 'package:github_raking/api.dart';
import 'package:github_raking/ranking_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // RefreshIndicator precisa de uma chave então essa será a chave usada
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();

    // Precisa retornar um dado futuro então vamos chamar a função getRanking() e
    // dar um setState((){}) para atualizar a página
    Future<List<RankingModel>> _refreshPage() {
      setState(() {});
      return getRanking();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Ranking'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Botão para recarregar os dados
          IconButton(
            tooltip: 'Recarregar',
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
      //RefreshIndicator precisa ser o primeiro Widget, só isso 😁
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshPage,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: FutureBuilder(
            // Acessa a API e retorna os dados
            future: getRanking(),
            builder: (context, snapshot) {
              // Faz a devida validação para saber se está a carregar, deu erro ou tem dados
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  //Retorna o resultado em forma de lista

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      RankingModel ranking = snapshot.data[index];

                      return GestureDetector(
                        onTap: () {
                          launch(ranking.owner.repositorio);
                        },
                        child: ListTile(
                          title: Text(ranking.name),
                          leading: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(ranking.owner.avatarUrl),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else
                  return errorWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  errorWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Text(
        'Servidor indisponível',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
