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
    - [x] Gemini API anahtarını Supabase Edge Function Secrets içinde güvene al
    - [x] `/generate-questions` Edge Function'ı deploy edildi: Kaygı metnine özel 3–4 yönlendirici soru üretimi
    - [x] `/generate-relief-message` Edge Function'ı deploy edildi: Seans sonu rahatlama ve eylemi pekiştirme mesajı
    - [x] Canlı Supabase URL ve Publishable Key entegrasyonu tamamlandı
    - [x] Çevrimdışı/Hata durumları için mobil istemcide kural tabanlı yerel soru ve mesaj havuzu (Fallback)

---

## 🎨 Aşama 2: Temel Kullanıcı Akışı ve Dokunsal Deneyim (Core UX)
- [x] **Karşılama Ekranı (Welcome Screen)**
  - [x] Minimalist ve sakinleştirici açılış, “Başla” butonu
  - [x] Hızlı başlangıç (Anonim / Misafir oturumu arka planda başlar)
- [x] **Düşünce Giriş Ekranı (Thought Input)**
  - [x] Odaklanmayı artıran sade metin kutusu (“Aklını meşgul eden düşünceyi yaz.”)
  - [ ] İsteğe bağlı: Başlangıç kaygı seviyesi seçimi (1–10)
  - [x] Metnin animasyonla ortada büyük bir "Kaya" nesnesine dönüşmesi
- [x] **Kaya Kırma Deneyimi (Interactive Rock Breaking)**
  - [x] Koyu renkli sembolik kaya tasarımı
  - [x] Dokunma/vurma algılayıcıları ve dokunma başına görsel çatlama animasyonları
  - [x] Yumuşak haptic feedback (dokunsal geri bildirim)
  - [ ] İsteğe bağlı sakinleştirici ses efekti (cam, çakıl veya hafif nefes tınısı)
  - [x] Birkaç dokunuş sonrası kayanın 3–4 küçük taş parçasına ayrılması
- [x] **Taş Soruları ve Düşünce Süzgeci (Stone Prompts)**
  - [x] Supabase Edge Function / Fallback üzerinden gelen 3–4 AI sorusunun taşlar üzerinde gösterilmesi
  - [x] Taşa dokunulduğunda açılan kısa cevap yazma kartı
  - [x] Son sorunun mutlaka uygulanabilir mikro adıma odaklanması (“Şimdi yapabileceğin, iki dakikadan kısa tek bir adım ne?”)
- [x] **Sürükle-Bırak ile Temizleme (Swipe/Drag to Clear)**
  - [x] Cevaplanan taşın ekrandan dışarı sürüklenerek uzaklaştırılması (Dismissible)
  - [x] Hafif parçacık animasyonu ve haptic geri bildirimi
- [x] **Huzurlu Alan ve Seans Özeti (Peaceful Completion & Summary)**
  - [x] Tüm taşlar temizlendiğinde ferah, aydınlık ve huzurlu arka plan geçişi
  - [x] AI tarafından üretilen kişiselleştirilmiş rahatlama mesajı
  - [x] Vurgulanan "Tek Küçük Adım" kartı
  - [ ] İsteğe bağlı: Seans sonrası kaygı seviyesi değerlendirmesi (1–10)
  - [x] Seansı yerel veritabanına ve Supabase'e kaydetme

---

## 🛡️ Aşama 3: Güvenlik, Etik Tasarım ve Kriz Yönetimi
- [x] Yasal Sorumluluk Reddi (Disclaimer): "Bu uygulama tıbbi/terapi desteği yerine geçmez."
- [x] Kriz/Acil Durum Anahtar Kelime Filtresi (Kendine zarar, intihar, acil tehlike algılama)
- [x] Kriz algılandığında akışı durdurup doğrudan **Destek Ekranı**'na yönlendirme
- [x] Destek Ekranı: Ülkeye özel acil destek hatları (112, 183), doğrudan arama ve yakınlara ulaşma önerileri
- [x] **Veri Güvenliği ve Google Play Kuralları:**
  - [x] Hassas metinlerin Supabase'de RLS ile korunması ve HTTPS ile şifreli aktarımı
  - [x] Reklam kişiselleştirmesi veya 3. parti izleyicilerin hassas verilere erişiminin engellenmesi
  - [x] "Gizli Seans / Geçmişi Kaydetme" yerel tercihi desteği

---

