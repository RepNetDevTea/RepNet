import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder , SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import type { NextFunction, Request, Response } from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
  .setTitle('API de Ejemplo')
  .setDescription('Documentación de la API con Swagger')
  .setVersion('1.0')
  .addTag('usuarios') // Puedes agregar más tags
  .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api-docs', app, document);

  app.getHttpAdapter().get('/swagger.json', (req, res) => {
    res.json(document);
  });

  app.use(
    helmet({
      contentSecurityPolicy: {
        directives:  { 
          'default-src': ["'self'"], 
          'script-src': ["'self'"], 
          'style-src': ["'self'", "'unsafe-inline'"], 
          'img-src': ["'self'", "data:", "https://*.amazonaws.com"], 
          'font-src': ["'self'"], 
          'connect-src': ["'self'", "http://localhost:3000"], 
          'frame-ancestors': ["'none'"], 
          'base-uri': ["'self'"], 
          'form-action': ["'self'"],
        } 
      }
    })
  );

  app.use(helmet.noSniff());
  app.use(helmet.frameguard({ action: 'deny' }));

  const allowedOrigins = [
    'http://localhost:3000', 'http://localhost:5173', 
    'http://10.48.200.81',  
    'http://10.48.208.241', 
    'http://10.48.227.78', 
  ];

  app.enableCors({
    origin: (origin, callback) => {
      if (!origin)
        return callback(null, true);
      if (allowedOrigins.includes(origin))
        return callback(null, true);

      return callback(new Error('CORS not allowed'), false);
    }, 
  });

  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
