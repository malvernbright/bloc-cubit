import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/model/weather.dart';
import '../data/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  WeatherBloc(this._weatherRepository) : super(WeatherInitial()) {
    on<GetWeather>(_getWeather);
  }

  _getWeather(GetWeather event, Emitter<WeatherState> emit) async {
    try {
      emit(WeatherLoading());
      final weather = await _weatherRepository.fetchWeather(event.cityName);
      emit(WeatherLoaded(weather));
    } on NetworkException {
      emit(WeatherError(
          "Oh no! Cannot load weather right now! Are you sure the device is online?"));
    }
  }
}
