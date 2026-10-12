# Sehaty (صحتي) — Project Context for AI Assistants

> ضع هذا الملف في جذر المشروع (project root) باسم `CLAUDE.md` أو `PROJECT_CONTEXT.md` حتى يقرأه أي AI assistant (Claude Code, Cursor, إلخ) قبل التعامل مع الكود.

---

## 1. هوية المشروع

**Sehaty — صحتي**

تطبيق Flutter لمنصة صحية تربط بين **المرضى والأطباء**.

### المريض يقدر:
- ينشئ حساب ويضيف معلومات صحية أساسية
- يكتشف ويبحث عن أطباء وتخصصات
- يشوف تفاصيل الطبيب والعيادة
- يحجز مواعيد ويتابعها
- يدير بروفايله

### الطبيب يقدر (flow منفصل):
- ينشئ حساب ويضيف معلومات مهنية وعيادة
- يحدد أيام وساعات العمل
- يشوف المواعيد والمرضى
- يدير بروفايله

---

## 2. Tech Stack

- Flutter / Dart
- Material UI
- **Cubit / BLoC** لإدارة الحالة
- **MVVM** concept
- بنية: `core` + `data` + `ui`

**لا تُدخل architecture تانية غير المذكور إلا لو طُلب صراحة.**

---

## 3. Architecture

```
View
  ↓
Cubit / ViewModel
  ↓
Repository
  ↓
Data Source
  ↓
API / Firebase
```

- **View**: شاشات، widgets، layout، forms — بدون API calls أو منطق أعمال معقّد
- **ViewModel (Cubit/BLoC)**: UI state، loading/success/error، أفعال المستخدم، استدعاء الـ repositories
- **Data**: Models، Data sources، Repositories، API/Firebase integration
- **Core**: Constants، Theme، Routes، Network، Errors، Utilities، Shared widgets

**قاعدة صارمة:** الـ UI ما ينادوش الـ API مباشرة أبدًا.

---

## 4. ⚠️ القاعدة الأهم: المرحلة الحالية = UI فقط

في المرحلة الحالية ركّز **فقط** على:
- UI / Navigation / Screen layouts / Reusable widgets / Forms / Dummy data

**ممنوع تمامًا** (إلا لو طُلب صراحة):
- Real API
- Firebase authentication
- Database
- Real booking requests
- Repository logic
- Complex Cubits
- Backend integration

الهدف: إنهاء الـ UI الكامل للتطبيق أولًا.

**عند أي مهمة جديدة**، حدد أولًا: هل هي UI / Data / ViewModel-Cubit / Core؟
إذا كانت المرحلة الحالية UI → نفّذ الجزء الخاص بالـ UI فقط، ولا تنشئ backend code تلقائيًا.

---

## 5. بنية المشروع

```
lib/
├── core/
├── data/
├── ui/
└── main.dart
```

الـ UI منظم حسب الـ features:

```
ui/
├── splash/
├── onboarding/
├── welcome/
├── auth/
│   ├── patient/ (login/, register/)
│   └── doctor/  (login/, register/)
├── patient/
│   ├── home/
│   ├── search/
│   ├── doctors/       (doctors_screen, doctor_details_screen)
│   ├── appointments/  (list, book, details)
│   └── profile/       (view, edit)
├── doctor/
│   ├── home/
│   ├── appointments/
│   ├── patients/      (list, details)
│   └── profile/       (view, edit)
└── navigation/         (patient_navigation, doctor_navigation)
```

كل شاشة لها مجلد `view/` وبداخله widgets خاصة بيها لو احتاجت.

---

## 6. تدفق المستخدم الكامل

```
Splash → Onboarding → Welcome → اختيار نوع المستخدم
                                   ├── Patient → Login/Register → Patient Home
                                   └── Doctor  → Login/Register → Doctor Home
```

**Patient flow:** Home → Search/Specialties → Doctor Details → Book Appointment → Confirm → My Appointments → Profile

**Doctor flow:** Doctor Home → Appointments → Patients → Profile

---

## 7. تفاصيل الشاشات الأساسية

