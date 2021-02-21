# Likee Scraper

[![Built with Crystal 0.36.1](https://img.shields.io/badge/Crystal-0.36.1-%23333333)](https://crystal-lang.org/)
[![GitHub release](https://img.shields.io/github/release/kandayo/likee-scraper.svg?label=Release)](https://github.com/kandayo/likee-scraper/releases)
[![Unit Tests](https://github.com/kandayo/likee-scraper/workflows/Unit%20Tests/badge.svg)](https://github.com/kandayo/likee-scraper/actions)
[![Integration Tests](https://github.com/kandayo/likee-scraper/workflows/Integration%20Tests/badge.svg)](https://github.com/kandayo/likee-scraper/actions)

Download videos from Likee, in their original quality, without watermark.

The integration tests are scheduled to run twice a day, through Github Actions.

See also: [**Likee API Wrapper**](https://github.com/kandayo/likee.cr).

## Index

- [Features](#features)
- [Disclaimer](#disclaimer)
- [Installation](#installation)
  - [Pre-built - Recommended](#pre-built--recommended)
  - [From source](#from-source)
- [Usage](#usage)
  - [Download profile by @username](#download-profile-by-username)
  - [Download profile by User ID](#download-profile-by-user-id)
  - [Batch file](#batch-file)
  - [Fast update](#fast-update)
- [Contributing](#contributing)
- [Contributors](#contributors)

## Features

```
$ likeer --user @Likee_US --user @Likee_UK --fast-update

Downloading 2 profiles: @Likee_US @Likee_UK.

Collecting videos from profile @Likee_US.
 + Likee US - 000005.mp4 [========================] 11.1 MB | 100%
 + Likee US - 000004.mp4; exists
✅ Likee US in sync!

Collecting videos from profile @Likee_UK.
 + Likee UK - 000011.mp4 [========================] 22.2 MB | 100%
 + Likee UK - 000010.mp4; exists
✅ Likee UK in sync!

$ ls
.
├── 11111111
│   ├── 2021-01-01 00:14:01 - 000005.mp4
│   ├── 2021-01-01 00:15:01 - 000004.mp4
│   └── [...]
├── 22222222
│   ├── 2021-01-02 00:14:01 - 000011.mp4
│   ├── 2021-01-02 00:15:01 - 000010.mp4
│   └── [...]
└──
```

- Download profiles by @username or User ID.
- **Built with archivists in mind: incremental sync.**
- JSON metadata is stored alongside the video.
- Batch file, cronjob friendly.

## Disclaimer

This app is in no way affiliated with, authorized, maintained or endorsed by
Likee or any of its affiliates or subsidiaries.

This is purely an educational proof of concept.

## Installation

### Pre-built - Recommended

Just download the latest release for your platform [here](https://github.com/kandayo/likee-scraper/releases).

Then move the binary to your PATH, or just use it right away.

### From source

It only takes a few seconds to compile it yourself. It's not rocket science.

Build dependencies:
 - Crystal language, https://crystal-lang.org/install.

```bash
$ git clone https://github.com/kandayo/likee-scraper
$ cd likee-scraper
$ shards build --release
$ ./bin/likeer --help
```

Then move the binary to your PATH, or just use it right away.

## Usage

For more examples, please refer to the [**documentation**](https://absolab.xyz/likee-scraper).

### Download profile by @username

Looking up a user by username requires an additional API request. It's strongly
recommended to use User IDs instead. Usernames must be prefixed with an `@`.

```bash
$ likeer -u @username1 -u @username2 [...]
```

### Download profile by User ID

If a identifier does not have a prefix, it is assumed to be an User ID.

```bash
$ likeer -u 11111111
```

### Batch file

If `--batch-file <file.txt>` (or `-a`) is given, Likee will read *file.txt*
expecting @usernames and User IDs to download, one identifier per line.
Lines starting with an `#` or empty lines are considered as comments and
ignored.

Usernames must be prefixed with an `@`, e.g. `@username`.

IDs must not be prefixed with an `@`, e.g. `1111111`.

```bash
$ cat batch.txt
~> # Comment (ignored)
~> @username   # Inline comments are also allowed.
~> 111111111

$ likeer -a batch.txt
```

### Fast update

If `--fast-update` (or `-f`) is given, Likeer stops when arriving at the
first already downloaded video. This flag is recommended when you use Likeer
to update your personal archive.

This concept was inspired by Instaloader.

```
$ likeer -f -u @username

Downloading 1 profile: @username.

Collecting videos from profile @username.
 + Example Username - 000003.mp4 [========================] 11.1 MB | 100%
 + Example Username - 000002.mp4; exists
✅ Example Username in sync!
```

## Contributing

1. Fork it (<https://github.com/kandayo/likee-scraper/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kandayo](https://github.com/kandayo) - creator and maintainer
