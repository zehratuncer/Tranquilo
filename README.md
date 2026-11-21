# 🧘 Tranquilo — Düşünce Süzgeci

> **"Düşünce yok olmadı; ama artık daha taşınabilir."**

Tranquilo, kaygıyı “çözülmesi gereken devasa bir problem” olarak görmek yerine; onu dokunsal ve görsel etkileşimlerle küçük, yönetilebilir parçalara bölen bir **Android wellness ve farkındalık uygulamasıdır**.

Kullanıcı zihnini meşgul eden düşünceyi yazar; bu düşünce sembolik bir **kayaya** dönüşür. Kullanıcı kayaya dokunarak onu çatlatır ve küçük taş parçalarına ayırır. Her bir taş, kullanıcının kaygısına özel üretilen **düşünce süzgeci sorularını** barındırır. Taşlar cevaplanıp ekrandan uzaklaştırıldığında geriye sakin bir zihin ve atılabilecek **tek bir küçük adım** kalır.

---

## ✨ Temel Özellikler

- **Düşünceyi Somutlaştırma:** Yazılan kaygı cümlesi ağır, koyu renkli bir kaya nesnesine dönüşür.
- **Dokunsal Parçalama (Haptic & Crack):** Dokunarak kayayı kırma, gerçekçi çatlama animasyonları ve yumuşak dokunsal geri bildirimler (haptic feedback).
- **Yapay Zeka Destekli Düşünce Süzgeci:** Kaygının içeriğine uygun olarak dinamik oluşturulan 3–4 yönlendirici soru (Bilişsel Davranışçı Terapi prensiplerinden ilham alan soru süzgeci).
- **Mikro Eyleme Dönüştürme:** Seans sonunda 2 dakikadan kısa sürecek, hemen uygulanabilir "tek küçük adım" belirleme.
- **Sürükle ve Temizle:** Cevaplanan taşları ekrandan sürükleyerek uzaklaştırma ve parçacık animasyonu ile huzurlu bir alana geçiş.
- **Kişiselleştirilmiş Rahatlama Mesajı:** Seans sonunda AI destekli, garantici olmayan fakat şefkatli kapanış özeti.
- **Sıfır Sürtünmeli Başlangıç (Guest Mode):** Kullanıcıyı kayıt formlarıyla boğmadan doğrudan anonim oturumla başlatma; dilediğinde verilerini Google ile yedekleme imkânı.
- **Kriz ve Etik Güvenlik Katmanı:** Kendine zarar veya acil risk içeren ifadelerde seans durdurularak kullanıcı doğrudan profesyonel destek hatlarına yönlendirilir.

---

## 🎨 Tasarım ve Etkileşim Dili

- **Renk Paleti:**
  - Bordo: `#750002` (Yoğunluk, başlangıçtaki ağırlık)
  - Pembe: `#f1a2df` (Ferahlık, hafifleme ve vurgu tonları)
- **Görsel Evrim:** Seans başlangıcında yoğun, karanlık ve odaklanmış; taşlar temizlendikçe aydınlık, açık ve huzurlu bir atmosfer.
- **Duyusal Geri Bildirim:** Yumuşak titreşimler, isteğe bağlı çakıl/cam/nefes ses efektleri.
- **Erişilebilirlik:** Animasyon azaltma modu, titreşim kapatma ve dinamik yazı tipi ölçekleme.

---

## 🛠️ Teknik Altyapı ve Veri Mimarisi

Uygulama, hem yüksek performans hem de Google Play Store standartlarında veri güvenliği sağlamak için **Local-First + Supabase (Hibrit)** mimarisini kullanır:

```
[Flutter UI]
     │
     ▼ (Anında Yazma / Okuma)
[Yerel Önbellek: Hive/SQLite] ──(Çevrimdışı Kesintisiz Çalışma)
     │
     ▼ (Arka Planda Senkronizasyon)
[Supabase Backend]
     ├── Auth (Anonim Giriş / Google Sign-In)
     ├── Postgres DB + Row Level Security (Kullanıcıya özel şifreli oturumlar)
     └── Edge Functions (AI Proxy: Gemini API anahtarını gizler, soruları üretir)
```

- **Frontend / Mobil:** [Flutter](https://flutter.dev/) (Dart)
- **Durum Yönetimi:** BLoC veya Riverpod
- **Yerel Depolama (Local-First):** Hive / SQLite / Isar (Metroda, internetsiz ortamda bile kaya kırma akışı donmaz)
- **Backend Servisi:** [Supabase](https://supabase.com/)
  - **Auth:** Anonim (Misafir) giriş + Google / E-posta hesap bağlama
  - **Database:** PostgreSQL (Row Level Security ile kullanıcı bazında izole veri güvenliği)
  - **Edge Functions:** Gemini API anahtarını istemciye sızdırmadan güvenli AI soru & rahatlama mesajı üretimi
  - **Hesap & Veri Silme:** Play Store zorunlu kuralı uyarınca uygulama içi tek tıkla hesap ve veri imhası

---

## 📱 Ekranlar

| Ekran | Açıklama |
|---|---|
| **Karşılama** | Minimalist karşılama, uygulamanın amacı ve "Başla" butonu |
| **Düşünce Girişi** | Kaygının tek cümleyle ifade edildiği odaklanma alanı |
| **Kaya Ekranı** | Dokunarak kayayı kırma ve parçalama deneyimi |
| **Taş Soruları** | Her bir taş parçasının temsil ettiği AI destekli süzgeç soruları |
| **Sürükleme Alanı** | Cevaplanan taşları savurarak uzaklaştırma |
| **Seans Özeti** | Huzurlu kapanış, rahatlama mesajı ve belirlenen küçük eylem |
| **Geçmiş** | Yerel önbellekten anında okunan, Supabase ile senkronize seans geçmişi |
| **Ayarlar & Hesap** | Tema, ses, haptic, veri silme, hesap bağlama ve yasal metinler |
| **Destek / Kriz Ekranı** | Riskli durumlarda devreye giren acil yardım rehberi |

---

## ⚠️ Önemli Sorumluluk Reddi (Disclaimer)

**Tranquilo bir terapi, teşhis veya tıbbi tedavi aracı değildir.**
Uygulama, bireylerin anlık stres ve kaygı anlarında düşüncelerini düzenlemelerine ve hafifletmelerine yardımcı olmak amacıyla tasarlanmış bir kişisel farkındalık ve rahatlama aracıdır. Ciddi psikolojik destek gerektiren durumlarda mutlaka uzman bir sağlık profesyoneline başvurulmalıdır.

---

## 🗺️ Yol Haritası ve Görevler

Ayrıntılı geliştirme görevleri, Supabase entegrasyon adımları ve Google Play Store kontrol listesi için lütfen [TODO.md](file:///c:/Users/Zehra/Desktop/Projeler/Tranquilo/TODO.md) dosyasını inceleyin.
