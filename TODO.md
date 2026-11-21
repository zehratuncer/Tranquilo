# 📌 Tranquilo — Yapılacaklar Listesi (TODO)

Bu belge, **Tranquilo** (Düşünce Süzgeci) projesinin planlanan geliştirme adımlarını, teknik mimari gereksinimlerini ve yayınlama kontrol listesini içermektedir.

---

## 🚀 Aşama 1: Proje Kurulumu ve Mimari Altyapı
- [ ] Flutter projesini oluştur (`com.zehratuncer.tranquilo`)
- [ ] Klasör mimarisini kur (Clean Architecture / Feature-First: `core`, `features`, `data`, `presentation`)
- [ ] Durum yönetimi (State Management) kütüphanesini seç ve entegre et (Bloc/Riverpod önerilir)
- [ ] Tasarım & Tema Sistemi:
  - [ ] Renk paletini tanımla (Bordo: `#750002`, Pembe: `#f1a2df`, arka planlar ve yumuşak geçiş tonları)
  - [ ] Koyu (Dark) ve Açık (Light) tema desteği
  - [ ] Tipografi ve yazı boyutu erişilebilirlik ayarları
- [ ] Yerel Depolama (Local Storage):
  - [ ] Hive veya Isar/sqflite kurulumu
  - [ ] Veri modeli (`SessionModel`) implementasyonu (id, createdAt, worryText, intensityBefore/After, answers, smallAction vb.)
  - [ ] Güvenli şifreleme/yerel saklama ve tek dokunuşla "Tüm Verileri Temizle" servisi
- [ ] AI Servis Entegrasyonu:
  - [ ] AI istemci modülünü oluştur (Gemini API vb.)
  - [ ] Prompt şablonları: Kullanıcının girdiği kaygı cümlesine özel 3-4 yönlendirilmiş soru üretimi
  - [ ] Prompt şablonları: Seans sonunda kaygıya özel rahatlama ve eylem pekiştirme mesajı üretimi
  - [ ] Çevrimdışı/Yedek (Fallback) durumlar için yerel soru havuzu ve kural tabanlı mesaj sistemi

---

## 🎨 Aşama 2: Temel Kullanıcı Akışı ve Dokunsal Deneyim (Core UX)
- [ ] **Karşılama Ekranı (Welcome Screen)**
  - [ ] Minimalist ve sakinleştirici karşılama metni
  - [ ] "Başla" butonu ve gizlilik/sorumluluk reddi notu
- [ ] **Düşünce Giriş Ekranı (Thought Input)**
  - [ ] Odaklanmayı artıran sade metin kutusu (“Aklını meşgul eden düşünceyi yaz.”)
  - [ ] İsteğe bağlı: Başlangıç kaygı seviyesi seçimi (1–10)
  - [ ] Metnin animasyonla ortada büyük bir "Kaya" nesnesine dönüşmesi
- [ ] **Kaya Kırma Deneyimi (Interactive Rock Breaking)**
  - [ ] Koyu renkli sembolik kaya tasarımı
  - [ ] Dokunma/vurma algılayıcıları ve dokunma başına görsel çatlama animasyonları
  - [ ] Yumuşak haptic feedback (dokunsal geri bildirim)
  - [ ] İsteğe bağlı sakinleştirici ses efekti (cam, çakıl veya hafif nefes tınısı)
  - [ ] Birkaç dokunuş sonrası kayanın 3–4 küçük taş parçasına ayrılması
- [ ] **Taş Soruları ve Düşünce Süzgeci (Stone Prompts)**
  - [ ] AI tarafından üretilen 3–4 spesifik sorunun taşlar üzerinde gösterilmesi
  - [ ] Taşa dokunulduğunda açılan kısa cevap yazma/seçenek kartı
  - [ ] Son sorunun mutlaka uygulanabilir mikro adıma odaklanması (“Şimdi yapabileceğin, iki dakikadan kısa tek bir adım ne?”)
