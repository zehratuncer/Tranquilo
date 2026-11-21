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
- **Tam Gizlilik ve Cihaz İçi Saklama:** Veriler varsayılan olarak yalnızca kullanıcının telefonunda tutulur; üyelik ve sunucu bağımlılığı gerektirmez. İstenildiği an tek tuşla tüm geçmiş silinebilir.
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

## 🛠️ Teknik Altyapı

- **Framework:** [Flutter](https://flutter.dev/) (Android öncelikli)
- **Mimari:** Feature-First / Clean Architecture
- **State Management:** BLoC / Riverpod
- **Yerel Veritabanı:** Hive / Isar (Çevrimdışı öncelikli, güvenli yerel depolama)
- **AI Entegrasyonu:** Gemini API (Kişiselleştirilmiş soru ve kapanış mesajı üretimi, çevrimdışı durumlar için kural tabanlı yerel soru havuzu desteği)

---

## 📱 Ekranlar

| Ekran | Açıklama |
|---|---|
| **Karşılama** | Minimalist karşılama, uygulamanın amacı ve "Başla" butonu |
| **Düşünce Girişi** | Kaygının tek cümleyle ifade edildiği odaklanma alanı |
| **Kaya Ekranı** | Dokunarak kayayı kırma ve parçalama deneyimi |
| **Taş Soruları** | Her bir taş parçasının temsil ettiği bilişsel süzgeç soruları |
| **Sürükleme Alanı** | Cevaplanan taşları savurarak uzaklaştırma |
| **Seans Özeti** | Huzurlu kapanış, rahatlama mesajı ve belirlenen küçük eylem |
| **Geçmiş** | İsteğe bağlı yerel kayıtlar ve geçmiş seans incelemesi |
| **Ayarlar** | Tema, ses, haptic, veri silme ve yasal bilgilendirmeler |
| **Destek / Kriz Ekranı** | Riskli durumlarda devreye giren acil yardım rehberi |

---

## ⚠️ Önemli Sorumluluk Reddi (Disclaimer)

**Tranquilo bir terapi, teşhis veya tıbbi tedavi aracı değildir.**
Uygulama, bireylerin anlık stres ve kaygı anlarında düşüncelerini düzenlemelerine ve hafifletmelerine yardımcı olmak amacıyla tasarlanmış bir kişisel farkındalık ve rahatlama aracıdır. Ciddi psikolojik destek gerektiren durumlarda mutlaka uzman bir sağlık profesyoneline başvurulmalıdır.

---

## 🗺️ Yol Haritası ve Görevler

Ayrıntılı geliştirme görevleri, tamamlanma durumları ve mağaza kontrol listesi için lütfen [TODO.md](file:///c:/Users/Zehra/Desktop/Projeler/Tranquilo/TODO.md) dosyasını inceleyin.
