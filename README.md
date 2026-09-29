# Mahalla Members Form

[![CI](https://github.com/iamafzalhassan/mmf-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/iamafzalhassan/mmf-flutter/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?logo=flutter&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-Cubit-13B9FD)
![Firebase Hosting](https://img.shields.io/badge/hosting-Firebase-FFCA28?logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/platform-Web-3DDC84)

A household registration form for a mahalla (local mosque community) in Sri Lanka, built with Flutter for the web and hosted on Firebase. Volunteers record each household and every member living in it, and each submission is sent to a Google Apps Script endpoint.

**Live:** [mmf-kohilawatta.web.app](https://mmf-kohilawatta.web.app)

The form captures detailed, structured data (education, religious studies, qualifications and special needs) while keeping entry fast on a phone browser, and it cleans every value before it is sent.

## Features

- **Household details**: an auto-generated read-only reference number, admission (sandapaname) number, address, route chosen from the area's lanes, house ownership and the number of families in the home.
- **Family members** added, edited and removed from a list, each on its own form page.
- **Member details**: full name, gender, age, relationship to the head, civil status, mobile and WhatsApp numbers, national ID, study or work status and occupation.
- **Education and background** as multi-select grids: school education, madrasa studies, ulama qualifications, professional qualifications and special needs.
- **Conditional fields**: an A/L year appears only when A/L is ticked, qualification details only when a qualification is chosen, and vocational course details only for a vocational course.
- **Gender-aware choices**: the relationship list and ulama titles adapt to the selected gender, and choices that no longer fit are cleared when the gender changes.
- **Household rules**: at least one member is required, exactly one member must be the Head of Family, and a second head is refused when adding or editing.
- **Validation**: Sri Lankan mobile numbers must be ten digits starting with `07`, and the head's mobile number is required; the A/L year must fall between 1950 and next year.
- **Clear feedback**: loading state while submitting, a success message, and the form resets with a fresh reference number after a successful submission.

## Architecture

- **Clean Architecture.** `domain` holds the `MainForm` and `FamilyMember` entities, the `FormRepository` contract and the `SubmitForm` use case; `data` holds the remote data source and repository implementation; `presentation` holds cubits, pages and widgets.
- **Cubits for state.** `MainFormCubit` owns the household and its member list; `FamilyMemberCubit` owns a single member form, including its conditional fields and gender rules. Cubits hold state and rules, including refusing a second Head of Family when a member is added or edited; the pages own the form keys, text controllers, field validators and snackbars.
- **Dependency injection with GetIt**, registering the HTTP client, data source, repository, use case and cubit.
- **Functional error handling.** The repository returns `Either<Failure, void>` from `dartz`, so the cubit folds a failure or a success instead of catching exceptions.
- **Reusable widgets** for text fields, dropdowns, checkbox grids, member cards, section headers, a primary button and snackbars.
- **No code generation.** Entities and their JSON are written by hand.

## How submission works

1. **Values are sanitised as they are serialised.** Names and free text are uppercased with collapsed whitespace and tidy punctuation, addresses get consistent comma spacing, phone numbers and years keep digits only, and national IDs keep only digits, `V` and `X`.
2. **Multi-select answers become comma-separated text** with blank entries removed, so each answer is a single value.
3. **The household is sent as one payload.** The form and all its members are encoded as JSON, then base64url-encoded into a request to the Apps Script endpoint, with a 30-second timeout.
4. **The response is checked.** A `success` status completes the submission, and so does a response that is not JSON; an `error` status surfaces the script's message, and any other status code or JSON reply is reported as a failed submission.

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
    core/error/         Failure, SubmissionException
    core/theme/         Theme and colours
    core/utils/         DataSanitizer
    domain/             MainForm, FamilyMember, FormRepository, SubmitForm
    data/               FormRemoteDataSource, FormRepositoryImpl
    presentation/
        cubits/         MainFormCubit and MainFormState, FamilyMemberCubit
        pages/          MahallaForm, FamilyForm
        widgets/        Text field, dropdown, checkbox grid, family card, section header, primary button, snackbars
```

## Building

**Requirements:** Flutter 3.29 or later (Dart 3.7) with web support, and the Firebase CLI to deploy.

- **Run locally:** `flutter run -d chrome`.
- **Deploy:** `flutter build web`, then `firebase deploy --only hosting`. Hosting serves `build/web` and rewrites every path to `index.html`.

## Testing

Unit tests live in `test/`, mirroring the `lib/` path of the code they cover:

- **`test/core/utils/data_sanitizer_test.dart`**: text, addresses, phone numbers, national IDs and multi-select answers are cleaned as described above.
- **`test/data/datasources/form_remote_data_source_test.dart`**: the household is sent as base64url JSON in a GET request, and an `error` status, a failed status code or a network failure throws a `SubmissionException` with a readable message.
- **`test/data/repositories/form_repository_impl_test.dart`**: a submission error becomes a `Failure` carrying its message without an exception prefix.
- **`test/presentation/cubits/family_member_cubit_test.dart`**: the A/L year, qualification details and vocational course details are cleared when their choices are unticked, and a gender change clears a relationship or ulama titles that no longer fit.
- **`test/presentation/cubits/main_form_cubit_test.dart`**: a household without members or without a Head of Family is refused, invalid fields block submission, a valid household is submitted and the form resets with a new reference number, a second Head of Family is refused when adding or editing, and editing a member ignores that member when checking for an existing head.
- **`test/presentation/pages/family_form_page_test.dart`**: mobile and WhatsApp numbers must be ten digits starting with `07`, the head needs a mobile number, and the A/L year is required and must fall between 1950 and next year.

Run them with `flutter test`.

## Roadmap

- Send submissions in a POST body instead of the request URL
- Save an unfinished household on the device so a closed tab loses nothing