- [ ] **Sürükle-Bırak ile Temizleme (Swipe/Drag to Clear)**
  - [ ] Cevaplanan taşın ekrandan dışarı sürüklenerek fırlatılması
  - [ ] Hafif parçacık (particle) animasyonu ve yumuşak haptic geri bildirimi
- [ ] **Huzurlu Alan ve Seans Özeti (Peaceful Completion & Summary)**
  - [ ] Tüm taşlar temizlendiğinde ferah, boş ve huzurlu arka plan geçişi
  - [ ] AI tarafından üretilen kişiselleştirilmiş rahatlama mesajı
  - [ ] Vurgulanan "Tek Küçük Adım" kartı
  - [ ] İsteğe bağlı: Seans sonrası kaygı seviyesi değerlendirmesi (1–10)

---

## 🛡️ Aşama 3: Güvenlik, Etik Tasarım ve Kriz Yönetimi
- [ ] Yasal Sorumluluk Reddi (Disclaimer): "Bu uygulama tıbbi/terapi desteği yerine geçmez."
- [ ] Kriz/Acil Durum Anahtar Kelime Filtresi (Kendine zarar, intihar, acil tehlike algılama)
- [ ] Kriz algılandığında akışı durdurup doğrudan **Destek Ekranı**'na yönlendirme
- [ ] Destek Ekranı: Ülkeye özel acil destek hatları, güvendiğin birine ulaşma önerileri
- [ ] Veri Gizliliği:
  - [ ] Kullanıcının hassas metinlerinin yalnızca cihazda kalması / anonim işlenmesi
  - [ ] "Geçmişi Hiç Kaydetme" gizlilik modu seçeneği
  - [ ] Reklam izleme ve kişiselleştirilmiş veri kullanımından tamamen kaçınma

---

## ⚙️ Aşama 4: Ayarlar ve Geçmiş Ekranları
- [ ] **Geçmiş Ekranı (History Screen)**
  - [ ] Tarih bazlı seans listesi
  - [ ] Seans detaylarını görüntüleme (Kaygı metni, cevaplanan adımlar, küçük eylem)
  - [ ] Tek tek seans silme veya dışa aktarma
- [ ] **Ayarlar Ekranı (Settings Screen)**
  - [ ] Koyu / Açık tema geçişi
  - [ ] Haptic (titreşim) açma/kapatma
  - [ ] Ses efektleri açma/kapatma
  - [ ] Animasyon azaltma (Erişilebilirlik modu)
  - [ ] Metin boyutu ayarlama
  - [ ] "Tüm Verileri Sıfırla ve Sil" fonksiyonu
  - [ ] Gizlilik Politikası ve Hakkında bağlantıları

---

## 🧪 Aşama 5: Test, Optimizasyon ve Erişilebilirlik
- [ ] Animasyon FPS ve performans optimizasyonu (düşük donanımlı cihazlarda test)
- [ ] Ekran boyutu ve yönelim adaptasyonları (Responsive layout)
- [ ] TalkBack / Ekran Okuyucu uyumluluğu
- [ ] Ağ kesintisi / Çevrimdışı modda AI yedekleme davranışı testleri
- [ ] Birim (Unit) ve Widget testlerinin yazılması

---

## 📦 Aşama 6: Google Play Store Yayını
- [ ] Uygulama ikonu ve splash screen tasarımı
- [ ] Feature Graphic (Öne çıkan görsel) ve 4–6 adet mağaza ekran görüntüsü
- [ ] Mağaza açıklaması ve anahtar kelimelerin hazırlanması (Türkçe)
- [ ] Gizlilik Politikası sayfasının yayınlanması (URL)
- [ ] Google Play Console "Data Safety" (Veri Güvenliği) formunun doldurulması
- [ ] İçerik Derecelendirme (Content Rating) anketinin tamamlanması
- [ ] Target SDK ve en son Android uyumluluk doğrulamaları
- [ ] Android App Bundle (`.aab`) derlemesi ve imzalanması
- [ ] Kapalı Test (Closed Testing) süreci ve kullanıcı geri bildirimlerinin toplanması
- [ ] Production yayını 🚀
