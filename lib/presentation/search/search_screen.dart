import 'dart:async';
import 'package:astro_shree_user/data/api_call/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/endpoints.dart';
import '../../data/model/search_model.dart';
import '../../widget/homepagewidgets/top_astrologers_card.dart';
import '../astro_profile/astrologers_profile.dart';
import '../e_pooja/pooja_listing.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  late TabController _tabController;
  final SearchControllerApi controller = Get.put(SearchControllerApi());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initial API call with empty search query to load all data
    // controller.fetchSearch(search: '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.toLowerCase();
        if(query.isNotEmpty){
          controller.fetchSearch(search: _searchQuery);
        }
      });
    });
  }

  List<Results> _filterAstrologers() {
    if (_searchQuery.isEmpty) {
      return controller.searchData.value.data?.astrologers?.results ?? [];
    }
    return controller.searchData.value.data?.astrologers?.results
        ?.where((astro) => astro.name?.toLowerCase().contains(_searchQuery) ?? false)
        .toList() ??
        [];
  }

  List<ProductsSearchData> _filterProducts() {
    if (_searchQuery.isEmpty) {
      return controller.searchData.value.data?.products?.results ?? [];
    }
    return controller.searchData.value.data?.products?.results
        ?.where((product) => product.name?.toLowerCase().contains(_searchQuery) ?? false)
        .toList() ??
        [];
  }

  List<PoojaData> _filterPoojas() {
    if (_searchQuery.isEmpty) {
      return controller.searchData.value.data?.poojas?.results ?? [];
    }
    return controller.searchData.value.data?.poojas?.results
        ?.where((pooja) => pooja.name?.toLowerCase().contains(_searchQuery) ?? false)
        .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Astrologers'),
            Tab(text: 'Products'),
            Tab(text: 'Remedies'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 16),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                _buildAstrologerTab(),
                _buildProductTab(),
                _buildPoojaTab(),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologerTab() {
    final astrologers = _filterAstrologers();
    return astrologers.isEmpty
        ? const Center(child: Text('No astrologers found'))
        : ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 16),
      itemCount: astrologers.length,
      itemBuilder: (context, index) {
        final astro = astrologers[index];
        return InkWell(
          onTap: (){
            Get.to(() =>
                AstrologersProfile(astroId: astro.sId.toString()));
          },
        child: Container(
        margin: const EdgeInsets.symmetric( vertical: 5),
        child: TopAstrologersListCard(
        imageUrl: EndPoints.base+ astro.profileImage.toString(),
        name: astro.name.toString(),
        position: astro.speciality!.where((e) => e.status!)
            .map((e) => e.name)
            .join(', '),
        language: astro.language!.join(', '),
        charge: "${astro.pricing!.chat}",
        comesFrom: 'chat',
        isCall: false,
        isChat: astro.services!.chat!,
        isPopular: index % 3 == 0,
        status: astro.status??"",
        isBusy: astro.isBusy!,
          experience: astro.experience.toString(),
        maxDuration: astro.maxWaitingTime??"",
        onPressed: () {
          Get.to(() =>
              AstrologersProfile(astroId: astro.sId.toString()));
        },
        onTap: () {
          Get.to(() =>
              AstrologersProfile(astroId: astro.sId.toString()));
        },
        ),
        ),);
            // child: _buildAstrologerCard(astro));
      },
    );
  }

  Widget _buildProductTab() {
    final products = _filterProducts();
    return products.isEmpty
        ? const Center(child: Text('No products found'))
        : ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildPoojaTab() {
    final poojas = _filterPoojas();
    return poojas.isEmpty
        ? const Center(child: Text('No poojas found'))
        : ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: poojas.length,
      itemBuilder: (context, index) {
        final pooja = poojas[index];
        return InkWell(
          onTap: (){
            Navigator.push(
                context,MaterialPageRoute(builder: (context) => ProductDetailScreen(poojaId: pooja.sId.toString(),),)
            );
          },
            child: _buildPoojaCard(pooja));
      },
    );
  }

  Widget _buildAstrologerCard(Results astro) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: astro.profileImage != null
                  ? NetworkImage(EndPoints.imageBaseUrl + astro.profileImage!)
                  : null,
              child: astro.profileImage == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    astro.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    astro.about ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Experience: ${astro.experience ?? 0} years',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Languages: ${astro.language?.join(", ") ?? 'N/A'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (astro.services?.chat ?? false)
                        _buildServiceChip('Chat: ₹${astro.pricing?.chat ?? 0}'),
                      if (astro.services?.voice ?? false)
                        _buildServiceChip('Voice: ₹${astro.pricing?.voice ?? 0}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductsSearchData product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.thumbImage != null
                  ? Image.network(
                EndPoints.imageBaseUrl + product.thumbImage!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 80),
              )
                  : const Icon(Icons.image_not_supported, size: 80),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.benefits ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: ₹${product.sellPrice ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (product.price != product.sellPrice)
                    Text(
                      'Original: ₹${product.price ?? 0}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoojaCard(PoojaData pooja) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: pooja.image != null
                  ? Image.network(
                EndPoints.imageBaseUrl + pooja.image!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 80),
              )
                  : const Icon(Icons.image_not_supported, size: 80),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pooja.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pooja.shortDescription ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: ₹${pooja.assignAstrologer?.isNotEmpty ?? false ? pooja.assignAstrologer![0].sellPrice ?? 0 : 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Benefits: ${pooja.benefits?.join(", ") ?? 'N/A'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.red[800],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}