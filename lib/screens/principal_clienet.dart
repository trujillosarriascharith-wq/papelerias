import 'package:flutter/material.dart';
import 'package:papelerias/screens/inicioseseion.dart';
import 'package:papelerias/screens/perfil_screen.dart';
import 'package:papelerias/screens/notificaciones.dart';
import '../theme/colores.dart';
import '../theme/estilostextos.dart';
import '../widgets/barrasuperior.dart';
import '../widgets/fondodegradado.dart';
import '../widgets/botoncategorias.dart';
import '../widgets/footercontacto.dart';
import '../components/chat_papeleria_modal.dart';
import '../services/sesion.dart';

/// Pantalla principal - Papelería y Variedades Juan José
class PrincipalClient extends StatelessWidget {
  const PrincipalClient({super.key});

  static const _categorias = [
    ('Cuadernos', 'assets/images/cuadernos.png'),
    ('Colores', 'assets/images/colores.png'),
    ('Cartucheras', 'assets/images/cartucheras.png'),
    ('Temperas', 'assets/images/temperas.png'),
    ('Marcadores', 'assets/images/marcadores.jpg'),
    ('Pegamentos', 'assets/images/pegamentos.jpg'),
  ];

  void _abrirCategoria(BuildContext context, String nombre) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Categoria $nombre proximamente'),
        backgroundColor: const Color(0xFFFF8FAB),
      ),
    );
  }

  void _abrirChatPapeleria(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChatPapeleriaModal(),
    );
  }

  // Abre las notificaciones solo si hay sesión iniciada (necesita el token)
  void _abrirNotificaciones(BuildContext context) {
    if (!Sesion.activa) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para ver tus notificaciones')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaNotificaciones(token: Sesion.token!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),//Es el margen interno. Separa el contenido de adentro del borde de afuera
          child: Column(
            children: [
              FondoDegradado(
                alto: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8),//que tan separados dejan los iconos de la margen
                child: Center(
                  child: BarraSuperior(
                    colorIconos: Colors.black,
                    onPerfil: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PerfilScreen()),
                      );
                    },
                    onCarrito: () {},
                    onNotificaciones: () => _abrirNotificaciones(context),
                    // onRegistro: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (_) => const InicioSesion()),
                    //   );
                    // },
                  ),
                ),
              ),
              const SizedBox(height: 12),//espacio entre una barra y la otra
              FondoDegradado(
                alto: 120,
                padding: const EdgeInsets.all(16),//espacio esntre la margen y el logo
                child: _encabezadoLogo(),
              ),
              const SizedBox(height: 20),
              Text('Categorias', style: Estilostextos.estilosTitulo),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,//cantidad de columnas
                mainAxisSpacing: 5,//Espacio VERTICAL entre filas. Separa un botón de categoría del que está abajo.
                crossAxisSpacing: 20,//Espacio HORIZONTAL entre columnas. Separa el botón de la izquierda del de la derecha
                childAspectRatio: 1.09,//La FORMA de cada tarjeta. Es ancho / alto.
                children: [
                  for (final (nombre, imagen) in _categorias)
                    BotonCategoria(
                      nombre: nombre,
                      imagen: imagen,
                      onTap: () => _abrirCategoria(context, nombre),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _abrirChatPapeleria(context),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8FAB).withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(255, 252, 203, 5),//color de circulo del chatbot
            child: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/robot.jpg'),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const FooterContacto(),
    );
  }

  Widget _encabezadoLogo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,//tamaño del logo
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/logo.jpg'),
        ),
        const SizedBox(width: 30),//que tan centrado se deja el texto de bienvenida
        Expanded(
          child: Text(
            '¡Bienvenidos a\nPapeleria y Variedaes\nJuan Jose!',
            textAlign: TextAlign.center,
            style: Estilostextos.estilosBienvenida,
          ),
        ),
      ],
    );
  }
}