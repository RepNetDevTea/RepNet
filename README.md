# 💻 RepNet Server

En este repositorio está almacenado el código del **servidor multiplataforma de RepNet**, y esta es una guía detallada de sus especificaciones y cómo inicializarlo.

---
## Requisitos Previos
Asegúrate de tener instalado:
- Node.js (v18 o superior)
- npm (v9 o superior)
- MySQL o acceso a una base de datos compatible
- Cuenta y credenciales de AWS (S3, Bedrock)

## Tecnologías Fundamentales

El servidor está construido sobre los siguientes bloques tecnológicos:

- ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white) — Lenguaje de programación  
- ![NestJS](https://img.shields.io/badge/NestJS-E0234E?logo=nestjs&logoColor=white) — Backend framework  
- ![Prisma](https://img.shields.io/badge/Prisma-2D3748?logo=prisma&logoColor=white) — ORM (Object Relational Mapper)  
- ![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white) — Servicio en la nube  

La combinación de estas tecnologías ofrece una experiencia de desarrollo moderna, segura (reduciendo en ~15% los bugs en tiempo de compilación), tipada, con alta velocidad de desarrollo para el servidor multiplataforma de **RepNet**.

---

## Datos Sensibles y Archivo `.env`

### AWS

Para el funcionamiento adecuado del servidor se utilizan servicios en la nube (particularmente **Bedrock** y **S3**) lo que implica el uso de **datos sensibles**.  
Estos valores deben resguardarse en un archivo `.env`, con las siguientes variables:

```env
AWS_REGION=your-aws-region
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
```

### DB

Retornando a una de las tecnologías indispensables del servidor, Prisma es un ORM moderno que ofrece: tipado, tipos autogenerados basados en tus prisma models, validación de tipos, manejo de errores, escribir SQL directamente (como otros ORMs) y un intermediario (como otros ORMs) para una interacción sencilla entre el servidor y la DB, esto ahorra la construcción de nuestros propios repositorios (en NestJS). Prisma, al igual que otros ORMs, necesita de la URL que indica la ubicación de nuestra DB que es considerada un dato sensible, es por eso que incluimos una variable de entorno que almacene nuestra URL:

```env
DATA_BASE_URL=your-database-url
```
(en el desarrollo, el servidor usa una DB MySQL)

### JWTs (Javascript Web Tokens)

El servidor implementa un proceso de autenticación con JWTs cuyos payloads contienen atributos importantes o únicos (id, username, role, etc) y una autorización basada en roles. Como todo JWT, son necesarias dos cosas: una cadena de caracteres (secret) cuyo propósito es firmar y comprobar que el token no haya sido comprometido y una cantidad de tiempo finito en la que el JWT es válido (time to live):

```env
ACCESS_JWT_SECRET=jwt-access-secret
ACCESS_JWT_EXPIRES_IN=15m

REFRESH_JWT_SECRET=jwt-refresh-secret
REFRESH_JWT_EXPIRES_IN=1d
```

### ¿Cómo es que generamos un JWT secret robusto?

Nuestra respuesta es a través de OpenSSL, abramos nuestra CLI (Command Line Interface) y ejecutemos el siguiente comando:

```bash
openssl rand -hex 32
```
La salida del comando previo será algo parecida a esta cadena de caracteres:

```bash
9963a7a0bfbd3834be86c016f1e49269b07e5764b60ac032a18420d31e2fd455
```

Después de haber repetido este proceso dos veces, hemos acabado de asignar los valores a todas nuestras variables de entorno.

## Instalación

### Paso 0

Con el propósito de montar el servidor, hay que clonar este repositorio (tener un repositorio local) como otro repo almacenado en GitHub.  
Dentro de nuestro repositorio local, una manera de comprobar que tienes un repositorio local exitoso (vinculado al repositorio remoto), es la existencia del subdirectorio `.git/`.

```plaintext
RepNet/
├── .git/
├── repnet_backend/
├── .gitignore
├── LICENSE
├── README.md
```

### Paso 1

A continuación necesitaremos instalar una serie de dependencias (esto puede tomar un momento) que están indicadas en el archivo `package.json`, ejecutaremos el siguiente comando:

```bash
npm install
```

Si la instalación de dependencias fue exitosa, existirá un nuevo subdirectorio nombrado `node_modules/`, este directorio contiene a todas nuestras dependencias instaladas.

```plaintext
RepNet/
├── .git/
├── repnet_backend/
│   ├── node_modules/
│   ├── prisma/
│   ├── src/
│   ├── test/
│   ├── .env
│   ├── .prettierrc
│   ├── eslint.config.mjs
│   ├── nest-cli.json
│   ├── package-lock.json
│   ├── package.json
│   ├── tsconfig.build.json
│   ├── tsconfig.json
├── .gitignore
├── LICENSE
├── README.md
```

En caso de que la instalación de dependencias no fuera exitosa, retorna al paso 0.

### Paso 2

Lo que queda por hacer es generar el intermediario de Prisma, llamado Prisma Client, ejecutemos el siguiente comando para generar al Prisma Client, sin esto no seremos capaces de realizar operaciones sobre nuestra base de datos:

```bash
npx prisma generate
```

Como nota, el flujo normal de la instalación de Prisma en un proyecto que no lo incluya es:

```bash
npm install prisma
npx prisma init
npm install @prisma/client
npx migrate dev --name some_name
npx prisma generate
```

### Paso 3

Si hemos llegado a este paso, quiere decir que hemos hecho un repositorio remoto exitoso, instalado las dependencias del servidor exitosamente y generado nuestro Prisma Client.
A estas alturas, podemos ejecutar el siguiente comando y comprobar que el servidor es montado exitosamente y está listo para servir solicitudes HTTP:

```bash
npm run start:dev
```

Este comando es un script que monta nuestro servidor, en caso de querer saber qué comando y qué opciones se ejecutan, podemos ir a la sección de scripts del archivo `package.json` (dentro de `./repnet_backend`).

Para comprobar que hemos hecho un montaje exitoso, abramos la terminal de nuestro editor de texto o nuestro IDE (Integrated Development Environment), dado el hecho de que VSCode (un editor de texto) es muy popular, podemos ocupar el atajo `Ctrl + J`.
En nuestra terminal deberán de desplegarse múltiples logs en color verde seguido del indicador verdadero, la impresión del mensaje:

```bash
Connected to DB
```

> © 2025 RepNet Server — Desarrollado por el equipo de backend de RepNet.
