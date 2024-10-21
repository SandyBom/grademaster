class Assesment {
  final int id;
  final String title, description, time, date;
  Assesment({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });
}

List<Assesment> demoAssesment = [
  Assesment(
      id: 1,
      title: 'Pemerograman Basis Data',
      time: '07:00 WIB',
      date: '10 September 2024',
      description: 'Lorem Ipsum juga deh ya biar panjang dikit aja lagi'),
  Assesment(
      id: 1,
      title: 'Pemerograman Basis Data',
      date: '1 Januari 2025',
      time: '07:00 WIB',
      description: 'Lorem Ipsum juga deh ya biar panjang dikit aja lagi'),
];
