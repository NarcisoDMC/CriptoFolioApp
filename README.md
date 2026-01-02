# CriptoFolioApp
Aplición desarrollada en Swift, usando SwfitUI en Xcode, es una aplicación que muestra la información en tiempo real del precio de las criptomonedas mas populares y con la capacidad de simular una compra de moneda y guardarla en una base de datos en FireBase, la aplicación esta alimentada de una API y una base de datos local

# CryptoFolio 🪙

**CryptoFolio** es una aplicación nativa de iOS desarrollada en **SwiftUI** que permite rastrear el mercado de criptomonedas en tiempo real y gestionar un portafolio de inversiones personal.

La aplicación implementa una arquitectura híbrida robusta: utiliza **SQLite** para caché local de alto rendimiento (permitiendo consultar precios offline) y **Firebase Firestore** para asegurar la persistencia de las inversiones del usuario en la nube.

## Capturas de Pantalla

<img width="301" height="648" alt="image" src="https://github.com/user-attachments/assets/26ae4bbd-802e-47ed-9d95-f37fdc54dfda" />
<img width="315" height="668" alt="image" src="https://github.com/user-attachments/assets/60812618-b5f3-4ecc-9f29-2cacf2858a97" />
<img width="314" height="670" alt="image" src="https://github.com/user-attachments/assets/083231a3-fae2-4f02-bfb5-f8a87bb49c03" />

## Características Principales

* **Rastreo de Mercado:** Consulta precios, cambios en 24h, símbolos y nombres de las principales criptomonedas.
* **Modo Híbrido (Offline First):** Los datos del mercado se descargan y se guardan localmente en una base de datos SQLite, permitiendo que la app cargue instantáneamente incluso sin internet.
* **Gestión de Portafolio:** Permite registrar compras de activos.
* **Sincronización en la Nube:** Las transacciones de compra se almacenan en Firebase Firestore, asegurando que los datos financieros no se pierdan si se borra la app.
* **Imágenes Optimizadas:** Carga asíncrona y caché de logos de monedas.

## 🛠 Tech Stack

* **Lenguaje:** Swift 5
* **UI Framework:** SwiftUI
* **Arquitectura:** MVVM (Model-View-ViewModel)
* **Gestión de Dependencias:** Swift Package Manager (SPM)

### Librerías Externas
* **[Alamofire](https://github.com/Alamofire/Alamofire):** Para peticiones de red (Networking) robustas y manejo de API.
* **[SQLite.swift](https://github.com/stephencelis/SQLite.swift):** Capa de acceso a base de datos SQL segura y tipada para Swift.
* **[Firebase Firestore](https://firebase.google.com/):** Base de datos NoSQL en la nube para persistencia de usuario.
* **[Kingfisher](https://github.com/onevcat/Kingfisher):** Descarga y caché eficiente de imágenes desde la web.

## Arquitectura de Datos

El flujo de datos de la aplicación está diseñado para eficiencia y seguridad:

1.  **API Externa** -> **Alamofire** descarga los datos JSON.
2.  **Persistencia Local** -> **SQLite** almacena/actualiza la tabla `coins` (incluyendo columnas como `priceChange24h`).
3.  **UI** -> La vista lee directamente de la base de datos local para una respuesta inmediata.
4.  **Transacciones** -> Las compras se envían directamente a **Firebase Firestore** a través de `FirebaseManager`.

## Instalación y Configuración

Para correr este proyecto localmente, necesitarás Xcode 16 o superior.

1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/NarcisoDMC/CryptoFolioApp.git](https://github.com/NarcisoDMC/CryptoFolioApp.git)
    ```

2.  **Configurar Firebase:**
    * Este repositorio **no incluye** el archivo `GoogleService-Info.plist` por razones de seguridad.
    * Debes crear un proyecto en Firebase Console.
    * Descargar tu propio `GoogleService-Info.plist`.
    * Arrastrarlo a la raíz del proyecto en Xcode.

3.  **Dependencias:**
    * Al abrir el proyecto, Xcode resolverá automáticamente los paquetes mediante SPM. Espera a que termine la indexación.

4.  **Ejecución:**
    * Presiona `Cmd + R` para correr en el Simulador.

## Solución de Problemas Comunes

**Error: "Missing argument label 'value:'"**
Asegúrate de importar correctamente SQLite o usar el alias en `DBManager`:
```swift
import SQLite
typealias Expression = SQLite.Expression
