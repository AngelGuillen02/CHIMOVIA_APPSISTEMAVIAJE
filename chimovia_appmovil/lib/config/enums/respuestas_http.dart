enum RespuestasHttp {
  ok(200),
  creado(201),
  errorServidor(500);


  final int codigo;
  const RespuestasHttp(this.codigo);

}