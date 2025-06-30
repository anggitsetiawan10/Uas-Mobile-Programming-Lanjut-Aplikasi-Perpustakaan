import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../services/loan_service.dart';
import '../models/loan_model.dart';
import '../main.dart'; // agar bisa akses routeObserver

import 'home_content.dart';
import 'searching.dart';
import 'history.dart';
import 'profil_page.dart';
import 'loan_list.dart'; // Import LoanListPage

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> with RouteAware {
  int _selectedIndex = 0;
  int _activeLoanCount = 0;

  final List<Widget> _pages = [
    HomeContentPage(),
    SearchingPage(),
    UserReviewsPage(),
    ProfilePage(),
  ];

  final List<String> _pageTitles = [
    "Perpustakaan Online",
    "Pencarian Buku",
    "Riwayat Review",
    "Profil Saya",
  ];

  final List<Icon> _pageIcons = [
    Icon(Icons.local_library, color: Colors.white),
    Icon(Icons.search, color: Colors.white),
    Icon(Icons.history, color: Colors.white),
    Icon(Icons.person, color: Colors.white),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadActiveLoanCount() async {
    try {
      final loans = await LoanService().fetchUserLoans();
      final activeLoans = loans
          .where((l) => l.status == 'dibooking' || l.status == 'dipinjam')
          .length;
      setState(() {
        _activeLoanCount = activeLoans;
      });
    } catch (e) {
      print("❌ Gagal mengambil data peminjaman: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadActiveLoanCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!); // Daftar ke RouteObserver
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // Hapus langganan RouteObserver
    super.dispose();
  }

  @override
  void didPopNext() {
    // Dipanggil saat kembali ke halaman ini dari halaman lain
    _loadActiveLoanCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        title: Row(
          children: [
            _pageIcons[_selectedIndex],
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _pageTitles[_selectedIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: badges.Badge(
              showBadge: _activeLoanCount > 0,
              badgeContent: Text(
                '$_activeLoanCount',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
                shape: badges.BadgeShape.circle,
              ),
              position: badges.BadgePosition.topEnd(top: -5, end: -5),
              child: IconButton(
                icon: const Icon(Icons.library_books, color: Colors.white),
                tooltip: 'Peminjaman Saya',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoanListPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pencarian"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Saya"),
        ],
      ),
    );
  }
}
