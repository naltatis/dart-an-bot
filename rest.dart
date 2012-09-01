#library("rest");
#import('dart:io');
#import('dart:uri');
#import('dart:json');

class Rest {
  var client = new HttpClient();

  Future<String> get(String url) {
    //print(">> ".concat(url));
    var completer = new Completer();
    var conn = client.getUrl(new Uri.fromString(url));
    conn.onRequest = (HttpClientRequest request) {
      request.outputStream.close();
    };
    conn.onResponse = (HttpClientResponse response) {
      print("<< ".concat(url));
      StringInputStream input = new StringInputStream(response.inputStream);
      StringBuffer buffer = new StringBuffer("");

      input.onData = () {
        String currentString = input.read();
        buffer.add(currentString);          
      };

      input.onClosed = () {
        completer.complete(buffer.toString());
        client.shutdown();
      };
    };  
    return completer.future;
  }

  Future<String> post(String url, String data) {
    //print(">> $url?$data");
    var completer = new Completer();
    var conn = client.postUrl(new Uri.fromString(url));
    conn.onRequest = (HttpClientRequest request) {
      request.headers.set(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded");
      var encodedData = encodeUri(data);
      request.contentLength = encodedData.length;
      request.outputStream.writeString(encodedData);
      request.outputStream.close();
    };
    conn.onResponse = (HttpClientResponse response) {
      final StringInputStream input = new StringInputStream(response.inputStream);
      completer.complete(response.statusCode);
      client.shutdown();
    }; 
    return completer.future;
  }


  Future<Map> getJson(String url) {
    var completer = new Completer();
    get(url).then((String data) {
      completer.complete(JSON.parse(data));
    });
    return completer.future;
  }
}