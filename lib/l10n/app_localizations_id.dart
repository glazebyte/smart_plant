// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Monitor Tanaman Pintar';

  @override
  String get dashboard => 'Beranda';

  @override
  String get control => 'Kontrol';

  @override
  String get schedule => 'Jadwal';

  @override
  String get logs => 'Riwayat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get soilMoisture => 'Kelembaban Tanah';

  @override
  String get humidity => 'Kelembaban Udara';

  @override
  String get temperature => 'Suhu';

  @override
  String get currentReadings => 'Pembacaan Saat Ini';

  @override
  String get noSensorData => 'Tidak ada data sensor';

  @override
  String get waitingForData => 'Menunggu data dari tanaman pintar Anda...';

  @override
  String get connectToViewData =>
      'Hubungkan ke tanaman pintar Anda untuk melihat data';

  @override
  String get lastUpdate => 'Pembaruan Terakhir';

  @override
  String get justNow => 'Baru saja';

  @override
  String minutesAgo(int minutes) {
    return '$minutes menit lalu';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours jam lalu';
  }

  @override
  String get deviceConnection => 'Koneksi Perangkat';

  @override
  String get disconnected => 'Terputus';

  @override
  String get scanning => 'Memindai...';

  @override
  String get connecting => 'Menghubungkan...';

  @override
  String get connected => 'Terhubung';

  @override
  String get connectionError => 'Kesalahan Koneksi';

  @override
  String get noDevicesFound => 'Tidak ada perangkat ditemukan';

  @override
  String get devicePairingInstructions =>
      'Pastikan perangkat tanaman pintar Anda menyala\ndan dalam mode pairing';

  @override
  String get scanAgain => 'Pindai Lagi';

  @override
  String get scanForDevices => 'Pindai Perangkat';

  @override
  String get scanningForDevices => 'Memindai perangkat tanaman pintar...';

  @override
  String get disconnect => 'Putuskan';

  @override
  String connectedTo(String deviceName) {
    return 'Terhubung ke $deviceName';
  }

  @override
  String failedToConnect(String error) {
    return 'Gagal menghubungkan: $error';
  }

  @override
  String get manualControl => 'Kontrol Manual';

  @override
  String get deviceNotConnected => 'Perangkat Tidak Terhubung';

  @override
  String get connectToUseControls =>
      'Hubungkan ke perangkat tanaman pintar Anda untuk menggunakan kontrol manual';

  @override
  String get plantStatus => 'Status Tanaman';

  @override
  String get needsWater => 'Perlu Air';

  @override
  String get moderate => 'Sedang';

  @override
  String get wellWatered => 'Sudah Disiram';

  @override
  String get cold => 'Dingin';

  @override
  String get cool => 'Sejuk';

  @override
  String get optimal => 'Optimal';

  @override
  String get warm => 'Hangat';

  @override
  String get hot => 'Panas';

  @override
  String get normal => 'Normal';

  @override
  String get manualWatering => 'Penyiraman Manual';

  @override
  String get duration => 'Durasi';

  @override
  String get quickSelect => 'Pilih Cepat';

  @override
  String get startWatering => 'Mulai Menyiram';

  @override
  String get stopWatering => 'Hentikan Penyiraman';

  @override
  String get connectToEnableControl =>
      'Hubungkan ke perangkat untuk mengaktifkan kontrol manual';

  @override
  String get emergencyControls => 'Kontrol Darurat';

  @override
  String get emergencyStop => 'Henti Darurat';

  @override
  String get immediatelyStopWatering => 'Segera hentikan semua penyiraman';

  @override
  String get stop => 'HENTI';

  @override
  String wateringStartedFor(String duration) {
    return 'Penyiraman dimulai selama $duration';
  }

  @override
  String failedToStartWatering(String error) {
    return 'Gagal memulai penyiraman: $error';
  }

  @override
  String get wateringStopped => 'Penyiraman dihentikan';

  @override
  String failedToStopWatering(String error) {
    return 'Gagal menghentikan penyiraman: $error';
  }

  @override
  String get emergencyStopAll => 'HENTI DARURAT - Semua penyiraman dihentikan';

  @override
  String emergencyStopFailed(String error) {
    return 'Henti darurat gagal: $error';
  }

  @override
  String get wateringSchedule => 'Jadwal Penyiraman';

  @override
  String get connectToManageSchedules =>
      'Hubungkan ke perangkat Anda untuk mengelola jadwal penyiraman';

  @override
  String get noSchedulesYet => 'Belum Ada Jadwal';

  @override
  String get addFirstSchedule =>
      'Tambahkan jadwal penyiraman pertama Anda untuk\nmenjaga tanaman tetap sehat secara otomatis';

  @override
  String get addSchedule => 'Tambah Jadwal';

  @override
  String scheduleSlot(int slot) {
    return 'Jadwal $slot';
  }

  @override
  String nextScheduled(String time) {
    return 'Berikutnya: $time';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteSchedule => 'Hapus Jadwal';

  @override
  String deleteScheduleConfirm(int slot) {
    return 'Apakah Anda yakin ingin menghapus Jadwal $slot?';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get newSchedule => 'Jadwal Baru';

  @override
  String get editSchedule => 'Edit Jadwal';

  @override
  String get wateringTime => 'Waktu Penyiraman';

  @override
  String get enableSchedule => 'Aktifkan Jadwal';

  @override
  String get save => 'Simpan';

  @override
  String failedToLoadSchedules(String error) {
    return 'Gagal memuat jadwal: $error';
  }

  @override
  String get scheduleSavedSuccessfully => 'Jadwal berhasil disimpan';

  @override
  String failedToSaveSchedule(String error) {
    return 'Gagal menyimpan jadwal: $error';
  }

  @override
  String get dataLogs => 'Log Data';

  @override
  String get charts => 'Grafik';

  @override
  String get history => 'Riwayat';

  @override
  String get noChartData => 'Tidak Ada Data Grafik';

  @override
  String get connectForCharts =>
      'Hubungkan ke perangkat Anda dan tunggu\ndata sensor untuk melihat grafik';

  @override
  String get noLogData => 'Tidak Ada Data Log';

  @override
  String get tapDownloadLogs =>
      'Ketuk tombol unduh untuk mengambil\ndata log dari perangkat Anda';

  @override
  String get downloadLogs => 'Unduh Log';

  @override
  String get connectToDownloadLogs =>
      'Hubungkan ke perangkat untuk mengunduh data log';

  @override
  String get timeRange => 'Rentang Waktu';

  @override
  String get hours24 => '24 Jam';

  @override
  String get days7 => '7 Hari';

  @override
  String get days30 => '30 Hari';

  @override
  String get logDataRequested => 'Data log berhasil diminta';

  @override
  String failedToRequestLogs(String error) {
    return 'Gagal meminta log: $error';
  }

  @override
  String get device => 'Perangkat';

  @override
  String get notConnected => 'Tidak terhubung';

  @override
  String get connect => 'Hubungkan';

  @override
  String get syncDeviceTime => 'Sinkronkan Waktu Perangkat';

  @override
  String get updateDeviceRTC => 'Perbarui RTC perangkat dengan waktu saat ini';

  @override
  String get dataManagement => 'Pengelolaan Data';

  @override
  String get clearLocalData => 'Hapus Data Lokal';

  @override
  String removeStoredReadings(int count) {
    return 'Hapus semua pembacaan sensor tersimpan ($count entri)';
  }

  @override
  String get downloadDeviceLogs => 'Unduh Log Perangkat';

  @override
  String get fetchHistoricalData => 'Ambil data historis dari perangkat';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi 1.0.0';

  @override
  String get deviceInfo => 'Info Perangkat';

  @override
  String get esp32System => 'Sistem Monitor Tanaman Pintar ESP32';

  @override
  String get madeWithFlutter => 'Dibuat dengan Flutter';

  @override
  String get builtForPlantCare => 'Dibuat untuk pecinta perawatan tanaman';

  @override
  String get currentStatus => 'Status Saat Ini';

  @override
  String get deviceTimeSynced => 'Waktu perangkat berhasil disinkronkan';

  @override
  String failedToSyncTime(String error) {
    return 'Gagal menyinkronkan waktu: $error';
  }

  @override
  String get clearLocalDataConfirm =>
      'Ini akan menghapus semua pembacaan sensor yang tersimpan dari perangkat Anda. Tindakan ini tidak dapat dibatalkan.\n\nApakah Anda yakin ingin melanjutkan?';

  @override
  String get clearData => 'Hapus Data';

  @override
  String get localDataCleared => 'Data lokal berhasil dihapus';

  @override
  String get logDownloadRequested => 'Unduhan log diminta. Periksa tab Log.';

  @override
  String get good => 'Bagus';

  @override
  String get low => 'Rendah';

  @override
  String get scan => 'Pindai';

  @override
  String get tapScanToFind =>
      'Ketuk pindai untuk menemukan perangkat tanaman pintar Anda';

  @override
  String devicesFound(int count) {
    return '$count perangkat ditemukan';
  }

  @override
  String get lookingForDevices => 'Mencari perangkat tanaman pintar...';

  @override
  String get establishingConnection => 'Membuat koneksi...';

  @override
  String get unknownDevice => 'Perangkat tidak dikenal';

  @override
  String get quickActions => 'Aksi Cepat';

  @override
  String get waterNow => 'Siram Sekarang';

  @override
  String get seconds30 => '30 detik';

  @override
  String get syncTime => 'Sinkron Waktu';

  @override
  String get updateRTC => 'Perbarui RTC';

  @override
  String get refreshData => 'Segarkan Data';

  @override
  String get getLatest => 'Dapatkan terbaru';

  @override
  String get viewLogs => 'Lihat Log';

  @override
  String get dataHistory => 'Riwayat data';

  @override
  String get connectToUseQuickActions =>
      'Hubungkan ke tanaman pintar Anda untuk menggunakan aksi cepat';

  @override
  String get waterPlant => 'Siram Tanaman';

  @override
  String get selectWateringDuration => 'Pilih durasi penyiraman:';

  @override
  String durationSeconds(int duration) {
    return 'Durasi: $duration detik';
  }

  @override
  String get timeSynchronizedSuccessfully => 'Waktu berhasil disinkronkan';

  @override
  String get dataRefreshRequested => 'Penyegaran data diminta';

  @override
  String get logDataRequestedShort => 'Data log diminta';

  @override
  String get plantAssistant => 'Asisten Tanaman';

  @override
  String get clearChat => 'Hapus Chat';

  @override
  String get clearChatConfirm =>
      'Apakah Anda yakin ingin menghapus semua pesan chat? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get clear => 'Hapus';

  @override
  String get startConversation =>
      'Mulai percakapan dengan Asisten Tanaman Anda';

  @override
  String get chatError =>
      'Gagal mengirim pesan. Silakan periksa API key Anda dan coba lagi.';

  @override
  String get typeMessage => 'Tanya tentang tanaman Anda...';

  @override
  String get typing => 'Mengetik...';

  @override
  String get chat => 'Chat';
}