| الشاشة | المحتوى |
|---|---|
| **Splash** | Logo، اسم التطبيق، animation/loading بسيط. UI stage: `Splash → Onboarding` مباشرة |
| **Onboarding** | 3 شاشات (illustration + title + description + Next/Skip + indicator) + خيار اللغة (العربية/English) |
| **Welcome** | اختيار Patient أو Doctor |
| **Patient Login** | Email, Password, Forgot Password, Login, Create Account |
| **Patient Register** | بيانات الحساب (الاسم، إيميل، تليفون، باسورد) + بيانات صحية (الطول، الوزن) + سؤال الأمراض المزمنة (Yes/No/I don't know) مع اختيار متعدد للأمراض لو Yes |
| **Doctor Login** | نفس Patient Login |
| **Doctor Register** | بيانات شخصية + معلومات مهنية (التخصص، نبذة) + معلومات العيادة (عنوان، تليفون) + جدول العمل (أيام + ساعات) |
| **Patient Home** | Header (اسم التطبيق + جرس إشعارات + اسم المستخدم) + Search bar + قائمة تخصصات + Top Rated Doctors |
| **Patient Bottom Nav** | Home / Search / Appointments / Profile |
| **Search Screen** | بحث بالاسم أو التخصص + فلاتر اختيارية + نتائج |
| **Doctor Details** | صورة، اسم، تخصص، تقييم، نبذة، بيانات العيادة والتواصل، أيام وساعات العمل + زر Book Appointment |
| **Book Appointment** | بيانات الطبيب + بيانات المريض (بدون إعادة إدخال) + وصف الحالة + تاريخ ووقت + Confirm Booking |
| **Booking Confirmation** | ملخص الحجز (طبيب، مريض، تاريخ، وقت، الحالة: Pending) |
| **Patient Appointments** | تابات Upcoming/Completed، كل appointment card فيها طبيب/تخصص/وقت/حالة |
| **Appointment Details** | كل تفاصيل الموعد (طبيب، مريض، حالة، تاريخ، وقت، عيادة) |
| **Patient Profile** | Header (صورة+اسم+إيميل) + My Appointments + My Information (بيانات شخصية وصحية) + Edit Profile + Settings |
| **Doctor Home** | ترحيب + مواعيد اليوم + المواعيد القادمة |
| **Doctor Appointments** | كل appointment: اسم المريض، تاريخ، وقت، حالة، وصف الحالة |
| **Doctor Patients** | قائمة مرضى (اسم، تليفون، الموعد القادم) → تفاصيل المريض |
| **Doctor Profile** | بيانات شخصية + مهنية + عيادة + جدول عمل + Edit Profile |

**حالات المواعيد الممكنة:** Pending / Confirmed / Completed / Cancelled

---

## 8. Dummy Data

في مرحلة الـ UI، استخدم بيانات وهمية محلية سهلة الاستبدال لاحقًا (بدون بناء fake API services إلا لو طُلب).

```dart
final doctors = [
  {'name': 'Dr. Ahmed Ali', 'specialty': 'Dentist', 'rating': 4.9},
  {'name': 'Dr. Mohamed Hassan', 'specialty': 'Cardiologist', 'rating': 4.8},
];
```

---

## 9. دعم اللغة

- يدعم **English** و **Arabic** مع **RTL كامل** للعربي
- خيار اللغة متاح من الـ Onboarding
- تجنّب أي layout بينكسر مع تغيّر طول النص أو الاتجاه (لا تعتمد على fixed-width containers بدون داعٍ)

---

## 10. الاتجاه التصميمي

عصري، نظيف، طبي، احترافي، بسيط، واضح. أولوية لـ: hierarchy واضح، مسافات جيدة، typography مقروءة، أزرار وcards متسقة، navigation واضح، touch targets يسهل الوصول لها. تجنّب الزخرفة الزايدة.

---

## 11. قواعد الكود

- أسماء واضحة، const حيث يمكن
- تقسيم الـ widgets الكبيرة لأجزاء أصغر
- تجنّب التعقيد الزائد (لا clean architecture layers زيادة، لا interfaces/abstract classes/services/design patterns غير ضرورية، لا packages زيادة)
- لا تكرار كود، لا ملفات ضخمة تجمع widgets غير مرتبطة
- منطق الأعمال ما ينفعش يبقى جوه الـ UI widgets
- كود بسيط ومفهوم لأي مطور Flutter

### Reusable widgets
قبل إنشاء widget جديد، تأكد إنه مش موجود بالفعل. أمثلة widgets مشتركة متوقعة:
`PrimaryButton, CustomTextField, DoctorCard, AppointmentCard, SpecialtyCard, SectionTitle, ProfileOption, LoadingWidget, EmptyStateWidget`

الـ widgets الخاصة بـ feature معينة تفضل جوه فولدرها، ولو بقت مستخدمة في أماكن كتير تنتقل لـ `core/widgets/`.

### Responsive
استخدم `MediaQuery`, `LayoutBuilder`, `Expanded`, `Flexible`, `FractionallySizedBox`, `Wrap`, `FittedBox` حسب الحاجة. تجنّب أبعاد ثابتة كبيرة بدون داعٍ.

### حالات البيانات
كل شاشة data-driven لازم تدعم لاحقًا: `Loading / Success / Empty / Error` (في مرحلة UI تكون أمثلة ثابتة).

---

## 12. ترتيب التنفيذ المقترح

1. Splash
2. Onboarding
3. خيار اللغة
4. Welcome / اختيار نوع المستخدم
5. Patient Login/Register
6. Doctor Login/Register
7. Patient Home
8. Patient Search
9. Doctors List
10. Doctor Details
11. Book Appointment
12. Booking Confirmation
13. Patient Appointments
14. Patient Profile
15. Doctor Home
16. Doctor Appointments
17. Doctor Patients
18. Doctor Profile
19. Navigation polish
20. Loading / Empty / Error states

بعد اكتمال الـ UI بالكامل: `Models → Repositories → Data Sources → Cubits → API/Firebase → Real Data`

---

## 13. القاعدة الذهبية

**ابنِ الـ UI أولًا. خليه بسيط. خليه منظم. متعملش over-engineering.**

كل feature جديدة لازم تتماشى مع الـ architecture والـ folder structure الموجودة. قبل إنشاء أو تعديل أي كود، افهم بنية المشروع الحالية وأعد استخدام المكونات الموجودة كل ما أمكن.
