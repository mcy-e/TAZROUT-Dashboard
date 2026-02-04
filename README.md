# TAZROUT Dashboard

A modern, cross-platform monitoring dashboard with real-time data visualization, analytics, and control capabilities. Built with Flutter (desktop) and FastAPI (backend), designed for flexibility and extensibility.

---

## Overview

This dashboard provides a comprehensive interface for monitoring systems with:

- **`Real-time data visualization`** - Live updates with interactive charts
- **`Multi-zone monitoring`** - Track multiple zones/areas simultaneously  
- **`Analytics & insights`** - Historical data analysis with customizable views
- **`Decision tracking`** - View AI/automated decision logs with detailed reasoning
- **`Emergency controls`** - Quick-action controls for critical situations (Likely won't be included in the beta version release)
- **`Multi-language support`** - English, French, and Arabic with RTL layout

---

## Architecture

```
┌─────────────────┐
│ Flutter Desktop │  Cross-platform UI (Windows/Linux/macOS)
│   Application   │  Charts, real-time updates, multi-language
└────────┬────────┘
         │ REST API
         │
┌────────▼────────┐
│ FastAPI Backend │  RESTful API server
│   (Python)      │  Data processing, formatting, endpoints
└────────┬────────┘
         │
         ├─── PostgreSQL (data storage)
         ├─── External APIs (data sources)
         └─── Hardware devices (controls)
```

**Flexible Integration**: The dashboard connects to any data source via its backend API. Swap out databases, sensors, or external services without changing the frontend.

---

## Tech Stack

### Frontend
- **Flutter Desktop** - Native cross-platform UI
- **Riverpod** - Reactive state management
- **Dio** - HTTP client
- **fl_chart** - Interactive charts
- **flutter_intl** - Internationalization

### Backend  
- **FastAPI** - High-performance Python framework
- **Pydantic** - Data validation
- **Uvicorn** - ASGI server
- **SQLAlchemy** - Database ORM

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Service orchestration

---

## Project Structure

```
TAZROUT-Dashboard/
│
├── README.md                       # Project overview and setup guide
├── LICENSE                         # CC BY-NC 4.0 License
├── .gitignore                      # Git ignore rules
├── .env.example                    # Environment variables template
│
├── docs/                           # Documentation
│   ├── SETUP_GUIDE.md              # Installation and setup instructions
│   ├── API_DOCUMENTATION.md        # API endpoints reference
│   ├── ARCHITECTURE.md             # System architecture overview
│   ├── DEPLOYMENT_GUIDE.md         # Deployment instructions
│   ├── CONTRIBUTING.md             # Contribution guidelines
│   ├── DESIGN_SYSTEM.md            # UI design specifications
│   ├── user-manuals/               # End-user documentation
│   │   ├── USER_MANUAL_EN.md       # English manual
│   │   ├── USER_MANUAL_FR.md       # French manual
│   │   └── USER_MANUAL_AR.md       # Arabic manual
│   ├── api-examples/               # API usage examples
│   └── testing/                    # Testing documentation
│
├── design/                         # Design Assets
│   ├── README.md                   # Design documentation
│   ├── FIGMA_LINKS.md              # Figma project links
│   ├── mockups/                    # Screen mockups (PNG/JPG)
│   ├── components/                 # Component designs
│   ├── flows/                      # User flow diagrams
│   └── assets/                     # Exported design assets
│       ├── icons/                  # SVG icons
│       ├── illustrations/          # Graphics
│       └── logo/                   # Logo variants
│
├── backend/                        # FastAPI Backend
│   ├── README.md                   # Backend documentation
│   ├── requirements.txt            # Python dependencies
│   ├── requirements-dev.txt        # Development dependencies
│   ├── pytest.ini                  # Pytest configuration
│   ├── .flake8                     # Linter configuration
│   ├── .dockerignore               # Docker ignore rules
│   ├── .env.example                # Backend environment template
│   ├── Dockerfile                  # Docker image definition
│   │
│   ├── app/                        # Application code
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI entry point
│   │   ├── config.py               # Configuration settings
│   │   │
│   │   ├── api/                    # API routes
│   │   │   └── v1/                 # API version 1
│   │   │       ├── endpoints/      # Endpoint handlers
│   │   │       └── router.py       # API router
│   │   │
│   │   ├── models/                 # Data models (ORM)
│   │   ├── schemas/                # Pydantic schemas (validation)
│   │   ├── services/               # Business logic
│   │   ├── database/               # Database connection
│   │   ├── utils/                  # Utility functions
│   │   └── core/                   # Core functionality
│   │
│   ├── mock_data/                  # Mock data for development
│   │   ├── README.md
│   │   ├── generators/             # Data generation scripts
│   │   └── *.json                  # Mock data files
│   │
│   ├── tests/                      # Test suite
│   │   ├── unit/                   # Unit tests
│   │   ├── integration/            # Integration tests
│   │   └── fixtures/               # Test fixtures
│   │
│   └── scripts/                    # Utility scripts
│       └── generate_mock_data.py
│
├── frontend/                       # Flutter Desktop App
│   ├── README.md                   # Frontend documentation
│   ├── pubspec.yaml                # Flutter dependencies
│   ├── analysis_options.yaml       # Flutter linter config
│   │
│   ├── lib/                        # Application source code
│   │   ├── main.dart               # App entry point
│   │   │
│   │   ├── core/                   # Core functionality
│   │   │   ├── api/                # API client
│   │   │   ├── constants/          # App constants
│   │   │   ├── localization/       # Translations (i18n)
│   │   │   │   └── l10n/           # Language files (.arb)
│   │   │   ├── theme/              # App theming
│   │   │   ├── router/             # Navigation
│   │   │   └── utils/              # Utilities
│   │   │
│   │   ├── models/                 # Data models
│   │   ├── providers/              # State management (Riverpod)
│   │   ├── repositories/           # Data access layer
│   │   │
│   │   ├── screens/                # UI screens
│   │   │   ├── home/               # Home screen
│   │   │   ├── zones/              # Zones monitoring
│   │   │   ├── analytics/          # Analytics dashboard
│   │   │   ├── ai_log/             # Decision log
│   │   │   ├── emergency/          # Emergency controls
│   │   │   └── settings/           # Settings screen
│   │   │
│   │   └── widgets/                # Reusable widgets
│   │       ├── common/             # Common widgets
│   │       ├── zone/               # Zone widgets
│   │       ├── sensor/             # Sensor widgets
│   │       ├── charts/             # Chart widgets
│   │       └── filters/            # Filter widgets
│   │
│   ├── assets/                     # Static assets
│   │   ├── images/                 # Images
│   │   ├── icons/                  # Icons
│   │   └── fonts/                  # Custom fonts
│   │
│   ├── test/                       # Test suite
│   │   ├── unit/                   # Unit tests
│   │   ├── widget/                 # Widget tests
│   │   └── integration/            # Integration tests
│   │
│   ├── windows/                    # Windows platform config
│   ├── linux/                      # Linux platform config
│   └── macos/                      # macOS platform config
│
├── deployment/                     # Deployment Configuration
│   ├── README.md
│   ├── docker/                     # Docker deployment
│   │   ├── docker-compose.dev.yml  # Development
│   │   ├── docker-compose.prod.yml # Production
│   │   ├── .env.dev.example
│   │   ├── .env.prod.example
│   │   └── nginx/                  # Reverse proxy
│   │
│   ├── vm/                         # VM deployment
│   │   ├── README.md
│   │   └── systemd/                # Service files
│   │
│   └── scripts/                    # Deployment scripts
│       ├── deploy-docker.sh
│       └── deploy-vm.sh
│
└── scripts/                        # Project Scripts
    ├── setup_dev.sh                # Development setup
    ├── clean.sh                    # Clean build artifacts
    └── run_tests.sh                # Run all tests
```

---

## 🛠️ Quick Start

### Prerequisites
- Flutter SDK 3.16.0+
- Python 3.10+
- Docker (optional)

### Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv
# For windows: venv\Scripts\activate
source venv/bin/activate  

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env

# Run server
uvicorn app.main:app --reload
```

API available at: `http://localhost:8000`  
Documentation: `http://localhost:8000/docs`

### Frontend Setup

```bash
cd frontend

# Install dependencies
flutter pub get

# Run application
flutter run -d windows  # or linux/macos
```

### Docker Setup

```bash
# Development mode
docker-compose -f deployment/docker/docker-compose.dev.yml up

# Production mode
docker-compose -f deployment/docker/docker-compose.prod.yml up -d
```

---

## Features

### Real-time Monitoring
- Live data updates from multiple zones/sensors
- Visual indicators for status 
- Battery levels and health monitoring
- Customizable refresh intervals

### Analytics Dashboard
- Interactive line and bar charts
- Time-based filtering 
- Export data capabilities
- Customizable metrics

### Decision Tracking
- View automated decision logs
- Filter by zone, date, type
- Detailed reasoning and confidence scores
- Historical decision analysis

### Emergency Controls
- Quick-action stop button
- System-wide status view
- Confirmation dialogs for safety
- Action history logging

### Internationalization
- English, French, Arabic
- RTL layout support for Arabic
- Localized date/time formats
- Easy language switching

---

## Testing

### Backend
```bash
cd backend
pytest                    # All tests
pytest --cov=app         # With coverage
```

### Frontend
```bash
cd frontend
flutter test             # All tests
flutter test --coverage  # With coverage
```

---

## 📖 Documentation

- [Setup Guide](./docs/SETUP_GUIDE.md)
- [API Reference](./docs/API_DOCUMENTATION.md)
- [Architecture](./docs/ARCHITECTURE.md)
- [Deployment](./docs/DEPLOYMENT_GUIDE.md)
- [Contributing](./docs/CONTRIBUTING.md)

---

## Configuration

The dashboard uses environment variables for configuration. Copy `.env.example` to `.env` and customize:

```bash
# Backend
cp backend/.env.example backend/.env

# Root (Docker)
cp .env.example .env
```

Key configurations:
- API endpoints and ports
- Database connections
- External service URLs
- Feature flags

See `.env.example` files for all options.

---

## Deployment

### Docker (Recommended)

```bash
# Build images
docker-compose -f deployment/docker/docker-compose.prod.yml build

# Deploy
docker-compose -f deployment/docker/docker-compose.prod.yml up -d
```

### Manual Deployment

See [Deployment Guide](./docs/DEPLOYMENT_GUIDE.md) for:
- VM deployment
- Kubernetes manifests
- Reverse proxy setup
- SSL configuration

---

## Customization

### Theming
Customize colors, fonts, and spacing in:
- `frontend/lib/core/constants/colors.dart`
- `frontend/lib/core/constants/text_styles.dart`
- `frontend/lib/core/theme/app_theme.dart`

### API Endpoints
Add new endpoints in:
- `backend/app/api/v1/endpoints/`

### Data Sources
Integrate new data sources by:
1. Add repository in `backend/app/repositories/`
2. Update service layer in `backend/app/services/`
3. Create API endpoint

---

## Contributing

We follow standard Git workflow practices.

**Commit Format**: `[verb]: description`

Examples:
```bash
[ADD]: implement user authentication
[FIXED]: resolve API timeout issue
[UPDATED]: improve chart performance
[DOCUMENTED]: add endpoint documentation
```

See [CONTRIBUTING.md](./docs/CONTRIBUTING.md) for details.

---

## License

This project is licensed under the MIT License - see [LICENSE](./LICENSE) file.

---

## Links

- **Documentation**: See `/docs` directory
- **API Docs**: `http://localhost:8000/docs` (when running)
- **Design Files**: See `design/FIGMA_LINKS.md`

---
## Project Status

**Version**: 1.0.0  
**Status**: In Development  
**Last Updated**: February 2025

---

## Security Features

- Environment-based configuration
- CORS protection
- Input validation
- Secure defaults
- Docker security practices

---

## Performance Goals

- Fast API response times
- Smooth 60fps animations
- Configurable real-time updates
- Scalable architecture

## Use Cases

This dashboard can be adapted for:
- Industrial monitoring systems
- IoT device management
- Environmental monitoring
- Process automation
- Data analytics platforms
- Control systems
- Any multi-zone monitoring application

---