## ⚙️ Aşama 4: Ayarlar, Hesap ve Geçmiş Ekranları
- [x] **Geçmiş Ekranı (History Screen)**
  - [x] Tarih bazlı seans listesi (yerel önbellekten anında listeleme + Supabase senkronizasyonu)
  - [x] Seans detaylarını görüntüleme (Kaygı metni, cevaplanan adımlar, küçük eylem)
  - [x] Tek tek seans silme imkânı (hem cihazdan hem Supabase'den silinir)
- [x] **Ayarlar Ekranı (Settings Screen)**
  - [x] Koyu / Açık tema desteği
  - [x] Haptic (titreşim) ve ses efektleri ayarları
  - [x] Erişilebilirlik ayarları (Animasyon azaltma)
  - [x] **Hesap ve Veri Yönetimi (Google Play Zorunluluğu):**
    - [x] **"Hesabımı ve Tüm Verilerimi Kalıcı Olarak Sil"** butonu (Account & Data Deletion)
  - [x] Gizlilik Politikası ve Sürüm bilgilendirmeleri

---

## 🧪 Aşama 5: Test ve Optimizasyon
- [ ] Düşük donanımlı cihazlarda animasyon akıcılığı (60 FPS hedefi)
- [ ] Ağ kesintisi testleri (İnternet yokken yerel sorularla seans tamamlama ve internet gelince eşitlenme)
- [ ] Supabase Edge Function yanıt süreleri ve hata yakalama senaryoları
- [ ] TalkBack / Ekran Okuyucu uyumluluğu
- [ ] Birim (Unit) ve Widget testlerinin hazırlanması

---

## 📦 Aşama 6: Google Play Store Yayını
- [x] Uygulama ikonu oluşturuldu ve Android/iOS/Web/Windows platformlarına yerleştirildi
- [ ] Splash screen tasarımı
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

---

## 🚨 Yayın Öncesi Zorunlu Güvenlik ve İşlevsellik Kontrolleri

Bu bölümdeki maddeler tamamlanıp gerçek cihaz ve Supabase ortamında doğrulanmadan uygulama Play Store'a gönderilmemelidir. Tranquilo; kaygı cümleleri, kullanıcı yanıtları ve ruh sağlığıyla ilişkili hassas veriler işlediği için bu kontroller doğrudan kullanıcı mahremiyetiyle ilgilidir.

### 1. Anonim oturumun gerçekten başlatılması ve RLS'in kapatılması

- [ ] **Uygulama açılır açılmaz Supabase anonim oturumu başlat.** `SupabaseService.signInAnonymously()` metodu mevcut, fakat uygulama başlangıcında çağrılmıyor. Oturum yokken kayıtlar `anonymous` kimliğiyle yazılabilir; bunun yerine her kullanıcıya Supabase Auth tarafından üretilmiş benzersiz bir anonim `auth.uid()` atanmalıdır.
- [ ] **`sessions` RLS politikalarından `OR user_id = 'anonymous'` koşulunu kaldır.** Bu koşul, anonim etiketli kayıtların başka anonim istemciler tarafından da okunmasına, değiştirilmesine veya silinmesine yol açabilir. SELECT / INSERT / UPDATE / DELETE politikaları yalnızca `auth.uid()::text = user_id` doğrulamasına dayanmalıdır.
- [ ] **`user_id` alanının istemciden güvenilerek gelmesini engelle.** Yeni kayıt oluştururken kullanıcı kimliğini oturumdaki `auth.uid()` ile eşleştir; test ortamında başka bir kullanıcıyla giriş yaparak bir kullanıcının diğerinin seanslarını göremediğini, güncelleyemediğini ve silemediğini doğrula.
- [ ] **Oturum başlatılamazsa bulut eşitlemeyi durdur.** Anonim giriş başarısız olduğunda uygulama yerel/fallback modda devam edebilir; ancak `anonymous` ortak kimliğiyle Supabase'e hassas seans verisi göndermemelidir.

### 2. Hesap ve tüm verileri silme akışını gerçek ve doğrulanabilir yap

- [ ] **`delete-user-account` Supabase Edge Function'ını oluştur ve deploy et.** Mobil uygulama bu fonksiyonu çağırıyor, fakat proje içinde fonksiyon henüz bulunmuyor. Fonksiyon yalnızca çağrıyı yapan kullanıcının JWT'sinden alınan kullanıcıyı silebilmeli; istemcinin gönderdiği herhangi bir kullanıcı kimliğine güvenmemelidir.
- [ ] **Silme sırasını sunucuda güvenli biçimde tamamla.** Önce yalnızca oturumdaki kullanıcıya ait `sessions` kayıtlarını sil, sonra Supabase Auth kullanıcısını admin yetkisiyle sil. Service-role anahtarı hiçbir koşulda mobil uygulamaya eklenmemeli; yalnızca Edge Function secret olarak tutulmalıdır.
- [ ] **Başarı/başarısızlık bilgisini kullanıcıya doğru göster.** Şu an yerel veriler temizlendikten sonra uzak silme başarısız olsa bile başarılı mesajı gösterilebilir. İşlem sonucu kullanıcıya açıkça bildirilmeli; başarısızlıkta yeniden deneme veya destek yönlendirmesi sunulmalıdır.
- [ ] **Silme senaryosunu iki farklı test kullanıcısıyla doğrula.** Birinci kullanıcı kendi verilerini silebilmeli; ikinci kullanıcının kayıtları kesinlikle etkilenmemelidir. Silme sonrasında hem cihazdaki Hive kutusu hem Supabase `sessions` tablosu hem de Auth kullanıcısı kontrol edilmelidir.
- [ ] **Play Store için herkese açık hesap silme URL'si hazırla.** Uygulama içindeki silme butonuna ek olarak, Google Play Console'da verilecek web sayfası kullanıcıya hangi verinin silindiğini, silme sürecini ve iletişim yolunu açıklamalıdır.

### 3. Ayarları yalnızca kaydetmek yerine uygulama davranışına bağla

- [ ] **Haptic ayarını tüm titreşim çağrılarına bağla.** Kullanıcı “Dokunsal Titreşim”i kapattığında kaya kırma ve taşı kaydırma sırasında `HapticFeedback` veya `Vibration` hiç çağrılmamalıdır.
- [ ] **“Animasyonları azalt” tercihini erişilebilirlik özelliğine dönüştür.** AnimatedSwitcher, kaya sallanması, ölçeklenme, parlama ve geçiş süreleri bu tercih açıkken azaltılmalı veya anlık geçişe çevrilmelidir. Sistem düzeyindeki “animasyonları kaldır” tercihi de mümkünse dikkate alınmalıdır.
- [ ] **Ses ayarını tamamla ya da ilk sürümden kaldır.** Ses açıkken yalnızca kullanıcının başlattığı etkileşimlerde yumuşak ses oynatılmalı; kapalıyken hiçbir ses yüklenmemeli/çalınmamalıdır. Ses dosyaları ve ses seviyesi tasarımı hazır değilse ayarı görünür bırakmak yerine sonraki sürüme taşımak daha dürüst olur.
- [ ] **Açık/koyu tema tercihini ekle.** Uygulama şu an koyu modla sabit açılıyor. Ayarlara tema seçimi eklenmeli; `system`, `light` ve `dark` seçenekleri kalıcı olarak saklanmalı ve bütün ekranlar seçime uygun renk/kontrastla test edilmelidir.

### 4. Ürün akışındaki eksiklerin tamamlanması

- [ ] **Geçmiş seans detay ekranını ekle.** Geçmiş listesinde kullanıcı bir kayda dokunduğunda kaygı metni, AI soruları, isteğe bağlı yanıtlar, mikro adım, rahatlatıcı mesaj ve tarih gösterilmelidir. Hassas metinlerin bildirimlerde veya uygulama önizlemelerinde görünmemesine dikkat edilmelidir.
- [ ] **"Geçmişi hiç kaydetme" tercihini test et.** Bu seçenek açıkken seansın Hive'a da Supabase'e de yazılmadığını; önceki kayıtların otomatik silinmediğini ve kullanıcıya davranışın açıkça anlatıldığını doğrula.
- [ ] **Kriz filtresi için negatif ve pozitif test seti oluştur.** Kendine zarar riski taşıyan Türkçe/İngilizce farklı ifadeler destek ekranına yönlendirmeli; bağlam dışı veya zararsız cümlelerde yanlış pozitif üretmemelidir. Bu filtre ek güvenlik katmanıdır; tek başına kriz tespiti garantisi olarak sunulmamalıdır.
- [ ] **AI Edge Function'larına kötüye kullanımı önleyecek sınırlar koy.** Her çağrıda geçerli kullanıcı oturumu doğrulanmalı, istek boyutu sınırlandırılmalı ve kullanıcı/IP başına makul oran sınırlaması uygulanmalıdır. Bu hem hassas veri erişimini hem de Gemini maliyetini korur.

### 5. Doğrulama ve yayın kararı

- [ ] **Gerçek cihazlarda Flutter analiz, widget testi ve release build çalıştır.** En az bir düşük/orta seviye Android cihazda kaya animasyonu, klavye görünümü, ekran boyutu, koyu/açık tema, titreşim kapalı durumu ve çevrimdışı fallback akışı kontrol edilmelidir.
- [ ] **Supabase ortamını ayrı test ve canlı projelere böl.** Geliştirme/test sırasında gerçek kullanıcı verisi veya canlı Gemini maliyeti kullanılmamalı; canlı URL, publishable key ve Edge Function secret'ları yayın anında ayrı ortamdan yönetilmelidir.
- [ ] **Gizlilik politikası ve Data Safety beyanını gerçek davranışla eşleştir.** Kaygı metinleri, kullanıcı kimliği, yerel depolama, Supabase aktarımı, AI işleme ve veri silme süreçleri açıkça belirtilmeli; uygulamada olmayan bir güvenlik özelliği beyan edilmemelidir.
