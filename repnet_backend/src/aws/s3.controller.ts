import { Controller, FileTypeValidator, MaxFileSizeValidator, ParseFilePipe, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { S3Service } from './s3.service';

@Controller('s3')
export class S3Controller {
  constructor(private s3Service: S3Service) {}
  // Vamos a user multer que es un npm package creado por
  // el mismo equipo que creo express. Es usado para lidiar/
  // administrar/parsear el cuerpo de la solicitud http que tiene como
  // valor multipart/form-data en el http header content-type
  // con método post. Multer nos retornará un buffer que nos servirá 
  // para subirlo a nuestro s3 bucket.
  @Post('upload')
  // Necesittamos un inerceptor para acceder a la http request antes 
  // de que llegue a nuestro route handler. Usaremos el interceptor
  // FileInterceptor, su primer argumento el nombre del campo donde recide
  // el archivo. Este argumento es una key que tiene que coincidir con la key
  // proporcionada en el cuerpo de la http request.
  @UseInterceptors(FileInterceptor('file'))
  // Existe un decorador en nestjs que nos permite acceder al archivo, se llama
  // UploadedFile que será de tipo Express.Multer.File. Podemos proporcionar un 
  // filtro de qué tipo de archivos son aceptables usando una pipe llamada ParseFilePipe
  // al que le pasamos un objeto que contenga validators, dentro de una propiedad llamada validators.
  async uploadFile(@UploadedFile(
    new ParseFilePipe({
      validators: [
        // new MaxFileSizeValidator({ maxSize: 209114 }),
        // new FileTypeValidator({ fileType: 'image/png' })
      ]
    })
  ) file: Express.Multer.File) {
    return await this.s3Service.upload(file.originalname, file.buffer);
  }
}