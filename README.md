# Mahalla Members Form

![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?logo=flutter&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-Cubit-13B9FD)
![Firebase Hosting](https://img.shields.io/badge/hosting-Firebase-FFCA28?logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/platform-Web-3DDC84)

A household registration form for a mahalla (local mosque community) in Sri Lanka, built with Flutter for the web and hosted on Firebase. Volunteers record each household and every member living in it, and each submission is sent to a Google Apps Script endpoint.

**Live:** [mmf-kohilawatta.web.app](https://mmf-kohilawatta.web.app)

The form captures detailed, structured data (education, religious studies, qualifications, special needs and zakat status) while keeping entry fast on a phone browser, and it cleans every value before it is sent.

## Features

- **Household details**: an auto-generated read-only reference number, admission (sandapaname) number, address, route chosen from the area's lanes, house ownership and the number of families in the home.
- **Family members** added, edited and removed from a list, each on its own form page.
- **Member details**: full name, gender, age, relationship to the head, civil status, mobile and WhatsApp numbers, national ID, study or work status and occupation.
- **Education and background** as multi-select grids: school education, madrasa studies, ulama qualifications, professional qualifications and special needs, plus zakat status.
- **Conditional fields**: an A/L year appears only when A/L is ticked, qualification details only when a qualification is chosen, and vocational course details only for a vocational course.
- **Gender-aware choices**: the relationship list and ulama titles adapt to the selected gender, and choices that no longer fit are cleared when the gender changes.
- **Household rules**: at least one member is required, exactly one member must be the Head of Family, and a second head is refused when adding or editing.
- **Validation**: Sri Lankan mobile numbers must be ten digits starting with `07`, and the head's mobile number is required; the A/L year must fall between 1950 and next year.
- **Clear feedback**: loading state while submitting, a success message, and the form resets with a fresh reference number after a successful submission.

## Architecture

- **Clean Architecture.** `domain` holds the `MainForm` and `FamilyMember` entities, the `FormRepository` contract and the `SubmitForm` use case; `data` holds the remote data source and repository implementation; `presentation` holds cubits, pages and widgets.
- **Cubits for state.** `MainFormCubit` owns the household and its member list; `FamilyMemberCubit` owns a single member form, including its conditional fields and gender rules. Cubits hold only state and rules; the pages own the form keys, text controllers and snackbars.
- **Dependency injection with GetIt**, registering the HTTP client, data source, repository, use case and cubit.
- **Functional error handling.** The repository returns `Either<Failure, void>` from `dartz`, so the cubit folds a failure or a success instead of catching exceptions.
- **Reusable widgets** for text fields, dropdowns, checkbox grids, member cards, section headers, gradient buttons and snackbars.
- **No code generation.** Entities and their JSON are written by hand.

## How submission works

1. **Values are sanitised as they are serialised.** Names and free text are uppercased with collapsed whitespace and tidy punctuation, addresses get consistent comma spacing, phone numbers and years keep digits only, and national IDs keep only digits, `V` and `X`.
2. **Multi-select answers become comma-separated text** with blank entries removed, so each answer is a single value.
3. **The household is sent as one payload.** The form and all its members are encoded as JSON, then base64url-encoded into a request to the Apps Script endpoint, with a 30-second timeout.
4. **The response is checked.** A `success` status completes the submission; an `error` status or an unexpected response surfaces its message to the volunteer.

## Tech stack

| Area | Choice |
|---|---|
| Language | Dart 3 |
| UI | Flutter web, Material, SF Pro Display |
| State | flutter_bloc (Cubit), equatable |
| Dependency injection | get_it |
| Networking | http |
| Error handling | dartz (`Either`) |
| Backend | Google Apps Script web app |
| Hosting | Firebase Hosting |

## Code conventions

- A strict member ordering convention for every class: fields sorted by type tier, then type, then name; methods ordered by call order.
- No comments in source. Names, types and ordering carry the meaning.
- `dart format` at a 240-column page width.

## Project structure

```
lib/
    main.dart, app.dart
    core/di/            GetIt container
    core/error/         Failures
    core/theme/         Theme and colours
    core/utils/         DataSanitizer, reference number generator
    domain/             MainForm, FamilyMember, FormRepository, SubmitForm
    data/               FormRemoteDataSource, FormRepositoryImpl
    presentation/
        cubits/         MainFormCubit, FamilyMemberCubit and their states
        pages/          MahallaForm, FamilyForm
        widgets/        Text field, dropdown, checkbox grid, family card, section header, gradient button, snackbars
```

## Building

**Requirements:** Flutter 3.10 or later with web support, and the Firebase CLI to deploy.

- **Run locally:** `flutter run -d chrome`.
- **Deploy:** `flutter build web`, then `firebase deploy --only hosting`. Hosting serves `build/web` and rewrites every path to `index.html`.

## Testing

Unit tests live in `test/`, mirroring the `lib/` path of the code they cover:

- **`test/core/utils/data_sanitizer_test.dart`**: text, addresses, phone numbers, national IDs and multi-select answers are cleaned as described above.
- **`test/presentation/cubits/main_form_cubit_test.dart`**: a household without members or without a Head of Family is refused, invalid fields block submission, a valid household is submitted and the form resets with a new reference number, and editing a member ignores that member when checking for an existing head.

Run them with `flutter test`.

## Roadmap

- Send submissions in a POST body instead of the request URL
- Save an unfinished household on the device so a closed tab loses nothing
