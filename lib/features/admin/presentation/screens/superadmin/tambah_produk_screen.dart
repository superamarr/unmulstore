
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pab/features/admin/domain/repositories/superadmin_repository.dart';
import 'package:pab/features/home/data/models/product_model.dart';
import 'package:pab/core/theme/app_theme.dart';
import 'package:pab/core/utils/security_utils.dart';
import 'package:pab/shared/widgets/primary_button.dart';
import 'package:pab/shared/widgets/custom_text_field.dart';
import 'package:pab/shared/widgets/confirm_action_sheet.dart';

class TambahProdukScreen extends StatefulWidget {
  final ProductModel? product;
  
  const TambahProdukScreen({super.key, this.product});

  @override
  State<TambahProdukScreen> createState() => _TambahProdukScreenState();
}

class _TambahProdukScreenState extends State<TambahProdukScreen> {
  final SuperAdminRepository _repo = SuperAdminRepository();
  final _formKey = GlobalKey<FormState>();
  
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _colorsCtrl = TextEditingController();
  final _sizesCtrl = TextEditingController();
  final _maxQtyCtrl = TextEditingController(text: '5');
  final _specCtrl = TextEditingController();
  final _sizeGuideCtrl = TextEditingController();
  
  // Rental configuration controllers
  final _depositCtrl = TextEditingController(text: '0');
  final _rentalDurationCtrl = TextEditingController(text: '3');
  final _lateFeeCtrl = TextEditingController(text: '20000');
  
