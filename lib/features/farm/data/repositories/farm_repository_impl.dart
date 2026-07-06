import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmtec/features/farm/data/datasources/farm_local_datasource.dart';
import 'package:farmtec/features/farm/domain/entities/farm.dart';
import 'package:farmtec/features/farm/domain/repositories/farm_repository.dart';

class FarmRepositoryImpl implements FarmRepository {
  FarmRepositoryImpl({FarmLocalDataSource? dataSource})
      : _dataSource = dataSource ?? FarmLocalDataSource();

  final FarmLocalDataSource _dataSource;
  List<Farm> _farms = [];
  String? _selectedFarmId;

  static const String _baseUrl = 'https://ahmed-mabrouk22-farmtech-backend.hf.space/api';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  Future<http.Response> _authenticatedRequest(
    String method,
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse(url);
    final access = await _getAuthToken();
    if (access == null) {
      throw Exception('Not authenticated');
    }

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
      ...?headers,
    };

    http.Response response;
    if (method == 'POST') {
      response = await http.post(uri, headers: requestHeaders, body: jsonEncode(body));
    } else if (method == 'PUT') {
      response = await http.put(uri, headers: requestHeaders, body: jsonEncode(body));
    } else if (method == 'PATCH') {
      response = await http.patch(uri, headers: requestHeaders, body: jsonEncode(body));
    } else if (method == 'DELETE') {
      response = await http.delete(uri, headers: requestHeaders);
    } else {
      response = await http.get(uri, headers: requestHeaders);
    }

    if (response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refresh = prefs.getString('refresh_token');
      if (refresh != null) {
        try {
          final refreshRes = await http.post(
            Uri.parse('$_baseUrl/accounts/token/refresh/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refresh}),
          );
          if (refreshRes.statusCode == 200) {
            final data = jsonDecode(refreshRes.body);
            final newAccess = data['access'];
            final newRefresh = data['refresh'] ?? refresh;
            await _saveTokens(newAccess, newRefresh);

            requestHeaders['Authorization'] = 'Bearer $newAccess';
            if (method == 'POST') {
              response = await http.post(uri, headers: requestHeaders, body: jsonEncode(body));
            } else if (method == 'PUT') {
              response = await http.put(uri, headers: requestHeaders, body: jsonEncode(body));
            } else if (method == 'PATCH') {
              response = await http.patch(uri, headers: requestHeaders, body: jsonEncode(body));
            } else if (method == 'DELETE') {
              response = await http.delete(uri, headers: requestHeaders);
            } else {
              response = await http.get(uri, headers: requestHeaders);
            }
          }
        } catch (e) {
          // Token refresh failed, proceed with original 401 response
        }
      }
    }

    return response;
  }

  String _mapCropTypeToChoices(String crop) {
    final clean = crop.trim().toLowerCase();
    if (clean.contains('wheat')) return 'wheat';
    if (clean.contains('corn')) return 'corn';
    if (clean.contains('rice')) return 'rice';
    if (clean.contains('barley')) return 'barley';
    if (clean.contains('soybean') || clean.contains('soy')) return 'soybeans';
    if (clean.contains('cotton')) return 'cotton';
    if (clean.contains('sugarcane')) return 'sugarcane';
    return 'other';
  }

  String _mapCropTypeToColor(String crop) {
    final clean = _mapCropTypeToChoices(crop);
    switch (clean) {
      case 'wheat':
        return '#3a8c3f';
      case 'corn':
        return '#e6a817';
      case 'rice':
        return '#1e7cb8';
      case 'barley':
        return '#9c8c3a';
      case 'soybeans':
        return '#8c6e3a';
      case 'cotton':
        return '#e0e0e0';
      case 'sugarcane':
        return '#3aa67f';
      default:
        return '#00AA00';
    }
  }

  Future<String?> _syncAddFarmToRemote(Farm farm) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      // 1. POST Farm
      final farmRes = await _authenticatedRequest(
        'POST',
        '$_baseUrl/farms/farms/',
        body: {
          'name': farm.name,
          'location': 'Egypt',
          'soil_type': 'Loamy',
          'climate_zone': 'Arid',
          'latitude': farm.lat,
          'longitude': farm.lng,
        },
      );

      if (farmRes.statusCode != 201) return null;
      final farmData = jsonDecode(farmRes.body);
      final int remoteId = farmData['id'];

      final double areaVal = double.tryParse(farm.area.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

      // 2. POST Plot
      final harvestDate = (farm.plantedAt ?? DateTime.now()).add(const Duration(days: 120));
      final harvestDateStr = '${harvestDate.year}-${harvestDate.month.toString().padLeft(2, '0')}-${harvestDate.day.toString().padLeft(2, '0')}';

      await _authenticatedRequest(
        'POST',
        '$_baseUrl/farms/plots/',
        body: {
          'farm': remoteId,
          'name': '${farm.name} Plot',
          'crop_type': farm.crop,
          'area': areaVal,
          'moisture': 60.0,
          'harvest_date': harvestDateStr,
          'status': 'healthy',
          'latitude': farm.lat,
          'longitude': farm.lng,
        },
      );

      // 3. POST CropField
      await _authenticatedRequest(
        'POST',
        '$_baseUrl/farms/fields/',
        body: {
          'farm': remoteId,
          'crop_type': _mapCropTypeToChoices(farm.crop),
          'color': _mapCropTypeToColor(farm.crop),
          'latitude': farm.lat,
          'longitude': farm.lng,
          'area': areaVal,
          'soil_type': 'Loamy',
        },
      );

      return remoteId.toString();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Farm>> getFarms() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        if (_farms.isEmpty) await _reload();
        return List.unmodifiable(_farms);
      }

