# Python-UV Base Image

A Docker base image that combines Python with the UV package installer for faster and more reliable Python package management.

## Features

- Based on `python:3.11-slim` (configurable)
- Pre-installed UV package installer
- Proper PATH configuration
- Minimal size overhead
- Support for multiple Python versions
- Flexible tagging system

## Building

Use the provided `build.sh` script to build the image:

```bash
# Build with defaults (Python 3.11, latest tag)
./build.sh

# Build with specific Python version
./build.sh --python 3.12

# Build with custom tag
./build.sh --tag v1.0.0

# Build specific Python version with custom tag
./build.sh --python 3.12 --tag py3.12
```

### Build Options

| Option | Description | Default |
|--------|-------------|---------|
| `-p, --python` | Python version to use | 3.11 |
| `-t, --tag` | Image tag | latest |
| `-h, --help` | Show help message | - |

When building with the `latest` tag, the image is automatically tagged with the Python version as well (e.g., `mcp/python-uv:3.11`).

## Usage

### As a Base Image

```dockerfile
FROM mcp/python-uv:latest

WORKDIR /app

# Use UV to install packages
COPY requirements.txt .
RUN uv pip install --system --no-cache -r requirements.txt

# Your application setup
COPY . .
CMD ["python", "your_app.py"]
```

### Direct Usage

```bash
# Run Python REPL
docker run -it --rm mcp/python-uv

# Run a specific Python script
docker run -it --rm -v $(pwd):/app mcp/python-uv python /app/script.py

# Install packages with UV
docker run -it --rm -v $(pwd):/app mcp/python-uv uv pip install --system package_name
```

## Image Tags

The image uses a flexible tagging system:

- `latest`: Always points to the most recent build with default Python version
- `x.y`: Python version tag (e.g., `3.11`, `3.12`)
- Custom tags: Any tag specified via `--tag` option

## Benefits

1. **Faster Builds**: UV is significantly faster than pip for package installation
2. **Better Caching**: UV's lockfile support ensures reproducible builds
3. **Reduced Size**: Based on slim Python image with minimal additional dependencies
4. **Standardized Environment**: Consistent UV setup across all derived images
5. **Version Flexibility**: Support for multiple Python versions
6. **Build Automation**: Simple build script with various options

## Technical Details

### Environment Variables

- `PATH`: Includes UV installation directory (`/root/.local/bin`)

### Base Image Details

- Base: Debian Slim
- Python: Configurable (default: 3.11)
- UV: Latest stable version
- Additional packages: curl, ca-certificates

### Build Process

1. Uses multi-stage build for minimal image size
2. Installs UV using official installation script
3. Configures shell environment for UV
4. Sets up system-wide UV availability

## Examples

### Building Different Versions

```bash
# Build Python 3.11 version (default)
./build.sh

# Build Python 3.12 version
./build.sh --python 3.12

# Build release version
./build.sh --tag v1.0.0 --python 3.11
```

### Using Different Tags

```dockerfile
# Use latest
FROM mcp/python-uv:latest

# Use specific Python version
FROM mcp/python-uv:3.11

# Use specific release
FROM mcp/python-uv:v1.0.0
``` 