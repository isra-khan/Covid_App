import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/utils/voice_query_parser.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceStatsController extends GetxController {
  final StateServicesController _service = Get.find<StateServicesController>();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  RxBool isAvailable = false.obs;
  RxBool isListening = false.obs;
  RxString transcript = ''.obs;
  Rxn<CountryModel> matched = Rxn<CountryModel>();
  RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    try {
      isAvailable.value = await _speech.initialize(
        onStatus: (s) {
          if (s == 'notListening' || s == 'done') isListening.value = false;
        },
        onError: (e) => error.value = e.errorMsg,
      );
    } catch (e) {
      isAvailable.value = false;
      error.value = 'Speech init failed.';
    }
  }

  Future<void> startListening() async {
    if (!isAvailable.value) {
      error.value = 'Speech recognition not available on this device.';
      return;
    }
    transcript.value = '';
    matched.value = null;
    error.value = null;
    isListening.value = true;
    await _speech.listen(
      onResult: (r) {
        transcript.value = r.recognizedWords;
        if (r.finalResult) _onFinal();
      },
      listenFor: const Duration(seconds: 6),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening.value = false;
    _onFinal();
  }

  void _onFinal() {
    if (_service.countries.isEmpty) {
      error.value = 'Country list not loaded yet.';
      return;
    }
    final c =
        VoiceQueryParser.matchCountry(transcript.value, _service.countries);
    matched.value = c;
    if (c == null) {
      error.value = 'Couldn\'t match a country in: "${transcript.value}".';
      _tts.speak('Sorry, I did not understand the country.');
    } else {
      final msg =
          '${c.country} has ${c.cases} cases, ${c.deaths} deaths, and ${c.recovered} recovered.';
      _tts.speak(msg);
    }
  }

  @override
  void onClose() {
    _speech.cancel();
    _tts.stop();
    super.onClose();
  }
}