      final response = await _authenticatedRequest('GET', '$_baseUrl/farms/farms/');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> results = [];
        if (decoded is List) {
          results = decoded;
        } else if (decoded is Map && decoded.containsKey('results')) {
          results = decoded['results'];
        }

        final List<Farm> remoteFarms = [];
        for (var item in results) {
          final id = item['id'].toString();
          final name = item['name'] ?? '';
          final lat = double.tryParse(item['latitude']?.toString() ?? '0') ?? 0.0;
          final lng = double.tryParse(item['longitude']?.toString() ?? '0') ?? 0.0;

          String crop = 'Wheat';
          String area = '0 ha';
          String health = 'healthy';
          DateTime? plantedAt;

          final plotsList = item['plots'] as List<dynamic>?;
          if (plotsList != null && plotsList.isNotEmpty) {
            final firstPlot = plotsList.first;
            crop = firstPlot['crop_type'] ?? 'Wheat';
            health = firstPlot['status'] ?? 'healthy';

            double totalArea = 0;
            for (var p in plotsList) {
              totalArea += double.tryParse(p['area']?.toString() ?? '0') ?? 0.0;
            }
            area = '${totalArea.toStringAsFixed(1)} ha';

            final harvestDateStr = firstPlot['harvest_date'];
            if (harvestDateStr != null && harvestDateStr.toString().isNotEmpty) {
              final harvestDate = DateTime.tryParse(harvestDateStr);
              if (harvestDate != null) {
                plantedAt = harvestDate.subtract(const Duration(days: 120));
              }
            }
          }

          remoteFarms.add(Farm(
            id: id,
            name: name,
            crop: crop,
            area: area,
            health: health,
            lastScan: '',
            lat: lat,
            lng: lng,
            plantedAt: plantedAt,
          ));
        }

        _farms = remoteFarms;
        await _dataSource.saveFarms(_farms, _selectedFarmId);
      } else {
        if (_farms.isEmpty) await _reload();
      }
    } catch (e) {
      if (_farms.isEmpty) await _reload();
    }

    return List.unmodifiable(_farms);
  }

  @override
  Future<Farm?> getSelectedFarm() async {
    if (_farms.isEmpty) await getFarms();
    if (_farms.isEmpty) return null;
    return _farms.firstWhere(
      (f) => f.id == _selectedFarmId,
      orElse: () => _farms.first,
    );
  }

  @override
  Future<void> selectFarm(String farmId) async {
    _selectedFarmId = farmId;
    await _dataSource.saveFarms(_farms, farmId);
  }

  @override
  Future<void> addFarm(Farm farm) async {
    String farmId = farm.id;
    final remoteId = await _syncAddFarmToRemote(farm);
    if (remoteId != null) {
      farmId = remoteId;
    }

    final syncedFarm = Farm(
      id: farmId,
      name: farm.name,
      crop: farm.crop,
      area: farm.area,
      health: farm.health,
      lastScan: farm.lastScan,
      lat: farm.lat,
      lng: farm.lng,
      plantedAt: farm.plantedAt,
    );

    _farms = [..._farms, syncedFarm];
    _selectedFarmId = farmId;
    await _dataSource.saveFarms(_farms, farmId);
  }

  @override
  Future<void> removeFarm(String farmId) async {
    _farms = _farms.where((f) => f.id != farmId).toList();
    if (_selectedFarmId == farmId) {
      _selectedFarmId = _farms.isNotEmpty ? _farms.first.id : null;
    }
    await _dataSource.saveFarms(_farms, _selectedFarmId);

    final intId = int.tryParse(farmId);
    if (intId != null) {
      try {
        await _authenticatedRequest('DELETE', '$_baseUrl/farms/farms/$farmId/');
      } catch (e) {
        // Silent catch
      }
    }
  }

  @override
  Future<void> updateFarm(Farm farm) async {
    final index = _farms.indexWhere((f) => f.id == farm.id);
    if (index != -1) {
      final updatedList = List<Farm>.from(_farms);
      updatedList[index] = farm;
      _farms = updatedList;
      await _dataSource.saveFarms(_farms, _selectedFarmId);
    }

    final intId = int.tryParse(farm.id);
    if (intId != null) {
      try {
        await _authenticatedRequest(
          'PATCH',
          '$_baseUrl/farms/farms/${farm.id}/',
          body: {
            'name': farm.name,
            'latitude': farm.lat,
            'longitude': farm.lng,
          },
        );
      } catch (e) {
        // Silent catch
      }
    }
  }

  Future<void> _reload() async {
    _farms = await _dataSource.loadFarms();
    _selectedFarmId = await _dataSource.loadSelectedFarmId();
    if (_farms.isNotEmpty && _selectedFarmId == null) {
      _selectedFarmId = _farms.first.id;
      await _dataSource.saveFarms(_farms, _selectedFarmId);
    }
  }
}
