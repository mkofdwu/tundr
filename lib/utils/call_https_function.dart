import 'package:cloud_functions/cloud_functions.dart';

Future<T> callHttpsFunction<T>(String functionName,
    [dynamic parameters]) async {
  final result = await FirebaseFunctions.instance
      .httpsCallable(functionName)
      .call(parameters);
  // if there is only a single value returned it will be in a field named 'result'
  return result.data == null ? null : result.data['result'] as T;
}
