# 🛠️ MultiToolbox App

Este proyecto es una aplicación móvil desarrollada con **Flutter** que funciona como una "caja de herramientas" personal y profesional, integrando diversas funcionalidades en una sola interfaz.

---

## ⬇️ Instalación y Ejecución

### 📱 APK

La aplicación está compilada y lista para instalar en cualquier dispositivo Android (teléfono o emulador).

* **Enlace de Descarga Directa (APK):**
    [Descargar `app-release.apk`](https://itlaedudo-my.sharepoint.com/:f:/g/personal/20222161_itla_edu_do/EpX4VN2xyhlKqB8odw81szoBZ1jMgcCP4jDSJ4jahMUR0g?e=wJAx7t)

### 💻 Entorno de Desarrollo

Para clonar y ejecutar el proyecto:

1.  Asegúrate de tener **Flutter SDK** y **Node.js** (Path) instalado y configurado (`flutter doctor`).
2.  Clona este repositorio: `https://github.com/AdrielApX/ToolboxApp.git`
3.  Navega a la carpeta del proyecto: `cd multi_toolbox`
4.  Obtén las dependencias: `flutter pub get`
5.  Corre la aplicación en un dispositivo o emulador: `flutter run`

---

## ✨ Funcionalidades Incluidas

La aplicación **MultiToolbox** ofrece una suite de herramientas útiles, accesibles desde su interfaz principal:

| Sección              | Descripción                                                                 | Requerimiento de Datos / APIs                                      |
| :------------------- | :-------------------------------------------------------------------------- | :----------------------------------------------------------------- |
| **Predecir Género** | Permite al usuario ingresar un nombre y predice el género (masculino/femenino). | Consumo de una API externa de predicción de género.                |
| **Predecir Edad** | Permite al usuario ingresar un nombre y predice una edad aproximada.        | Consumo de una API externa de predicción de edad.                  |
| **Universidades** | Muestra una lista de universidades, posiblemente filtradas por país.        | Consumo de una API externa de listado de universidades.            |
| **Clima en RD** | Presenta el estado del tiempo actual en **Santo Domingo, República Dominicana**. | API de **OpenWeatherMap** (requiere clave API).                    |
| **Info. Pokémon** | Ofrece información básica sobre Pokémon, consultando una API de Pokémon.    | Consumo de la **PokeAPI** (o similar).                             |
| **Noticias WordPress** | Muestra un feed de noticias o publicaciones de un sitio WordPress específico. | Consumo de una API REST de WordPress.                              |
| **Acerca de** | Información sobre el desarrollador (**Adriel**), incluyendo foto de perfil y detalles de contacto/redes. | N/A (usa datos locales y `url_launcher` para enlaces externos). |
---

## 🎨 Aspecto Visual

* **Icono del Lanzador:** La aplicación utiliza una **foto de perfil** personalizada como icono del lanzador, generado con `flutter_launcher_icons`.
* **Splash Screen:** La pantalla de inicio de la aplicación utiliza la **foto de perfil** en un fondo blanco (generado con `flutter_native_splash`).

---

## ⚙️ Tecnologías

* **Framework:** Flutter (Dart)
* **APIs:** OpenWeatherMap
* **Control de Versiones:** Git & GitHub

---

## 👨‍💻 Desarrollador

**Adriel P**
