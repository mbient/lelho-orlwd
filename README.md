# lelho-orlwd

A buildah-script to create and run a simple c-program.

## Introduction

This project utilizes [Buildah](https://buildah.io/) for creating and managing container images. It enables easy and efficient containerization of applications.

## Prerequisites

Ensure that the following software components are installed on your system:

- [Buildah](https://buildah.io/)
- [Make](https://www.gnu.org/software/make/)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/mbient/lelho-orlwd.git
   cd lelho-orlwd
   ```

2. Make sure all dependencies are installed.

## Usage

To run the Buildah script, use the following commands:

- To execute the default target (clean and build):
  ```bash
  make
  ```

- To run only the build target:
  ```bash
  make build
  ```

- To run the clean target:
  ```bash
  make clean
  ```
## Contributing

Contributions are welcome! Please open an issue or create a pull request to suggest your changes.

## License

This project is licensed under the [BSD 3 License](LICENSE).
