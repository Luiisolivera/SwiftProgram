# ControlFinanzasApp (iOS / SwiftUI + SwiftData)

Aplicación nativa en Swift para el control de finanzas personales, ingresos y gastos, con base de datos local utilizando **SwiftData** y arquitectura desacoplada para pruebas unitarias automatizadas con **GitHub Actions**.

## 🚀 Características
- **Base de Datos Local**: Persistencia reactiva local con `SwiftData` (`@Model` y `@Query`).
- **Dashboard Financiero**: Tarjetas interactivas con cálculo en tiempo real de Balance Total, Ingresos y Gastos.
- **Categorías**: Clasificación visual con iconos SF Symbols (Salario, Alimentación, Transporte, Vivienda, Salud, Entretenimiento, etc.).
- **Filtros rápidos**: Segmentación entre Todos, Ingresos y Gastos.
- **Pruebas Unitarias Automatizadas**: Suite completa de pruebas con `XCTest` y base de datos en memoria para verificar cálculos y validaciones.
- **CI / CD con GitHub Actions**: Workflow configurado para compilar y ejecutar pruebas en runners oficiales de macOS.

## 📁 Estructura del Proyecto

```text
ControlFinanzasApp/
├── .github/
│   └── workflows/
│       └── swift-tests.yml        # Workflow de GitHub Actions CI
├── Sources/
│   └── ControlFinanzas/
│       ├── App/
│       │   └── ControlFinanzasApp.swift # Punto de entrada (@main)
│       ├── Models/
│       │   ├── Transaction.swift         # Modelo SwiftData (@Model)
│       │   ├── TransactionType.swift     # Enum (Ingreso / Gasto)
│       │   └── TransactionCategory.swift # Categorías con iconos
│       ├── Services/
│       │   └── FinanceService.swift      # Lógica de negocio y cálculos
│       └── Views/
│           ├── DashboardView.swift       # Vista principal con balance y lista
│           ├── AddTransactionView.swift  # Formulario de nueva transacción
│           └── TransactionRowView.swift  # Fila individual de movimiento
├── Tests/
│   └── ControlFinanzasTests/
│       └── FinanceServiceTests.swift     # Pruebas unitarias automatizadas
├── Package.swift                         # Definición de Swift Package
├── .gitignore
└── README.md
```

## 🧪 Pruebas Unitarias
El proyecto incluye pruebas que validan:
1. Incremento de ingresos y balance al registrar entradas de dinero.
2. Deducción del balance al registrar gastos.
3. Rechazo y validación de montos menores o iguales a cero.
4. Rechazo y validación de títulos o conceptos vacíos.
5. Eliminación de registros y actualización inmediata del balance.

## 🛠️ Cómo abrir en Xcode
1. Abre Xcode en tu Mac.
2. Selecciona **File > Open...** y elige la carpeta `ControlFinanzasApp` (o abre directamente el archivo `Package.swift`).
3. Para ejecutar la app, selecciona el simulador deseado (ej. iPhone 15 Pro) y presiona `Cmd + R`.
4. Para ejecutar las pruebas unitarias, presiona `Cmd + U`.
