enum Endpoints { createUser, updateUser, deleteUser, getUsers }

class ServiceConstants {
  final scheme = 'http';
  final host = '146.59.52.68';
  final port = 11235;

  String getPath(Endpoints value, String? id) {
    switch (value) {
      case Endpoints.createUser:
        return '/api/user';
      case Endpoints.updateUser:
        // TODO: Handle this case.
        return '/api/user/$id';
      case Endpoints.deleteUser:
        // TODO: Handle this case.
        return '/api/user/$id';
      case Endpoints.getUsers:
        // TODO: Handle this case.
        return '/api/user';
    }
  }

  final headers = {
    'accept': 'text/plain',
    'ApiKey': 'aa83a0d7-1876-482b-be52-a5c1e1a14225',
    'Content-Type': 'application/json'
  };

  Uri getURI(Endpoints endpoint,
      {String term = '', String skip = '', String take = '', String? id}) {
    var URI = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: getPath(endpoint, id),
      queryParameters: (endpoint == Endpoints.getUsers)
          ? {
              "search": term,
              "skip": skip,
              "take": take,
            }
          : null,
    );
    return URI;
  }
}
