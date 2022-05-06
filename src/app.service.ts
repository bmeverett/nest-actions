import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    // comment
    return 'Hello World!';
  }
}
