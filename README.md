# flupass

![GitHub release (latest by date)](https://img.shields.io/github/v/release/ryans233/flupass?style=flat-square) ![GitHub](https://img.shields.io/github/license/ryans233/flupass?color=orange&style=flat-square)

A cross-platform open source password manager inspired by pass, the standard UNIX password manager.

This program is written in Flutter and still WIP. Feel free to open up a PR or make a feature request!

## Feature
- Pass file support
  - Create
  - Read
  - Update
  - Delete
- Folder support
- OpenPGP file encryption / decryption
- Password Generator
- 2 Columns UI in landscape mode
- Filename search
- Custom field parser ([pass-otp](https://github.com/tadfisher/pass-otp), etc.)
- i18n

## To-do

- [ ] First time setup wizard
- [ ] Enhanced indexing search
- [ ] Import & Export
- [ ] Synchronization
- [ ] Dark mode
- [ ] Mobile support (scoped storage, Auto-fill, biometrics option, etc.)
- [ ] Better desktop browser experience (dedicated browser extension or integrate with browserpass)
- [ ] Maybe a stylish icon?

## Build

### Requirements

- Flutter beta channel (>=2.8.0)

```shell
flutter run --release
```

