# 📌 Tranquilo — Yapılacaklar Listesi (TODO)

Bu belge, **Tranquilo** (Düşünce Süzgeci) projesinin Play Store standartlarına uygun mimari altyapısını (**Local-First + Supabase**), teknik gereksinimlerini ve yayınlama adımlarını içermektedir.

---

## 🚀 Aşama 1: Proje Kurulumu ve Mimari Altyapı
- [x] Flutter projesini oluştur (`com.zehratuncer.tranquilo`)
- [x] Klasör mimarisini kur (Clean Architecture / Feature-First: `core`, `features`, `data`, `presentation`)
- [x] Durum yönetimi (State Management) entegrasyonu (Riverpod)
- [x] **Tasarım & Tema Sistemi:**
  - [x] Renk paletini tanımla (Bordo: `#750002`, Pembe: `#f1a2df`, yumuşak geçiş tonları)
  - [x] Koyu (Dark) ve Açık (Light) tema desteği
  - [ ] Erişilebilirlik: Dinamik metin boyutu ve animasyon azaltma modu
- [x] **Local-First Yerel Depolama (Offline-First):**
  - [x] Yerel veritabanı kurulumu (Hive)
  - [x] Çevrimdışı senkronizasyon kuyruğu (offline queue: bağlantı gelince Supabase'e gönder)
- [x] **Supabase Backend Entegrasyonu:**
  - [x] Supabase projesini oluştur ve Flutter SDK'yı entegre et
  - [x] **Auth (Kimlik Doğrulama):**
    - [x] Anonim Giriş (Guest Mode - Kullanıcıyı kayıtla boğmadan doğrudan deneyim sunma)
    - [ ] Google Sign-In & E-posta/Şifre ile hesabı kalıcı hale getirme (Upgrade account)
  - [x] **Veritabanı & RLS (Row Level Security):**
    - [x] `sessions` tablosu ve RLS SQL şeması (`supabase_schema.sql`)
    - [x] Sıkı RLS politikaları (Her kullanıcı yalnızca kendi hassas verisine erişebilir)
  - [x] **Edge Functions (Güvenli AI Proxy):**
    - [x] AI Edge Function istemci çağrıları (`generate-questions`, `generate-relief-message`)
    - [x] Çevrimdışı/Hata durumları için mobil istemcide kural tabanlı yerel soru ve mesaj havuzu (Fallback)

---

## 🎨 Aşama 2: Temel Kullanıcı Akışı ve Dokunsal Deneyim (Core UX)
- [ ] **Karşılama Ekranı (Welcome Screen)**
  - [ ] Minimalist ve sakinleştirici açılış, “Başla” butonu
  - [ ] Hızlı başlangıç (Anonim / Misafir oturumu arka planda başlar)
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
  - [ ] Supabase Edge Function üzerinden gelen 3–4 AI sorusunun taşlar üzerinde gösterilmesi
  - [ ] Taşa dokunulduğunda açılan kısa cevap yazma/seçenek kartı
  - [ ] Son sorunun mutlaka uygulanabilir mikro adıma odaklanması (“Şimdi yapabileceğin, iki dakikadan kısa tek bir adım ne?”)
- [ ] **Sürükle-Bırak ile Temizleme (Swipe/Drag to Clear)**
  - [ ] Cevaplanan taşın ekrandan dışarı sürüklenerek uzaklaştırılması
  - [ ] Hafif parçacık animasyonu ve haptic geri bildirimi
- [ ] **Huzurlu Alan ve Seans Özeti (Peaceful Completion & Summary)**
  - [ ] Tüm taşlar temizlendiğinde ferah, aydınlık ve huzurlu arka plan geçişi
  - [ ] AI tarafından üretilen kişiselleştirilmiş rahatlama mesajı
  - [ ] Vurgulanan "Tek Küçük Adım" kartı
  - [ ] İsteğe bağlı: Seans sonrası kaygı seviyesi değerlendirmesi (1–10)
  - [ ] Seansı yerel veritabanına ve Supabase'e kaydetme

---

## 🛡️ Aşama 3: Güvenlik, Etik Tasarım ve Kriz Yönetimi
- [ ] Yasal Sorumluluk Reddi (Disclaimer): "Bu uygulama tıbbi/terapi desteği yerine geçmez."
- [ ] Kriz/Acil Durum Anahtar Kelime Filtresi (Kendine zarar, intihar, acil tehlike algılama)
- [ ] Kriz algılandığında akışı durdurup doğrudan **Destek Ekranı**'na yönlendirme
- [ ] Destek Ekranı: Ülkeye özel acil destek hatları, güvendiğin birine ulaşma önerileri
- [ ] **Veri Güvenliği ve Google Play Kuralları:**
  - [ ] Hassas metinlerin Supabase'de RLS ile korunması ve HTTPS ile şifreli aktarımı
  - [ ] Reklam kişiselleştirmesi veya 3. parti izleyicilerin hassas verilere erişiminin engellenmesi
  - [ ] "Gizli Seans / Geçmişi Kaydetme" modu

---

## ⚙️ Aşama 4: Ayarlar, Hesap ve Geçmiş Ekranları
- [ ] **Geçmiş Ekranı (History Screen)**
  - [ ] Tarih bazlı seans listesi (yerel önbellekten anında listeleme + Supabase senkronizasyonu)
  - [ ] Seans detaylarını görüntüleme (Kaygı metni, cevaplanan adımlar, küçük eylem)
  - [ ] Tek tek seans silme imkânı (hem cihazdan hem Supabase'den silinir)
- [ ] **Ayarlar Ekranı (Settings Screen)**
  - [ ] Koyu / Açık tema geçişi
  - [ ] Haptic (titreşim) ve ses efektleri ayarları
  - [ ] Erişilebilirlik ayarları (Animasyon azaltma, büyük font)
  - [ ] **Hesap ve Veri Yönetimi (Google Play Zorunluluğu):**
    - [ ] Misafir hesabı Google / E-posta ile bağlama (Verileri kaybetmeden yedekleme)
    - [ ] Çıkış Yap butonu
    - [ ] **"Hesabımı ve Tüm Verilerimi Kalıcı Olarak Sil"** butonu (Account & Data Deletion)
  - [ ] Gizlilik Politikası ve Kullanım Koşulları sayfalarına bağlantılar

---

## 🧪 Aşama 5: Test ve Optimizasyon
- [ ] Düşük donanımlı cihazlarda animasyon akıcılığı (60 FPS hedefi)
- [ ] Ağ kesintisi testleri (İnternet yokken yerel sorularla seans tamamlama ve internet gelince eşitlenme)
- [ ] Supabase Edge Function yanıt süreleri ve hata yakalama senaryoları
- [ ] TalkBack / Ekran Okuyucu uyumluluğu
- [ ] Birim (Unit) ve Widget testlerinin hazırlanması

---

## 📦 Aşama 6: Google Play Store Yayını
- [ ] Uygulama ikonu ve splash screen tasarımı
- [ ] Feature Graphic (Öne çıkan görsel) ve 4–6 adet mağaza ekran görüntüsü
- [ ] Mağaza açıklaması ve anahtar kelimelerin hazırlanması (Türkçe)
- [ ] Gizlilik Politikası web sayfasının hazırlanıp yayınlanması (URL)
- [ ] **Google Play Console "Data Safety" (Veri Güvenliği) Beyanı:**
  - [ ] Supabase kullanımı (Verilerin şifreli aktarımı, kullanıcı kimliği ve uygulama içi metinlerin toplanması)
  - [ ] Hesap silme URL'si ve uygulama içi hesap silme akışının belgelenmesi
- [ ] İçerik Derecelendirme (Content Rating) anketinin tamamlanması
- [ ] Target SDK ve en son Android sürümleriyle uyumluluk kontrolü
- [ ] Android App Bundle (`.aab`) derlemesi ve imzalanması
- [ ] Kapalı Test (Closed Testing) süreci ve geri bildirimlerin toplanması
- [ ] Production yayını 🚀
