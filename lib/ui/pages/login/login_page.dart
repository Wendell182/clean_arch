import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(
              text: 'login',
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                  child: Column(
                children: [
                  StreamBuilder<String>(
                      stream: presenter.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: presenter.validateEmail,
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
                    child: StreamBuilder<String>(
                        stream: presenter.passwordErrorController,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                errorText: snapshot.data),
                            obscureText: true,
                            onChanged: presenter.validatePassword,
                          );
                        }),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Entrar'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Text('Criar conta'),
                      ],
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