  bool _isRentable = false;
  bool _isLoading = false;
  XFile? _imageFile;
  String? _existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      final p = widget.product!;
      debugPrint('AUTOFILL: Loading product ${p.title}');
      _titleCtrl.text = p.title;
      _descCtrl.text = p.description;
      _priceCtrl.text = p.price.toString();
      _stockCtrl.text = p.stock.toString();
      _maxQtyCtrl.text = p.maxQty.toString();
      _categoryCtrl.text = p.category ?? '';
      _isRentable = p.isRentable;
      _existingImageUrl = p.imagePath;
      _specCtrl.text = p.specifications ?? '';
      _sizeGuideCtrl.text = p.sizeGuide ?? '';
      _depositCtrl.text = p.deposit.toString();
      _rentalDurationCtrl.text = p.rentalDuration.toString();
      _lateFeeCtrl.text = p.lateFee.toString();
      if (p.colors != null) _colorsCtrl.text = p.colors!.join(',');
      if (p.sizes != null) _sizesCtrl.text = p.sizes!.join(',');
    } else {
      debugPrint('AUTOFILL: No product passed (Mode: Tambah)');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint("Gagal memilih gambar: $e");
    }
  }

  Future<void> _saveProduct() async {
    if (_imageFile == null && _existingImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih gambar produk terlebih dahulu!')));
      return;
    }

    // Validasi field wajib
    final title = _titleCtrl.text.trim();
    final description = _descCtrl.text.trim();
    final priceText = _priceCtrl.text.trim();
    final stockText = _stockCtrl.text.trim();
    final maxQtyText = _maxQtyCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama produk wajib diisi!')));
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deskripsi produk wajib diisi!')));
      return;
    }

    final price = int.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harga produk wajib diisi dan harus lebih dari 0!')));
      return;
    }

    final stock = int.tryParse(stockText);
    if (stock == null || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stok produk wajib diisi!')));
      return;
    }

    final maxQty = int.tryParse(maxQtyText);
    if (maxQty == null || maxQty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maksimal pembelian wajib diisi dan harus lebih dari 0!')));
      return;
    }

    // Validasi variasi ukuran dan warna
    final sizes = _sizesCtrl.text.trim();
    final colors = _colorsCtrl.text.trim();

    if (sizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Variasi ukuran wajib diisi! Jika tidak ada ukuran, isi dengan "-"')));
      return;
    }

    if (colors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Variasi warna wajib diisi! Jika tidak ada warna, isi dengan "-"')));
      return;
    }

    // Security check - XSS and SQL Injection
    final validationErrors = SecurityUtils.validateProductInput(
      title: title,
      description: description,
      price: priceText,
      stock: stockText,
      maxQty: maxQtyText,
      sizes: sizes,
      colors: colors,
    );

    if (validationErrors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationErrors.first)),
      );
      return;
    }

    final isEdit = widget.product != null;
    final confirm = await showConfirmActionSheet(
      context,
      variant: isEdit ? ConfirmActionVariant.update : ConfirmActionVariant.save,
      title: isEdit ? 'Perbarui produk?' : 'Simpan & publikasikan?',
      message: isEdit
          ? 'Apakah Anda yakin ingin memperbarui data produk ini?'
          : 'Apakah Anda yakin ingin menambahkan produk ini ke etalase?',
    );
    if (confirm != true || !mounted) return;

    await _persistProduct();
  }

  Future<void> _persistProduct() async {
    setState(() => _isLoading = true);

    try {
      String imageUrl = _existingImageUrl ?? '';

      if (_imageFile != null) {
        // Upload Gambar ke Supabase Storage
        final bytes = await _imageFile!.readAsBytes();
        final fileExt = _imageFile!.name.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        final path = 'public/$fileName';

        await Supabase.instance.client.storage
            .from('product-images')
            .uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(contentType: 'image/$fileExt'),
            );

        imageUrl = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl(path);
      }

      // Parsing tag Lists dengan sanitasi
      List<String> parseTags(String text) {
        if (text.trim().isEmpty) return [];
        return text.split(',')
            .map((e) => SecurityUtils.preventXSS(e.trim()))
            .where((e) => e.isNotEmpty)
            .toList();
      }

      // Sanitasi input sebelum simpan ke database
      final sanitizedTitle = SecurityUtils.preventXSS(_titleCtrl.text.trim());
      final sanitizedDesc = SecurityUtils.preventXSS(_descCtrl.text.trim());
      final sanitizedCategory = _categoryCtrl.text.isEmpty 
          ? null 
          : SecurityUtils.preventXSS(_categoryCtrl.text.trim());
      final sanitizedSpec = _specCtrl.text.isEmpty 
          ? null 
          : SecurityUtils.preventXSS(_specCtrl.text.trim());
      final sanitizedSizeGuide = _sizeGuideCtrl.text.isEmpty 
          ? null 
          : SecurityUtils.preventXSS(_sizeGuideCtrl.text.trim());

      // Simpan data ke tabel products
      final productData = {
        'id': widget.product?.id,
        'title': sanitizedTitle,
        'description': sanitizedDesc,
        'image_path': imageUrl,
        'price': SecurityUtils.parseSafeInt(_priceCtrl.text),
        'stock': SecurityUtils.parseSafeInt(_stockCtrl.text),
        'max_qty': SecurityUtils.parseSafeInt(_maxQtyCtrl.text, defaultValue: 5),
        'is_rentable': _isRentable,
        'category': sanitizedCategory,
        'colors': parseTags(_colorsCtrl.text),
        'sizes': parseTags(_sizesCtrl.text),
        'specifications': sanitizedSpec,
        'size_guide': sanitizedSizeGuide,
        'deposit': _isRentable ? SecurityUtils.parseSafeInt(_depositCtrl.text) : 0,
        'rental_duration': _isRentable ? SecurityUtils.parseSafeInt(_rentalDurationCtrl.text, defaultValue: 3) : 0,
        'late_fee': _isRentable ? SecurityUtils.parseSafeInt(_lateFeeCtrl.text, defaultValue: 20000) : 0,
      };
      
      // Preserve rating
      if (widget.product == null) {
         productData['rating'] = 0.0;
      }

      await _repo.saveProduct(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.product != null ? 'Produk berhasil diperbarui!' : 'Produk berhasil ditambahkan!'),
        ));
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildLabel(String text, {required bool required, String? hint}) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: const Color(0xFF1B1B1B),
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            )
          else
            TextSpan(
              text: ' (Opsional)',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          if (hint != null) ...[
            const TextSpan(text: '\n'),
            TextSpan(
              text: hint,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _categoryCtrl.dispose();
    _colorsCtrl.dispose();
    _sizesCtrl.dispose();
    _maxQtyCtrl.dispose();
    _specCtrl.dispose();
    _sizeGuideCtrl.dispose();
    _depositCtrl.dispose();
    _rentalDurationCtrl.dispose();
    _lateFeeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEdit ? 'Edit: ${widget.product?.title ?? "Produk"}' : 'Tambah Produk',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Gambar Upload ---
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 2, style: BorderStyle.solid),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: NetworkImage(_imageFile!.path), 
                                  fit: BoxFit.cover,
                                )
                              : _existingImageUrl != null && _existingImageUrl!.startsWith('http')
                                  ? DecorationImage(
                                      image: NetworkImage(_existingImageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: (_imageFile == null && _existingImageUrl == null)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: Colors.grey.shade400, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pilih Foto',
                                    style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 12),
                                  )
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  _buildLabel('Nama Produk', required: true),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'Contoh: T-Shirt Unmul',
                    controller: _titleCtrl,
                    maxLength: 60,
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Deskripsi', required: true),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'Penjelasan detail produk',
                    controller: _descCtrl,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Harga (Rp)', required: true),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hintText: '100000',
                              controller: _priceCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Stok', required: true),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hintText: '24',
                              controller: _stockCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Maksimal Pembelian / Sewa per Transaksi', required: true),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: '5',
                    controller: _maxQtyCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Variasi Ukuran', required: true, hint: 'Pisahkan dengan Koma'),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'Contoh: S,M,L,XL,XXL',
                    controller: _sizesCtrl,
                    maxLength: 100,
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Variasi Warna', required: true, hint: 'Pisahkan dengan Koma'),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'Contoh: Hitam,Putih,Navy',
                    controller: _colorsCtrl,
                    maxLength: 100,
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Spesifikasi Produk', required: false, hint: 'Tampil di Dropdown Bawah'),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'Bahan, Kualitas sablon, dll',
                    controller: _specCtrl,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Panduan Ukuran', required: false),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'S: Lebar 48x68, M: 50x70...',
                    controller: _sizeGuideCtrl,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 16),
                  _buildLabel('Kategori', required: false),
                  const SizedBox(height: 6),
                  CustomTextField(
                    hintText: 'Contoh: Merchandise',
                    controller: _categoryCtrl,
                    maxLength: 20,
                  ),

                  const SizedBox(height: 24),
                  
                  // --- Toggle Switch Rentable ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Produk Bisa Disewa?',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'Tandai jika barang berupa Toga/Almet',
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isRentable,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (val) {
                            setState(() {
                              _isRentable = val;
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  // Tampilkan field sewa jika disewa
                  if (_isRentable) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA), // teal light
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 18, color: const Color(0xFF0F766E)),
                              const SizedBox(width: 8),
                              Text(
                                'Pengaturan Sewa',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: const Color(0xFF0F766E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Biaya Jaminan / Deposit (Rp)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    const SizedBox(height: 6),
                                    CustomTextField(
                                      hintText: '50000',
                                      controller: _depositCtrl,
                                      keyboardType: TextInputType.number,
                                      maxLength: 9,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Batas Sewa (Hari)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    const SizedBox(height: 6),
                                    CustomTextField(
                                      hintText: '3',
                                      controller: _rentalDurationCtrl,
                                      keyboardType: TextInputType.number,
                                      maxLength: 3,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Biaya Keterlambatan per Hari (Rp)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 6),
                          CustomTextField(
                            hintText: '20000',
                            controller: _lateFeeCtrl,
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 48),

                  PrimaryButton(
                    text: isEdit ? 'Simpan Perubahan' : 'Simpan & Publikasikan',
                    onPressed: _saveProduct,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
    );
  }
}
